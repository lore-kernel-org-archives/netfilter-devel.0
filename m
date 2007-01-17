From: Patrick McHardy <kaber@trash.net>
Subject: Re: Resend [Patch 1/2] Avoid direct connections between NATed hosts
Date: Wed, 17 Jan 2007 13:23:27 +0100
Message-ID: <45AE153F.6010105@trash.net>
References: <1168621167.28615.14.camel@localhost.localdomain>	<Pine.LNX.4.61.0701122350230.19224@yvahk01.tjqt.qr>
	<1168722049.5737.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1168722049.5737.4.camel@localhost>
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

Eric Leblond wrote:
> diff --git a/include/linux/netfilter_ipv4/ip_nat.h b/include/linux/netfilter_ipv4/ip_nat.h
> index bdf5536..bbca89a 100644
> --- a/include/linux/netfilter_ipv4/ip_nat.h
> +++ b/include/linux/netfilter_ipv4/ip_nat.h
> @@ -16,6 +16,7 @@ #define HOOK2MANIP(hooknum) ((hooknum) !
>  
>  #define IP_NAT_RANGE_MAP_IPS 1
>  #define IP_NAT_RANGE_PROTO_SPECIFIED 2
> +#define IP_NAT_RANGE_PROTO_RANDOM 4 /* add randomness to "port" selection */
>  
>  /* NAT sequence number modifications */
>  struct ip_nat_seq {
> diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
> index 61c6206..bc57dd7 100644
> --- a/include/net/netfilter/nf_nat.h
> +++ b/include/net/netfilter/nf_nat.h
> @@ -16,6 +16,7 @@ #define HOOK2MANIP(hooknum) ((hooknum) !
>  
>  #define IP_NAT_RANGE_MAP_IPS 1
>  #define IP_NAT_RANGE_PROTO_SPECIFIED 2
> +#define IP_NAT_RANGE_PROTO_RANDOM 4
>  
>  /* NAT sequence number modifications */
>  struct nf_nat_seq {
> diff --git a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
> index 9d1a517..5e08c2b 100644
> --- a/net/ipv4/netfilter/ip_nat_core.c
> +++ b/net/ipv4/netfilter/ip_nat_core.c
> @@ -246,8 +246,9 @@ get_unique_tuple(struct ip_conntrack_tup
>  	if (maniptype == IP_NAT_MANIP_SRC) {
>  		if (find_appropriate_src(orig_tuple, tuple, range)) {
>  			DEBUGP("get_unique_tuple: Found current src map\n");
> -			if (!ip_nat_used_tuple(tuple, conntrack))
> -				return;
> +			if (!(range->flags & IP_NAT_RANGE_PROTO_RANDOM))
> +				if (!ip_nat_used_tuple(tuple, conntrack))
> +					return;
>  		}
>  	}
>  
> @@ -261,6 +262,13 @@ get_unique_tuple(struct ip_conntrack_tup
>  
>  	proto = ip_nat_proto_find_get(orig_tuple->dst.protonum);
>  
> +	/* Change protocol info to have some randomization */
> +	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM) {

This doesn't seem to make much sense for DNAT. Either catch it in
the checkentry functions or avoid some other way.

> +		proto->unique_tuple(tuple, range, maniptype, conntrack);
> +		ip_nat_proto_put(proto);
> +		return;
> +	}
> +
>  	/* Only bother mapping if it's not already in range and unique */
>  	if ((!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)
>  	     || proto->in_range(tuple, maniptype, &range->min, &range->max))
> diff --git a/net/ipv4/netfilter/ip_nat_proto_tcp.c b/net/ipv4/netfilter/ip_nat_proto_tcp.c
> index b586d18..154a4f7 100644
> --- a/net/ipv4/netfilter/ip_nat_proto_tcp.c
> +++ b/net/ipv4/netfilter/ip_nat_proto_tcp.c
> @@ -18,6 +18,8 @@ #include <linux/netfilter_ipv4/ip_nat_ru
>  #include <linux/netfilter_ipv4/ip_nat_protocol.h>
>  #include <linux/netfilter_ipv4/ip_nat_core.h>
>  
> +#include <linux/random.h>

Put this next to the other linux/ includes please.

> +
>  static int
>  tcp_in_range(const struct ip_conntrack_tuple *tuple,
>  	     enum ip_nat_manip_type maniptype,
> @@ -75,6 +77,9 @@ tcp_unique_tuple(struct ip_conntrack_tup
>  		range_size = ntohs(range->max.tcp.port) - min + 1;
>  	}
>  
> +	/* Start from random port to avoid prediction */
> +	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM)
> +		port = (u_int16_t) net_random();

No need to cast, also endianness error (port is __be16).

>  	for (i = 0; i < range_size; i++, port++) {
>  		*portptr = htons(min + port % range_size);
>  		if (!ip_nat_used_tuple(tuple, conntrack)) {
