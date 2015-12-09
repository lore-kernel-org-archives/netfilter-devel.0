From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 libnftnl 1/3] src: add trace infrastructure support
Date: Wed, 9 Dec 2015 15:06:51 +0100
Message-ID: <20151209140651.GA26134@breakpoint.cc>
References: <1448649800-26153-1-git-send-email-fw@strlen.de>
 <1448649800-26153-2-git-send-email-fw@strlen.de>
 <20151209135557.GA1516@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44512 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754132AbbLIOGx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 09:06:53 -0500
Content-Disposition: inline
In-Reply-To: <20151209135557.GA1516@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Nov 27, 2015 at 07:43:18PM +0100, Florian Westphal wrote:
> > parses trace monitor netlink messages from the kernel and builds
> > nftnl_trace struct that contains the dissected information.
> > 
> > Provides getters to access these attributes.
> 
> I leave it to you to push trace code to libnftnl. Thanks.

Pushed libnftnl changes, thanks Pablo.

@Patrick: I won't push anything trace related to nftables.git since I'm
assuming that you'll take care of nftables side eventually.

Cheers,
Florian
