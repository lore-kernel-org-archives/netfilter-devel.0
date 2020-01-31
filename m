Return-Path: <SRS0=LRZR=3U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAADBC33CB7
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 20:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99A67217BA
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 20:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nphb9NXe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgAaUxP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 15:53:15 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38125 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbgAaUw5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 15:52:57 -0500
Received: by mail-pl1-f196.google.com with SMTP id t6so3212647plj.5;
        Fri, 31 Jan 2020 12:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OU7pCbPuM2E7mJI/H5ckjCXxPxlbQB9wqm/B7j0dW/4=;
        b=Nphb9NXeamgOuoKh37H38HpKV+y/WJaeOnUbwII6g8CamLlsV4tOtcuVGMV0eihm1W
         qIvxY24VpBIxz1xTb0BPmcS47tfTb+fa7T+C6LE1Gdnl58C7LxbHl9lxdhPuCGQh5HDX
         R7Y5Sm7nSz9tYz1/TvFMRNHcvIjqk9A+9/2jJ7rBovbWE/TyWLzkPKKSZQVpbtYGWciR
         5/r0VPSGtp3gf7pC79WFEF0SMRFP73GWn/LLpqDzg3GFZqjC87/Uj8l/ZGLRjWdRVdnV
         Rf94jDNOYqPFbolW91a12vc6bC+xEETTQqXAm1HSTl1ngmAiahN3qO7e00cUece3U2pP
         +mYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OU7pCbPuM2E7mJI/H5ckjCXxPxlbQB9wqm/B7j0dW/4=;
        b=CPH9CAjf3wNPGLMSseJNaNbz5MMSJ53pM69oNsslyQDf0p68CsZ5sslV3D9QzbL98g
         ufY4pSbjGys0q0V2utSAzEtAZ8+nPVaP8aWpjgfjiKBl71XD1+hP02D6sPkpqglXeTxC
         NeQ119f7OM2C9jG+cRJY/3EUH6Vy1TObCAwkGDLLkzXwEsMN/R1zBqIDT7+jhrQ/CVJv
         52O1we0OrwjvWY1ErsAvpHGBUopwnw0Ifbq2i9F3nKxMIWJ0SsL72Bx9xgTTRMO8nfjR
         SoKvo0vWeh5B+PKUfnWjjjzSl4FwlVBfaYitJtF/aa8C+dfGPJlnasY+sfPY/kKaLiQU
         PXvQ==
X-Gm-Message-State: APjAAAUJRZjngrPe3bqddU3Iw9PNcM+7IMT1YpaS1OzntdlyJToFQ6sW
        0+iZDhPS33o6GEp7Kiz/iwq/9OMV06I=
X-Google-Smtp-Source: APXvYqyXzlJSRWytiAEImeyGlflJaG5k/1+DneHvRmmRD2bjxg77FVFMTGc8s25B/qoJvPeqlGZCtw==
X-Received: by 2002:a17:90a:a48a:: with SMTP id z10mr7124931pjp.52.1580503976350;
        Fri, 31 Jan 2020 12:52:56 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id m128sm11599169pfm.183.2020.01.31.12.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 12:52:55 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [Patch nf 3/3] xt_hashlimit: limit the max size of hashtable
Date:   Fri, 31 Jan 2020 12:52:16 -0800
Message-Id: <20200131205216.22213-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
References: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The user-specified hashtable size is unbound, this could
easily lead to an OOM or a hung task as we hold the global
mutex while allocating and initializing the new hashtable.

The max value is derived from the max value when chosen by
the kernel.

Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netfilter/xt_hashlimit.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 57a2639bcc22..6327134c5886 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -272,6 +272,8 @@ dsthash_free(struct xt_hashlimit_htable *ht, struct dsthash_ent *ent)
 }
 static void htable_gc(struct work_struct *work);
 
+#define HASHLIMIT_MAX_SIZE 8192
+
 static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 			 const char *name, u_int8_t family,
 			 struct xt_hashlimit_htable **out_hinfo,
@@ -290,7 +292,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		size = (nr_pages << PAGE_SHIFT) / 16384 /
 		       sizeof(struct hlist_head);
 		if (nr_pages > 1024 * 1024 * 1024 / PAGE_SIZE)
-			size = 8192;
+			size = HASHLIMIT_MAX_SIZE;
 		if (size < 16)
 			size = 16;
 	}
@@ -848,6 +850,8 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
 
 	if (cfg->gc_interval == 0 || cfg->expire == 0)
 		return -EINVAL;
+	if (cfg->size > HASHLIMIT_MAX_SIZE)
+		return -ENOMEM;
 	if (par->family == NFPROTO_IPV4) {
 		if (cfg->srcmask > 32 || cfg->dstmask > 32)
 			return -EINVAL;
-- 
2.21.1

