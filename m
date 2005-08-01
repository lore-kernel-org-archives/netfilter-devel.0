From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/7] Fix expectation leak
Date: Mon, 01 Aug 2005 19:12:15 +0200
Message-ID: <42EE57EF.4070807@trash.net>
References: <42EE5633.9030307@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42EE5633.9030307@eurodev.net>
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

Pablo Neira wrote:
> expectation refcount is set to 1 in ip_conntrack_expect_alloc, and
> incremented again in ip_conntrack_expect_related. So once the
> ip_conntrack_expect_free is called, the expectation is never released.

This looks wrong. expect_alloc sets it to 1, expect_insert increases it
too 2, the helper then sets puts it when done with it, so it is 1 while
inserted.

> ------------------------------------------------------------------------
> 
> Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c
> ===================================================================
> --- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-01 16:20:26.000000000 +0200
> +++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-01 16:24:47.000000000 +0200
> @@ -970,7 +970,6 @@
>  
>  static void ip_conntrack_expect_insert(struct ip_conntrack_expect *exp)
>  {
> -	atomic_inc(&exp->use);
>  	exp->master->expecting++;
>  	list_add(&exp->list, &ip_conntrack_expect_list);
>  
