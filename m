From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: tcp-window-tracking vs. pending/24_conntrack-nosysctl.patch
Date: 03 Apr 2003 12:15:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049364942.25148.60.camel@tux.rsn.bth.se>
References: <20030403025151.GA1702@pc.ilinx>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@interlinx.bc.ca
In-Reply-To: <20030403025151.GA1702@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2003-04-03 at 04:51, netfilter@interlinx.bc.ca wrote:
> There is a patch in pending that makes the tcp-window-tracking patch
> fail to apply cleanly.  The patch in
> pending/24_conntrack-nosysctl.patch:
> 
> --- linux-2.4.21-pre5-ac3/net/ipv4/netfilter/ip_conntrack_core.c	Sat Mar 15 12:16:55 2003
> +++ linux-2.4.21-pre5-ac3-fixed/net/ipv4/netfilter/ip_conntrack_core.c	Sat Mar 15 12:23:34 2003
> @@ -1478,8 +1478,10 @@
>  	ip_ct_attach = ip_conntrack_attach;
>  	return ret;
>  
> +#ifdef CONFIG_SYSCTL
>  err_free_ct_cachep:
>  	kmem_cache_destroy(ip_conntrack_cachep);
> +#endif /*CONFIG_SYSCTL*/
>  err_free_hash:
>  	vfree(ip_conntrack_hash);
>  err_unreg_sockopt:
> 
> 
> is not accounted for in hunk 5 to file
> net/ipv4/netfilter/ip_conntrack_core.c in
> extra/tcp-window-tracking.patch.
> 
> I guess the question is, should it be expected that patches in suites
> like extra should apply if all of submitted and pending are applied.

Thanks for the report, I'll try to fix it up.

The answer is that I don't have time to check all the time if everything
still applies after new stuff has been added to pom.

-- 
/Martin
