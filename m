From: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Subject: Re: xtables-addons 64-bit counter patch
Date: Mon, 19 Oct 2015 01:34:54 -0400
Message-ID: <20151019013454.6f81f4f5@playground>
References: <20150604180442.12410111@playground>
	<alpine.LSU.2.20.1506061315120.29092@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from MAIL1.WPI.EDU ([130.215.36.91]:35064 "EHLO MAIL1.WPI.EDU"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbbJSGBx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Oct 2015 02:01:53 -0400
In-Reply-To: <alpine.LSU.2.20.1506061315120.29092@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 6 Jun 2015 13:15:38 +0200 (CEST)
Jan Engelhardt <jengelh@inai.de> wrote:

> x
> On Friday 2015-06-05 00:04, Neal P. Murphy wrote:
> >The theory:
> >  - Use two kernel pages for the counters for each group of 256
> >    addresses.
> >  - Change counters to 64-bit.
> >  - Change to __get_free_pages/free_pages, using order=2 (two
> >    consecutive pages), and zero both pages.
> >  - Change "%u" to "%llu" as needed.
> >  - Everything else pretty much stays the same.
> >
> >I also changed tmpbuf to two pages (Justin Case's idea), but I
> >don't know if that's really necessary.
> >
> >Did I miss anything?
> 
> I applied it.

Disembowel me with a wooden spoon. My first patch makes xt_ACCOUNT hiss. Well, I think that's what a memory leak sounds like.

Below is the patch with the *rest* of the free_page(X) calls changed to free_pages(X, 2). xt_ACCOUNT should always allocate memory in page pairs. And always *free* memory in page pairs.

Neal

--------
diff -Nubr xtables-addons-1.45-P1/extensions/ACCOUNT/xt_ACCOUNT.c xtables-addons-1.45/extensions/ACCOUNT/xt_ACCOUNT.c
--- xtables-addons-1.45-P1/extensions/ACCOUNT/xt_ACCOUNT.c	2015-10-19 01:23:03.000000000 -0400
+++ xtables-addons-1.45/extensions/ACCOUNT/xt_ACCOUNT.c	2015-10-19 01:23:39.000000000 -0400
@@ -145,7 +145,7 @@
 		unsigned int b;
 		for (b = 0; b <= 255; b++) {
 			if (mask_16->mask_24[b]) {
-				free_page((unsigned long)mask_16->mask_24[b]);
+				free_pages((unsigned long)mask_16->mask_24[b], 2);
 			}
 		}
 		free_pages((unsigned long)data, 2);
@@ -162,10 +162,10 @@
 
 				for (b = 0; b <= 255; b++) {
 					if (mask_16->mask_24[b]) {
-						free_page((unsigned long)mask_16->mask_24[b]);
+						free_pages((unsigned long)mask_16->mask_24[b], 2);
 					}
 				}
-				free_page((unsigned long)mask_16);
+				free_pages((unsigned long)mask_16, 2);
 			}
 		}
 		free_pages((unsigned long)data, 2);
