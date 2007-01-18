From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: PANIC: divide by zero in xt_connbytes
Date: Thu, 18 Jan 2007 14:28:55 +0100
Message-ID: <45AF7617.8010202@netfilter.org>
References: <45AF5318.8040204@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <45AF5318.8040204@outerspace.dyndns.org>
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

Jonas Berlin wrote:
> Hidden asked me (on irc) to bring your attention to this bug:
> 
> ~  http://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=533

Copied from your patch available on bugzilla:

> diff -ur linux-2.6.19/net/netfilter/xt_connbytes.c linux-2.6.19-xt_connbytes_fix/net/netfilter/xt_connbytes.c
> --- linux-2.6.19/net/netfilter/xt_connbytes.c	2007-01-11 20:01:51.000000000 +0200
> +++ linux-2.6.19-xt_connbytes_fix/net/netfilter/xt_connbytes.c	2007-01-18 12:15:50.000000000 +0200
> @@ -89,26 +89,39 @@
>  	case XT_CONNBYTES_AVGPKT:
>  		switch (sinfo->direction) {
>  		case XT_CONNBYTES_DIR_ORIGINAL:
> -			what = div64_64(counters[IP_CT_DIR_ORIGINAL].bytes,
> -					counters[IP_CT_DIR_ORIGINAL].packets);

Better check that divisor must be != 0 inside div64_64.

> +			if (counters[IP_CT_DIR_ORIGINAL].packets == 0) {
> +				what = 0;
> +			} else {
> +				what = div64_64(counters[IP_CT_DIR_ORIGINAL].bytes,
> +						counters[IP_CT_DIR_ORIGINAL].packets);
> +			}
>  			break;
>  		case XT_CONNBYTES_DIR_REPLY:
> -			what = div64_64(counters[IP_CT_DIR_REPLY].bytes,
> -					counters[IP_CT_DIR_REPLY].packets);
> +			if (counters[IP_CT_DIR_REPLY].packets == 0) {
> +				what = 0;
> +			} else {
> +				what = div64_64(counters[IP_CT_DIR_REPLY].bytes,
> +						counters[IP_CT_DIR_REPLY].packets);
> +			}
>  			break;
>  		case XT_CONNBYTES_DIR_BOTH:
>  			{
> -				u_int64_t bytes;
>  				u_int64_t pkts;
> -				bytes = counters[IP_CT_DIR_ORIGINAL].bytes +
> -					counters[IP_CT_DIR_REPLY].bytes;
>  				pkts = counters[IP_CT_DIR_ORIGINAL].packets+
>  					counters[IP_CT_DIR_REPLY].packets;
>  
> -				/* FIXME_THEORETICAL: what to do if sum
> -				 * overflows ? */
> +				if (pkts == 0) {
> +					what = 0;
> +				} else {
> +					u_int64_t bytes;
> +					bytes = counters[IP_CT_DIR_ORIGINAL].bytes +
> +						counters[IP_CT_DIR_REPLY].bytes;
> +
> +					/* FIXME_THEORETICAL: what to do if sum
> +					 * overflows ? */
                                           ^^^
Hm, already had this discussion: This is really hard to happen with 64
bits counters, it would take years even in a high performance network.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
