From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3][CONNTRACK] Fix race condition in early drop #2
Date: Fri, 25 Aug 2006 07:24:21 +0200
Message-ID: <44EE8985.6020509@trash.net>
References: <44EE2EF5.90006@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44EE2EF5.90006@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Index: net-2.6/net/ipv4/netfilter/ip_conntrack_core.c
> ===================================================================
> --- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_core.c	2006-08-24 16:45:25.000000000 +0200
> +++ net-2.6/net/ipv4/netfilter/ip_conntrack_core.c	2006-08-24 16:47:51.000000000 +0200
> @@ -641,11 +641,15 @@ struct ip_conntrack *ip_conntrack_alloc(
>  		ip_conntrack_hash_rnd_initted = 1;
>  	}
>  
> +	/* We don't want any race condition at early drop stage */
> +	atomic_inc(&ip_conntrack_count);
> +
>  	if (ip_conntrack_max
>  	    && atomic_read(&ip_conntrack_count) >= ip_conntrack_max) {


This should become ">", no? No need to send a new patch, I can change it
before applying.
