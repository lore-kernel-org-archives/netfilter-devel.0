From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: xtables-addons 64-bit counter patch
Date: Mon, 9 Nov 2015 22:34:47 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1511092234210.16150@nerf40.vanv.qr>
References: <20150604180442.12410111@playground> <alpine.LSU.2.20.1506061315120.29092@nerf40.vanv.qr> <20151019013454.6f81f4f5@playground> <20151108184911.58e53fe5@playground> <alpine.LSU.2.20.1511091013590.26401@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, Jaroslav Drzik <jaro@ttx.sk>,
	ipt_ACCOUNT@developer.intra2net.com
To: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:42397 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbbKIVeu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 16:34:50 -0500
In-Reply-To: <alpine.LSU.2.20.1511091013590.26401@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2015-11-09 10:14, Jan Engelhardt wrote:
>On Monday 2015-11-09 00:49, Neal P. Murphy wrote:
>
>>Re-sent, as the original may have been overlooked.
>
>This was included in 2.6 already.

>>diff -Nubr xtables-addons-1.45-P1/extensions/ACCOUNT/xt_ACCOUNT.c xtables-addons-1.45/extensions/ACCOUNT/xt_ACCOUNT.c
>>--- xtables-addons-1.45-P1/extensions/ACCOUNT/xt_ACCOUNT.c	2015-10-19 01:23:03.000000000 -0400
>>+++ xtables-addons-1.45/extensions/ACCOUNT/xt_ACCOUNT.c	2015-10-19 01:23:39.000000000 -0400
>>@@ -145,7 +145,7 @@
>> 		unsigned int b;
>> 		for (b = 0; b <= 255; b++) {
>> 			if (mask_16->mask_24[b]) {
>>-				free_page((unsigned long)mask_16->mask_24[b]);
>>+				free_pages((unsigned long)mask_16->mask_24[b], 2);


Now placed into git master after seeing that there were still 
free_page() calls left.
