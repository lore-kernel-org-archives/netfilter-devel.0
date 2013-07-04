From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH -stable-3.9 01/15] netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond packet boundary
Date: Thu, 04 Jul 2013 15:59:54 +0100
Message-ID: <87ehbe5q1h.fsf@canonical.com>
References: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	stable@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1372776665-6795-1-git-send-email-pablo@netfilter.org> (Pablo
	Neira Ayuso's message of "Tue, 2 Jul 2013 16:50:51 +0200")
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

Apparently, most of these patches are also applicable to older kernel
trees.  I did a quick check and the following seem to be applicable to
the 3.5 kernel:

bc6bcb5 netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond packet boundary
4f36ea6 netfilter: ipt_ULOG: fix non-null terminated string in the nf_log path
2a7851b netfilter: add nf_ipv6_ops hook to fix xt_addrtype with IPv6
d660164 netfilter: xt_LOG: fix mark logging for IPv6 packets
a8241c6 ipvs: info leak in __ip_vs_get_dest_entries()
37bc4f8 netfilter: nfnetlink_cttimeout: fix incomplete dumping of objects
991a6b7 netfilter: nfnetlink_acct: fix incomplete dumping of objects
409b545 netfilter: xt_TCPMSS: Fix violation of RFC879 in absence of MSS option
ed82c43 netfilter: xt_TCPOPTSTRIP: don't use tcp_hdr()
b396966 netfilter: xt_TCPMSS: Fix missing fragmentation handling
70d19f8 netfilter: xt_TCPMSS: Fix IPv6 default MSS too
06f3d7f ipvs: SCTP ports should be writable in ICMP packets

Only these 3 were left out:

dc7b3eb ipvs: Fix reuse connection if real server is dead
5aed938 netfilter: nf_nat_sip: fix mangling
797a7d6 netfilter: ctnetlink: send event when conntrack label was modified

Do you have any reason for including them on 3.9 kernel only, or
should they be queued for older kernels as well?

Cheers,
-- 
Luis

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> This target assumes that tcph->doff is well-formed, that may be well
> not the case. Add extra sanity checkings to avoid possible crash due
> to read/write out of the real packet boundary. After this patch, the
> default action on malformed TCP packets is to drop them. Moreover,
> fragments are skipped.
>
> Reported-by: Rafal Kupka <rkupka@telemetry.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Cherry-pick: bc6bcb59dd7c184d229f9e86d08aa56059938a4c
>
>  net/netfilter/xt_TCPOPTSTRIP.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
> index 25fd1c4..1eb1a44 100644
> --- a/net/netfilter/xt_TCPOPTSTRIP.c
> +++ b/net/netfilter/xt_TCPOPTSTRIP.c
> @@ -30,17 +30,28 @@ static inline unsigned int optlen(const u_int8_t *opt, unsigned int offset)
>  
>  static unsigned int
>  tcpoptstrip_mangle_packet(struct sk_buff *skb,
> -			  const struct xt_tcpoptstrip_target_info *info,
> +			  const struct xt_action_param *par,
>  			  unsigned int tcphoff, unsigned int minlen)
>  {
> +	const struct xt_tcpoptstrip_target_info *info = par->targinfo;
>  	unsigned int optl, i, j;
>  	struct tcphdr *tcph;
>  	u_int16_t n, o;
>  	u_int8_t *opt;
> +	int len;
> +
> +	/* This is a fragment, no TCP header is available */
> +	if (par->fragoff != 0)
> +		return XT_CONTINUE;
>  
>  	if (!skb_make_writable(skb, skb->len))
>  		return NF_DROP;
>  
> +	len = skb->len - tcphoff;
> +	if (len < (int)sizeof(struct tcphdr) ||
> +	    tcp_hdr(skb)->doff * 4 > len)
> +		return NF_DROP;
> +
>  	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
>  	opt  = (u_int8_t *)tcph;
>  
> @@ -76,7 +87,7 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
>  static unsigned int
>  tcpoptstrip_tg4(struct sk_buff *skb, const struct xt_action_param *par)
>  {
> -	return tcpoptstrip_mangle_packet(skb, par->targinfo, ip_hdrlen(skb),
> +	return tcpoptstrip_mangle_packet(skb, par, ip_hdrlen(skb),
>  	       sizeof(struct iphdr) + sizeof(struct tcphdr));
>  }
>  
> @@ -94,7 +105,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_action_param *par)
>  	if (tcphoff < 0)
>  		return NF_DROP;
>  
> -	return tcpoptstrip_mangle_packet(skb, par->targinfo, tcphoff,
> +	return tcpoptstrip_mangle_packet(skb, par, tcphoff,
>  	       sizeof(*ipv6h) + sizeof(struct tcphdr));
>  }
>  #endif
