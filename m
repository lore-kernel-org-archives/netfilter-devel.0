Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCC4C64E7A
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 13:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4FE622268
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 13:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387936AbgLCNLX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 08:11:23 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:38142 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgLCNLW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 08:11:22 -0500
Received: by mail-wr1-f41.google.com with SMTP id p8so1819818wrx.5
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Dec 2020 05:11:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Vy2kPX0/riksESQVfpGqfozCdDYiIC1EqImCPNOLfUc=;
        b=f9F9dUCnpBiq3ExULyhhcuKeF8j3zEjnq5vqIbpkctm7cihpnnKzKAYefp7PVa+9Jq
         XTPlLH5+81SuJjz+qz3sYVYtYJlroRXWkPQAotq2uNNdaRqDxxzerg6NgpmJxt3MlBIF
         kGomBVre1pFl1c0qog2snLhUmQu9ID7x+HXDiHg1DQ2gOmevEQy8kFR0saR+T5peVoey
         pqMC3k6yHjQbMxuDjiAsPrXQVw641mIb0+epLLvbgcwGC9GMlZCH61KPU1Dok0pqjpt4
         7kWLzGiqvp+4ma1ZpzbDqrCNL9HWepQ3OM5Mpvevj1gkvRr5UL8ajdEld/XqeNfsSAVt
         PLbA==
X-Gm-Message-State: AOAM5300P+bIvDyB9/YeoO9yQi4NoO4iNbsXPS656Zi7ITRd+m4noTVo
        5rf7EQ5JRgJ64XIpmFAwAKFwsJR7PkJh0A==
X-Google-Smtp-Source: ABdhPJwBGkimWj2V8rpdLymrKkz1re22xPFDWDwL/2ummW5n9lslqmoEO7Gc5wrIrMferYOCqt/jmg==
X-Received: by 2002:adf:ed04:: with SMTP id a4mr3655068wro.172.1607001040267;
        Thu, 03 Dec 2020 05:10:40 -0800 (PST)
Received: from localhost ([213.194.141.17])
        by smtp.gmail.com with ESMTPSA id o15sm1718778wrp.74.2020.12.03.05.10.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 05:10:39 -0800 (PST)
Subject: [conntrack-tools PATCH 2/2] conntrackd: external_inject: report
 inject issues as warning
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Thu, 03 Dec 2020 14:10:38 +0100
Message-ID: <160700103873.39855.3747782410251714155.stgit@endurance>
In-Reply-To: <160700103220.39855.6588996986767666395.stgit@endurance>
References: <160700103220.39855.6588996986767666395.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In busy firewalls that run conntrackd in NOTRACK with both internal and external caches disabled,
external_inject can get lots of traffic. In case of issues injecting or updating conntrack entries
a log entry will be generated, the infamous inject-addX, inject-updX messages.

But there is nothing end users can do about this error message, is purely internal. This patch is
basically cosmetic, relaxing the message from ERROR to WARNING. The information reported is the
same, but the idea is to leave ERROR messages to issues that would *stop* or *prevent* conntrackd
from working at all.

Another nice thing to do in the future is to rate-limit this message, which is generated in the
data path and can easily fill log files. But ideally, the actual root cause would be fixed, and
there would be no WARNING message reported at all, meaning that all conntrack entries are smothly
synced between the firewalls in the cluster. We can work on that later.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 src/external_inject.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/external_inject.c b/src/external_inject.c
index 0ad3478..e4ef569 100644
--- a/src/external_inject.c
+++ b/src/external_inject.c
@@ -76,12 +76,12 @@ retry:
 				}
 			}
 			external_inject_stat.add_fail++;
-			dlog(LOG_ERR, "inject-add1: %s", strerror(errno));
+			dlog(LOG_WARNING, "inject-add1: %s", strerror(errno));
 			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
 			return;
 		}
 		external_inject_stat.add_fail++;
-		dlog(LOG_ERR, "inject-add2: %s", strerror(errno));
+		dlog(LOG_WARNING, "inject-add2: %s", strerror(errno));
 		dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
 	} else {
 		external_inject_stat.add_ok++;
@@ -102,7 +102,7 @@ static void external_inject_ct_upd(struct nf_conntrack *ct)
 	if (errno == ENOENT) {
 		if (nl_create_conntrack(inject, ct, 0) == -1) {
 			external_inject_stat.upd_fail++;
-			dlog(LOG_ERR, "inject-upd1: %s", strerror(errno));
+			dlog(LOG_WARNING, "inject-upd1: %s", strerror(errno));
 			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
 		} else {
 			external_inject_stat.upd_ok++;
@@ -117,7 +117,7 @@ static void external_inject_ct_upd(struct nf_conntrack *ct)
 	if (ret == 0 || (ret == -1 && errno == ENOENT)) {
 		if (nl_create_conntrack(inject, ct, 0) == -1) {
 			external_inject_stat.upd_fail++;
-			dlog(LOG_ERR, "inject-upd2: %s", strerror(errno));
+			dlog(LOG_WARNING, "inject-upd2: %s", strerror(errno));
 			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
 		} else {
 			external_inject_stat.upd_ok++;
@@ -125,7 +125,7 @@ static void external_inject_ct_upd(struct nf_conntrack *ct)
 		return;
 	}
 	external_inject_stat.upd_fail++;
-	dlog(LOG_ERR, "inject-upd3: %s", strerror(errno));
+	dlog(LOG_WARNING, "inject-upd3: %s", strerror(errno));
 	dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
 }
 
@@ -134,7 +134,7 @@ static void external_inject_ct_del(struct nf_conntrack *ct)
 	if (nl_destroy_conntrack(inject, ct) == -1) {
 		if (errno != ENOENT) {
 			external_inject_stat.del_fail++;
-			dlog(LOG_ERR, "inject-del: %s", strerror(errno));
+			dlog(LOG_WARNING, "inject-del: %s", strerror(errno));
 			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
 		}
 	} else {

