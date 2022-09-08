
var { chromium } = require('playwright');

JSON.parse(process.argv[2]).forEach(async function (item) {
    var url = item.url;
    var directory = item.directory;
    var filename = item.filename;
    var width = item.width;
    var height = item.height;
    var headless = item.headless;
    var waitForSelector = item.waitForSelector;
    var waitForLoadState = item.waitForLoadState;
    var waitForTimeout = item.waitForTimeout;
    var clickSelector = item.clickSelector;
    var browserName = item.browserName;
    var colorScheme = item.colorScheme;
    var { browserName } = require('playwright');

    var path = require('path');
    var fs = require('fs');
    var file = path.join(directory, filename);
    console.log("processing " + file);

    var browser = await chromium.launch({
        headless: headless,
        channel: browserName
        //colorScheme: colorScheme
    });

    var context = await browser.newContext({
        viewport: {
            width: width,
            height: height,
        }
    });
    // connect to webpage
    var page = await context.newPage();
    await page.goto(url);
    // wait for the page to load
    await page.waitForLoadState('domcontentloaded');
    //await page.waitForSelector('text=Table with Paging');
    // take a screenshot
    await page.screenshot({ path: file });
    await context.close();
    await browser.close();
});