From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_dup: add missing dependencies with NF_CONNTRACK
Date: Wed,  9 Dec 2015 22:09:07 +0100
Message-ID: <1449695347-2534-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33087 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbbLIVJ1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 16:09:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DA4EC18CDC3
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 22:09:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CBB4BDA732
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 22:09:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 31852DA732
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 22:09:20 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

CONFIG_NF_CONNTRACK=m
CONFIG_NF_DUP_IPV4=y

results in:

   net/built-in.o: In function `nf_dup_ipv4':
>> (.text+0xd434f): undefined reference to `nf_conntrack_untracked'

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/Kconfig | 1 +
 net/ipv6/netfilter/Kconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index a355841..c187c60 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -60,6 +60,7 @@ config NFT_REJECT_IPV4
 
 config NFT_DUP_IPV4
 	tristate "IPv4 nf_tables packet duplication support"
+	depends on !NF_CONNTRACK || NF_CONNTRACK
 	select NF_DUP_IPV4
 	help
 	  This module enables IPv4 packet duplication support for nf_tables.
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index f6a024e..e10a04c 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -49,6 +49,7 @@ config NFT_REJECT_IPV6
 
 config NFT_DUP_IPV6
 	tristate "IPv6 nf_tables packet duplication support"
+	depends on !NF_CONNTRACK || NF_CONNTRACK
 	select NF_DUP_IPV6
 	help
 	  This module enables IPv6 packet duplication support for nf_tables.
-- 
2.1.4

