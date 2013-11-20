From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] build: use automake and pkgconfig
Date: Wed, 20 Nov 2013 15:06:05 +0100
Message-ID: <20131120140605.GB7599@localhost>
References: <1382280491-9921-1-git-send-email-jengelh@inai.de>
 <1382280491-9921-4-git-send-email-jengelh@inai.de>
 <20131119202815.GC4929@localhost>
 <alpine.LSU.2.11.1311201008300.24243@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43074 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab3KTOGO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:06:14 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1311201008300.24243@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 20, 2013 at 11:54:21AM +0100, Jan Engelhardt wrote:
> On Tuesday 2013-11-19 21:28, Pablo Neira Ayuso wrote:
> 
> >On Sun, Oct 20, 2013 at 04:48:11PM +0200, Jan Engelhardt wrote:
> >> This now also honors the cflags as obtained from pkgconfig, otherwise
> >> one gets a compile error if the headers are in a location other than
> >> /usr/include.
> >
> >I don't want to consider changing the build system at this stage.
> 
> At this stage, the build is rather broken, for cases that are not
> even far-fetched.

Then fix what we already have.

If you convince me in that it is way too complex to make it, then I'll
consider this move to automake.
