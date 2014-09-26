From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH nf v2] netfilter: conntrack: disable generic tracking
 for known protocols
Date: Fri, 26 Sep 2014 12:13:44 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409261212510.18634@blackhole.kfki.hu>
References: <20140926093542.GD26716@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, dborkman@redhat.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:56771 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbaIZKNV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:13:21 -0400
In-Reply-To: <20140926093542.GD26716@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 26 Sep 2014, Florian Westphal wrote:

> Given following iptables ruleset:
> 
> -P FORWARD DROP
> -A FORWARD -m sctp --dport 9 -j ACCEPT
> -A FORWARD -p tcp --dport 80 -j ACCEPT
> -A FORWARD -p tcp -m conntrack -m state ESTABLISHED,RELATED -j ACCEPT
> 
> One would assume that this allows SCTP on port 9 and TCP on port 80.
> Unfortunately, if the SCTP conntrack module is not loaded, this allows
> *all* SCTP communication, to pass though, i.e. -p sctp -j ACCEPT,
> which we think is a security issue.
> 
> This is because on the first SCTP packet on port 9, we create a dummy
> "generic l4" conntrack entry without any port information (since
> conntrack doesn't know how to extract this information).
> 
> All subsequent packets that are unknown will then be in established
> state since they will fallback to proto_generic and will match the
> 'generic' entry.
> 
> Our originally proposed version [1] completely disabled generic protocol
> tracking, but Jozsef suggests to not track protocols for which a more
> suitable helper is available, hence we now mitigate the issue for in
> tree known ct protocol helpers only, so that at least NAT and direction
> information will still be preserved for others.
> 
>  [1] http://www.spinics.net/lists/netfilter-devel/msg33430.html
> 
> Joint work with Daniel Borkmann.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

> ---
>  net/netfilter/nf_conntrack_proto_generic.c |   26 +++++++++++++++++++++++++-
>  1 files changed, 25 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
> index d25f293..957c1db 100644
> --- a/net/netfilter/nf_conntrack_proto_generic.c
> +++ b/net/netfilter/nf_conntrack_proto_generic.c
> @@ -14,6 +14,30 @@
>  
>  static unsigned int nf_ct_generic_timeout __read_mostly = 600*HZ;
>  
> +static bool nf_generic_should_process(u8 proto)
> +{
> +	switch (proto) {
> +#ifdef CONFIG_NF_CT_PROTO_SCTP_MODULE
> +	case IPPROTO_SCTP:
> +		return false;
> +#endif
> +#ifdef CONFIG_NF_CT_PROTO_DCCP_MODULE
> +	case IPPROTO_DCCP:
> +		return false;
> +#endif
> +#ifdef CONFIG_NF_CT_PROTO_GRE_MODULE
> +	case IPPROTO_GRE:
> +		return false;
> +#endif
> +#ifdef CONFIG_NF_CT_PROTO_UDPLITE_MODULE
> +	case IPPROTO_UDPLITE:
> +		return false;
> +#endif
> +	default:
> +		return true;
> +	}
> +}
> +
>  static inline struct nf_generic_net *generic_pernet(struct net *net)
>  {
>  	return &net->ct.nf_ct_proto.generic;
> @@ -67,7 +91,7 @@ static int generic_packet(struct nf_conn *ct,
>  static bool generic_new(struct nf_conn *ct, const struct sk_buff *skb,
>  			unsigned int dataoff, unsigned int *timeouts)
>  {
> -	return true;
> +	return nf_generic_should_process(nf_ct_protonum(ct));
>  }
>  
>  #if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
> -- 
> 1.7.1

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
