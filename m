Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A962EC46467
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbiK2VsA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236192AbiK2Vr6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:47:58 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6BC64A0D
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Cx37xVJxTIYoDBvY4mgkjoAKv+gPEA0mrr7wrbIkY2s=; b=rQ356hjxPh1cA7DOL5xir7QoOD
        ClhVrCm+svy/5zf5ixk2yK0ZKFXyOd7mJXV2bDGpLl4futJogvSyNKXzJDXflHsYU6ZaksrYuWsNQ
        XMwu/AcnXNvJ1XjgdO5cOC7pBKn3jggsnrxJrW848q8ctu+7L82MpLMWcmG5edtgyGSTK9yb/WSyk
        P7Ml29OYqEWfk1d1Txn4DbJgxOcMgDHym3OkjsFvnNqFhkatU5rGiHfSDnqQhFLpktGyRW2A/Sr6N
        8Crrib9tqiQaVvjFL+9DeUgYh3U2PhblOXw2GWxfjToboUX02gwQm7k8Jz37PgT+E6DU0V39COmrZ
        VhBXnPQg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SJ-00DjQp-Ed
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:55 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 08/34] src: parenthesize config-entry macro arguments
Date:   Tue, 29 Nov 2022 21:47:23 +0000
Message-Id: <20221129214749.247878-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221129214749.247878-1-jeremy@azazel.net>
References: <20221129214749.247878-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's avoids problems with operator precedence.  For example, with no
parentheses:

  #define blah_ce(x) (x->ces[0])

  blah_ce(&whatever)

yields:

  (&(whatever->ces[0]))

instead of:

  ((&whatever)->ces[0])

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/db.h                | 14 +++++++-------
 input/flow/ulogd_inpflow_NFCT.c   | 18 +++++++++---------
 input/packet/ulogd_inppkt_NFLOG.c | 24 ++++++++++++------------
 input/sum/ulogd_inpflow_NFACCT.c  |  6 +++---
 output/dbi/ulogd_output_DBI.c     | 14 +++++++-------
 output/ipfix/ulogd_output_IPFIX.c | 12 ++++++------
 output/mysql/ulogd_output_MYSQL.c | 10 +++++-----
 output/pgsql/ulogd_output_PGSQL.c | 14 +++++++-------
 output/ulogd_output_GRAPHITE.c    |  6 +++---
 output/ulogd_output_JSON.c        |  8 ++++----
 10 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index bf62f236d772..50925a69f240 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -103,13 +103,13 @@ struct db_instance {
 		}
 
 #define DB_CE_NUM		7
-#define table_ce(x)		(x->ces[0])
-#define reconnect_ce(x)		(x->ces[1])
-#define timeout_ce(x)		(x->ces[2])
-#define procedure_ce(x)		(x->ces[3])
-#define backlog_memcap_ce(x)	(x->ces[4])
-#define backlog_oneshot_ce(x)	(x->ces[5])
-#define ringsize_ce(x)		(x->ces[6])
+#define table_ce(x)		((x)->ces[0])
+#define reconnect_ce(x)		((x)->ces[1])
+#define timeout_ce(x)		((x)->ces[2])
+#define procedure_ce(x)		((x)->ces[3])
+#define backlog_memcap_ce(x)	((x)->ces[4])
+#define backlog_oneshot_ce(x)	((x)->ces[5])
+#define ringsize_ce(x)		((x)->ces[6])
 
 void ulogd_db_signal(struct ulogd_pluginstance *upi, int signal);
 int ulogd_db_start(struct ulogd_pluginstance *upi);
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 76250f2a9982..04910601fb8c 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -137,15 +137,15 @@ static struct config_keyset nfct_kset = {
 		},
 	},
 };
-#define pollint_ce(x)	(x->ces[0])
-#define usehash_ce(x)	(x->ces[1])
-#define buckets_ce(x)	(x->ces[2])
-#define maxentries_ce(x) (x->ces[3])
-#define eventmask_ce(x) (x->ces[4])
-#define nlsockbufsize_ce(x) (x->ces[5])
-#define nlsockbufmaxsize_ce(x) (x->ces[6])
-#define nlresynctimeout_ce(x) (x->ces[7])
-#define reliable_ce(x)	(x->ces[8])
+#define pollint_ce(x)		((x)->ces[0])
+#define usehash_ce(x)		((x)->ces[1])
+#define buckets_ce(x)		((x)->ces[2])
+#define maxentries_ce(x)	((x)->ces[3])
+#define eventmask_ce(x)		((x)->ces[4])
+#define nlsockbufsize_ce(x)	((x)->ces[5])
+#define nlsockbufmaxsize_ce(x)	((x)->ces[6])
+#define nlresynctimeout_ce(x)	((x)->ces[7])
+#define reliable_ce(x)		((x)->ces[8])
 #define src_filter_ce(x)	((x)->ces[9])
 #define dst_filter_ce(x)	((x)->ces[10])
 #define proto_filter_ce(x)	((x)->ces[11])
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index e197a705cb4d..4cbae69fee20 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -99,18 +99,18 @@ static struct config_keyset libulog_kset = {
 	}
 };
 
