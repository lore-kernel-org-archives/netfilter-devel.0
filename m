From: Sergey Vlasov <vsu@altlinux.ru>
Subject: Re: [PATCH 2.4] netfilter ipt_conntrack/ipt_state moduse count
Date: Sun, 01 Feb 2004 15:59:40 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <pan.2004.02.01.12.59.36.391644@altlinux.ru>
References: <20040127214857.GE11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 27 Jan 2004 22:48:57 +0100, Harald Welte wrote:

> Hi Dave!
> 
> Please apply the following fix to your 2.4.x tree.  A 2.6.x fix is not
> needed, because of it's different reference counting.

Looks like the patch is buggy - it will oops in the failure path if
ip_conntrack is not a module (it will call __MOD_DEC_USE_COUNT(NULL)).

Also, why this manual refcounting is needed here at all?
ipt_conntrack.o and ipt_state.o have references at least to
ip_conntrack_get(), which is exported by ip_conntrack.o.  Because of
this, there is no way to unload ip_conntrack without unloading
ipt_conntrack and ipt_state first.

Other instances where ip_conntrack_module is used also don't seem to
need it for the same reason.

> Thanks.
> 
> --
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
> diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.4.24/net/ipv4/netfilter/ipt_conntrack.c linux-2.4.24-usecount/net/ipv4/netfilter/ipt_conntrack.c
> --- linux-2.4.24/net/ipv4/netfilter/ipt_conntrack.c	2003-06-13 10:51:39.000000000 -0400
> +++ linux-2.4.24-usecount/net/ipv4/netfilter/ipt_conntrack.c	2004-01-21 08:50:59.232369344 -0500
> @@ -109,10 +109,15 @@
>  
>  static int __init init(void)
>  {
> +	int ret;
> +
>  	/* NULL if ip_conntrack not a module */
>  	if (ip_conntrack_module)
>  		__MOD_INC_USE_COUNT(ip_conntrack_module);
> -	return ipt_register_match(&conntrack_match);
> +	ret = ipt_register_match(&conntrack_match);
> +	if (ret)
> +		__MOD_DEC_USE_COUNT(ip_conntrack_module);
> +	return ret;
>  }
>  
>  static void __exit fini(void)
> diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.4.24/net/ipv4/netfilter/ipt_state.c linux-2.4.24-usecount/net/ipv4/netfilter/ipt_state.c
> --- linux-2.4.24/net/ipv4/netfilter/ipt_state.c	2001-09-30 15:26:08.000000000 -0400
> +++ linux-2.4.24-usecount/net/ipv4/netfilter/ipt_state.c	2004-01-21 08:49:36.054014376 -0500
> @@ -46,10 +46,15 @@
>  
>  static int __init init(void)
>  {
> +	int ret;
> +
>  	/* NULL if ip_conntrack not a module */
>  	if (ip_conntrack_module)
>  		__MOD_INC_USE_COUNT(ip_conntrack_module);
> -	return ipt_register_match(&state_match);
> +	ret = ipt_register_match(&state_match);
> +	if (ret)
> +		__MOD_DEC_USE_COUNT(ip_conntrack_module);
> +	return ret;
>  }
>  
>  static void __exit fini(void)
