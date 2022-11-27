Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A6BC43217
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Nov 2022 00:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiK0AXZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Nov 2022 19:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiK0AXY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Nov 2022 19:23:24 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB94DEFE
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Nov 2022 16:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QasY0hxRysgwEGgnx2ioKumml2MK2IumgQ82lgVK2Js=; b=pd5rBYN351uFGTN9dF58kJNhpX
        Wd+7m0pRRgPN3CCtP/rnoDwGOo0sdgLO+87uKS6fbPJ9I+n1AZvzmaVLz6PaMSHAh2jVuDgN7mTA8
        mlHCEC0U27ABtTAsWi5tUIl2gY6h7DWcFtyfFQCoB/lvhQ11RRU91yCSThgobXDRg08etK6dX5Oxd
        OUbEHZicwrFnNNxCOYkSTWWNxQtO1X1av/mqhqKdj+JoAGO5ub/YFFrSXR1Mrc+Rb40Q5ZvVFZDq9
        jtHu9kfrZVLxnpnhDF/7+fQAozik/nV/QFZrNyjCy/4gOjrLJqB+kAPEUmf5xWScFwkWSs+GvGYwN
        Id2ypQtw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oz5S3-00Aj1L-1c; Sun, 27 Nov 2022 00:23:19 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Robert O'Brien <robrien@foxtrot-research.com>
Subject: [PATCH ulogd2 2/3] output: add missing support for int64_t values
Date:   Sun, 27 Nov 2022 00:22:59 +0000
Message-Id: <20221127002300.191936-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221127002300.191936-1-jeremy@azazel.net>
References: <20221127002300.191936-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some of the output plug-ins don't handle 64-bit signed values.

Fix formatting of OPRINT switch.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ulogd_output_GPRINT.c |  4 ++-
 output/ulogd_output_JSON.c   |  3 ++
 output/ulogd_output_OPRINT.c | 55 +++++++++++++++++++-----------------
 3 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
index aedd08e980f7..eeeec6ac3eb0 100644
--- a/output/ulogd_output_GPRINT.c
+++ b/output/ulogd_output_GPRINT.c
@@ -127,13 +127,15 @@ static int gprint_interp(struct ulogd_pluginstance *upi)
 		case ULOGD_RET_INT8:
 		case ULOGD_RET_INT16:
 		case ULOGD_RET_INT32:
+		case ULOGD_RET_INT64:
 			ret = snprintf(buf+size, rem, "%s=", key->name);
 			if (ret < 0)
 				break;
 			rem -= ret;
 			size += ret;
 
-			ret = snprintf(buf+size, rem, "%d,", key->u.value.i32);
+			ret = snprintf(buf+size, rem, "%" PRId64 ",",
+				       key->u.value.i64);
 			if (ret < 0)
 				break;
 			rem -= ret;
diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index bbc3dba5d41a..32d020ac657a 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -366,6 +366,9 @@ static int json_interp(struct ulogd_pluginstance *upi)
 		case ULOGD_RET_INT32:
 			json_object_set_new(msg, field_name, json_integer(key->u.value.i32));
 			break;
+		case ULOGD_RET_INT64:
+			json_object_set_new(msg, field_name, json_integer(key->u.value.i64));
+			break;
 		case ULOGD_RET_UINT8:
 			if ((upi->config_kset->ces[JSON_CONF_BOOLEAN_LABEL].u.value != 0)
 					&& (!strcmp(key->name, "raw.label"))) {
diff --git a/output/ulogd_output_OPRINT.c b/output/ulogd_output_OPRINT.c
index 6fde445ed1e4..8617203237c3 100644
--- a/output/ulogd_output_OPRINT.c
+++ b/output/ulogd_output_OPRINT.c
@@ -65,32 +65,35 @@ static int oprint_interp(struct ulogd_pluginstance *upi)
 
 		fprintf(opi->of,"%s=", ret->name);
 		switch (ret->type) {
-			case ULOGD_RET_STRING:
-				fprintf(opi->of, "%s\n",
-					(char *) ret->u.value.ptr);
-				break;
-			case ULOGD_RET_BOOL:
-			case ULOGD_RET_INT8:
-			case ULOGD_RET_INT16:
-			case ULOGD_RET_INT32:
-				fprintf(opi->of, "%d\n", ret->u.value.i32);
-				break;
-			case ULOGD_RET_UINT8:
-			case ULOGD_RET_UINT16:
-			case ULOGD_RET_UINT32:
-				fprintf(opi->of, "%u\n", ret->u.value.ui32);
-				break;
-			case ULOGD_RET_UINT64:
-				fprintf(opi->of, "%" PRIu64 "\n", ret->u.value.ui64);
-				break;
-			case ULOGD_RET_IPADDR:
-				fprintf(opi->of, "%u.%u.%u.%u\n", 
-					HIPQUAD(ret->u.value.ui32));
-				break;
-			case ULOGD_RET_NONE:
-				fprintf(opi->of, "<none>\n");
-				break;
-			default: fprintf(opi->of, "default\n");
+		case ULOGD_RET_STRING:
+			fprintf(opi->of, "%s\n",
+				(char *) ret->u.value.ptr);
+			break;
+		case ULOGD_RET_BOOL:
+		case ULOGD_RET_INT8:
+		case ULOGD_RET_INT16:
+		case ULOGD_RET_INT32:
+			fprintf(opi->of, "%d\n", ret->u.value.i32);
+			break;
+		case ULOGD_RET_INT64:
+			fprintf(opi->of, "%" PRId64 "\n", ret->u.value.i64);
+			break;
+		case ULOGD_RET_UINT8:
+		case ULOGD_RET_UINT16:
+		case ULOGD_RET_UINT32:
+			fprintf(opi->of, "%u\n", ret->u.value.ui32);
+			break;
+		case ULOGD_RET_UINT64:
+			fprintf(opi->of, "%" PRIu64 "\n", ret->u.value.ui64);
+			break;
+		case ULOGD_RET_IPADDR:
+			fprintf(opi->of, "%u.%u.%u.%u\n",
+				HIPQUAD(ret->u.value.ui32));
+			break;
+		case ULOGD_RET_NONE:
+			fprintf(opi->of, "<none>\n");
+			break;
+		default: fprintf(opi->of, "default\n");
 		}
 	}
 	if (upi->config_kset->ces[1].u.value != 0)
-- 
2.35.1

