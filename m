From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -next] netfilter: nfnetlink: work around wrong endianess
 with old nft userspace
Date: Fri, 28 Aug 2015 21:24:12 +0200
Message-ID: <20150828192412.GC17804@breakpoint.cc>
References: <1440713863-18469-1-git-send-email-fw@strlen.de>
 <20150828190143.GA5575@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58321 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171AbbH1TYO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Aug 2015 15:24:14 -0400
Content-Disposition: inline
In-Reply-To: <20150828190143.GA5575@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Aug 28, 2015 at 12:17:43AM +0200, Florian Westphal wrote:
> > The nfgenmsg res_id is __be16.  Unfortunately nftables batch support uses
> > host byte order.
> > 
> > This adds a compat workaround for old nft userspace.
> 
> Would you be also OK with the attached patch? Thanks.

Sure.
