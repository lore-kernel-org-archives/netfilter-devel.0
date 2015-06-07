From: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Subject: Re: xtables-addons 64-bit counter patch
Date: Sun, 7 Jun 2015 01:21:59 -0400
Message-ID: <20150607012159.492666d6@playground>
References: <20150604180442.12410111@playground>
	<alpine.LSU.2.20.1506061315120.29092@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from MAIL1.WPI.EDU ([130.215.36.91]:35788 "EHLO MAIL1.WPI.EDU"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbbFGFWG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Jun 2015 01:22:06 -0400
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

Thanks! It never occurred to me that a long long might someday be
longer than 64 bits. And I haven't had to program C structs for more
than one ARCH for around 25 years, when I had to make a home-brew
DB work on m68k, m88k, Sparc and MIPS. Using about as many different
compilers and OSes. *I* thought I was being clever using explicit
padding to align elements by hand. I've applied your tweaks to my patch.

Neal
