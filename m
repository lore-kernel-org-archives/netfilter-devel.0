Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BA8C43219
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbiKUW1p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbiKUW1k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:27:40 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC0EDF97
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FlQ9Jrlj9K0rNd7YBqYiZ+nBicTB8yIxOIaqIRskgKE=; b=PDQ8fibF3qYdWBOEe8ML3Hsi39
        7993bCoLFkd6Nj/8ygdr5cSrij0I3hzYA5slkxHJq69hTM99AgGw1ITP9tmkQEjkesbJrKsxia3ol
        DzIO+iXT6P4BnvrBDDvgiQphK3z8hZ7r8gH+t2A36jhllcujLNvl3sajdPnZegNM8vfb937vxxJ0Y
        d4aLl/r+SgbVveKL+U9auAP5qN86lyMeNIFHJ8jy3nBmMci/rFfeGwTu5m9kEVZkYNrNZ8W8Sr7Xy
        j8XyJD6Mcy5KWqzHYLLsYBC6PXw0Z9LxXeME14OlFCnOZuEbR/SU930+ZQv2ek3btSubCLEAXtKLu
        kdJK+giA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGC-005LgP-MX
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:28 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 07/34] src: remove zero-valued config-key fields
Date:   Mon, 21 Nov 2022 22:25:44 +0000
Message-Id: <20221121222611.3914559-8-jeremy@azazel.net>
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

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_MARK.c           |  3 --
 include/ulogd/db.h                   |  1 -
 input/flow/ulogd_inpflow_NFCT.c      | 14 ---------
 input/packet/ulogd_inppkt_NFLOG.c    | 19 ------------
 input/packet/ulogd_inppkt_ULOG.c     | 44 ++++++++++++----------------
 input/packet/ulogd_inppkt_UNIXSOCK.c |  5 ----
 input/sum/ulogd_inpflow_NFACCT.c     |  5 ----
 output/dbi/ulogd_output_DBI.c        |  4 ---
 output/ipfix/ulogd_output_IPFIX.c    |  2 --
 output/pcap/ulogd_output_PCAP.c      |  2 --
 output/pgsql/ulogd_output_PGSQL.c    |  5 ----
 output/ulogd_output_GPRINT.c         |  7 +----
 output/ulogd_output_GRAPHITE.c       |  3 --
 output/ulogd_output_JSON.c           | 13 +-------
 output/ulogd_output_LOGEMU.c         |  2 --
 output/ulogd_output_NACCT.c          |  5 +---
 output/ulogd_output_OPRINT.c         |  5 +---
 output/ulogd_output_SYSLOG.c         | 16 +++++-----
 output/ulogd_output_XML.c            |  5 ----
 src/ulogd.c                          |  2 --
 20 files changed, 30 insertions(+), 132 deletions(-)

