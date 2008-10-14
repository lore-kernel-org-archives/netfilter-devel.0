From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [PATCH] remove module dependency between ctnetlink and
 nf_nat
Date: Tue, 14 Oct 2008 15:50:59 +0200
Message-ID: <48F4A3C3.2080202@trash.net>
References: <20081013222400.8612.80582.stgit@Decadence>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080204070809000905030802"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36765 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYJNNvF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:51:05 -0400
In-Reply-To: <20081013222400.8612.80582.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080204070809000905030802
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> This patch removes the module dependency between ctnetlink and
> nf_nat by means of an indirect call that is initialized when
> nf_nat is loaded. Now, nf_conntrack_netlink only requires
> nf_conntrack and nfnetlink.
> 
> This patch puts nfnetlink_parse_nat_setup_hook into the
> nf_conntrack_core to avoid dependencies between ctnetlink,
> nf_conntrack_ipv4 and nf_conntrack_ipv6.
> 
> This patch also introduces the function ctnetlink_change_nat
> that is only invoked from the creation path. Actually, the
> nat handling cannot be invoked from the update path since
> this is not allowed. By introducing this function, we remove
> the useless nat handling in the update path and we avoid
> deadlock-prone code.
> 
> This patch also adds the required EAGAIN logic for nfnetlink.

This looks great, I've applied it with one minor change,
thanks!

> +ctnetlink_parse_nat_setup(struct nf_conn *ct,
> +			  enum nf_nat_manip_type manip,
> +			  struct nlattr *attr)
> +{
> +	typeof(nfnetlink_parse_nat_setup_hook) parse_nat_setup;
> +
> +	parse_nat_setup = rcu_dereference(nfnetlink_parse_nat_setup_hook);
> +	if (!parse_nat_setup) {
> +#ifdef CONFIG_KMOD
> +		rcu_read_unlock();
> +		nfnl_unlock();
> +		if (request_module("nf-nat-ipv4") < 0) {
> +			nfnl_lock();
> +			rcu_read_lock();
> +			return -EOPNOTSUPP;
> +		}
> +		nfnl_lock();
> +		rcu_read_lock();
> +		parse_nat_setup =
> +			rcu_dereference(nfnetlink_parse_nat_setup_hook);
> +		if (parse_nat_setup)
> +			return -EAGAIN;

The rcu_dereference here isn't necessary because the pointer isn't
actually dereferenced. It doesn't matter much, but removing it also
looks slightly nicer :)


--------------080204070809000905030802
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b132124..08e82d6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -832,9 +832,7 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 		}
 		nfnl_lock();
 		rcu_read_lock();
-		parse_nat_setup =
-			rcu_dereference(nfnetlink_parse_nat_setup_hook);
-		if (parse_nat_setup)
+		if (nfnetlink_parse_nat_setup_hook)
 			return -EAGAIN;
 #endif
 		return -EOPNOTSUPP;

--------------080204070809000905030802--
