From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] ipt_recent
Date: Sat, 04 Mar 2006 11:00:18 +0100
Message-ID: <44096532.2070000@trash.net>
References: <dt51lh$b63$1@sea.gmane.org> <43F9EA77.4060208@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <43F9EA77.4060208@ufomechanic.net>
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

Amin Azez wrote:
> This patch fixes the previously mentioned bug in ipt_recent and adds:
> 
> --lt n  # check less than n items in list
> --gt n  # checks more than n items in list
> --eq n  # check exactly n items in list
> 
> Which can be prefixed with ! to invert.
>
> --- include/linux/netfilter_ipv4/ipt_recent.h.nolimit	2006-02-20 10:12:06.000000000 +0000
> +++ include/linux/netfilter_ipv4/ipt_recent.h	2006-02-20 11:30:58.000000000 +0000
> @@ -10,6 +10,11 @@
>  #define IPT_RECENT_REMOVE 8
>  #define IPT_RECENT_TTL   16
>  
> +#define IPT_RECENT_INVERT 1
> +#define IPT_RECENT_LT	  2
> +#define IPT_RECENT_GT	  4
> +#define IPT_RECENT_EQ	  (IPT_RECENT_LT | IPT_RECENT_GT)
> +
>  #define IPT_RECENT_SOURCE 0
>  #define IPT_RECENT_DEST   1
>  
> @@ -20,6 +25,8 @@
>  	u_int32_t   hit_count;
>  	u_int8_t    check_set;
>  	u_int8_t    invert;
> +	u_int8_t    check_count;
> +	u_int32_t   entry_count;
>  	char        name[IPT_RECENT_NAME_LEN];
>  	u_int8_t    side;
>  };

Sorry, we can't do that since it breaks userspace compatibility. But I'm
really glad someone finally has the stomach to touch ipt_recent, I'll
review your other patches now.
