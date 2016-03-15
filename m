From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] nft: Removed ^L characters
Date: Tue, 15 Mar 2016 09:49:28 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1603150944430.25426@nerf40.vanv.qr>
References: <20160315031330.GA4185@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Piyush Pangtey <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:37826 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbcCOItb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 04:49:31 -0400
In-Reply-To: <20160315031330.GA4185@fate>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2016-03-15 04:13, Piyush Pangtey wrote:

>Unnecessary line-feed characters removed.
>
>Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
>---
> COPYING        |  8 ++++----
>
>diff --git a/COPYING b/COPYING
>index bf7f06e..b9e45a5 100644
>--- a/COPYING
>+++ b/COPYING
>@@ -63,7 +63,7 @@ patent must be licensed for everyone's free use or not licensed at all.
> 
>   The precise terms and conditions for copying, distribution and
> modification follow.
>-

>+
> 		    GNU GENERAL PUBLIC LICENSE
>    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
> 

This is a pointless exercise. The file (files) are copied verbatim from 
upstream. For the license file, you also just disabled filesystem level 
deduplication via hardlink because its contents are now needlessy 
different from other redundant copies installed by other software.

^L has its purposes, namely it indicates where to make a page break, 
should you consider sending the file to a line printer, or opening it a 
program equal to understanding the same (like LibreOffice).
