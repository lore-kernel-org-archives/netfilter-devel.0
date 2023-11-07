Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A3DC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Nov 2023 09:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbjKGJsX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Nov 2023 04:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233844AbjKGJsW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2023 04:48:22 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D2411F
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2023 01:48:18 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r0Igx-0001Vw-Tl; Tue, 07 Nov 2023 10:48:15 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] ipvs: add missing module descriptions
Date:   Tue,  7 Nov 2023 10:48:04 +0100
Message-ID: <20231107094807.2723-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

W=1 builds warn on missing MODULE_DESCRIPTION, add them.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipvs/ip_vs_core.c   | 1 +
 net/netfilter/ipvs/ip_vs_dh.c     | 1 +
 net/netfilter/ipvs/ip_vs_fo.c     | 1 +
 net/netfilter/ipvs/ip_vs_ftp.c    | 1 +
 net/netfilter/ipvs/ip_vs_lblc.c   | 1 +
 net/netfilter/ipvs/ip_vs_lblcr.c  | 1 +
 net/netfilter/ipvs/ip_vs_lc.c     | 1 +
 net/netfilter/ipvs/ip_vs_nq.c     | 1 +
 net/netfilter/ipvs/ip_vs_ovf.c    | 1 +
 net/netfilter/ipvs/ip_vs_pe_sip.c | 1 +
 net/netfilter/ipvs/ip_vs_rr.c     | 1 +
 net/netfilter/ipvs/ip_vs_sed.c    | 1 +
 net/netfilter/ipvs/ip_vs_sh.c     | 1 +
 net/netfilter/ipvs/ip_vs_twos.c   | 1 +
 net/netfilter/ipvs/ip_vs_wlc.c    | 1 +
 net/netfilter/ipvs/ip_vs_wrr.c    | 1 +
 16 files changed, 16 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 3230506ae3ff..a2c16b501087 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2450,3 +2450,4 @@ static void __exit ip_vs_cleanup(void)
 module_init(ip_vs_init);
 module_exit(ip_vs_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("IP Virtual Server");
diff --git a/net/netfilter/ipvs/ip_vs_dh.c b/net/netfilter/ipvs/ip_vs_dh.c
index 5e6ec32aff2b..75f4c231f4a0 100644
--- a/net/netfilter/ipvs/ip_vs_dh.c
+++ b/net/netfilter/ipvs/ip_vs_dh.c
@@ -270,3 +270,4 @@ static void __exit ip_vs_dh_cleanup(void)
 module_init(ip_vs_dh_init);
 module_exit(ip_vs_dh_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs destination hashing scheduler");
diff --git a/net/netfilter/ipvs/ip_vs_fo.c b/net/netfilter/ipvs/ip_vs_fo.c
index b846cc385279..ab117e5bc34e 100644
--- a/net/netfilter/ipvs/ip_vs_fo.c
+++ b/net/netfilter/ipvs/ip_vs_fo.c
@@ -72,3 +72,4 @@ static void __exit ip_vs_fo_cleanup(void)
 module_init(ip_vs_fo_init);
 module_exit(ip_vs_fo_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs weighted failover scheduler");
diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index ef1f45e43b63..f53899d12416 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -635,3 +635,4 @@ static void __exit ip_vs_ftp_exit(void)
 module_init(ip_vs_ftp_init);
 module_exit(ip_vs_ftp_exit);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs ftp helper");
diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index cf78ba4ce5ff..8ceec7a2fa8f 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -632,3 +632,4 @@ static void __exit ip_vs_lblc_cleanup(void)
 module_init(ip_vs_lblc_init);
 module_exit(ip_vs_lblc_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs locality-based least-connection scheduler");
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index 9eddf118b40e..0fb64707213f 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -817,3 +817,4 @@ static void __exit ip_vs_lblcr_cleanup(void)
 module_init(ip_vs_lblcr_init);
 module_exit(ip_vs_lblcr_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs locality-based least-connection with replication scheduler");
diff --git a/net/netfilter/ipvs/ip_vs_lc.c b/net/netfilter/ipvs/ip_vs_lc.c
index 9d34d81fc6f1..c2764505e380 100644
--- a/net/netfilter/ipvs/ip_vs_lc.c
+++ b/net/netfilter/ipvs/ip_vs_lc.c
@@ -86,3 +86,4 @@ static void __exit ip_vs_lc_cleanup(void)
 module_init(ip_vs_lc_init);
 module_exit(ip_vs_lc_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs least connection scheduler");
diff --git a/net/netfilter/ipvs/ip_vs_nq.c b/net/netfilter/ipvs/ip_vs_nq.c
index f56862a87518..ed7f5c889b41 100644
--- a/net/netfilter/ipvs/ip_vs_nq.c
+++ b/net/netfilter/ipvs/ip_vs_nq.c
@@ -136,3 +136,4 @@ static void __exit ip_vs_nq_cleanup(void)
 module_init(ip_vs_nq_init);
 module_exit(ip_vs_nq_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs never queue scheduler");
diff --git a/net/netfilter/ipvs/ip_vs_ovf.c b/net/netfilter/ipvs/ip_vs_ovf.c
index c03066fdd5ca..c7708b809700 100644
--- a/net/netfilter/ipvs/ip_vs_ovf.c
+++ b/net/netfilter/ipvs/ip_vs_ovf.c
@@ -79,3 +79,4 @@ static void __exit ip_vs_ovf_cleanup(void)
 module_init(ip_vs_ovf_init);
 module_exit(ip_vs_ovf_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs overflow connection scheduler");
diff --git a/net/netfilter/ipvs/ip_vs_pe_sip.c b/net/netfilter/ipvs/ip_vs_pe_sip.c
index 0ac6705a61d3..e4ce1d9a63f9 100644
--- a/net/netfilter/ipvs/ip_vs_pe_sip.c
+++ b/net/netfilter/ipvs/ip_vs_pe_sip.c
@@ -185,3 +185,4 @@ static void __exit ip_vs_sip_cleanup(void)
 module_init(ip_vs_sip_init);
 module_exit(ip_vs_sip_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs sip helper");
diff --git a/net/netfilter/ipvs/ip_vs_rr.c b/net/netfilter/ipvs/ip_vs_rr.c
index 38495c6f6c7c..6baa34dff9f0 100644
--- a/net/netfilter/ipvs/ip_vs_rr.c
+++ b/net/netfilter/ipvs/ip_vs_rr.c
@@ -122,4 +122,5 @@ static void __exit ip_vs_rr_cleanup(void)
 
 module_init(ip_vs_rr_init);
 module_exit(ip_vs_rr_cleanup);
+MODULE_DESCRIPTION("ipvs round-robin scheduler");
 MODULE_LICENSE("GPL");
diff --git a/net/netfilter/ipvs/ip_vs_sed.c b/net/netfilter/ipvs/ip_vs_sed.c
index 7663288e5358..a46f99a56618 100644
--- a/net/netfilter/ipvs/ip_vs_sed.c
+++ b/net/netfilter/ipvs/ip_vs_sed.c
@@ -137,3 +137,4 @@ static void __exit ip_vs_sed_cleanup(void)
 module_init(ip_vs_sed_init);
 module_exit(ip_vs_sed_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs shortest expected delay scheduler");
diff --git a/net/netfilter/ipvs/ip_vs_sh.c b/net/netfilter/ipvs/ip_vs_sh.c
index c2028e412092..92e77d7a6b50 100644
--- a/net/netfilter/ipvs/ip_vs_sh.c
+++ b/net/netfilter/ipvs/ip_vs_sh.c
@@ -376,3 +376,4 @@ static void __exit ip_vs_sh_cleanup(void)
 module_init(ip_vs_sh_init);
 module_exit(ip_vs_sh_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs source hashing scheduler");
diff --git a/net/netfilter/ipvs/ip_vs_twos.c b/net/netfilter/ipvs/ip_vs_twos.c
index 3308e4cc740a..8d5419edde50 100644
--- a/net/netfilter/ipvs/ip_vs_twos.c
+++ b/net/netfilter/ipvs/ip_vs_twos.c
@@ -137,3 +137,4 @@ static void __exit ip_vs_twos_cleanup(void)
 module_init(ip_vs_twos_init);
 module_exit(ip_vs_twos_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs power of twos choice scheduler");
diff --git a/net/netfilter/ipvs/ip_vs_wlc.c b/net/netfilter/ipvs/ip_vs_wlc.c
index 09f584b564a0..9fa500927c0a 100644
--- a/net/netfilter/ipvs/ip_vs_wlc.c
+++ b/net/netfilter/ipvs/ip_vs_wlc.c
@@ -109,3 +109,4 @@ static void __exit ip_vs_wlc_cleanup(void)
 module_init(ip_vs_wlc_init);
 module_exit(ip_vs_wlc_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs weighted least connection scheduler");
diff --git a/net/netfilter/ipvs/ip_vs_wrr.c b/net/netfilter/ipvs/ip_vs_wrr.c
index 1bc7a0789d85..85ce0d04afac 100644
--- a/net/netfilter/ipvs/ip_vs_wrr.c
+++ b/net/netfilter/ipvs/ip_vs_wrr.c
@@ -263,3 +263,4 @@ static void __exit ip_vs_wrr_cleanup(void)
 module_init(ip_vs_wrr_init);
 module_exit(ip_vs_wrr_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ipvs weighted round-robin scheduler");
-- 
2.41.0

