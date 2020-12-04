Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0994EC4361A
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Dec 2020 10:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8733229CA
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Dec 2020 10:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbgLDKvJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Dec 2020 05:51:09 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:34379 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbgLDKvJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Dec 2020 05:51:09 -0500
Received: by mail-wr1-f45.google.com with SMTP id k14so4879811wrn.1
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Dec 2020 02:50:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Y+sfo7GMvEGdtheAuunQe9Q6Sq6c/VnhOD3VZyEmWkI=;
        b=ncsGx7cmupEZO7oZZ+kcQaxtLZ3taln2GFuRlcZf1kKC4OCXjfbn0SLRVvXWjTZD53
         rD91MWuUaBEZi28PedQkBGbeTkIb97QW/XfKNfObZEd9P9ggJ5d+7oSdCo3JzJpdf9bJ
         aNPL9ME+yElwR+vl/7ExpszGLLSVOyZAAdb5O61FSsHV3FAR/2s33IaVoiWc+3hjmKZT
         WeqWA778banE2wYizdTG/qycySVd899pR+2YsrJ4JV7+pMwBWz2pHSbGlkNqM+NaRadB
         EElbn7ywtBM0g/tMfuymldD2/SiVQkck23dDqjDkT+A9VIUw7II7xKB38TJ56RHYfRwk
         omxQ==
X-Gm-Message-State: AOAM531u/q374ff8ZE060AraCOckQjn6dMa7jdLkRKBxL96ZuQOIYZNJ
        THBnFw8OmDXIPMG7jXW/NWuQaK0R4Ev+NQ==
X-Google-Smtp-Source: ABdhPJycVfGc4ae8svZElOrZYjLELa2USG5RQLZv2VBTUyaxE38iHvhnOQt5BdDRT5HVg63c46DwOw==
X-Received: by 2002:a5d:654c:: with SMTP id z12mr4281189wrv.46.1607079026600;
        Fri, 04 Dec 2020 02:50:26 -0800 (PST)
Received: from localhost (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id c4sm2772557wmf.19.2020.12.04.02.50.25
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 02:50:26 -0800 (PST)
Subject: [conntrack-tools PATCH v2 2/2] conntrackd: external_inject: report
 inject issues as warning
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Fri, 04 Dec 2020 11:50:25 +0100
Message-ID: <160707895903.12188.7283813676910230247.stgit@endurance>
In-Reply-To: <160707894303.12188.18393188272117372516.stgit@endurance>
References: <160707894303.12188.18393188272117372516.stgit@endurance>
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

But there is nothing end users can do about this error message, which is purely internal. This
patch is basically cosmetic, relaxing the message from ERROR to WARNING. The information reported
is also extended a bit. The idea is to leave ERROR messages to issues that would *stop* or
*prevent* conntrackd from working at all.

Another nice thing to do in the future is to rate-limit this message, which is generated in the
data path and can easily fill log files. But ideally, the actual root cause would be fixed, and
there would be no WARNING message reported at all, meaning that all conntrack entries are smoothly
synced between the firewalls in the cluster. We can work on that later.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
v2: fix commit message. Add the same pattern for expectation functions. Add more informative error
messages in general.

 src/external_inject.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/src/external_inject.c b/src/external_inject.c
index 0ad3478..920d7c4 100644
--- a/src/external_inject.c
+++ b/src/external_inject.c
@@ -76,12 +76,14 @@ retry:
 				}
 			}
 			external_inject_stat.add_fail++;
-			dlog(LOG_ERR, "inject-add1: %s", strerror(errno));
+			dlog(LOG_WARNING,
+			     "could not add new ct entry, even when deleting it first: %s",
+			     strerror(errno));
 			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
 			return;
 		}
 		external_inject_stat.add_fail++;
-		dlog(LOG_ERR, "inject-add2: %s", strerror(errno));
+		dlog(LOG_WARNING, "could not add new ct entry: %s", strerror(errno));
 		dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
 	} else {
 		external_inject_stat.add_ok++;
@@ -102,7 +104,9 @@ static void external_inject_ct_upd(struct nf_conntrack *ct)
 	if (errno == ENOENT) {
 		if (nl_create_conntrack(inject, ct, 0) == -1) {
 			external_inject_stat.upd_fail++;
-			dlog(LOG_ERR, "inject-upd1: %s", strerror(errno));
+			dlog(LOG_WARNING,
+			     "could not update ct entry, even if creating it instead: %s",
+			     strerror(errno));
 			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
 		} else {
 			external_inject_stat.upd_ok++;
@@ -117,7 +121,9 @@ static void external_inject_ct_upd(struct nf_conntrack *ct)
 	if (ret == 0 || (ret == -1 && errno == ENOENT)) {
 		if (nl_create_conntrack(inject, ct, 0) == -1) {
 			external_inject_stat.upd_fail++;
-			dlog(LOG_ERR, "inject-upd2: %s", strerror(errno));
+			dlog(LOG_WARNING,
+			     "could not update ct entry, even when deleting it first: %s",
+			     strerror(errno));
 			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
 		} else {
 			external_inject_stat.upd_ok++;
@@ -125,7 +131,7 @@ static void external_inject_ct_upd(struct nf_conntrack *ct)
 		return;
 	}
 	external_inject_stat.upd_fail++;
-	dlog(LOG_ERR, "inject-upd3: %s", strerror(errno));
+	dlog(LOG_WARNING, "could not update ct entry: %s", strerror(errno));
 	dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
 }
 
@@ -134,7 +140,7 @@ static void external_inject_ct_del(struct nf_conntrack *ct)
 	if (nl_destroy_conntrack(inject, ct) == -1) {
 		if (errno != ENOENT) {
 			external_inject_stat.del_fail++;
-			dlog(LOG_ERR, "inject-del: %s", strerror(errno));
+			dlog(LOG_WARNING, "could not destroy ct entry: %s", strerror(errno));
 			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
 		}
 	} else {
@@ -200,12 +206,15 @@ retry:
 				}
 			}
 			exp_external_inject_stat.add_fail++;
-			dlog(LOG_ERR, "inject-add1: %s", strerror(errno));
+			dlog(LOG_WARNING,
+			     "could not add new exp entry, even when deleting it first: %s",
+			     strerror(errno));
 			dlog_exp(STATE(log), exp, NFCT_O_PLAIN);
 			return;
 		}
 		exp_external_inject_stat.add_fail++;
-		dlog(LOG_ERR, "inject-add2: %s", strerror(errno));
+		dlog(LOG_WARNING,
+		     "could not add new exp entry: %s", strerror(errno));
 		dlog_exp(STATE(log), exp, NFCT_O_PLAIN);
 	} else {
 		exp_external_inject_stat.add_ok++;
@@ -217,7 +226,8 @@ static void external_inject_exp_del(struct nf_expect *exp)
 	if (nl_destroy_expect(inject, exp) == -1) {
 		if (errno != ENOENT) {
 			exp_external_inject_stat.del_fail++;
-			dlog(LOG_ERR, "inject-del: %s", strerror(errno));
+			dlog(LOG_WARNING,
+                             "could not delete exp entry: %s", strerror(errno));
 			dlog_exp(STATE(log), exp, NFCT_O_PLAIN);
 		}
 	} else {

