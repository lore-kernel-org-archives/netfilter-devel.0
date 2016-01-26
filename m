From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 3/3] netlink: do binop postprocessing also for map
 lookups
Date: Tue, 26 Jan 2016 14:50:51 +0100
Message-ID: <20160126135051.GA20654@breakpoint.cc>
References: <1453658307-7177-1-git-send-email-fw@strlen.de>
 <1453658307-7177-3-git-send-email-fw@strlen.de>
 <20160126133839.GC4168@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35683 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964992AbcAZNux (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jan 2016 08:50:53 -0500
Content-Disposition: inline
In-Reply-To: <20160126133839.GC4168@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Jan 24, 2016 at 06:58:27PM +0100, Florian Westphal wrote:
> > nft list before patch:
> > mark set unknown unknown & 0xfff [invalid type] map { 3 : 0x00000017, 1 : 0x0000002a}
> > now:
> > mark set vlan id map { 3 : 0x00000017, 1 : 0x0000002a}
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks, I pushed the series to nft master.
