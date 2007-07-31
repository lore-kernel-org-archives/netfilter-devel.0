From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 01/**] libxt_*.so lookup
Date: Tue, 31 Jul 2007 09:25:12 +0900 (JST)
Message-ID: <200707310025.l6V0PDvM029553@toshiba.co.jp>
References: <Pine.LNX.4.64.0707241111280.18990@fbirervta.pbzchgretzou.qr>
	<200707240949.l6O9n1Oi008901@toshiba.co.jp>
	<Pine.LNX.4.64.0707241201420.18990@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707241201420.18990@fbirervta.pbzchgretzou.qr>
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


Hi,

From: Jan Engelhardt <jengelh@computergmbh.de>

> Let the iptable tools search for libxt modules first,
> then for l3-specific modules (libipt, libip6t)
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>


> +static const char *const family_prefix[] = {
> +	[AF_UNSPEC] = "xt",
> +	[AF_INET]   = "ipt",
> +	[AF_INET6]  = "ip6t",
> +};
> +

Using AF_UNSPEC is attractive. It can save almost samef xtables_{match,target}
as you proposed in other mail. But I prefer to keep things logical. Other
than IPv4 and IPv6 family cannot support almost 'xt_' matches/targets.

>  struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
> -				 struct xtables_rule_match **matches)
> +				 struct xtables_rule_match **matches,
> +				 unsigned int family)
>  {
>  	struct xtables_match *ptr;
>  	const char *icmp6 = "icmp6";
> @@ -292,21 +300,27 @@ struct xtables_match *find_match(const c
>  	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
>  		char path[strlen(lib_dir) + sizeof("/.so")
>  			  + strlen(afinfo.libprefix) + strlen(name)];
> -		sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
> -			name);
> -		if (dlopen(path, RTLD_NOW)) {
> -			/* Found library.  If it didn't register itself,
> -			   maybe they specified target as match. */
> -			ptr = find_match(name, DONT_LOAD, NULL);
> -
> -			if (!ptr)
> -				exit_error(PARAMETER_PROBLEM,
> -					   "Couldn't load match `%s'\n",
> -					   name);
> -		} else if (tryload == LOAD_MUST_SUCCEED)
> +
> +		snprintf(path, sizeof(path), "%s/lib%s_%s.so", lib_dir,
> +		         family_prefix[AF_UNSPEC], name);

So, here "%s/libxt_%s.so" is enough, and

> +		if (dlopen(path, RTLD_NOW) != NULL)
> +			/*
> +			 * Library loaded (and its constructors run).
> +			 * Try to grab the pointer to the struct.
> +			 */
> +			ptr = find_match(name, DONT_LOAD, NULL, family);
> +
> +		if (ptr == NULL && family < ARRAY_SIZE(family_prefix) &&
> +		    family_prefix[family] != NULL) {
> +			snprintf(path, sizeof(path), "%s/lib%s_%s.so",
> +			         lib_dir, family_prefix[family], name);

let's use afinfo.libprefix.

> +			if (dlopen(path, RTLD_NOW) != NULL)
> +				ptr = find_match(name, DONT_LOAD, NULL, family);
> +		}
> +
> +		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
>  			exit_error(PARAMETER_PROBLEM,
> -				   "Couldn't load match `%s':%s\n",
> -				   name, dlerror());
> +				   "Couldn't load match `%s'\n", name);
>  	}
>  #else
>  	if (ptr && !ptr->loaded) {

-- Yasuyuki Kozakai
