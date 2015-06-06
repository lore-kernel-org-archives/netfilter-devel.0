From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: xtables-addons 64-bit counter patch
Date: Sat, 6 Jun 2015 13:15:38 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1506061315120.29092@nerf40.vanv.qr>
References: <20150604180442.12410111@playground>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:45183 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbbFFLPl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jun 2015 07:15:41 -0400
In-Reply-To: <20150604180442.12410111@playground>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

x
On Friday 2015-06-05 00:04, Neal P. Murphy wrote:
>The theory:
>  - Use two kernel pages for the counters for each group of 256
>    addresses.
>  - Change counters to 64-bit.
>  - Change to __get_free_pages/free_pages, using order=2 (two
>    consecutive pages), and zero both pages.
>  - Change "%u" to "%llu" as needed.
>  - Everything else pretty much stays the same.
>
>I also changed tmpbuf to two pages (Justin Case's idea), but I
>don't know if that's really necessary.
>
>Did I miss anything?

I applied it.
