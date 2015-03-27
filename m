From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 1/2] netfilter: x_tables: refactor lookup
 helpers from xt_socket
Date: Fri, 27 Mar 2015 01:06:44 +0100
Message-ID: <20150327000644.GC3545@salvia>
References: <cover.1427394874.git.daniel@iogearbox.net>
 <647fedfdea7781dbe48a8cb720b4715ef769cd05.1427394874.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46236 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbbC0ACq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 20:02:46 -0400
Content-Disposition: inline
In-Reply-To: <647fedfdea7781dbe48a8cb720b4715ef769cd05.1427394874.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 26, 2015 at 08:14:47PM +0100, Daniel Borkmann wrote:
> The socket lookup helpers are also needed for fixing xt_cgroups,
> therefore refactor them into shareable helper functions.
> 
> This simplifies and optimizes the xt_socket code itself a bit
> as well, i.e. time to verdict for early demux sockets should be
> much faster than previously:
> 
> We've unnecessarily extracted proto, {s,d}addr and {s,d}ports
> from the skb data, accessing possible conntrack information,
> etc even though we were not even calling into the socket lookup
> via xt_socket_get_sock_v4() due to skb->sk hit.
> 
> After this patch, we only proceed the slow-path when we have an
> actual skb->sk miss.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Daniel Mack <daniel@zonque.org>
> Cc: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/xt_sk_helper.h | 282 +++++++++++++++++++++++++++++++++++++++++
>  net/netfilter/xt_socket.c    | 293 +++----------------------------------------
>  2 files changed, 300 insertions(+), 275 deletions(-)
>  create mode 100644 net/netfilter/xt_sk_helper.h
> 
> diff --git a/net/netfilter/xt_sk_helper.h b/net/netfilter/xt_sk_helper.h
> new file mode 100644
> index 0000000..604b7ac
> --- /dev/null
> +++ b/net/netfilter/xt_sk_helper.h

Please, no code in a header file. Instead split the content of this
file in two:

* net/ipv4/netfilter/nf_sock_ipv4.c
* net/ipv6/netfilter/nf_sock_ipv6.c

You will have the corresponding Kconfig and Makefile trickery too.

Also rename all those functions to the prefix nf_sock_*

The Kconfig for xt_socket should contain:

select NF_SOCK_IPV4
select NF_SOCK_IPV6 if IP6_NF_IPTABLES

This is how we're doing with other extensions to share code between xt
and nft, you will help us if you do it like that.

Thanks.
