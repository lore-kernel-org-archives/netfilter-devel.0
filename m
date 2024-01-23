Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914125A0EB
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2024 10:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706004901; cv=none; b=Ebogj39FCBNCwpNfdYQAKJu8fdbVR4nqAU7iBHqcaoCHkdSl4piRr4UP3O5w0rIsYHWH1V63V8QcUkMO2rCzOMlYVjEijQ8r+QB1MmQJymUPLI23P1HsaFRVk+H71Okm6OnbdFj0y7N7dcsg2nN5ZEOQIZ0cigG12c9C19/+WEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706004901; c=relaxed/simple;
	bh=Y6cVHwtKnHOSRaGr+eG44yCqNM1oCPGOqxJkzNkyFaQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=n76iMqF99uQVcQpcDMQae+aZ/46WN6h0Ue+wPoJG7HjmNlYP2a0KBbBfl/GFwtIorgJ/39x1+YPLHeM+yj+S73uZl9eIlD+Ei8XFQGU7Li+d9Z1cvuB0vf4GSNi0TNT9LHvVv1vu5xEI082IISYhXec3SPYSFGpGeSVKvRKtsNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GMBnN9zu; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GMBnN9zu"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-559cef15db5so9125018a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2024 02:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706004898; x=1706609698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZIyGSjoCwV/lmxlx1diFGTi5YFN9hMj9G/dCJYzxNhM=;
        b=GMBnN9zuFK4lHVjdHPfDena48YOmos6LqZvAgVq97KnyKOeOfjRx6wapl+/3ZTW0VO
         HgMBAYoCyrQT3gGeCShfPW+XpLwcKhx57gT9t5vxZjCdYcgixaUSckneTEkPn2ME/IsB
         zYusTRYAy4wmFraD++ma3BRMZL7qs82ah7YFlXuZE11yUK/xZKyq9cU3DEToDQMSiqDR
         3sDSRW/hfHIclxhNjPR/zQE0u7Equ/cFvRUukJvy3rYNB5Wsj5/e4/5l8wEVi7r4iegV
         lTxiXYEmttDX7qoGZHBdNMkWdHDtR16Im6wBhQD47S44xIhbm4Xmrk9CQ9NYXor0WAWh
         H+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706004898; x=1706609698;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZIyGSjoCwV/lmxlx1diFGTi5YFN9hMj9G/dCJYzxNhM=;
        b=tKjW9n/uyJizUpyqi9CORE6VFo/X8K2ymAM0RRFfmE90bW3ty/auz11MmU2YBWfiF2
         UiYtEDc00KKOY5xqhtBrUAK4APL7IgcKSSIDx5P5wf5oWsYxGoiFSX8SyhFsre5isT6h
         ZVaIVJsEXILaASVHijNArf6AmMqj4f0rmC+ZKe2bWQ+JolkDf0UQ0RstI8ZitBCfjgd2
         XnGWXFEXm4jdmSYFKXNibULTq9gKVoNHApGYGRO37AMFkwcU3PtjOYsRah74DLsA+MaZ
         R+MsgNpJeLcoLVeJy2OU9Ds/gskrrG24TIplfiYK33fBZpVBOM71ZbOvY/H4csJhjptT
         YF7A==
X-Gm-Message-State: AOJu0Yxd4sVcnGJkdnFdLxzyg+qKc7wLoZw1366+gEqwtZPYwg0VAIAs
	SXIopxmCSOYgCDl6H1VMagoVLZ8HRDQF1a4u2Y/vST1ixYzjyGKcs64NtZX8Pfs=
X-Google-Smtp-Source: AGHT+IHz52MAfld20qF2o6G0/juUY/ZK5ztGFAKqWRRblKojf5GyzxHCs5LFy8qanPJ84fdOR0+lfg==
X-Received: by 2002:a17:906:ad8e:b0:a30:ccab:fe59 with SMTP id la14-20020a170906ad8e00b00a30ccabfe59mr641749ejb.7.1706004897464;
        Tue, 23 Jan 2024 02:14:57 -0800 (PST)
Received: from linux-ti96.home.skz-net.net ([80.68.235.246])
        by smtp.gmail.com with ESMTPSA id tg14-20020a1709078dce00b00a2cb117050fsm13259806ejc.126.2024.01.23.02.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 02:14:56 -0800 (PST)
From: Jacek Tomasiak <jacek.tomasiak@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Jacek Tomasiak <jacek.tomasiak@gmail.com>,
	Jacek Tomasiak <jtomasiak@arista.com>
Subject: [iptables PATCH] iptables: Add missing error codes
Date: Tue, 23 Jan 2024 11:14:27 +0100
Message-Id: <20240123101428.19535-1-jacek.tomasiak@gmail.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Without these, commands like `iptables -n -L CHAIN` sometimes print
"Incompatible with this kernel" instead of "No chain/target/match
by that name".

Signed-off-by: Jacek Tomasiak <jacek.tomasiak@gmail.com>
Signed-off-by: Jacek Tomasiak <jtomasiak@arista.com>
---
 iptables/nft.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index f5368578..c2cbc9d7 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2812,8 +2812,10 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 
 	if (chain) {
 		c = nft_chain_find(h, table, chain);
-		if (!c)
+		if (!c) {
+			errno = ENOENT;
 			return 0;
+		}
 
 		if (rulenum)
 			d.save_fmt = true;	/* skip header printing */
@@ -2920,8 +2922,10 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 
 	if (chain) {
 		c = nft_chain_find(h, table, chain);
-		if (!c)
+		if (!c) {
+			errno = ENOENT;
 			return 0;
+		}
 
 		if (!rulenum)
 			nft_rule_list_chain_save(c, &counters);
@@ -2953,8 +2957,10 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 	nft_fn = nft_rule_delete;
 
 	c = nft_chain_find(h, table, chain);
-	if (!c)
+	if (!c) {
+		errno = ENOENT;
 		return 0;
+	}
 
 	r = nft_rule_find(h, c, NULL, rulenum);
 	if (r == NULL) {
-- 
2.35.3

