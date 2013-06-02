MHFacebookImageViewer
=======================

A new Image Viewer inspired by Facebook


## Screenshots

![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/demo1_zpse8778327.gif)

![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/Demo2_zps23b37e99.gif)

![Preview](http://i1102.photobucket.com/albums/g447/michaelhenry119/IOS%20Controls/MHFacebookImageViewer/Demo3_zps54985d8d.gif)


# Demo Video

http://youtu.be/NTs2COXxrrA



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