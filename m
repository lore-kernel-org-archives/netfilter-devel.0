Return-Path: <SRS0=jWs9=AB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CF7C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jun 2020 08:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6461B23A53
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jun 2020 08:17:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="eR5zwwj5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgFTIRg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jun 2020 04:17:36 -0400
Received: from mail-40131.protonmail.ch ([185.70.40.131]:58703 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgFTIRf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jun 2020 04:17:35 -0400
Date:   Sat, 20 Jun 2020 08:17:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1592641049;
        bh=O4roCSEm6mZu290vdCWG0WCu2C5EOgqWqYOZMVtoxQY=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=eR5zwwj5lO3WuxqeTFh5+mKtcAKZkVValaCfd0T/etyKnEAVG1Ks7Gh8iDJOvzfpv
         EjvdRxsU/W52bII5tw2MaUSwVOxcPTDMKZHsoJ7FJzLG0oNSvD7/PDGbgGWX3kuTSO
         k8PfUhVvJ0kRc9wfht0asdjbuojcZhwSNOtIYUdI=
To:     netfilter-devel@vger.kernel.org
From:   Rob Gill <rrobgill@protonmail.com>
Cc:     Rob Gill <rrobgill@protonmail.com>
Reply-To: Rob Gill <rrobgill@protonmail.com>
Subject: [PATCH] netfilter: Add MODULE_DESCRIPTION entries to kernel modules
Message-ID: <20200620081715.11732-1-rrobgill@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The user tool modinfo is used to get information on kernel modules, includi=
ng a
description where it is available.

This patch adds a brief MODULE_DESCRIPTION to netfilter kernel modules
(descriptions taken from Kconfig file or code comments)

Signed-off-by: Rob Gill <rrobgill@protonmail.com>
---
 net/bridge/netfilter/nft_meta_bridge.c   | 1 +
 net/bridge/netfilter/nft_reject_bridge.c | 1 +
 net/ipv4/netfilter/ipt_SYNPROXY.c        | 1 +
 net/ipv4/netfilter/nf_flow_table_ipv4.c  | 1 +
 net/ipv4/netfilter/nft_dup_ipv4.c        | 1 +
 net/ipv4/netfilter/nft_fib_ipv4.c        | 1 +
 net/ipv4/netfilter/nft_reject_ipv4.c     | 1 +
 net/ipv6/netfilter/ip6t_SYNPROXY.c       | 1 +
 net/ipv6/netfilter/nf_flow_table_ipv6.c  | 1 +
 net/ipv6/netfilter/nft_dup_ipv6.c        | 1 +
 net/ipv6/netfilter/nft_fib_ipv6.c        | 1 +
 net/ipv6/netfilter/nft_reject_ipv6.c     | 1 +
 net/netfilter/nf_dup_netdev.c            | 1 +
 net/netfilter/nf_flow_table_core.c       | 1 +
 net/netfilter/nf_flow_table_inet.c       | 1 +
 net/netfilter/nf_synproxy_core.c         | 1 +
 net/netfilter/nfnetlink.c                | 1 +
 net/netfilter/nft_compat.c               | 1 +
 net/netfilter/nft_connlimit.c            | 1 +
 net/netfilter/nft_counter.c              | 1 +
 net/netfilter/nft_ct.c                   | 1 +
 net/netfilter/nft_dup_netdev.c           | 1 +
 net/netfilter/nft_fib_inet.c             | 1 +
 net/netfilter/nft_fib_netdev.c           | 1 +
 net/netfilter/nft_flow_offload.c         | 1 +
 net/netfilter/nft_hash.c                 | 1 +
 net/netfilter/nft_limit.c                | 1 +
 net/netfilter/nft_log.c                  | 1 +
 net/netfilter/nft_masq.c                 | 1 +
 net/netfilter/nft_nat.c                  | 1 +
 net/netfilter/nft_numgen.c               | 1 +
 net/netfilter/nft_objref.c               | 1 +
 net/netfilter/nft_osf.c                  | 1 +
 net/netfilter/nft_queue.c                | 1 +
 net/netfilter/nft_quota.c                | 1 +
 net/netfilter/nft_redir.c                | 1 +
 net/netfilter/nft_reject.c               | 1 +
 net/netfilter/nft_reject_inet.c          | 1 +
 net/netfilter/nft_synproxy.c             | 1 +
 net/netfilter/nft_tunnel.c               | 1 +
 net/netfilter/xt_nat.c                   | 1 +
 41 files changed, 41 insertions(+)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/=
nft_meta_bridge.c
index 7c9e92b2f..a9b430928 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -155,3 +155,4 @@ module_exit(nft_meta_bridge_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("wenxu <wenxu@ucloud.cn>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_BRIDGE, "meta");
+MODULE_DESCRIPTION("Netfilter nf_table bridge meta support");
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilte=
r/nft_reject_bridge.c
index f48cf4cfb..5ade5cd73 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -455,3 +455,4 @@ module_exit(nft_reject_bridge_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_BRIDGE, "reject");
+MODULE_DESCRIPTION("Netfilter nf_tables bridge reject support");
diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYN=
PROXY.c
index 748dc3ce5..bc37fb1e4 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -118,3 +118,4 @@ module_exit(synproxy_tg4_exit);
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("SYNPROXY target support");
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/n=
f_flow_table_ipv4.c
index e32e41b99..5b2716017 100644
--- a/net/ipv4/netfilter/nf_flow_table_ipv4.c
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -34,3 +34,4 @@ module_exit(nf_flow_ipv4_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NF_FLOWTABLE(AF_INET);
+MODULE_DESCRIPTION("Netfilter flow table module");
diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft_dup=
_ipv4.c
index abf89b972..1080c5199 100644
--- a/net/ipv4/netfilter/nft_dup_ipv4.c
+++ b/net/ipv4/netfilter/nft_dup_ipv4.c
@@ -107,3 +107,4 @@ module_exit(nft_dup_ipv4_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "dup");
+MODULE_DESCRIPTION("IPv4 nf_tables packet duplication support");
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib=
_ipv4.c
index ce294113d..c3aee4894 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -210,3 +210,4 @@ module_exit(nft_fib4_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
 MODULE_ALIAS_NFT_AF_EXPR(2, "fib");
+MODULE_DESCRIPTION("nf_tables fib / ip route lookup support");
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_=
reject_ipv4.c
index 7e6fd5cde..724ede938 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -71,3 +71,4 @@ module_exit(nft_reject_ipv4_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "reject");
+MODULE_DESCRIPTION("IPv4 packet rejection for nf_tables");
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_S=
YNPROXY.c
index fd1f52a21..9a0f6438a 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -121,3 +121,4 @@ module_exit(synproxy_tg6_exit);
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("IPv6 SYNPROXY target support");
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/n=
f_flow_table_ipv6.c
index a8566ee12..667b8af25 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -35,3 +35,4 @@ module_exit(nf_flow_ipv6_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NF_FLOWTABLE(AF_INET6);
+MODULE_DESCRIPTION("Netfilter flow table IPv6 module");
diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup=
_ipv6.c
index 2af322005..af49109e4 100644
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -105,3 +105,4 @@ module_exit(nft_dup_ipv6_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "dup");
+MODULE_DESCRIPTION("IPv6 nf_tables packet duplication support");
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib=
_ipv6.c
index 7ece86afd..e6c8cdd2a 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -255,3 +255,4 @@ module_exit(nft_fib6_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
 MODULE_ALIAS_NFT_AF_EXPR(10, "fib");
+MODULE_DESCRIPTION("nf_tables fib / ipv6 route lookup support");
diff --git a/net/ipv6/netfilter/nft_reject_ipv6.c b/net/ipv6/netfilter/nft_=
reject_ipv6.c
index 680a28ce2..68ccd6ec2 100644
--- a/net/ipv6/netfilter/nft_reject_ipv6.c
+++ b/net/ipv6/netfilter/nft_reject_ipv6.c
@@ -72,3 +72,4 @@ module_exit(nft_reject_ipv6_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "reject");
+MODULE_DESCRIPTION("IPv6 packet rejection for nf_tables");
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index f108a7692..2b01a151e 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -73,3 +73,4 @@ EXPORT_SYMBOL_GPL(nft_fwd_dup_netdev_offload);
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_DESCRIPTION("Netfilter packet duplication support");
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_tab=
le_core.c
index afa85171d..b1eb5272b 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -594,3 +594,4 @@ module_exit(nf_flow_table_module_exit);
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_DESCRIPTION("Netfilter flow table module");
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_tab=
le_inet.c
index 88bedf1ff..bc4126d8e 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -72,3 +72,4 @@ module_exit(nf_flow_inet_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NF_FLOWTABLE(1); /* NFPROTO_INET */
+MODULE_DESCRIPTION("Netfilter flow table mixed IPv4/IPv6 module");
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_c=
ore.c
index b9cbe1e24..fab7289c9 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -1237,3 +1237,4 @@ EXPORT_SYMBOL_GPL(nf_synproxy_ipv6_fini);
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("Netfilter nf_tables SYNPROXY core");
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 99127e2d9..5f24edf95 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -33,6 +33,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NETFILTER);
+MODULE_DESCRIPTION("Netfilter messages via netlink socket");
=20
 #define nfnl_dereference_protected(id) \
 =09rcu_dereference_protected(table[(id)].subsys, \
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index f9adca62c..9f24995fb 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -902,3 +902,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_EXPR("match");
 MODULE_ALIAS_NFT_EXPR("target");
+MODULE_DESCRIPTION("Netfilter x_tables over nf_tables module");
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 69d6173f9..df1804259 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -280,3 +280,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso");
 MODULE_ALIAS_NFT_EXPR("connlimit");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CONNLIMIT);
+MODULE_DESCRIPTION("Netfilter nf_tables connlimit module");
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index f6d4d0fa2..a9feaa8f9 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -303,3 +303,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_EXPR("counter");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_COUNTER);
+MODULE_DESCRIPTION("Netfilter nf_tables counter module");
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index faea72c2d..77258af1f 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1345,3 +1345,4 @@ MODULE_ALIAS_NFT_EXPR("notrack");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_HELPER);
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_TIMEOUT);
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_EXPECT);
+MODULE_DESCRIPTION("Netfilter nf_tables conntrack module");
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.=
c
index c2e78c160..aada7acf8 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -102,3 +102,4 @@ module_exit(nft_dup_netdev_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_AF_EXPR(5, "dup");
+MODULE_DESCRIPTION("Netfilter nf_tables netdev packet duplication support"=
);
diff --git a/net/netfilter/nft_fib_inet.c b/net/netfilter/nft_fib_inet.c
index 465432e05..9434dbf2c 100644
--- a/net/netfilter/nft_fib_inet.c
+++ b/net/netfilter/nft_fib_inet.c
@@ -76,3 +76,4 @@ module_exit(nft_fib_inet_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
 MODULE_ALIAS_NFT_AF_EXPR(1, "fib");
+MODULE_DESCRIPTION("Netfilter nf_tables fib inet support");
diff --git a/net/netfilter/nft_fib_netdev.c b/net/netfilter/nft_fib_netdev.=
c
index a2e726ae7..04779ace7 100644
--- a/net/netfilter/nft_fib_netdev.c
+++ b/net/netfilter/nft_fib_netdev.c
@@ -85,3 +85,4 @@ module_exit(nft_fib_netdev_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo M. Bermudo Garay <pablombg@gmail.com>");
 MODULE_ALIAS_NFT_AF_EXPR(5, "fib");
+MODULE_DESCRIPTION("Netfilter nf_tables netdev fib lookups support");
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offl=
oad.c
index b70b48996..d24ce460a 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -286,3 +286,4 @@ module_exit(nft_flow_offload_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_EXPR("flow_offload");
+MODULE_DESCRIPTION("Netfilter nf_tables hardware flow offload module");
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index b836d550b..31dae79bb 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -248,3 +248,4 @@ module_exit(nft_hash_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Laura Garcia <nevola@gmail.com>");
 MODULE_ALIAS_NFT_EXPR("hash");
+MODULE_DESCRIPTION("Netfilter nf_tables hash module");
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 35b67d7e3..787e74807 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -372,3 +372,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_EXPR("limit");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_LIMIT);
+MODULE_DESCRIPTION("Netfilter nf_tables limit module");
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index fe4831f22..57899454a 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -298,3 +298,4 @@ module_exit(nft_log_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_EXPR("log");
+MODULE_DESCRIPTION("Netfilter nf_tables log module");
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index bc9fd98c5..59d997f85 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -305,3 +305,4 @@ module_exit(nft_masq_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
 MODULE_ALIAS_NFT_EXPR("masq");
+MODULE_DESCRIPTION("Netfilter nf_tables masquerade support");
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 23a7bfd10..4bcf33b04 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -402,3 +402,4 @@ module_exit(nft_nat_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>");
 MODULE_ALIAS_NFT_EXPR("nat");
+MODULE_DESCRIPTION("Network Address Translation support");
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 48edb9d5f..46850bbf2 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -217,3 +217,4 @@ module_exit(nft_ng_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Laura Garcia <nevola@gmail.com>");
 MODULE_ALIAS_NFT_EXPR("numgen");
+MODULE_DESCRIPTION("Netfilter nf_tables number generator module");
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index bfd18d2b6..65ac42397 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -252,3 +252,4 @@ module_exit(nft_objref_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_EXPR("objref");
+MODULE_DESCRIPTION("Netfilter nf_tables stateful object reference module")=
;
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index b42247aa4..c3398f0de 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -149,3 +149,4 @@ module_exit(nft_osf_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Fernando Fernandez <ffmancera@riseup.net>");
 MODULE_ALIAS_NFT_EXPR("osf");
+MODULE_DESCRIPTION("Netfilter nf_tables passive OS fingerprint support");
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 5ece0a6aa..05ac74515 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -216,3 +216,4 @@ module_exit(nft_queue_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Eric Leblond <eric@regit.org>");
 MODULE_ALIAS_NFT_EXPR("queue");
+MODULE_DESCRIPTION("Netfilter nf_tables queue module");
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 441369059..e51e1d37c 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -254,3 +254,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_EXPR("quota");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_QUOTA);
+MODULE_DESCRIPTION("Netfilter nf_tables quota module");
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 5b7791715..318a58caa 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -292,3 +292,4 @@ module_exit(nft_redir_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
 MODULE_ALIAS_NFT_EXPR("redir");
+MODULE_DESCRIPTION("Netfilter nf_tables redirect support");
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 00f865fb8..1ba7bd394 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -119,3 +119,4 @@ EXPORT_SYMBOL_GPL(nft_reject_icmpv6_code);
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("Netfilter x_tables over nf_tables module");
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_ine=
t.c
index f41f414b7..b27c8791b 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -149,3 +149,4 @@ module_exit(nft_reject_inet_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_AF_EXPR(1, "reject");
+MODULE_DESCRIPTION("Netfilter nf_tables reject inet support"
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index e2c1fc608..8ee984a7d 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -388,3 +388,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Fernando Fernandez <ffmancera@riseup.net>");
 MODULE_ALIAS_NFT_EXPR("synproxy");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_SYNPROXY);
+MODULE_DESCRIPTION("Netfilter nf_tables SYNPROXY expression support");
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 30be5787f..ac8447783 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -719,3 +719,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_EXPR("tunnel");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_TUNNEL);
+MODULE_DESCRIPTION("Netfilter nf_tables tunnel module");
diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index a8e5f6c8d..b4f7bbc3f 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -244,3 +244,4 @@ MODULE_ALIAS("ipt_SNAT");
 MODULE_ALIAS("ipt_DNAT");
 MODULE_ALIAS("ip6t_SNAT");
 MODULE_ALIAS("ip6t_DNAT");
+MODULE_DESCRIPTION("SNAT and DNAT targets support");
--=20
2.17.1


