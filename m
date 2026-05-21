Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFB817A303
	for <netfilter-devel@vger.kernel.org>; Thu, 21 May 2026 20:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779394288; cv=none; b=CO98sihUj3SYSbttKzPiuYuBVCZdUya1/PFSJRw+3mjGqr40hOWa2uCeQBgk63u5fj0/hvWrErfsKQR9gtwBn3tE1ot4n62JNhXqsc93ptmLU1xR9EcHj9UcH/458GWR8lx9eG0KWRYJ33N2zr9ipDLNFpsqOeFLBsauVJuX1UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779394288; c=relaxed/simple;
	bh=mLh+d4qlElpXIcJ1ZUEOnij8xVm/BsTClJk1LRcyK84=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pe/yulVu6ZFt7/1jZ9EFk4VgmxIp19IvhyxGs060lv/Mszij0lu6IpuF68h+wbMFE/zvPtQF5/IV3EQJO2Cizi9NBh/sUT7M9pBbtMcGZLlu+C9R6ytDrZombhrD40xymJdMVQLVJss3RAqPKJZV7hqpDl2CDO945GklI7cD5Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D0E1560344; Thu, 21 May 2026 22:11:23 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3] netfilter: add option for GCOV profiling
Date: Thu, 21 May 2026 22:11:15 +0200
Message-ID: <20260521201119.22209-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to a few other subsystems: add a new config toggle to
enable netfilter gcov profiling in netfilter, including ebtables,
arptables and so on.

ipset and ipvs gain their own, dedicated toggles.

Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: also cover netfilter.c and br_netfilter.
 I have no interest in their coverage, but AI complains
 about them not being covered.

 net/bridge/Makefile           | 6 ++++++
 net/bridge/netfilter/Makefile | 4 ++++
 net/ipv4/Makefile             | 4 ++++
 net/ipv4/netfilter/Makefile   | 4 ++++
 net/ipv6/Makefile             | 4 ++++
 net/ipv6/netfilter/Makefile   | 4 ++++
 net/netfilter/Kconfig         | 8 ++++++++
 net/netfilter/Makefile        | 4 ++++
 net/netfilter/ipset/Kconfig   | 9 +++++++++
 net/netfilter/ipset/Makefile  | 3 +++
 net/netfilter/ipvs/Kconfig    | 9 +++++++++
 net/netfilter/ipvs/Makefile   | 3 +++
 12 files changed, 62 insertions(+)

diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index 24bd1c0a9a5a..1203dc19e15c 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -29,3 +29,9 @@ obj-$(CONFIG_NETFILTER) += netfilter/
 bridge-$(CONFIG_BRIDGE_MRP)	+= br_mrp_switchdev.o br_mrp.o br_mrp_netlink.o
 
 bridge-$(CONFIG_BRIDGE_CFM)	+= br_cfm.o br_cfm_netlink.o
+
+ifdef CONFIG_GCOV_PROFILE_NETFILTER
+GCOV_PROFILE_br_nf_core.o := y
+GCOV_PROFILE_br_netfilter_hooks.o := y
+GCOV_PROFILE_br_netfilter_ipv6.o := y
+endif
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index b9a1303da977..af0c903aa4ac 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -38,3 +38,7 @@ obj-$(CONFIG_BRIDGE_EBT_SNAT) += ebt_snat.o
 # watchers
 obj-$(CONFIG_BRIDGE_EBT_LOG) += ebt_log.o
 obj-$(CONFIG_BRIDGE_EBT_NFLOG) += ebt_nflog.o
+
+ifdef CONFIG_GCOV_PROFILE_NETFILTER
+GCOV_PROFILE := y
+endif
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 7964234f0d08..06e21c26b76f 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -71,3 +71,7 @@ obj-$(CONFIG_TCP_AO) += tcp_ao.o
 ifeq ($(CONFIG_BPF_JIT),y)
 obj-$(CONFIG_BPF_SYSCALL) += bpf_tcp_ca.o
 endif
+
+ifdef CONFIG_GCOV_PROFILE_NETFILTER
+GCOV_PROFILE_netfilter.o := y
+endif
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 85502d4dfbb4..dbfb1c4739a8 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -51,3 +51,7 @@ obj-$(CONFIG_IP_NF_ARP_MANGLE) += arpt_mangle.o
 obj-$(CONFIG_IP_NF_ARPFILTER) += arptable_filter.o
 
 obj-$(CONFIG_NF_DUP_IPV4) += nf_dup_ipv4.o
