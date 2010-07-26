From: Karl Hiramoto <karl@hiramoto.org>
Subject: Re: [RFC 0/4] nfnetlink_queue bypass queue to userspace X bytes of
 connection
Date: Mon, 26 Jul 2010 08:50:00 +0200
Message-ID: <4C4D3018.7050907@hiramoto.org>
References: <1279986285-11665-1-git-send-email-karl@hiramoto.org> <4C4B305F.2070005@netfilter.org> <4C4BDFEC.4080600@hiramoto.org> <4C4C1524.8070805@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:60159 "EHLO
	homiemail-a26.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753084Ab0GZGuE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jul 2010 02:50:04 -0400
In-Reply-To: <4C4C1524.8070805@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 On 25/07/2010 12:42, Pablo Neira Ayuso wrote:
>
> You can limit the string matching for only a few bytes in the very
> beginning of the packet. 
That really doesn't help trying to find the "Host:" or path of or URL in HTTP because you don't know variables like cookie length, or other variables. String match also doesn't help me at all if the string is split across multiple packets


> This extension seems to me very specific for HTTP/1.1.
HTTP is the most popular protocol on the internet[1][2][3], optimizing the most common case has merits.

Besides HTTP  I can imagine this extension helping implementing a POP3 or IMAP filter using NF_QUEUE.   For example many network UTM devices that scan attachments for viruses or other blocked content, will skip a compressed file that is over X bytes because there is not enough free memory to decompress and scan it.   In this case you could bypass the queue for X bytes, then continue scanning smaller files.


[1]
http://torrentfreak.com/http-traffic-overtakes-p2p-courtesy-of-youtube/

[2]
http://www.nanog.org/meetings/nanog47/abstracts.php?pt=MTQ1MyZuYW5vZzQ3&nm=nanog47 <http://www.nanog.org/meetings/nanog47/abstracts.php?pt=MTQ1MyZuYW5vZzQ3&nm=nanog47>
[3]
http://www.cisco.com/en/US/netsol/ns827/networking_solutions_sub_solution.html#~forecast <http://www.cisco.com/en/US/netsol/ns827/networking_solutions_sub_solution.html#%7Eforecast>
NOTE talking about video being the most popular, a lot of video is delivered over HTTP. 


--
Karl


