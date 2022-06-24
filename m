Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A0DCCA473
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jun 2022 15:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbiFXPBz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Jun 2022 11:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbiFXPBq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Jun 2022 11:01:46 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D67EFD29
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2022 08:01:46 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id pk21so5303353ejb.2
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2022 08:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jlYYxBBIQmaUxZGvuc6Lx4KQsR+TQ4FWSXiubrGZjP0=;
        b=El7/LJ+DYTnuPPldOuAUsyJiX7Gk4uLwOjqhm7EVXFEOv6C31//sSItC9g8MBA6BsI
         yog2iYksULmaf1fZWK0J4Mc1ruOQJMFwtTV1Mcqi+2r67Agvw2dXFz+3zPSQ14FOQ0fL
         A9IVREwrlwmdmsaWTZ5B29vj6i/YQXxw4WQe07/vejIdY2LGDcn9VM/JtD4gZfkOsB3R
         9Pl7ykFVfh1p1Vl1GDCeWZucmfKyaGc/EKYW75qHjm1IgFnDE3HuA9kht6lAopQ91JBo
         umyWIc64Im2ikNJ/xT62zz921wPQ5Y0MQlJ1cgChuFUOR/oxc15+mvXDctTF8GKuAYyN
         1FLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jlYYxBBIQmaUxZGvuc6Lx4KQsR+TQ4FWSXiubrGZjP0=;
        b=gFBESvKVae+yxIECzF/v88RXrtuitFLLv0kaxNO3cNrEzlzjENTBSbEDvyk1CBKjP4
         T6Y14kyErlFEEfZlsHKey0fTIZhW5TooOSe4pX20XizQ+z5l0wK7o2+iMorvgfQFpAFB
         kuv8tK7tJThIKGFXP7Gsfs6zBbAUTQanp/VHaihvtglm92s6iiEYerby/2BVwDLRWJD6
         EVDw+/VI/aM0JxDqXE/zspIrQ6Bec2aJXptJwcc/yKP32SByuszQkHYl9unlkVHWUhDF
         yn1l7q7ED8VojPsXsaew8dVudjioyzEio4+SwXACtFQyOJXEkbbY596XbMeenWpSyp82
         ohBA==
X-Gm-Message-State: AJIora+7pwqtPJMg4yPBMdcpx5fI0ztgN+OpQRrD4ZTP3AarID81q0LS
        gja8KV1tbvvybh3hNMWri3GBFjbAlO4GYw==
X-Google-Smtp-Source: AGRyM1tQSmrfc/QrbDcTbW2TvTUdEff1XdKMzyEl5rH9b81+UzDonOsQcZnYyrMGdCRIfJtNgllvsA==
X-Received: by 2002:a17:906:b048:b0:6fe:be4a:3ecf with SMTP id bj8-20020a170906b04800b006febe4a3ecfmr14137284ejb.104.1656082903914;
        Fri, 24 Jun 2022 08:01:43 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id r13-20020a170906a20d00b006fec9cf9237sm1246842ejy.130.2022.06.24.08.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 08:01:42 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 2/3] conntrack: fix protocol number parsing
Date:   Fri, 24 Jun 2022 17:01:25 +0200
Message-Id: <20220624150126.24916-3-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220624150126.24916-1-mikhail.sennikovskii@ionos.com>
References: <20220624150126.24916-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Before this commit it was possible to successfully create a ct entry
passing -p 256 and -p some_nonsense.
In both cases an entry with the protocol=0 would be created.

Do not allow invalid protocol values to -p option.
Include testcases covering the issue.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c                    | 19 +++++++++++++++++--
 tests/conntrack/testsuite/00create | 10 ++++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 500e736..e381543 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -882,6 +882,21 @@ static int ct_save_snprintf(char *buf, size_t len,
 
 extern struct ctproto_handler ct_proto_unknown;
 
+static int parse_proto_num(const char *str)
+{
+	char *endptr;
+	long val;
+
+	val = strtol(str, &endptr, 0);
+	if (val >= IPPROTO_MAX ||
+	    val < 0 ||
+	    endptr == str ||
+	    *endptr != '\0')
+		return -1;
+
+	return val;
+}
+
 static struct ctproto_handler *findproto(char *name, int *pnum)
 {
 	struct ctproto_handler *cur;
@@ -901,8 +916,8 @@ static struct ctproto_handler *findproto(char *name, int *pnum)
 		return &ct_proto_unknown;
 	}
 	/* using a protocol number? */
-	protonum = atoi(name);
-	if (protonum >= 0 && protonum <= IPPROTO_MAX) {
+	protonum = parse_proto_num(name);
+	if (protonum >= 0) {
 		/* try lookup by number, perhaps this protocol is supported */
 		list_for_each_entry(cur, &proto_list, head) {
 			if (cur->protonum == protonum) {
diff --git a/tests/conntrack/testsuite/00create b/tests/conntrack/testsuite/00create
index 9962e23..af22f18 100644
--- a/tests/conntrack/testsuite/00create
+++ b/tests/conntrack/testsuite/00create
@@ -61,3 +61,13 @@
 -D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
 # delete again
 -D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; BAD
+# Invalid protocol values
+# 256 should fail
+-I -t 10 -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p 256 ; BAD
+# take some invalid protocol name
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p foo ; BAD
+# take some other invalid protocol values
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p -10 ; BAD
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2000 ; BAD
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 20foo ; BAD
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p foo20 ; BAD
-- 
2.25.1

