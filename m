Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75785C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiKUW6g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbiKUW6f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:58:35 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9092F383
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WuRPrc2pRcRyzTqY+4/2eXOh+Zp2tl4wwjmKOY8jlm0=; b=EBx7E2pFlZRt2Ey71PxIRxTHTH
        N8WgRN8DLHJolqE+zCfVHEeFVmHLTQwVJt1MpBHM5ZDsgSXphKk0dxHfWK5jdZDg7O4MFQKshwF1p
        Ksz5Zku/JtwQwynV1KHdgXI08b/iZAB7K9cIBn/yG4v1qJXnTuq51QTg96mcNQ+iLUmM3P0M4qIA2
        iyfEJiJT82D9ag+WV7+kHaOlOnmwT0VbEhWvlN4uBW4guECoWIubNPX2ERtGYiiB67PujuLRrEZCk
        pWnEU9pmSP3GSF2EMnOPQLP7yvZrUL7jY+OgadR3N41eR7dvIAHC+QegYyCUWyltu6+lLwdffSYNt
        tDIsehBw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGD-005LgP-H0
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:29 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 13/34] output: remove zero-initialized `struct ulogd_plugin` members
Date:   Mon, 21 Nov 2022 22:25:50 +0000
Message-Id: <20221121222611.3914559-14-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221121222611.3914559-1-jeremy@azazel.net>
References: <20221121222611.3914559-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Struct members are zero-initialized as a matter of course.

Use consistent formatting.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/dbi/ulogd_output_DBI.c         | 10 ++++------
 output/ipfix/ulogd_output_IPFIX.c     | 20 ++++++++++----------
 output/mysql/ulogd_output_MYSQL.c     | 22 ++++++++++------------
 output/pcap/ulogd_output_PCAP.c       |  6 +++---
 output/pgsql/ulogd_output_PGSQL.c     | 10 ++++------
 output/sqlite3/ulogd_output_SQLITE3.c | 18 +++++++++---------
 6 files changed, 40 insertions(+), 46 deletions(-)

diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 88b530ead034..6312ac1649e2 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -287,16 +287,14 @@ static int configure_dbi(struct ulogd_pluginstance *upi,
 }
 
 static struct ulogd_plugin dbi_plugin = {
-	.name 		= "DBI",
-	.input 		= {
-		.keys	= NULL,
-		.num_keys = 0,
+	.name		= "DBI",
+	.input		= {
 		.type	= ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
 	},
-	.output 	= {
+	.output		= {
 		.type	= ULOGD_DTYPE_SINK,
 	},
-	.config_kset 	= &dbi_kset,
+	.config_kset	= &dbi_kset,
 	.priv_size	= sizeof(struct dbi_instance),
 	.configure	= &configure_dbi,
 	.start		= &ulogd_db_start,
diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
index 45fd36bc271c..f252ec72b5f6 100644
--- a/output/ipfix/ulogd_output_IPFIX.c
+++ b/output/ipfix/ulogd_output_IPFIX.c
@@ -486,22 +486,22 @@ again:
 }
 
 static struct ulogd_plugin ipfix_plugin = {
-	.name = "IPFIX",
-	.input = {
+	.name           = "IPFIX",
+	.input          = {
 		.keys = ipfix_in_keys,
 		.num_keys = ARRAY_SIZE(ipfix_in_keys),
 		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW | ULOGD_DTYPE_SUM
 	},
-	.output = {
+	.output         = {
 		.type = ULOGD_DTYPE_SINK
 	},
-	.config_kset = (struct config_keyset *) &ipfix_kset,
-	.priv_size = sizeof(struct ipfix_priv),
-	.configure = ipfix_configure,
-	.start = ipfix_start,
-	.stop = ipfix_stop,
-	.interp = ipfix_interp,
-	.version = VERSION,
+	.config_kset    = (struct config_keyset *) &ipfix_kset,
+	.priv_size      = sizeof(struct ipfix_priv),
+	.configure      = ipfix_configure,
+	.start          = ipfix_start,
+	.stop           = ipfix_stop,
+	.interp         = ipfix_interp,
+	.version        = VERSION,
 };
 
 static void __attribute__ ((constructor)) init(void)
diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index c98b98284748..5891207d5990 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -259,23 +259,21 @@ static int configure_mysql(struct ulogd_pluginstance *upi,
 }
 
 static struct ulogd_plugin plugin_mysql = {
-	.name = "MYSQL",
-	.input = {
-		.keys = NULL,
-		.num_keys = 0,
+	.name	     = "MYSQL",
+	.input	     = {
 		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
 	},
-	.output = {
+	.output	     = {
 		.type = ULOGD_DTYPE_SINK,
 	},
 	.config_kset = &kset_mysql,
-	.priv_size = sizeof(struct mysql_instance),
-	.configure = &configure_mysql,
-	.start	   = &ulogd_db_start,
-	.stop	   = &ulogd_db_stop,
-	.signal	   = &ulogd_db_signal,
-	.interp	   = &ulogd_db_interp,
-	.version   = VERSION,
+	.priv_size   = sizeof(struct mysql_instance),
+	.configure   = &configure_mysql,
+	.start	     = &ulogd_db_start,
+	.stop	     = &ulogd_db_stop,
+	.signal	     = &ulogd_db_signal,
+	.interp	     = &ulogd_db_interp,
+	.version     = VERSION,
 };
 
 static void __attribute__ ((constructor)) init(void)
diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index 5f9fde3c48ed..5336f88e539d 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -287,13 +287,13 @@ static int stop_pcap(struct ulogd_pluginstance *upi)
 }
 
 static struct ulogd_plugin pcap_plugin = {
-	.name = "PCAP",
-	.input = {
+	.name		= "PCAP",
+	.input		= {
 		.keys = pcap_keys,
 		.num_keys = ARRAY_SIZE(pcap_keys),
 		.type = ULOGD_DTYPE_PACKET,
 	},
-	.output = {
+	.output		= {
 		.type = ULOGD_DTYPE_SINK,
 	},
 	.config_kset	= &pcap_kset,
diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index b798555b5ade..bc0eae7558b3 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -337,16 +337,14 @@ static int configure_pgsql(struct ulogd_pluginstance *upi,
 }
 
 static struct ulogd_plugin pgsql_plugin = {
-	.name 		= "PGSQL",
-	.input 		= {
-		.keys	= NULL,
-		.num_keys = 0,
+	.name		= "PGSQL",
+	.input		= {
 		.type	= ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
 	},
-	.output 	= {
+	.output		= {
 		.type	= ULOGD_DTYPE_SINK,
 	},
-	.config_kset 	= &pgsql_kset,
+	.config_kset	= &pgsql_kset,
 	.priv_size	= sizeof(struct pgsql_instance),
 	.configure	= &configure_pgsql,
 	.start		= &ulogd_db_start,
diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index 40d99ca3b249..32459dd6c4c5 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -419,20 +419,20 @@ sqlite3_stop(struct ulogd_pluginstance *pi)
 }
 
 static struct ulogd_plugin sqlite3_plugin = {
-	.name = "SQLITE3",
-	.input = {
+	.name	     = "SQLITE3",
+	.input	     = {
 		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
 	},
-	.output = {
+	.output	     = {
 		.type = ULOGD_DTYPE_SINK,
 	},
 	.config_kset = &sqlite3_kset,
-	.priv_size = sizeof(struct sqlite3_priv),
-	.configure = sqlite3_configure,
-	.start = sqlite3_start,
-	.stop = sqlite3_stop,
-	.interp = sqlite3_interp,
-	.version = VERSION,
+	.priv_size   = sizeof(struct sqlite3_priv),
+	.configure   = sqlite3_configure,
+	.start	     = sqlite3_start,
+	.stop	     = sqlite3_stop,
+	.interp	     = sqlite3_interp,
+	.version     = VERSION,
 };
 
 static void __attribute__ ((constructor)) init(void)
-- 
2.35.1