diff --git a/filter/ulogd_filter_MARK.c b/filter/ulogd_filter_MARK.c
index 149725d92574..94343a2b6b5b 100644
--- a/filter/ulogd_filter_MARK.c
+++ b/filter/ulogd_filter_MARK.c
@@ -35,13 +35,10 @@ static struct config_keyset libulog_kset = {
 		[MARK_MARK] = {
 			.key 	 = "mark",
 			.type 	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
 		},
 		[MARK_MASK] = {
 			.key 	 = "mask",
 			.type 	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = 0xffffffff,
 		},
 
diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index 9f9e96d6e077..bf62f236d772 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -90,7 +90,6 @@ struct db_instance {
 		{						\
 			.key = "backlog_memcap",		\
 			.type = CONFIG_TYPE_INT,		\
-			.u.value = 0,				\
 		},						\
 		{						\
 			.key = "backlog_oneshot_requests",	\
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 899b7e3b8039..76250f2a9982 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -83,71 +83,57 @@ static struct config_keyset nfct_kset = {
 		{
 			.key	 = "pollinterval",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
 		},
 		{
 			.key	 = "hash_enable",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = 1,
 		},
 		{
 			.key	 = "hash_buckets",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = HTABLE_SIZE,
 		},
 		{
 			.key	 = "hash_max_entries",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = MAX_ENTRIES,
 		},
 		{
 			.key	 = "event_mask",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = EVENT_MASK,
 		},
 		{
 			.key	 = "netlink_socket_buffer_size",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = 0,
 		},
 		{
 			.key	 = "netlink_socket_buffer_maxsize",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = 0,
 		},
 		{
 			.key	 = "netlink_resync_timeout",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = 60,
 		},
 		{
 			.key	 = "reliable",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
 		},
 		{
 			.key	 = "accept_src_filter",
 			.type	 = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 		},
 		{
 			.key	 = "accept_dst_filter",
 			.type	 = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 		},
 		{
 			.key	 = "accept_proto_filter",
 			.type	 = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 		},
 	},
 };
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 4fdeb12886cc..e197a705cb4d 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -45,69 +45,50 @@ static struct config_keyset libulog_kset = {
 		{
 			.key 	 = "bufsize",
 			.type 	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = NFLOG_BUFSIZE_DEFAULT,
 		},
 		{
 			.key	 = "group",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = NFLOG_GROUP_DEFAULT,
 		},
 		{
 			.key	 = "unbind",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = 1,
 		},
 		{
 			.key	 = "bind",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
 		},
 
 		{
 			.key	 = "seq_local",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
 		},
 		{
 			.key	 = "seq_global",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
 		},
 		{
 			.key	 = "numeric_label",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
 		},
 		{
 			.key     = "netlink_socket_buffer_size",
 			.type    = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
 		},
 		{
 			.key     = "netlink_socket_buffer_maxsize",
 			.type    = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
 		},
 		{
 			.key     = "netlink_qthreshold",
 			.type    = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
 		},
 		{
 			.key     = "netlink_qtimeout",
 			.type    = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
 		},
 		{
 			.key     = "attach_conntrack",
diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index 45ffc8b57ac4..bc271dbfd0b1 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -37,31 +37,25 @@ struct ulog_input {
 static struct config_keyset libulog_kset = {
 	.num_ces = 4,
 	.ces = {
-	{
-		.key 	 = "bufsize",
-		.type 	 = CONFIG_TYPE_INT,
-		.options = CONFIG_OPT_NONE,
-		.u.value = ULOGD_BUFSIZE_DEFAULT,
-	},
-	{
-		.key	 = "nlgroup",
-		.type	 = CONFIG_TYPE_INT,
-		.options = CONFIG_OPT_NONE,
-		.u.value = ULOGD_NLGROUP_DEFAULT,
-	},
-	{
-		.key	 = "rmem",
-		.type	 = CONFIG_TYPE_INT,
-		.options = CONFIG_OPT_NONE,
-		.u.value = ULOGD_RMEM_DEFAULT,
-	},
-	{
-		.key	 = "numeric_label",
-		.type	 = CONFIG_TYPE_INT,
-		.options = CONFIG_OPT_NONE,
-		.u.value = 0,
-	},
-
+		{
+			.key 	 = "bufsize",
+			.type 	 = CONFIG_TYPE_INT,
+			.u.value = ULOGD_BUFSIZE_DEFAULT,
+		},
+		{
+			.key	 = "nlgroup",
+			.type	 = CONFIG_TYPE_INT,
+			.u.value = ULOGD_NLGROUP_DEFAULT,
+		},
+		{
+			.key	 = "rmem",
+			.type	 = CONFIG_TYPE_INT,
+			.u.value = ULOGD_RMEM_DEFAULT,
+		},
+		{
+			.key	 = "numeric_label",
+			.type	 = CONFIG_TYPE_INT,
+		},
 	}
 };
 enum ulog_keys {
diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
index f1d15348ccb3..0ce599bd9b84 100644
--- a/input/packet/ulogd_inppkt_UNIXSOCK.c
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -290,30 +290,25 @@ static struct config_keyset libunixsock_kset = {
 		{
 			.key 	 = "socket_path",
 			.type 	 = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 			.u.string = UNIXSOCK_UNIXPATH_DEFAULT,
 		},
 		{
 			.key 	 = "bufsize",
 			.type 	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = UNIXSOCK_BUFSIZE_DEFAULT,
 		},
 		{
 			.key 	 = "perms",
 			.type 	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = UNIXSOCK_PERMS_DEFAULT,
 		},
 		{
 			.key 	 = "owner",
 			.type 	 = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 		},
 		{
 			.key 	 = "group",
 			.type 	 = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 		},
 	},
 };
diff --git a/input/sum/ulogd_inpflow_NFACCT.c b/input/sum/ulogd_inpflow_NFACCT.c
index b022e6373406..539fb67f5863 100644
--- a/input/sum/ulogd_inpflow_NFACCT.c
+++ b/input/sum/ulogd_inpflow_NFACCT.c
@@ -38,20 +38,15 @@ static struct config_keyset nfacct_kset = {
 		{
 			.key	 = "pollinterval",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
 		},
 		{
 			.key	 = "zerocounter",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = 1,
 		},
 		{
 			.key	 = "timestamp",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = 0,
 		}
 	},
 	.num_ces = 3,
diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 1a623e14c41a..5639125dde1f 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -52,7 +52,6 @@ static struct config_keyset dbi_kset = {
 		{
 			.key = "host",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 		},
 		{
 			.key = "user",
@@ -62,17 +61,14 @@ static struct config_keyset dbi_kset = {
 		{
 			.key = "pass",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 		},
 		{
 			.key = "port",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 		},
 		{
 			.key = "schema",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 			.u.string = "public",
 		},
 		{
diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
index 4863d008562e..13d170108375 100644
--- a/output/ipfix/ulogd_output_IPFIX.c
+++ b/output/ipfix/ulogd_output_IPFIX.c
@@ -53,12 +53,10 @@ static const struct config_keyset ipfix_kset = {
 		{
 			.key = "oid",
 			.type = CONFIG_TYPE_INT,
-			.u.value = 0
 		},
 		{
 			.key = "host",
 			.type = CONFIG_TYPE_STRING,
-			.u.string = ""
 		},
 		{
 			.key = "port",
diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index 6640087f55a5..c125ffcd2a8f 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -94,13 +94,11 @@ static struct config_keyset pcap_kset = {
 		{
 			.key = "file",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 			.u = { .string = ULOGD_PCAP_DEFAULT },
 		},
 		{
 			.key = "sync",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u = { .value = ULOGD_PCAP_SYNC_DEFAULT },
 		},
 	},
diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index 6f3cde61a312..1890cb574a95 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -49,7 +49,6 @@ static struct config_keyset pgsql_kset = {
 		{
 			.key = "host",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 		},
 		{
 			.key = "user",
@@ -59,23 +58,19 @@ static struct config_keyset pgsql_kset = {
 		{
 			.key = "pass",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 		},
 		{
 			.key = "port",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 		},
 		{
 			.key = "schema",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 			.u.string = "public",
 		},
 		{
 			.key = "connstring",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 		},
 	},
 };
diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
index aedd08e980f7..72365dd87cc1 100644
--- a/output/ulogd_output_GPRINT.c
+++ b/output/ulogd_output_GPRINT.c
@@ -51,20 +51,15 @@ static struct config_keyset gprint_kset = {
 		[GPRINT_CONF_FILENAME] = {
 			.key = "file",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
-			.u = {.string = ULOGD_GPRINT_DEFAULT },
+			.u = { .string = ULOGD_GPRINT_DEFAULT },
 		},
 		[GPRINT_CONF_SYNC] = {
 			.key = "sync",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u = { .value = 0 },
 		},
 		[GPRINT_CONF_TIMESTAMP] = {
 			.key = "timestamp",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u = { .value = 0 },
 		},
 	},
 };
diff --git a/output/ulogd_output_GRAPHITE.c b/output/ulogd_output_GRAPHITE.c
index 5328f8e95572..28280b200544 100644
--- a/output/ulogd_output_GRAPHITE.c
+++ b/output/ulogd_output_GRAPHITE.c
@@ -67,17 +67,14 @@ static struct config_keyset graphite_kset = {
 		{
 			.key = "host",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 		},
 		{
 			.key = "port",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 		},
 		{
 			.key = "prefix",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 		},
 	},
 };
diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index 700abc25e5ea..59aab305e545 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -87,26 +87,20 @@ static struct config_keyset json_kset = {
 		[JSON_CONF_FILENAME] = {
 			.key = "file",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
-			.u = {.string = ULOGD_JSON_DEFAULT },
+			.u = { .string = ULOGD_JSON_DEFAULT },
 		},
 		[JSON_CONF_SYNC] = {
 			.key = "sync",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u = { .value = 0 },
 		},
 		[JSON_CONF_TIMESTAMP] = {
 			.key = "timestamp",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u = { .value = 1 },
 		},
 		[JSON_CONF_EVENTV1] = {
 			.key = "eventv1",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u = { .value = 0 },
 		},
 		[JSON_CONF_DEVICE] = {
 			.key = "device",
@@ -117,25 +111,20 @@ static struct config_keyset json_kset = {
 		[JSON_CONF_BOOLEAN_LABEL] = {
 			.key = "boolean_label",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u = { .value = 0 },
 		},
 		[JSON_CONF_MODE] = {
 			.key = "mode",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 			.u = { .string = "file" },
 		},
 		[JSON_CONF_HOST] = {
 			.key = "host",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 			.u = { .string = "127.0.0.1" },
 		},
 		[JSON_CONF_PORT] = {
 			.key = "port",
 			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 			.u = { .string = "12345" },
 		},
 	},
diff --git a/output/ulogd_output_LOGEMU.c b/output/ulogd_output_LOGEMU.c
index cfcfab734746..c20ba1852be8 100644
--- a/output/ulogd_output_LOGEMU.c
+++ b/output/ulogd_output_LOGEMU.c
@@ -64,13 +64,11 @@ static struct config_keyset logemu_kset = {
 		{
 			.key 	 = "file",
 			.type	 = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_NONE,
 			.u	 = { .string = ULOGD_LOGEMU_DEFAULT },
 		},
 		{
 			.key	 = "sync",
 			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u	 = { .value = ULOGD_LOGEMU_SYNC_DEFAULT },
 		},
 	},
diff --git a/output/ulogd_output_NACCT.c b/output/ulogd_output_NACCT.c
index d369c7a87315..7f5d1c5ecbf2 100644
--- a/output/ulogd_output_NACCT.c
+++ b/output/ulogd_output_NACCT.c
@@ -163,14 +163,11 @@ static struct config_keyset nacct_kset = {
 		{
 			.key = "file", 
 			.type = CONFIG_TYPE_STRING, 
-			.options = CONFIG_OPT_NONE,
-			.u = {.string = NACCT_FILE_DEFAULT },
+			.u = { .string = NACCT_FILE_DEFAULT },
 		},
 		{
 			.key = "sync",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u = { .value = 0 },
 		},
 	},
 };
diff --git a/output/ulogd_output_OPRINT.c b/output/ulogd_output_OPRINT.c
index 6fde445ed1e4..265103a04719 100644
--- a/output/ulogd_output_OPRINT.c
+++ b/output/ulogd_output_OPRINT.c
@@ -105,14 +105,11 @@ static struct config_keyset oprint_kset = {
 		{
 			.key = "file", 
 			.type = CONFIG_TYPE_STRING, 
-			.options = CONFIG_OPT_NONE,
-			.u = {.string = ULOGD_OPRINT_DEFAULT },
+			.u = { .string = ULOGD_OPRINT_DEFAULT },
 		},
 		{
 			.key = "sync",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u = { .value = 0 },
 		},
 	},
 };
diff --git a/output/ulogd_output_SYSLOG.c b/output/ulogd_output_SYSLOG.c
index 9777f0fe9185..675db7daf16d 100644
--- a/output/ulogd_output_SYSLOG.c
+++ b/output/ulogd_output_SYSLOG.c
@@ -49,16 +49,14 @@ static struct config_keyset syslog_kset = {
 	.num_ces = 2,
 	.ces = {
 		{
-		.key = "facility", 
-		.type = CONFIG_TYPE_STRING, 
-		.options = CONFIG_OPT_NONE, 
-		.u = { .string = SYSLOG_FACILITY_DEFAULT } 
+			.key = "facility",
+			.type = CONFIG_TYPE_STRING,
+			.u = { .string = SYSLOG_FACILITY_DEFAULT }
 		},
-		{ 
-		.key = "level", 
-		.type = CONFIG_TYPE_STRING,
-		.options = CONFIG_OPT_NONE, 
-		.u = { .string = SYSLOG_LEVEL_DEFAULT }
+		{
+			.key = "level",
+			.type = CONFIG_TYPE_STRING,
+			.u = { .string = SYSLOG_LEVEL_DEFAULT }
 		},
 	},
 };
diff --git a/output/ulogd_output_XML.c b/output/ulogd_output_XML.c
index 44af596dc2bc..512293c506ae 100644
--- a/output/ulogd_output_XML.c
+++ b/output/ulogd_output_XML.c
@@ -75,20 +75,15 @@ static struct config_keyset xml_kset = {
 		[CFG_XML_DIR] = {
 			.key = "directory", 
 			.type = CONFIG_TYPE_STRING, 
-			.options = CONFIG_OPT_NONE,
 			.u = { .string = ULOGD_XML_DEFAULT_DIR },
 		},
 		[CFG_XML_SYNC] = {
 			.key = "sync",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u = { .value = 0 },
 		},
 		[CFG_XML_STDOUT] = {
 			.key = "stdout",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u = { .value = 0 },
 		},
 	},
 };
diff --git a/src/ulogd.c b/src/ulogd.c
index cdb5c689ab36..ec0745e63169 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -133,7 +133,6 @@ static struct config_keyset ulogd_kset = {
 		{
 			.key = "logfile",
 			.type = CONFIG_TYPE_CALLBACK,
-			.options = CONFIG_OPT_NONE,
 			.u.parser = &logfile_open,
 		},
 		{
@@ -145,7 +144,6 @@ static struct config_keyset ulogd_kset = {
 		{
 			.key = "loglevel",
 			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
 			.u.value = ULOGD_NOTICE,
 		},
 		{
-- 
2.35.1