-#define bufsiz_ce(x)	(x->ces[0])
-#define group_ce(x)	(x->ces[1])
-#define unbind_ce(x)	(x->ces[2])
-#define bind_ce(x)	(x->ces[3])
-#define seq_ce(x)	(x->ces[4])
-#define seq_global_ce(x)	(x->ces[5])
-#define label_ce(x)	(x->ces[6])
-#define nlsockbufsize_ce(x) (x->ces[7])
-#define nlsockbufmaxsize_ce(x) (x->ces[8])
-#define nlthreshold_ce(x) (x->ces[9])
-#define nltimeout_ce(x) (x->ces[10])
-#define attach_conntrack_ce(x) (x->ces[11])
+#define bufsiz_ce(x)		((x)->ces[0])
+#define group_ce(x)		((x)->ces[1])
+#define unbind_ce(x)		((x)->ces[2])
+#define bind_ce(x)		((x)->ces[3])
+#define seq_ce(x)		((x)->ces[4])
+#define seq_global_ce(x)	((x)->ces[5])
+#define label_ce(x)		((x)->ces[6])
+#define nlsockbufsize_ce(x)	((x)->ces[7])
+#define nlsockbufmaxsize_ce(x)	((x)->ces[8])
+#define nlthreshold_ce(x)	((x)->ces[9])
+#define nltimeout_ce(x)		((x)->ces[10])
+#define attach_conntrack_ce(x)	((x)->ces[11])
 
 enum nflog_keys {
 	NFLOG_KEY_RAW_MAC = 0,
diff --git a/input/sum/ulogd_inpflow_NFACCT.c b/input/sum/ulogd_inpflow_NFACCT.c
index 539fb67f5863..c680a52a80e8 100644
--- a/input/sum/ulogd_inpflow_NFACCT.c
+++ b/input/sum/ulogd_inpflow_NFACCT.c
@@ -51,9 +51,9 @@ static struct config_keyset nfacct_kset = {
 	},
 	.num_ces = 3,
 };
-#define pollint_ce(x)	(x->ces[0])
-#define zerocounter_ce(x) (x->ces[1])
-#define timestamp_ce(x) (x->ces[2])
+#define pollint_ce(x)		((x)->ces[0])
+#define zerocounter_ce(x)	((x)->ces[1])
+#define timestamp_ce(x)		((x)->ces[2])
 
 enum ulogd_nfacct_keys {
 	ULOGD_NFACCT_NAME,
diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 5639125dde1f..95bd35789c08 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -78,13 +78,13 @@ static struct config_keyset dbi_kset = {
 		},
 	},
 };
-#define db_ce(x)	(x->ces[DB_CE_NUM+0])
-#define host_ce(x)	(x->ces[DB_CE_NUM+1])
-#define user_ce(x)	(x->ces[DB_CE_NUM+2])
-#define pass_ce(x)	(x->ces[DB_CE_NUM+3])
-#define port_ce(x)	(x->ces[DB_CE_NUM+4])
-#define schema_ce(x)	(x->ces[DB_CE_NUM+5])
-#define dbtype_ce(x)	(x->ces[DB_CE_NUM+6])
+#define db_ce(x)	((x)->ces[DB_CE_NUM + 0])
+#define host_ce(x)	((x)->ces[DB_CE_NUM + 1])
+#define user_ce(x)	((x)->ces[DB_CE_NUM + 2])
+#define pass_ce(x)	((x)->ces[DB_CE_NUM + 3])
+#define port_ce(x)	((x)->ces[DB_CE_NUM + 4])
+#define schema_ce(x)	((x)->ces[DB_CE_NUM + 5])
+#define dbtype_ce(x)	((x)->ces[DB_CE_NUM + 6])
 
 
 /* find out which columns the table has */
diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
index 13d170108375..745d30a163b2 100644
--- a/output/ipfix/ulogd_output_IPFIX.c
+++ b/output/ipfix/ulogd_output_IPFIX.c
@@ -40,12 +40,12 @@ enum {
 	SEND_TEMPLATE_CE
 };
 
