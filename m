From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next,RFC 2/3] netfilter: ctnetlink: use 64-bit
 conntrack ID
Date: Tue, 28 Nov 2017 13:12:06 +0100
Message-ID: <20171128121206.GG23412@breakpoint.cc>
References: <20171128021309.11277-1-pablo@netfilter.org>
 <20171128021309.11277-2-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, richard@nod.at, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48786 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752324AbdK1MNQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Nov 2017 07:13:16 -0500
Content-Disposition: inline
In-Reply-To: <20171128021309.11277-2-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>  static int ctnetlink_flush_conntrack(struct net *net,
> @@ -1174,6 +1177,13 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
>  			nf_ct_put(ct);
>  			return -ENOENT;
>  		}
> +	} else if (cda[CTA_ID64]) {
> +		u64 id = ntohl(nla_get_be64(cda[CTA_ID64]));

be64_to_cpu()?

But at this point we already uniquely identified the conntrack entry
so the ID check appears to be unneeded?

I never understood existing test either, so this remark isn't specific
to your patch.
