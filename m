From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: move br_netfilter out of the bridge
 core
Date: Thu, 25 Sep 2014 13:25:08 +0200
Message-ID: <20140925112508.GB25548@breakpoint.cc>
References: <1411388201-12124-1-git-send-email-pablo@netfilter.org>
 <1411388201-12124-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51626 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589AbaIYLZK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:25:10 -0400
Content-Disposition: inline
In-Reply-To: <1411388201-12124-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Jesper reported that br_netfilter always registers the hooks since
> this is part of the bridge core. This harms performance for people that
> don't need this.
> 
> This patch modularizes br_netfilter so it can be rmmod'ed, thus,
> the hooks can be unregistered. I think the bridge netfilter should have
> been a separated module since the beginning, Patrick agreed on that.
> 
> Note that this is breaking compatibility for users that expect that
> bridge netfilter is going to be available after explicitly 'modprobe
> bridge' or via automatic load through brctl.
> 
> However, the damage can be easily undone by modprobing br_netfilter.
> The bridge core also spots a message to provide a clue to people that
> didn't notice that this has been deprecated.
> 
> On top of that, the plan is that nftables will not rely on this software
> layer, but integrate the connection tracking into the bridge layer to
> enable stateful filtering and NAT, which is was bridge netfilter users
> seem to require.
> 
> This patch still keeps the fake_dst_ops in the bridge core, since this
> is required by when the bridge port is initialized. So we can safely
> modprobe/rmmod br_netfilter anytime.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks Pablo.
Acked-by: Florian Westphal <fw@strlen.de>

