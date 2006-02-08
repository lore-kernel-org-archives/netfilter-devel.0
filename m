From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC][PATCH] nf_conntrack_ipv[4|6] load on demand for x_tables
 matches/targets
Date: Wed, 08 Feb 2006 17:21:29 +0900 (JST)
Message-ID: <200602080821.k188LUtR005369@toshiba.co.jp>
References: <43E69541.1040206@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org, kaber@trash.net
In-Reply-To: <43E69541.1040206@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi, Pablo,

At first, I've heard that Patrick has patches which change checkentry()
for net-2.6.17 tree. Patrick, how patch that is ?

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 06 Feb 2006 01:16:01 +0100

> Since x_tables was merged I have to load nf_conntrack_ipv4 by hand. I
> think that it's good if the kernel can load on demand whatever it needs.
>  This patch proposes a way to solve this open issue.
> 
> Comments welcome.


looks fine expect nf_ct_l3proto_try_module_get().

> +int
> +nf_ct_l3proto_try_module_get(u_int16_t l3proto)
> +{
> +	int ret = 0;
> +	struct nf_conntrack_l3proto *p;
> +
> +retry:	preempt_disable();
> +	p = __nf_ct_l3proto_find(l3proto);
> +	if (p == &nf_conntrack_generic_l3proto) {
> +		preempt_enable();
> +		ret = request_module("nf_conntrack-%d", l3proto);
> +		if (!ret)
> +			goto retry;
> +
> +		return ret;
> +	}
> +	if (!try_module_get(p->me))
> +		ret = -1;
> +	preempt_enable();
> +
> +	return ret;
> +}

We cannot assume that 0 as the return value of request_module() means
success. And it may return positive value (as far as I did
"rm nf_conntrack_ipv6.ko; ip6tables -A INPUT -m state ...").

How about using try_then_request_module() like this ?

	ret = try_then_request_module(nf_ct_l3proto_find_get(l3proto)
						!= &nf_ct_l3proto_generic,
				      "nf_conntrack-%d", l3proto);
	if (ret)
		return -EPROTOTYPE;

You might worry about refcount leak of nf_ct_l3proto_generic.
But don't worry, nf_ct_l3proto_find_get() should not get refcount of it.
It has bug in the current. I'll send a patch to fix that later.

-- Yasuyuki Kozakai
