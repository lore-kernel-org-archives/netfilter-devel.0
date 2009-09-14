From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: [PATCH 00/11] TProxy for IPv6
Date: Mon, 14 Sep 2009 07:41:19 +0000
Message-ID: <1252914079.12904.32.camel@bzorp.balabit>
References: <cover.1251295408.git.bazsi@balabit.hu>
	 <4AA0AE8C.30203@treenet.co.nz>  <1252059564.7452.17.camel@nyarlathotep>
	 <1252435673.32029.45.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Amos Jeffries <squid3@treenet.co.nz>,
	netfilter-devel@vger.kernel.org
To: Harry Mason <harry.mason@smoothwall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:46355 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751246AbZINHlX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:41:23 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 5969B39D177
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2009 09:41:24 +0200 (CEST)
In-Reply-To: <1252435673.32029.45.camel@bzorp.balabit>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This is just a short note that I've updated the git repository and added
your patches to the tree (the UDP and ICMP related bits), although I
haven't had time to write proper changelogs and integrate related
patches to one, I figured it's better to say I did so instead of waiting
for code to rot in the git repo.

I hope I get another shot to do a formal release in the coming days.

On Tue, 2009-09-08 at 20:47 +0200, Balazs Scheidler wrote:
> On Fri, 2009-09-04 at 11:19 +0100, Harry Mason wrote:
> > On Fri, 2009-09-04 at 18:07 +1200, Amos Jeffries wrote:
> > > Balazs Scheidler wrote:
> > > 
> > > > I've just pushed a set of patches that implement TProxy for IPv6 to
> > > > 
> > > > http://git.balabit.hu/bazsi/tproxy-2.6.git
> > > 
> > > I'm interested :)
> > > 
> > > Amos Jeffries
> > > Squid Proxy Project
> > 
> > In TProxy for IPv4 there's support for the SO_ORIGINAL_DST sockopt, which returns
> > the original destination of the request. I needed this option in my prototype to
> > do TRT but I assume Squid will need it too for transparent proxying.
> > 
> > I've ported this feature to Balazs's implementation; Git bundle attached.
> > 
> > Balazs, does this look OK to be merged with your patches?
> > Amos, this might help you test Squid with IPv6; hopefully the API I chose won't
> > need to change but I'm very new to kernel development.
> 
> I'll check what I could pick from this and your previous bundle (which
> as I see was only sent in private) and push another round of patches.
> 
-- 
Bazsi

