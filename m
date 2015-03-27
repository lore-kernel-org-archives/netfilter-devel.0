From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 0/2] xt_cgroups fix
Date: Fri, 27 Mar 2015 01:40:16 +0100
Message-ID: <20150327004016.GE3545@salvia>
References: <cover.1427394874.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48247 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbbC0AgS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 20:36:18 -0400
Content-Disposition: inline
In-Reply-To: <cover.1427394874.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 26, 2015 at 08:14:46PM +0100, Daniel Borkmann wrote:
> Hi Pablo,
> 
> here's a possible fix for xt_cgroups that was previously reported
> by Daniel Mack.
> 
> I respinned the set based on your previous feedback wrt tw sockets.
> 
> The first patch refactors common helpers, which is later on being
> used by the actual fix. Please see individual patches for details.
> 
> I have rebased it against nf-next as in the previous version.

The existing cgroup support for nf_tables is quite broken (see patch
attached), that needs some care too. Would you also help us to get
that in good shape? It will be half way done after your patches.

This makes me think that you can place something generic to fetch the
sk_classid:

        static bool nf_sock_classid(u32 *sk_classid);

this would go in net/ipv4/netfilter/nf_sock_ipv4.c.

And also the ipv6 version:

static bool nf_sock6_classid(u32 *sk_classid);

so we can use the same function to fetch the sk_classid that can be
shared by xt and nft. Please, give it another spin, you can probably
come up with a better interface.

BTW, we also have two more families: inet and bridge. Inet should be
easy, it's basically a special family for dual-stack setups, 'inet'
chain see both ipv4 and ipv6 traffic, you have to use pkt->ops->pf to
pass this to right ipv4/ipv6 function.

See net/netfilter/nft_reject.c, net/ipv{4,6}/nft_reject_ipv{4,6}.c and
net/netfilter/nft_reject_inet.c for reference.

Thanks.
