From: Mike Wright <nobody@nospam.hostisimo.com>
Subject: Re: ipset website
Date: Fri, 28 Nov 2014 20:08:26 -0800
Message-ID: <547946BA.106@nospam.hostisimo.com>
References: <547919CB.7030202@nospam.hostisimo.com> <alpine.LSU.2.11.1411290212430.31411@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from theorb.net ([204.11.228.190]:39616 "HELO b.mx.theorb.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1750996AbaK2EIY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Nov 2014 23:08:24 -0500
In-Reply-To: <alpine.LSU.2.11.1411290212430.31411@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 11/28/2014 05:23 PM, Jan Engelhardt wrote:
>
> On Saturday 2014-11-29 01:56, Mike Wright wrote:
>>
>> I've made some updates to the ipset.netfilter.org website.  The changes are
>> cosmetic, such as highlighting the menu link when on a specific page,
>
> The syntax for color= is probably incorrect, it is missing #.
> But why do you even introduce the archaic <font> tag? The CSS
> class "hot" seemed to be just right.
>
The <font> tags were in the original.  That was the first thing I removed.

> Forcing a scrollbar also seems backwards. If the table is to
> have a consistent size irrespective of scrollbar, one would
> probably use CSS's position: or float:.
 >
Those solutions won't work.  The scroll bar is added to the page by the 
browser, outside of the body, which causes the body width to narrow, 
specifically by different widths depending on which browser.  The only 
way to accomplish that is with javascript.  I feel that is an 
inappropriate addition to the pages.  I prefer that each page's body 
width be constant.  Six of the nine pages would have one anyway.

>> framing the man pages so that you don't have to use the "back" button to
>> continue navigating the site (required adding four new pages).
>
> It adds another scrollbar rather than just filling the page downards.
> This would preferably call for something like SSI, or PHP's include(),
> for avoiding the duplication of the menu.
>
Agreed.  The <iframe/> tags have been removed.  The ipset, ip(6)tables, 
and iptables-extensions pages are now php.

>
>> To see the diffs between the original pages and mine:
>
> They are not in unified form.

Just learned how to do that :) They are now.

The changes I made should now be in line with your comments.  Please review.

site:  http://ipset.hostisimo.com
diff:  http://ipset.hostisimo.com/diff
bzip:  http://ipset.hostisimo.com/ipset.netfilter.org.tar.bz2



> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
