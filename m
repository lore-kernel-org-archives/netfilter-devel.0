Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC88C3F68F
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 04:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E71A207E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 04:32:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="helXDmET"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBCEbV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Feb 2020 23:31:21 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46322 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgBCEbU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Feb 2020 23:31:20 -0500
Received: by mail-pf1-f196.google.com with SMTP id k29so6850750pfp.13;
        Sun, 02 Feb 2020 20:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ikbOgVn/JuDRreUdkS0Lnc6cVOsPSurSCODuXTVbzbc=;
        b=helXDmETOcofgWyKbbtUW1Lt4zjyrjFHRTeAPBIqDi7IrMmVHSvE9Ge/mpfME1fD6+
         TGSjfiIqsD1OyqWpsfzIXWI7a/L2p+46i7a0vaVwIgIDCzDoiLH98O+n495J4qoqhj2c
         ZXJm66j68UBRyvLlId/DfjZpR0q4XfLgyZBCk1I903dT+6Js2RrcprOkO+3DEEjeqU3D
         wJXz32QCC6FWpNiFwNVib8TZJkBXT43fY4IIWEUb5lFGYeNdhiuQp87Ooznk3wTpFaIu
         ATueCHBY7/T/BfSANGZmqTzOrQMTZ2U+bMhdyGSF6vzbDGc7xwmGB3Fq/SCyLJNr4iSZ
         k0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ikbOgVn/JuDRreUdkS0Lnc6cVOsPSurSCODuXTVbzbc=;
        b=Fp0xAOt+oeDDVx3MGaEkLzgLUFJd846YMH65zaI0RjVaurxkUQsMjSt9dkdkMIYAVU
         hWYo9JxcPwNjQh3QAS6YGQOYlcxI+BAyZDN3cDDAjQwryzP6QntJSqJJU5Gh6YDLGuBs
         S3RNOsNz8SxdpwBVC5zbImQPmYl+pCP0keNtohdo52tlpbAwM19Ktl1ugSIdBGjTtDkb
         VHkepcTB8SZUFKr+tTtZCi8Tuzujde15YGimHh+i+7RrGb1brDVHiYlK5nakhGlurZ1i
         eYnRnjk01WWBBn9K8gOlwWe1kHxUrruP6x+HYd8HH3e/RSDomwY7O2T4mS3bTFW6EL1W
         lxsg==
X-Gm-Message-State: APjAAAXEQYQnmmSdel2GZAO7YBgp6SsWOQk/6bNmW1Eyp9y9wI0OFr+k
        6SmRoWT74irb3znyYQ9PAfeiqHmmJUw=
X-Google-Smtp-Source: APXvYqxETSYWxyEwECGO0UJgnGGRupnzJgqsALSw/VV2Mwqshbm/SMcOI1a44tcLsTIdslnSW915Lg==
X-Received: by 2002:aa7:9dde:: with SMTP id g30mr22724643pfq.91.1580704280117;
        Sun, 02 Feb 2020 20:31:20 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id z29sm17823374pgc.21.2020.02.02.20.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 20:31:19 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [Patch nf v2 2/3] xt_hashlimit: reduce hashlimit_mutex scope for htable_put()
Date:   Sun,  2 Feb 2020 20:30:52 -0800
Message-Id: <20200203043053.19192-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200203043053.19192-1-xiyou.wangcong@gmail.com>
References: <20200203043053.19192-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It is unnecessary to hold hashlimit_mutex for htable_destroy()
as it is already removed from the global hashtable and its
refcount is already zero.

Also, switch hinfo->use to refcount_t so that we don't have
to hold the mutex until it reaches zero in htable_put().

Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netfilter/xt_hashlimit.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 5d9943b37c42..06e59f9d9f62 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -36,6 +36,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/mutex.h>
 #include <linux/kernel.h>
+#include <linux/refcount.h>
 #include <uapi/linux/netfilter/xt_hashlimit.h>
 
 #define XT_HASHLIMIT_ALL (XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT | \
@@ -114,7 +115,7 @@ struct dsthash_ent {
 
 struct xt_hashlimit_htable {
 	struct hlist_node node;		/* global list of all htables */
-	int use;
+	refcount_t use;
 	u_int8_t family;
 	bool rnd_initialized;
 
@@ -315,7 +316,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 	for (i = 0; i < hinfo->cfg.size; i++)
 		INIT_HLIST_HEAD(&hinfo->hash[i]);
 
-	hinfo->use = 1;
+	refcount_set(&hinfo->use, 1);
 	hinfo->count = 0;
 	hinfo->family = family;
 	hinfo->rnd_initialized = false;
@@ -420,7 +421,7 @@ static struct xt_hashlimit_htable *htable_find_get(struct net *net,
 	hlist_for_each_entry(hinfo, &hashlimit_net->htables, node) {
 		if (!strcmp(name, hinfo->name) &&
 		    hinfo->family == family) {
-			hinfo->use++;
+			refcount_inc(&hinfo->use);
 			return hinfo;
 		}
 	}
@@ -429,12 +430,11 @@ static struct xt_hashlimit_htable *htable_find_get(struct net *net,
 
 static void htable_put(struct xt_hashlimit_htable *hinfo)
 {
-	mutex_lock(&hashlimit_mutex);
-	if (--hinfo->use == 0) {
+	if (refcount_dec_and_mutex_lock(&hinfo->use, &hashlimit_mutex)) {
 		hlist_del(&hinfo->node);
+		mutex_unlock(&hashlimit_mutex);
 		htable_destroy(hinfo);
 	}
-	mutex_unlock(&hashlimit_mutex);
 }
 
 /* The algorithm used is the Simple Token Bucket Filter (TBF)
-- 
2.21.1

