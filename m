From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file
 descriptor
Date: Tue, 04 Dec 2007 10:14:43 +0100
Message-ID: <47551A83.80009@trash.net>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>  <4753B957.2000207@trash.net> <beb91d720712030435t3b8f6164p3a489880618ebee9@mail.gmail.com> <47550D5C.8090004@trash.net> <Pine.LNX.4.64.0712040950390.11746@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080404080308020305090601"
Cc: Salatiel Filho <salatiel.filho@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Jesper Dangaard Brouer <hawk@diku.dk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58327 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbXLDJPK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 04:15:10 -0500
In-Reply-To: <Pine.LNX.4.64.0712040950390.11746@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080404080308020305090601
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> On Dec 4 2007 09:18, Patrick McHardy wrote:
>> Salatiel Filho wrote:
>>> On Dec 3, 2007 5:07 AM, Patrick McHardy <kaber@trash.net> wrote:
>>>> Salatiel Filho wrote:
>>>>> # iptables -L
>>>>> iptables v1.3.6: can't initialize iptables table `filter': Bad file
>>>>> descriptor
>>>>> Perhaps iptables or your kernel needs to be upgraded.
>>>>>
>>>>> My machine is a ARM machine with debian 4.0.
>>>>> I also have already tried 1.3.8 and got the same error.
>>>> Which kernel version (please also send .config)? Did you compile
>>>> iptables yourself or used a version from Debian?
>>>>
> 
> This looks more like an userspace issue. The strace log shows that the
> netlink socket was obtained, but calls setsockopt with fd=-1.
> Just a guess, though.


Right, I missed that, thanks. Jesper seems to be correct, if autoloading
fails we close the socket and decrement sockfd_use twice, which causes
iptables to not open it again for the second attempt.

Salatiel, does this patch fix the problem?

--------------080404080308020305090601
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: libiptc/libiptc.c
===================================================================
--- libiptc/libiptc.c	(Revision 7130)
+++ libiptc/libiptc.c	(Arbeitskopie)
@@ -866,10 +866,6 @@
 	CHECK(h);
 	return h;
 error:
-	if (--sockfd_use == 0) {
-		close(sockfd);
-		sockfd = -1;
-	}
 	TC_FREE(&h);
 	return NULL;
 }

--------------080404080308020305090601--
