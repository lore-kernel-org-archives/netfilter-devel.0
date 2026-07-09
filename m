Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3438287E;
	Thu,  9 Jul 2026 13:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783603847; cv=none; b=ovbHVmH/bmo4mFrSlSdzw5ud+DgbZuCaDL+VGR41XHicJc3W2ggAhFTGBZt/OEnruDzhtbdk5m5A/I719BGeAvLlAud9NT3VEeaXB73eviNtG/S1jp/urEtgNOkQLtENCP/96T4r+J0sTwG1Hoys3+7sP2sHAYM4IHjA5S5q0D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783603847; c=relaxed/simple;
	bh=L/ogQLdgUcD9paTKdYv+pyUnSwM8BJaXRFJQijUaefc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p1PWf33EtL6rY7/y3p19aRi20Ok7BgGkdMf/4fa6yz9H1u0dbM707rx0iQ86pvjl8ScQw1QbYgVdzRnyCYZcU1S2hhn136g0kfOQTLnw1miso6RZeM85jbnD7KzRtj+hpM4+RhMFWnEYlnOMFInWNMcg3mqPB/mo1a95UcjlskY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 150D960288; Thu, 09 Jul 2026 15:30:43 +0200 (CEST)
Date: Thu, 9 Jul 2026 15:30:42 +0200
From: Florian Westphal <fw@strlen.de>
To: xietangxin <xietangxin@h-partners.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Victor Nogueira <victor@mojatatu.com>,
	gaoxingwang <gaoxingwang1@huawei.com>,
	huyizhen <huyizhen2@huawei.com>
Subject: Re: [PATCH net v2] netfilter: nf_nat: recalculate TCP TS offset when
 snat change sport
Message-ID: <ak-igtwiaPIi9o_w@strlen.de>
References: <20260709131216.2189210-1-xietangxin@h-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709131216.2189210-1-xietangxin@h-partners.com>

xietangxin <xietangxin@h-partners.com> wrote:
> v1: https://lore.kernel.org/all/20260629093408.3927103-1-xietangxin@h-partners.com/
> ---
>  net/netfilter/nf_nat_core.c | 103 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 102 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 63ff6b4d5d21..9d0b316fa3c7 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -16,6 +16,8 @@
>  #include <linux/siphash.h>
>  #include <linux/rtnetlink.h>
>  
> +#include <net/tcp.h>
> +#include <net/secure_seq.h>
>  #include <net/netfilter/nf_conntrack_bpf.h>
>  #include <net/netfilter/nf_conntrack_core.h>
>  #include <net/netfilter/nf_conntrack_helper.h>
> @@ -894,6 +896,99 @@ static bool in_vrf_postrouting(const struct nf_hook_state *state)
>  	return false;
>  }
>  
> +static __be32 *nf_nat_tcp_ts_option_ptr(const struct sk_buff *skb)
> +{
> +	struct tcphdr *th;
> +	unsigned char *ptr;
> +	unsigned char opcode;
> +	unsigned char opsize;
> +	unsigned int optlen, offset;
> +
> +	offset = 0;
> +	th = tcp_hdr(skb);
> +	optlen = (th->doff - 5) * 4;
> +	ptr = (unsigned char *)(th + 1);

Hmm, I don't think we should assume its in linear
area.  In future someone might re-use this for forwarded
packets too.

Given you munge the packet, I think you could just call
skb_ensure_writable() early to assert entire tcp header
including options is in linear area.

> +	while (offset < optlen) {
> +		opcode = ptr[offset];
> +		if (opcode == TCPOPT_EOL)
> +			break;
> +
> +		if (opcode == TCPOPT_NOP) {
> +			offset++;
> +			continue;
> +		}
> +
> +		if (offset + 1 >= optlen)
> +			break;
> +
> +		opsize = ptr[offset + 1];
> +		if (opsize < 2 || offset + opsize > optlen)
> +			break;
> +		if (opcode == TCPOPT_TIMESTAMP && opsize == TCPOLEN_TIMESTAMP)
> +			return (__be32 *)(ptr + offset + 2);

Maybe add a comment here that says that this is only for locally
generated packets and that linux tcp will always align the tsval.

Else, write needs put_unaligned_be32() instead of direct assign.

> +static void nf_nat_update_tcp_ts_offset(struct nf_conn *ct, struct sk_buff *skb)
> +{
> +	__be32 *tsptr;
> +	struct net *net;
> +	struct tcphdr *th;
> +	struct tcp_sock *tp;
> +	union tcp_seq_and_ts_off st;
> +	struct nf_conntrack_tuple *orig_tuple;
> +	struct nf_conntrack_tuple *reply_tuple;

Could reorder this for reverse x-mas tree (i.e. invert
the above order...).

> +	orig_tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
> +	reply_tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
> +	if (orig_tuple->src.u.tcp.port == reply_tuple->dst.u.tcp.port)
> +		return;

Maybe add a comment like /* no port rewrite? No need to update anything */

> +	th = tcp_hdr(skb);
> +	if (!th || !th->syn || th->ack)
> +		return;
> +
> +	net = nf_ct_net(ct);
> +	if (READ_ONCE(net->ipv4.sysctl_tcp_timestamps) != 1)
> +		return;
> +

Maybe add a comment that above check avoid bogus tsoff update for
non-randomized tcp timestamps?

> +	if (!skb->sk)
> +		return;
> +

I suggest to do this first, so that its obvious this function
is only for locally generated packets.

> +	tsptr = nf_nat_tcp_ts_option_ptr(skb);
> +	if (!tsptr)
> +		return;
> +
> +	switch (nf_ct_l3num(ct)) {
> +	case NFPROTO_IPV4:
> +		st = secure_tcp_seq_and_ts_off(net, reply_tuple->dst.u3.ip,
> +					       reply_tuple->src.u3.ip,
> +					       reply_tuple->dst.u.tcp.port,
> +					       reply_tuple->src.u.tcp.port);
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case NFPROTO_IPV6:
> +		st = secure_tcpv6_seq_and_ts_off(net, reply_tuple->dst.u3.ip6,
> +						 reply_tuple->src.u3.ip6,
> +						 reply_tuple->dst.u.tcp.port,
> +						 reply_tuple->src.u.tcp.port);
> +		break;
> +#endif
> +	default:
> +		return;
> +	}
> +
> +	tp = tcp_sk(skb->sk);
> +	*tsptr = htonl(tcp_skb_timestamp_ts(tp->tcp_usec_ts, skb) + st.ts_off);
>
>  unsigned int
>  nf_nat_inet_fn(void *priv, struct sk_buff *skb,
>  	       const struct nf_hook_state *state)
> @@ -937,8 +1032,14 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
>  						       state);
>  				if (ret != NF_ACCEPT)
>  					return ret;
> -				if (nf_nat_initialized(ct, maniptype))
> +				if (nf_nat_initialized(ct, maniptype)) {
> +					if (state->hook == NF_INET_POST_ROUTING &&

I wonder if this should be LOCAL_OUT.  I do understand that many
people use SNAT/MASQUERADE from postrouting to deal with both local and
forwarded traffic at the same time, so more of a open question.
