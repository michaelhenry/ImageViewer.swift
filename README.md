MHFacebookImageViewer
=======================

A new Image Viewer inspired by Facebook

# Demo Video

http://youtu.be/-RVPWoOdOFU

# Requirements
	
	Requires either iOS 5.0 and above.

# Usage:

## How to use it:
Just

	#import "MHFacebookImageViewer.h"  

and then in your UIImageView after you set the Image just call the 

	[UIImageView  setupImageViewer]



## Example (UITableViewController):

### In your UITableViewController import the MHFacebookImageViewer.h

	#import "MHFacebookImageViewer.h"
	
### In your [UITableView cellForRowAtIndexPath]

	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
	{
	    static NSString *CellIdentifier = @"image_cell";
	    UITableViewCell *cell = UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	    UIImageView * imageView = (UIImageView*)[cell viewWithTag:1];
	   
	    [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",indexPath.row]]];
	    imageView.contentMode = UIViewContentModeScaleAspectFill;
	    [imageView setupImageViewer];
	    imageView.clipsToBounds = YES;
	    return cell;
	}

### That's it. :)


## Screenshots
![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/1_zps2d86ec06.png)  ![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/2_zps53fd2fb1.png)

![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/3_zps0d1e65d2.png)   ![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/4_zpsdc876860.png)

![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/5_zpsbe8b2b6b.png)   ![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/6_zps2835afae.png)

![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/7_zps0faffe44.png)   ![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/8_zps8b82eb8e.png)

![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/9_zpsefb88194.png)   ![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/10_zpsec7f3cf4.png)

![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/11_zps7149e94d.png)   ![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/12_zps23ef4456.png)

![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/13_zpsa4bdfd63.png)   ![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/14_zps8851fde7.png)


Please let me know if you have any questions. 

Cheers,  
[Michael Henry Pantaleon](http://www.iamkel.net)

Twitter: [@michaelhenry119](https://twitter.com/michaelhenry119)

Linked in: [ken119](http://ph.linkedin.com/in/ken119)

http://www.iamkel.net



# Licensing

Copyright (c) 2013 Michael Henry Pantaleon (http://www.iamkel.net). All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.