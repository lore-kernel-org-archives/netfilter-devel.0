From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/11] kernel: use __read_mostly for registration-type structures
Date: Sun, 19 Dec 2010 06:18:06 +0100
Message-ID: <1292735894-17534-5-git-send-email-jengelh@medozas.de>
References: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42664 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab0LSFST (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 00:18:19 -0500
In-Reply-To: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here is where __read_mostly goes :-)
---
 kernel/ip_set.c                |    4 ++--
 kernel/ip_set_bitmap_ip.c      |    2 +-
 kernel/ip_set_hash_ip.c        |    2 +-
 kernel/ip_set_hash_ipport.c    |    2 +-
 kernel/ip_set_hash_ipportip.c  |    2 +-
 kernel/ip_set_hash_ipportnet.c |    2 +-
 kernel/ip_set_hash_net.c       |    2 +-
 kernel/ip_set_hash_netport.c   |    2 +-
 kernel/ip_set_list_set.c       |    2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/ip_set.c b/kernel/ip_set.c
index 19a0571..038a70e 100644
--- a/kernel/ip_set.c
+++ b/kernel/ip_set.c
@@ -1692,7 +1692,7 @@ static const struct nfnl_callback ip_set_netlink_subsys_cb[IPSET_MSG_MAX] = {
 	},
 };
 
-static struct nfnetlink_subsystem ip_set_netlink_subsys = {
+static struct nfnetlink_subsystem ip_set_netlink_subsys __read_mostly = {
 	.name		= "ip_set",
 	.subsys_id	= NFNL_SUBSYS_IPSET,
 	.cb_count	= IPSET_MSG_MAX,
@@ -1791,7 +1791,7 @@ done:
 	return ret;
 }
 
-static struct nf_sockopt_ops so_set = {
+static struct nf_sockopt_ops so_set __read_mostly = {
 	.pf		= PF_INET,
 	.get_optmin	= SO_IP_SET,
 	.get_optmax	= SO_IP_SET + 1,
diff --git a/kernel/ip_set_bitmap_ip.c b/kernel/ip_set_bitmap_ip.c
index 470a42d..2f124ec 100644
--- a/kernel/ip_set_bitmap_ip.c
+++ b/kernel/ip_set_bitmap_ip.c
@@ -700,7 +700,7 @@ bitmap_ip_create(struct ip_set *set, struct nlattr *head, int len,
 	return 0;
 }
 
-static struct ip_set_type bitmap_ip_type = {
+static struct ip_set_type bitmap_ip_type __read_mostly = {
 	.name		= "bitmap:ip",
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP,
diff --git a/kernel/ip_set_hash_ip.c b/kernel/ip_set_hash_ip.c
index 583b572..6859ac8 100644
--- a/kernel/ip_set_hash_ip.c
+++ b/kernel/ip_set_hash_ip.c
@@ -457,7 +457,7 @@ hash_ip_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 	return 0;
 }
 
-static struct ip_set_type hash_ip_type = {
+static struct ip_set_type hash_ip_type __read_mostly = {
 	.name		= "hash:ip",
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP,
diff --git a/kernel/ip_set_hash_ipport.c b/kernel/ip_set_hash_ipport.c
index 16eed36..f9db93d 100644
--- a/kernel/ip_set_hash_ipport.c
+++ b/kernel/ip_set_hash_ipport.c
@@ -542,7 +542,7 @@ hash_ipport_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 	return 0;
 }
 
-static struct ip_set_type hash_ipport_type = {
+static struct ip_set_type hash_ipport_type __read_mostly = {
 	.name		= "hash:ip,port",
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP | IPSET_TYPE_PORT,
diff --git a/kernel/ip_set_hash_ipportip.c b/kernel/ip_set_hash_ipportip.c
index 396273b..5511bbf 100644
--- a/kernel/ip_set_hash_ipportip.c
+++ b/kernel/ip_set_hash_ipportip.c
@@ -563,7 +563,7 @@ hash_ipportip_create(struct ip_set *set, struct nlattr *head,
 	return 0;
 }
 
-static struct ip_set_type hash_ipportip_type = {
+static struct ip_set_type hash_ipportip_type __read_mostly = {
 	.name		= "hash:ip,port,ip",
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP | IPSET_TYPE_PORT | IPSET_TYPE_IP2,
diff --git a/kernel/ip_set_hash_ipportnet.c b/kernel/ip_set_hash_ipportnet.c
index 0021c0c..5775c57 100644
--- a/kernel/ip_set_hash_ipportnet.c
+++ b/kernel/ip_set_hash_ipportnet.c
@@ -629,7 +629,7 @@ hash_ipportnet_create(struct ip_set *set, struct nlattr *head,
 	return 0;
 }
 
-static struct ip_set_type hash_ipportnet_type = {
+static struct ip_set_type hash_ipportnet_type __read_mostly = {
 	.name		= "hash:ip,port,net",
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP | IPSET_TYPE_PORT | IPSET_TYPE_IP2,
diff --git a/kernel/ip_set_hash_net.c b/kernel/ip_set_hash_net.c
index 1282839..5e3086b 100644
--- a/kernel/ip_set_hash_net.c
+++ b/kernel/ip_set_hash_net.c
@@ -458,7 +458,7 @@ hash_net_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 	return 0;
 }
 
-static struct ip_set_type hash_net_type = {
+static struct ip_set_type hash_net_type __read_mostly = {
 	.name		= "hash:net",
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP,
diff --git a/kernel/ip_set_hash_netport.c b/kernel/ip_set_hash_netport.c
index 9c4767e..c3f47a1 100644
--- a/kernel/ip_set_hash_netport.c
+++ b/kernel/ip_set_hash_netport.c
@@ -578,7 +578,7 @@ hash_netport_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 	return 0;
 }
 
-static struct ip_set_type hash_netport_type = {
+static struct ip_set_type hash_netport_type __read_mostly = {
 	.name		= "hash:net,port",
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_IP | IPSET_TYPE_PORT,
diff --git a/kernel/ip_set_list_set.c b/kernel/ip_set_list_set.c
index a2c2eef..07d9929 100644
--- a/kernel/ip_set_list_set.c
+++ b/kernel/ip_set_list_set.c
@@ -562,7 +562,7 @@ list_set_create(struct ip_set *set, struct nlattr *head, int len,
 	return 0;
 }
 
-static struct ip_set_type list_set_type = {
+static struct ip_set_type list_set_type __read_mostly = {
 	.name		= "list:set",
 	.protocol	= IPSET_PROTOCOL,
 	.features	= IPSET_TYPE_NAME | IPSET_DUMP_LAST,
-- 
1.7.1

