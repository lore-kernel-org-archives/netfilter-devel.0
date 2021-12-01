Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6880C43217
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 17:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351930AbhLARhU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 12:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351934AbhLARgf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 12:36:35 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A80C06175C
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 09:33:14 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m25-20020a7bcb99000000b0033aa12cdd33so1280801wmi.1
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Dec 2021 09:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QrPCJvTQZEuMZt8tg26jzJI3MASAuWsEobTgf9NoSPQ=;
        b=A5HtmFDtYiIokobHcSDFg8PqWoopW/n/gAFdTX+KWE3vkCXgYqKk5pemkZYMoKELKe
         Vz673U7LUAuAo0IK+uCXVpfLq9JQqeTKAmGE5wjo3eGiQzsA/q249si1PiJVVgklAGSw
         GvAv79xTjQTj7iP3dqa2WEUvI3lcOevVlQ2AwQoHztf2LX4LhaeGkpJXaakprfMiI1vz
         Y35khaMbFuumX3GcODW1WAKynIio4y/0gJ5JWqxyXlumknh1oTbRNEU2MwrgVHtaNfur
         CBcoNZ6dLrcWifeFKdTyHW5Rjnor7jr/jS71l/wNWSyLgI4Ikx4Nr7lknO+w7BcjYf76
         NFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QrPCJvTQZEuMZt8tg26jzJI3MASAuWsEobTgf9NoSPQ=;
        b=gowDGmBU7xYoXNdkmyRFUZVp1lqF29U0+5YrGVU/1ldi4SkY2ecHLNcbKkKQd6+ZdC
         BYjDNjo8+l6I4qhMr41lYJpoqy1XBe1devqpkQw2BZzNpHV9Mfb4X+4OPT8+Z8lMY3YD
         u97E3EE3EoFwi6igXcW+bBElLrBTp2Gf1xLg/uqi1soCg0fh7DS0M11TOZm2PKhGeXOw
         6sL1d9IVRsBwzB0wyYmOGQvEUUyfBxUvO49zP7vHfKZFI/oyg1D7G8YApseT4wyt3dB4
         AmnVak76nym426yyB8trHVI/vyQK4kYjaAkEdTpFNwPmGyawvE7a7T4s/aDV5wJpGhpe
         kukA==
X-Gm-Message-State: AOAM530zDN4jQ2742sSExdJAbYLYYEDqGRAbFh28nH6yPKNqJhAHRYWc
        XJLLYr6V6vQB9ryNTondQO27w0I9A5aHrw==
X-Google-Smtp-Source: ABdhPJyz5ur7zDBkzxA6EY/Y9sI0aqK7Nt09YXwYal2D1OHM0fjSeMKvnBwLpPxeXUbYt/i9AYZghA==
X-Received: by 2002:a05:600c:1c07:: with SMTP id j7mr8970806wms.12.1638379992205;
        Wed, 01 Dec 2021 09:33:12 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf77c.dynamic.kabel-deutschland.de. [95.91.247.124])
        by smtp.gmail.com with ESMTPSA id r17sm1918291wmq.5.2021.12.01.09.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:33:11 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 6/6] conntrack: use libmnl for flushing conntrack table
Date:   Wed,  1 Dec 2021 18:32:53 +0100
Message-Id: <20211201173253.33432-7-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201173253.33432-1-mikhail.sennikovskii@ionos.com>
References: <20211201173253.33432-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use libmnl and libnetfilter_conntrack mnl helpers to flush the conntrack
table entries.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index de5c051..3498071 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2411,6 +2411,17 @@ nfct_mnl_print(struct nfct_mnl_socket *socket,
 		      cb, NULL);
 }
 
+static int
+nfct_mnl_flush(struct nfct_mnl_socket *socket,
+	      uint16_t subsys, uint16_t type, uint8_t family)
+{
+	return nfct_mnl_call(socket, subsys, type,
+		      NLM_F_REQUEST|NLM_F_ACK,
+		      NULL, family,
+		      NULL,
+		      NULL, NULL);
+}
+
 #define UNKNOWN_STATS_NUM 4
 
 static int nfct_stats_attr_cb(const struct nlattr *attr, void *data)
@@ -3496,11 +3507,15 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case CT_FLUSH:
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-		res = nfct_query(cth, NFCT_Q_FLUSH_FILTER, &cmd->family);
-		nfct_close(cth);
+		res = nfct_mnl_socket_open(&sock, 0);
+		if (res < 0)
+			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
+
+		res = nfct_mnl_flush(&sock,
+			    NFNL_SUBSYS_CTNETLINK,
+				IPCTNL_MSG_CT_DELETE,
+				cmd->family);
+		nfct_mnl_socket_close(&sock);
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"connection tracking table has been emptied.\n");
 		break;
-- 
2.25.1

