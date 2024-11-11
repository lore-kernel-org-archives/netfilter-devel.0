Received: from smtp-out.freemail.hu (fmfe12.freemail.hu [46.107.16.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564B1219ED;
	Mon, 11 Nov 2024 16:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731343587; cv=none; b=QVQhsvDkrlOkDbbTp2Y53hh6480ydhTmCMzTPj+vj0x90vePRtqYSZlNeiS0IjqqbEdSzCzcgCWYgP3ckyzajQVUQNkfRrb0ktdVNOaQXPrRuracy8yGUAuCSK2RpdRIZGsqeJT+as6qf1sxLkeoSir35LJj5Dxb6/RNWB9QcjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731343587; c=relaxed/simple;
	bh=DiGMD2vaU42Lw4N34D2zVVQanU4ucJyLB3x5BeoRT+k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XbU/P0zdtd5h/Vk3eXorvF00ZZMmjQxUlLfjlFgTqGrpk8l/o66w4/aw4POzLvHchGpoAmLMyFK9/1emxMR/8bHKDItbVuV7TUznHaxhSKuQBz4fAVLHsrkYAYqepQVetx8G1FwVzUgeG2Ud5LVUhSMgYb+1+O05mEMGRtXT6hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=MxqIMByx reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="MxqIMByx"
Received: from localhost.localdomain (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4XnFc713lXztSh;
	Mon, 11 Nov 2024 17:38:47 +0100 (CET)
From: egyszeregy@freemail.hu
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: =?UTF-8?q?Benjamin=20Sz=C5=91ke?= <egyszeregy@freemail.hu>
Subject: [PATCH] netfilter: uapi: Fix file names for case-insensitive filesystem.
Date: Mon, 11 Nov 2024 17:36:34 +0100
Message-ID: <20241111163634.1022-1-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.47.0.windows.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1731343127;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=9249; bh=MFJ0d0K4njkBR/5La38uPan3/vOgwnNgHuSkxd63V6I=;
	b=MxqIMByxB7IicqUVo0lEzpTN0JV2cUgSCMyWKkPZfnOSPb3HFD7wwVsaUVi3iGsg
	zUfcM3To0PgA4i0DrHQFwYS+pJGBzNHdC0Z3VPrJgBXofgQGbLClQmQY0rnapfYF3mO
	77a+S9ao5pCs8MaS3K/Us7fybaIZrtqlFuVAf9xJvQPBSDsWFqu/fZmmJ/kWbOoz2lY
	sdzH+GDu51ETge0x2tW31cw6ahqeKZ6BMfNvt7UeUFODAHJumBXoA/tj2KGZusu9xPF
	wDMxGmJyRFtt8D9FK0JfCUImiztwza2YaixZ1tOXgDY/iiJLjKgtX36ta942pIZDL5Y
	IHzmYl11fw==

From: Benjamin Szőke <egyszeregy@freemail.hu>

The goal is to fix Linux repository for case-insensitive filesystem,
to able to clone it and editable on any operating systems.

In netfilter, many of source files has duplaction with uppercase filename
style. They was fixed by renaming.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 .../netfilter/{xt_CONNMARK.h => xt_CONNMARK_TARGET.h}     | 0
 .../uapi/linux/netfilter/{xt_DSCP.h => xt_DSCP_TARGET.h}  | 0
 .../uapi/linux/netfilter/{xt_MARK.h => xt_MARK_TARGET.h}  | 0
 .../linux/netfilter/{xt_RATEEST.h => xt_RATEEST_TARGET.h} | 0
 .../linux/netfilter/{xt_TCPMSS.h => xt_TCPMSS_TARGET.h}   | 0
 .../linux/netfilter_ipv4/{ipt_ECN.h => ipt_ECN_TARGET.h}  | 2 +-
 .../linux/netfilter_ipv4/{ipt_TTL.h => ipt_TTL_TARGET.h}  | 0
 .../linux/netfilter_ipv6/{ip6t_HL.h => ip6t_HL_TARGET.h}  | 0
 net/ipv4/netfilter/Makefile                               | 2 +-
 net/ipv4/netfilter/{ipt_ECN.c => ipt_ECN_TARGET.c}        | 2 +-
 net/netfilter/Makefile                                    | 8 ++++----
 net/netfilter/{xt_DSCP.c => xt_DSCP_TARGET.c}             | 2 +-
 net/netfilter/{xt_HL.c => xt_HL_TARGET.c}                 | 0
 net/netfilter/{xt_RATEEST.c => xt_RATEEST_TARGET.c}       | 2 +-
 net/netfilter/{xt_TCPMSS.c => xt_TCPMSS_TARGET.c}         | 2 +-
 15 files changed, 10 insertions(+), 10 deletions(-)
 rename include/uapi/linux/netfilter/{xt_CONNMARK.h => xt_CONNMARK_TARGET.h} (100%)
 rename include/uapi/linux/netfilter/{xt_DSCP.h => xt_DSCP_TARGET.h} (100%)
 rename include/uapi/linux/netfilter/{xt_MARK.h => xt_MARK_TARGET.h} (100%)
 rename include/uapi/linux/netfilter/{xt_RATEEST.h => xt_RATEEST_TARGET.h} (100%)
 rename include/uapi/linux/netfilter/{xt_TCPMSS.h => xt_TCPMSS_TARGET.h} (100%)
 rename include/uapi/linux/netfilter_ipv4/{ipt_ECN.h => ipt_ECN_TARGET.h} (95%)
 rename include/uapi/linux/netfilter_ipv4/{ipt_TTL.h => ipt_TTL_TARGET.h} (100%)
 rename include/uapi/linux/netfilter_ipv6/{ip6t_HL.h => ip6t_HL_TARGET.h} (100%)
 rename net/ipv4/netfilter/{ipt_ECN.c => ipt_ECN_TARGET.c} (98%)
 rename net/netfilter/{xt_DSCP.c => xt_DSCP_TARGET.c} (98%)
 rename net/netfilter/{xt_HL.c => xt_HL_TARGET.c} (100%)
 rename net/netfilter/{xt_RATEEST.c => xt_RATEEST_TARGET.c} (99%)
 rename net/netfilter/{xt_TCPMSS.c => xt_TCPMSS_TARGET.c} (99%)

diff --git a/include/uapi/linux/netfilter/xt_CONNMARK.h b/include/uapi/linux/netfilter/xt_CONNMARK_TARGET.h
similarity index 100%
rename from include/uapi/linux/netfilter/xt_CONNMARK.h
rename to include/uapi/linux/netfilter/xt_CONNMARK_TARGET.h
diff --git a/include/uapi/linux/netfilter/xt_DSCP.h b/include/uapi/linux/netfilter/xt_DSCP_TARGET.h
similarity index 100%
rename from include/uapi/linux/netfilter/xt_DSCP.h
rename to include/uapi/linux/netfilter/xt_DSCP_TARGET.h
diff --git a/include/uapi/linux/netfilter/xt_MARK.h b/include/uapi/linux/netfilter/xt_MARK_TARGET.h
similarity index 100%
rename from include/uapi/linux/netfilter/xt_MARK.h
rename to include/uapi/linux/netfilter/xt_MARK_TARGET.h
diff --git a/include/uapi/linux/netfilter/xt_RATEEST.h b/include/uapi/linux/netfilter/xt_RATEEST_TARGET.h
similarity index 100%
rename from include/uapi/linux/netfilter/xt_RATEEST.h
rename to include/uapi/linux/netfilter/xt_RATEEST_TARGET.h
diff --git a/include/uapi/linux/netfilter/xt_TCPMSS.h b/include/uapi/linux/netfilter/xt_TCPMSS_TARGET.h
similarity index 100%
rename from include/uapi/linux/netfilter/xt_TCPMSS.h
rename to include/uapi/linux/netfilter/xt_TCPMSS_TARGET.h
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h b/include/uapi/linux/netfilter_ipv4/ipt_ECN_TARGET.h
similarity index 95%
rename from include/uapi/linux/netfilter_ipv4/ipt_ECN.h
rename to include/uapi/linux/netfilter_ipv4/ipt_ECN_TARGET.h
index e3630fd045b8..195a124f9bfa 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ECN_TARGET.h
@@ -11,7 +11,7 @@
 #define _IPT_ECN_TARGET_H
 
 #include <linux/types.h>
-#include <linux/netfilter/xt_DSCP.h>
+#include <linux/netfilter/xt_DSCP_TARGET.h>
 
 #define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
 
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_TTL.h b/include/uapi/linux/netfilter_ipv4/ipt_TTL_TARGET.h
similarity index 100%
rename from include/uapi/linux/netfilter_ipv4/ipt_TTL.h
rename to include/uapi/linux/netfilter_ipv4/ipt_TTL_TARGET.h
diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_HL.h b/include/uapi/linux/netfilter_ipv6/ip6t_HL_TARGET.h
similarity index 100%
rename from include/uapi/linux/netfilter_ipv6/ip6t_HL.h
rename to include/uapi/linux/netfilter_ipv6/ip6t_HL_TARGET.h
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 85502d4dfbb4..5bdb9dedcd63 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -39,7 +39,7 @@ obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_RPFILTER) += ipt_rpfilter.o
 
 # targets
-obj-$(CONFIG_IP_NF_TARGET_ECN) += ipt_ECN.o
+obj-$(CONFIG_IP_NF_TARGET_ECN) += ipt_ECN_TARGET.o
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_SYNPROXY) += ipt_SYNPROXY.o
 
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN_TARGET.c
similarity index 98%
rename from net/ipv4/netfilter/ipt_ECN.c
rename to net/ipv4/netfilter/ipt_ECN_TARGET.c
index 5930d3b02555..5a18103a29b2 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN_TARGET.c
@@ -14,7 +14,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_ECN.h>
+#include <linux/netfilter_ipv4/ipt_ECN_TARGET.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index f0aa4d7ef499..277befb4d1e9 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -167,20 +167,20 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_CHECKSUM) += xt_CHECKSUM.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) += xt_CLASSIFY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CT) += xt_CT.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_HL) += xt_HL.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP_TARGET.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_HL) += xt_HL_TARGET.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_HMARK) += xt_HMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_LED) += xt_LED.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_LOG) += xt_LOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NETMAP) += xt_NETMAP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST_TARGET.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_REDIRECT) += xt_REDIRECT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_MASQUERADE) += xt_MASQUERADE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS_TARGET.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) += xt_TEE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP_TARGET.c
similarity index 98%
rename from net/netfilter/xt_DSCP.c
rename to net/netfilter/xt_DSCP_TARGET.c
index cfa44515ab72..347335b0d69a 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP_TARGET.c
@@ -14,7 +14,7 @@
 #include <net/dsfield.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_DSCP.h>
+#include <linux/netfilter/xt_DSCP_TARGET.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: DSCP/TOS field modification");
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL_TARGET.c
similarity index 100%
rename from net/netfilter/xt_HL.c
rename to net/netfilter/xt_HL_TARGET.c
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST_TARGET.c
similarity index 99%
rename from net/netfilter/xt_RATEEST.c
rename to net/netfilter/xt_RATEEST_TARGET.c
index 4f49cfc27831..ca21d5da6833 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST_TARGET.c
@@ -14,7 +14,7 @@
 #include <net/netns/generic.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_RATEEST.h>
+#include <linux/netfilter/xt_RATEEST_TARGET.h>
 #include <net/netfilter/xt_rateest.h>
 
 #define RATEEST_HSIZE	16
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS_TARGET.c
similarity index 99%
rename from net/netfilter/xt_TCPMSS.c
rename to net/netfilter/xt_TCPMSS_TARGET.c
index 116a885adb3c..fec2f0942fc6 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS_TARGET.c
@@ -22,7 +22,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_tcpudp.h>
-#include <linux/netfilter/xt_TCPMSS.h>
+#include <linux/netfilter/xt_TCPMSS_TARGET.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-- 
2.47.0.windows.2