-#define oid_ce(x)		(x->ces[OID_CE])
-#define host_ce(x)		(x->ces[HOST_CE])
-#define port_ce(x)		(x->ces[PORT_CE])
-#define proto_ce(x)		(x->ces[PROTO_CE])
-#define mtu_ce(x)		(x->ces[MTU_CE])
-#define send_template_ce(x)	(x->ces[SEND_TEMPLATE_CE])
+#define oid_ce(x)		((x)->ces[OID_CE])
+#define host_ce(x)		((x)->ces[HOST_CE])
+#define port_ce(x)		((x)->ces[PORT_CE])
+#define proto_ce(x)		((x)->ces[PROTO_CE])
+#define mtu_ce(x)		((x)->ces[MTU_CE])
+#define send_template_ce(x)	((x)->ces[SEND_TEMPLATE_CE])
 
 static const struct config_keyset ipfix_kset = {
 	.num_ces = 6,
diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index dc49a2ae4e5b..0b79a9cd270c 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -89,11 +89,11 @@ static struct config_keyset kset_mysql = {
 		},
 	},
 };
-#define db_ce(x)	(x->ces[DB_CE_NUM+0])
-#define	host_ce(x)	(x->ces[DB_CE_NUM+1])
-#define user_ce(x)	(x->ces[DB_CE_NUM+2])
-#define pass_ce(x)	(x->ces[DB_CE_NUM+3])
-#define port_ce(x)	(x->ces[DB_CE_NUM+4])
+#define db_ce(x)	((x)->ces[DB_CE_NUM + 0])
+#define host_ce(x)	((x)->ces[DB_CE_NUM + 1])
+#define user_ce(x)	((x)->ces[DB_CE_NUM + 2])
+#define pass_ce(x)	((x)->ces[DB_CE_NUM + 3])
+#define port_ce(x)	((x)->ces[DB_CE_NUM + 4])
 /* find out which columns the table has */
 static int get_columns_mysql(struct ulogd_pluginstance *upi)
 {
diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index 1890cb574a95..7f215f0fee4c 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -74,13 +74,13 @@ static struct config_keyset pgsql_kset = {
 		},
 	},
 };
-#define db_ce(x)	(x->ces[DB_CE_NUM+0])
-#define host_ce(x)	(x->ces[DB_CE_NUM+1])
-#define user_ce(x)	(x->ces[DB_CE_NUM+2])
-#define pass_ce(x)	(x->ces[DB_CE_NUM+3])
-#define port_ce(x)	(x->ces[DB_CE_NUM+4])
-#define schema_ce(x)	(x->ces[DB_CE_NUM+5])
-#define connstr_ce(x)	(x->ces[DB_CE_NUM+6])
+#define db_ce(x)	((x)->ces[DB_CE_NUM + 0])
+#define host_ce(x)	((x)->ces[DB_CE_NUM + 1])
+#define user_ce(x)	((x)->ces[DB_CE_NUM + 2])
+#define pass_ce(x)	((x)->ces[DB_CE_NUM + 3])
+#define port_ce(x)	((x)->ces[DB_CE_NUM + 4])
+#define schema_ce(x)	((x)->ces[DB_CE_NUM + 5])
+#define connstr_ce(x)	((x)->ces[DB_CE_NUM + 6])
 
 #define PGSQL_HAVE_NAMESPACE_TEMPLATE 			\
 	"SELECT nspname FROM pg_namespace n WHERE n.nspname='%s'"
diff --git a/output/ulogd_output_GRAPHITE.c b/output/ulogd_output_GRAPHITE.c
index 28280b200544..22434707bcf9 100644
--- a/output/ulogd_output_GRAPHITE.c
+++ b/output/ulogd_output_GRAPHITE.c
@@ -79,9 +79,9 @@ static struct config_keyset graphite_kset = {
 	},
 };
 
-#define host_ce(x)	(x->ces[0])
-#define port_ce(x)	(x->ces[1])
-#define prefix_ce(x)	(x->ces[2])
+#define host_ce(x)	((x)->ces[0])
+#define port_ce(x)	((x)->ces[1])
+#define prefix_ce(x)	((x)->ces[2])
 
 struct graphite_instance {
 	int sck;
diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index 59aab305e545..76b51b2afaa7 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -45,10 +45,10 @@
 #define ULOGD_JSON_DEFAULT_DEVICE "Netfilter"
 #endif
 
-#define host_ce(x)	(x->ces[JSON_CONF_HOST])
-#define port_ce(x)	(x->ces[JSON_CONF_PORT])
-#define mode_ce(x)	(x->ces[JSON_CONF_MODE])
-#define file_ce(x)	(x->ces[JSON_CONF_FILENAME])
+#define host_ce(x)	((x)->ces[JSON_CONF_HOST])
+#define port_ce(x)	((x)->ces[JSON_CONF_PORT])
+#define mode_ce(x)	((x)->ces[JSON_CONF_MODE])
+#define file_ce(x)	((x)->ces[JSON_CONF_FILENAME])
 #define unlikely(x) __builtin_expect((x),0)
 
 struct json_priv {
-- 
2.35.1