+
+ifdef CONFIG_GCOV_PROFILE_NETFILTER
+GCOV_PROFILE := y
+endif
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 2c9ce2ccbde1..5b0cd6488021 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -54,3 +54,7 @@ obj-$(CONFIG_NET_UDP_TUNNEL) += ip6_udp_tunnel.o
 obj-y += mcast_snoop.o
 obj-$(CONFIG_TCP_AO) += tcp_ao.o
 endif
+
+ifdef CONFIG_GCOV_PROFILE_NETFILTER
+GCOV_PROFILE_netfilter.o := y
+endif
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 66ce6fa5b2f5..72902d8005ad 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -43,3 +43,7 @@ obj-$(CONFIG_IP6_NF_MATCH_SRH) += ip6t_srh.o
 obj-$(CONFIG_IP6_NF_TARGET_NPT) += ip6t_NPT.o
 obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
 obj-$(CONFIG_IP6_NF_TARGET_SYNPROXY) += ip6t_SYNPROXY.o
+
+ifdef CONFIG_GCOV_PROFILE_NETFILTER
+GCOV_PROFILE := y
+endif
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 682c675125fc..f71ff98eb5d0 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1648,6 +1648,14 @@ config NETFILTER_XT_MATCH_U32
 
 endif # NETFILTER_XTABLES
 
+config GCOV_PROFILE_NETFILTER
+	bool "Enable GCOV profiling for netfilter"
+	depends on GCOV_KERNEL
+	help
+	  Enable GCOV profiling for netfilter to check which functions/lines
+	  are executed.
+
+	  If unsure, say N.
 endmenu
 
 source "net/netfilter/ipset/Kconfig"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 6bfc250e474f..f0751ca302c6 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -240,3 +240,7 @@ obj-$(CONFIG_IP_VS) += ipvs/
 
 # lwtunnel
 obj-$(CONFIG_LWTUNNEL) += nf_hooks_lwtunnel.o
+
+ifdef CONFIG_GCOV_PROFILE_NETFILTER
+GCOV_PROFILE := y
+endif
diff --git a/net/netfilter/ipset/Kconfig b/net/netfilter/ipset/Kconfig
index b1ea054bb82c..6c4d54758106 100644
--- a/net/netfilter/ipset/Kconfig
+++ b/net/netfilter/ipset/Kconfig
@@ -175,4 +175,13 @@ config IP_SET_LIST_SET
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config GCOV_PROFILE_IPSET
+	bool "Enable GCOV profiling for ipset"
+	depends on GCOV_KERNEL
+	help
+	  Enable GCOV profiling for ipset to check which functions/lines
+	  are executed.
+
+	  If unsure, say N.
+
 endif # IP_SET
diff --git a/net/netfilter/ipset/Makefile b/net/netfilter/ipset/Makefile
index a445a6bf4f11..4f48df5406cd 100644
--- a/net/netfilter/ipset/Makefile
+++ b/net/netfilter/ipset/Makefile
@@ -29,3 +29,6 @@ obj-$(CONFIG_IP_SET_HASH_NETPORTNET) += ip_set_hash_netportnet.o
 
 # list types
 obj-$(CONFIG_IP_SET_LIST_SET) += ip_set_list_set.o
+ifdef CONFIG_GCOV_PROFILE_IPSET
+GCOV_PROFILE := y
+endif
diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index c203252e856d..7724cb44e6de 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -349,4 +349,13 @@ config	IP_VS_PE_SIP
 	help
 	  Allow persistence based on the SIP Call-ID
 
+config GCOV_PROFILE_IPVS
+	bool "Enable GCOV profiling for IPVS"
+	depends on GCOV_KERNEL
+	help
+	  Enable GCOV profiling for IPVS to check which functions/lines
+	  are executed.
+
+	  If unsure, say N.
+
 endif # IP_VS
diff --git a/net/netfilter/ipvs/Makefile b/net/netfilter/ipvs/Makefile
index bb5d8125c82a..8e4cc67ad39d 100644
--- a/net/netfilter/ipvs/Makefile
+++ b/net/netfilter/ipvs/Makefile
@@ -43,3 +43,6 @@ obj-$(CONFIG_IP_VS_FTP) += ip_vs_ftp.o
 
 # IPVS connection template retrievers
 obj-$(CONFIG_IP_VS_PE_SIP) += ip_vs_pe_sip.o
+ifdef CONFIG_GCOV_PROFILE_IPVS
+GCOV_PROFILE := y
+endif
-- 
2.53.0

