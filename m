From: Roberto Nibali <ratz@tac.ch>
Subject: SOLVED (was: Re: [PATCH] update raw patch in POM)
Date: Mon, 20 Jun 2005 12:41:44 +0200
Message-ID: <42B69D68.3050507@tac.ch>
References: <42A57FC4.7010508@tac.ch>	<42A5B144.3090005@tac.ch>	<42A625DA.7090807@eurodev.net>	<42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>
	<42B67BEC.1090105@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42B67BEC.1090105@tac.ch>
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

Looks like we have a winner:

> Index: linux-2.4/net/ipv4/ip_output.c
> ===================================================================
> --- linux-2.4.orig/net/ipv4/ip_output.c	2005-06-08 00:16:54.000000000 +0200
> +++ linux-2.4/net/ipv4/ip_output.c	2005-06-15 23:42:13.000000000 +0200
> @@ -166,6 +166,8 @@
>  	nf_debug_ip_finish_output2(skb);
>  #endif /*CONFIG_NETFILTER_DEBUG*/
> 
> +	nf_reset(skb);
> +
>  	if (hh) {
>  		int hh_alen;

This patch kind of did it. I cannot trigger the oops anymore (with the method
described earlier in this thread) with this patch. It could be related to a
recent fix that went in for 2.6.x kernel, by Patrick:

https://lists.netfilter.org/pipermail/netfilter-devel/2005-March/018857.html

I'll hit it a few more rounds and harder with a couple of thousand rules and a
few hundred megs of data in the conntrack ;).
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
