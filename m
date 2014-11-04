From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFA][PATCH 3/8] netfilter: Convert print_tuple functions to
 return void
Date: Tue, 4 Nov 2014 09:50:41 -0500
Message-ID: <20141104095041.1cafa975@gandalf.local.home>
References: <20141029215602.535533597@goodmis.org>
	<20141029220107.627391824@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Joe Perches <joe@perches.com>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141029220107.627391824@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Pablo,

I'm replying to the patch that was sent. Hopefully you get it.

Thanks,

-- Steve


On Wed, 29 Oct 2014 17:56:05 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Joe Perches <joe@perches.com>
> 
> [ REQUEST FOR ACKS ]
> 
> Since adding a new function to seq_file (seq_has_overflowed())
> there isn't any value for functions called from seq_show to
> return anything.   Remove the int returns of the various
> print_tuple/<foo>_print_tuple functions.
> 
> Link: http://lkml.kernel.org/p/f2e8cf8df433a197daa62cbaf124c900c708edc7.1412031505.git.joe@perches.com
> 
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Cc: netfilter-devel@vger.kernel.org
> Cc: coreteam@netfilter.org
> Signed-off-by: Joe Perches <joe@perches.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/net/netfilter/nf_conntrack_core.h             |  2 +-
>  include/net/netfilter/nf_conntrack_l3proto.h          |  4 ++--
>  include/net/netfilter/nf_conntrack_l4proto.h          |  4 ++--
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c        |  6 +++---
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c | 12 ++++++++----
>  net/ipv4/netfilter/nf_conntrack_proto_icmp.c          | 10 +++++-----
>  net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c        |  6 +++---
>  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c        | 10 +++++-----
>  net/netfilter/nf_conntrack_l3proto_generic.c          |  5 ++---
>  net/netfilter/nf_conntrack_proto_dccp.c               | 10 +++++-----
>  net/netfilter/nf_conntrack_proto_generic.c            |  5 ++---
>  net/netfilter/nf_conntrack_proto_gre.c                | 10 +++++-----
>  net/netfilter/nf_conntrack_proto_sctp.c               | 10 +++++-----
>  net/netfilter/nf_conntrack_proto_tcp.c                | 10 +++++-----
>  net/netfilter/nf_conntrack_proto_udp.c                | 10 +++++-----
>  net/netfilter/nf_conntrack_proto_udplite.c            | 10 +++++-----
>  net/netfilter/nf_conntrack_standalone.c               | 15 +++++++--------
>  17 files changed, 70 insertions(+), 69 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
> index cc0c18827602..f2f0fa3bb150 100644
> --- a/include/net/netfilter/nf_conntrack_core.h
> +++ b/include/net/netfilter/nf_conntrack_core.h
> @@ -72,7 +72,7 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
>  	return ret;
>  }
>  
> -int
> +void
>  print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
>              const struct nf_conntrack_l3proto *l3proto,
>              const struct nf_conntrack_l4proto *proto);
> diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
> index adc1fa3dd7ab..cdc920b4c4c2 100644
> --- a/include/net/netfilter/nf_conntrack_l3proto.h
> +++ b/include/net/netfilter/nf_conntrack_l3proto.h
> @@ -38,8 +38,8 @@ struct nf_conntrack_l3proto {
>  			     const struct nf_conntrack_tuple *orig);
>  
>  	/* Print out the per-protocol part of the tuple. */
> -	int (*print_tuple)(struct seq_file *s,
> -			   const struct nf_conntrack_tuple *);
> +	void (*print_tuple)(struct seq_file *s,
> +			    const struct nf_conntrack_tuple *);
>  
>  	/*
>  	 * Called before tracking. 
> diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
> index 82e4ec002a39..1f7061313d54 100644
> --- a/include/net/netfilter/nf_conntrack_l4proto.h
> +++ b/include/net/netfilter/nf_conntrack_l4proto.h
> @@ -56,8 +56,8 @@ struct nf_conntrack_l4proto {
>  		     u_int8_t pf, unsigned int hooknum);
>  
>  	/* Print out the per-protocol part of the tuple. Return like seq_* */
> -	int (*print_tuple)(struct seq_file *s,
> -			   const struct nf_conntrack_tuple *);
> +	void (*print_tuple)(struct seq_file *s,
> +			    const struct nf_conntrack_tuple *);
>  
>  	/* Print out the private part of the conntrack. */
>  	void (*print_conntrack)(struct seq_file *s, struct nf_conn *);
> diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> index a054fe083431..5c61328b7704 100644
> --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> @@ -56,11 +56,11 @@ static bool ipv4_invert_tuple(struct nf_conntrack_tuple *tuple,
>  	return true;
>  }
>  
> -static int ipv4_print_tuple(struct seq_file *s,
> +static void ipv4_print_tuple(struct seq_file *s,
>  			    const struct nf_conntrack_tuple *tuple)
>  {
> -	return seq_printf(s, "src=%pI4 dst=%pI4 ",
> -			  &tuple->src.u3.ip, &tuple->dst.u3.ip);
> +	seq_printf(s, "src=%pI4 dst=%pI4 ",
> +		   &tuple->src.u3.ip, &tuple->dst.u3.ip);
>  }
>  
>  static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
> diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
> index 91f207c2cb69..d927f9e72130 100644
> --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
> +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
> @@ -153,8 +153,10 @@ static int ct_seq_show(struct seq_file *s, void *v)
>  	if (seq_has_overflowed(s))
>  		goto release;
>  
> -	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> -			l3proto, l4proto))
> +	print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> +		    l3proto, l4proto);
> +
> +	if (seq_has_overflowed(s))
>  		goto release;
>  
>  	if (seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL))
> @@ -164,8 +166,10 @@ static int ct_seq_show(struct seq_file *s, void *v)
>  		if (seq_printf(s, "[UNREPLIED] "))
>  			goto release;
>  
> -	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
> -			l3proto, l4proto))
> +	print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
> +		    l3proto, l4proto);
> +
> +	if (seq_has_overflowed(s))
>  		goto release;
>  
>  	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
> diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
> index b91b2641adda..80d5554b9a88 100644
> --- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
> +++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
> @@ -72,13 +72,13 @@ static bool icmp_invert_tuple(struct nf_conntrack_tuple *tuple,
>  }
>  
>  /* Print out the per-protocol part of the tuple. */
> -static int icmp_print_tuple(struct seq_file *s,
> +static void icmp_print_tuple(struct seq_file *s,
>  			    const struct nf_conntrack_tuple *tuple)
>  {
> -	return seq_printf(s, "type=%u code=%u id=%u ",
> -			  tuple->dst.u.icmp.type,
> -			  tuple->dst.u.icmp.code,
> -			  ntohs(tuple->src.u.icmp.id));
> +	seq_printf(s, "type=%u code=%u id=%u ",
> +		   tuple->dst.u.icmp.type,
> +		   tuple->dst.u.icmp.code,
> +		   ntohs(tuple->src.u.icmp.id));
>  }
>  
>  static unsigned int *icmp_get_timeouts(struct net *net)
> diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
> index 4cbc6b290dd5..b68d0e59c1f8 100644
> --- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
> +++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
> @@ -60,11 +60,11 @@ static bool ipv6_invert_tuple(struct nf_conntrack_tuple *tuple,
>  	return true;
>  }
>  
> -static int ipv6_print_tuple(struct seq_file *s,
> +static void ipv6_print_tuple(struct seq_file *s,
>  			    const struct nf_conntrack_tuple *tuple)
>  {
> -	return seq_printf(s, "src=%pI6 dst=%pI6 ",
> -			  tuple->src.u3.ip6, tuple->dst.u3.ip6);
> +	seq_printf(s, "src=%pI6 dst=%pI6 ",
> +		   tuple->src.u3.ip6, tuple->dst.u3.ip6);
>  }
>  
>  static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
> diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> index b3807c5cb888..90388d606483 100644
> --- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> +++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> @@ -84,13 +84,13 @@ static bool icmpv6_invert_tuple(struct nf_conntrack_tuple *tuple,
>  }
>  
>  /* Print out the per-protocol part of the tuple. */
> -static int icmpv6_print_tuple(struct seq_file *s,
> +static void icmpv6_print_tuple(struct seq_file *s,
>  			      const struct nf_conntrack_tuple *tuple)
>  {
> -	return seq_printf(s, "type=%u code=%u id=%u ",
> -			  tuple->dst.u.icmp.type,
> -			  tuple->dst.u.icmp.code,
> -			  ntohs(tuple->src.u.icmp.id));
> +	seq_printf(s, "type=%u code=%u id=%u ",
> +		   tuple->dst.u.icmp.type,
> +		   tuple->dst.u.icmp.code,
> +		   ntohs(tuple->src.u.icmp.id));
>  }
>  
>  static unsigned int *icmpv6_get_timeouts(struct net *net)
> diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
> index e7eb807fe07d..cf9ace70bece 100644
> --- a/net/netfilter/nf_conntrack_l3proto_generic.c
> +++ b/net/netfilter/nf_conntrack_l3proto_generic.c
> @@ -49,10 +49,9 @@ static bool generic_invert_tuple(struct nf_conntrack_tuple *tuple,
>  	return true;
>  }
>  
> -static int generic_print_tuple(struct seq_file *s,
> -			    const struct nf_conntrack_tuple *tuple)
> +static void generic_print_tuple(struct seq_file *s,
> +				const struct nf_conntrack_tuple *tuple)
>  {
> -	return 0;
>  }
>  
>  static int generic_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
> diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
> index 15971177470a..6dd995c7c72b 100644
> --- a/net/netfilter/nf_conntrack_proto_dccp.c
> +++ b/net/netfilter/nf_conntrack_proto_dccp.c
> @@ -618,12 +618,12 @@ out_invalid:
>  	return -NF_ACCEPT;
>  }
>  
> -static int dccp_print_tuple(struct seq_file *s,
> -			    const struct nf_conntrack_tuple *tuple)
> +static void dccp_print_tuple(struct seq_file *s,
> +			     const struct nf_conntrack_tuple *tuple)
>  {
> -	return seq_printf(s, "sport=%hu dport=%hu ",
> -			  ntohs(tuple->src.u.dccp.port),
> -			  ntohs(tuple->dst.u.dccp.port));
> +	seq_printf(s, "sport=%hu dport=%hu ",
> +		   ntohs(tuple->src.u.dccp.port),
> +		   ntohs(tuple->dst.u.dccp.port));
>  }
>  
>  static void dccp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
> diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
> index 957c1db66652..60865f110309 100644
> --- a/net/netfilter/nf_conntrack_proto_generic.c
> +++ b/net/netfilter/nf_conntrack_proto_generic.c
> @@ -63,10 +63,9 @@ static bool generic_invert_tuple(struct nf_conntrack_tuple *tuple,
>  }
>  
>  /* Print out the per-protocol part of the tuple. */
> -static int generic_print_tuple(struct seq_file *s,
> -			       const struct nf_conntrack_tuple *tuple)
> +static void generic_print_tuple(struct seq_file *s,
> +				const struct nf_conntrack_tuple *tuple)
>  {
> -	return 0;
>  }
>  
>  static unsigned int *generic_get_timeouts(struct net *net)
> diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
> index cba607ada069..7648674f29c3 100644
> --- a/net/netfilter/nf_conntrack_proto_gre.c
> +++ b/net/netfilter/nf_conntrack_proto_gre.c
> @@ -226,12 +226,12 @@ static bool gre_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
>  }
>  
>  /* print gre part of tuple */
> -static int gre_print_tuple(struct seq_file *s,
> -			   const struct nf_conntrack_tuple *tuple)
> +static void gre_print_tuple(struct seq_file *s,
> +			    const struct nf_conntrack_tuple *tuple)
>  {
> -	return seq_printf(s, "srckey=0x%x dstkey=0x%x ",
> -			  ntohs(tuple->src.u.gre.key),
> -			  ntohs(tuple->dst.u.gre.key));
> +	seq_printf(s, "srckey=0x%x dstkey=0x%x ",
> +		   ntohs(tuple->src.u.gre.key),
> +		   ntohs(tuple->dst.u.gre.key));
>  }
>  
>  /* print private data for conntrack */
> diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> index c61f4cd6407d..b45da90fad32 100644
> --- a/net/netfilter/nf_conntrack_proto_sctp.c
> +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> @@ -166,12 +166,12 @@ static bool sctp_invert_tuple(struct nf_conntrack_tuple *tuple,
>  }
>  
>  /* Print out the per-protocol part of the tuple. */
> -static int sctp_print_tuple(struct seq_file *s,
> -			    const struct nf_conntrack_tuple *tuple)
> +static void sctp_print_tuple(struct seq_file *s,
> +			     const struct nf_conntrack_tuple *tuple)
>  {
> -	return seq_printf(s, "sport=%hu dport=%hu ",
> -			  ntohs(tuple->src.u.sctp.port),
> -			  ntohs(tuple->dst.u.sctp.port));
> +	seq_printf(s, "sport=%hu dport=%hu ",
> +		   ntohs(tuple->src.u.sctp.port),
> +		   ntohs(tuple->dst.u.sctp.port));
>  }
>  
>  /* Print out the private part of the conntrack. */
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 79668fd3db96..36a3ac8ee9f5 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -302,12 +302,12 @@ static bool tcp_invert_tuple(struct nf_conntrack_tuple *tuple,
>  }
>  
>  /* Print out the per-protocol part of the tuple. */
> -static int tcp_print_tuple(struct seq_file *s,
> -			   const struct nf_conntrack_tuple *tuple)
> +static void tcp_print_tuple(struct seq_file *s,
> +			    const struct nf_conntrack_tuple *tuple)
>  {
> -	return seq_printf(s, "sport=%hu dport=%hu ",
> -			  ntohs(tuple->src.u.tcp.port),
> -			  ntohs(tuple->dst.u.tcp.port));
> +	seq_printf(s, "sport=%hu dport=%hu ",
> +		   ntohs(tuple->src.u.tcp.port),
> +		   ntohs(tuple->dst.u.tcp.port));
>  }
>  
>  /* Print out the private part of the conntrack. */
> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
> index 9d7721cbce4b..6957281ffee5 100644
> --- a/net/netfilter/nf_conntrack_proto_udp.c
> +++ b/net/netfilter/nf_conntrack_proto_udp.c
> @@ -63,12 +63,12 @@ static bool udp_invert_tuple(struct nf_conntrack_tuple *tuple,
>  }
>  
>  /* Print out the per-protocol part of the tuple. */
> -static int udp_print_tuple(struct seq_file *s,
> -			   const struct nf_conntrack_tuple *tuple)
> +static void udp_print_tuple(struct seq_file *s,
> +			    const struct nf_conntrack_tuple *tuple)
>  {
> -	return seq_printf(s, "sport=%hu dport=%hu ",
> -			  ntohs(tuple->src.u.udp.port),
> -			  ntohs(tuple->dst.u.udp.port));
> +	seq_printf(s, "sport=%hu dport=%hu ",
> +		   ntohs(tuple->src.u.udp.port),
> +		   ntohs(tuple->dst.u.udp.port));
>  }
>  
>  static unsigned int *udp_get_timeouts(struct net *net)
> diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
> index 2750e6c69f82..c5903d1649f9 100644
> --- a/net/netfilter/nf_conntrack_proto_udplite.c
> +++ b/net/netfilter/nf_conntrack_proto_udplite.c
> @@ -71,12 +71,12 @@ static bool udplite_invert_tuple(struct nf_conntrack_tuple *tuple,
>  }
>  
>  /* Print out the per-protocol part of the tuple. */
> -static int udplite_print_tuple(struct seq_file *s,
> -			       const struct nf_conntrack_tuple *tuple)
> +static void udplite_print_tuple(struct seq_file *s,
> +				const struct nf_conntrack_tuple *tuple)
>  {
> -	return seq_printf(s, "sport=%hu dport=%hu ",
> -			  ntohs(tuple->src.u.udp.port),
> -			  ntohs(tuple->dst.u.udp.port));
> +	seq_printf(s, "sport=%hu dport=%hu ",
> +		   ntohs(tuple->src.u.udp.port),
> +		   ntohs(tuple->dst.u.udp.port));
>  }
>  
>  static unsigned int *udplite_get_timeouts(struct net *net)
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 348aa3602787..23a0dcab21d4 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -36,12 +36,13 @@
>  MODULE_LICENSE("GPL");
>  
>  #ifdef CONFIG_NF_CONNTRACK_PROCFS
> -int
> +void
>  print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
>              const struct nf_conntrack_l3proto *l3proto,
>              const struct nf_conntrack_l4proto *l4proto)
>  {
> -	return l3proto->print_tuple(s, tuple) || l4proto->print_tuple(s, tuple);
> +	l3proto->print_tuple(s, tuple);
> +	l4proto->print_tuple(s, tuple);
>  }
>  EXPORT_SYMBOL_GPL(print_tuple);
>  
> @@ -202,9 +203,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
>  	if (l4proto->print_conntrack)
>  		l4proto->print_conntrack(s, ct);
>  
> -	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> -			l3proto, l4proto))
> -		goto release;
> +	print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> +		    l3proto, l4proto);
>  
>  	if (seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL))
>  		goto release;
> @@ -213,9 +213,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
>  		if (seq_printf(s, "[UNREPLIED] "))
>  			goto release;
>  
> -	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
> -			l3proto, l4proto))
> -		goto release;
> +	print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
> +		    l3proto, l4proto);
>  
>  	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
>  		goto release;
