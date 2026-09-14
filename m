Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7062443C37
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 11:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386721; cv=none; b=jOEm2YBqsvMfH+9G+DanLoMP+0//GxVs02VkABfRQwPOcSTDTgR88dbL2z6StsP9voZpknQY9RiQROVyskvZbv06uYo6AyrUrnDlaXVZjpa54Lk7WaLoSscU48sdIOnIwR3VvVGvSf3Xn+veil26YPGnNuZxDdyVshCw5pwIDxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386721; c=relaxed/simple;
	bh=mkOn9nUqrfUVleranEM9ERRJUce7DlZpXPdGbyI6jW0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EgZcnwkptM+dFBtdc8wf7dykw+jNr1z4c8ctgaZgNL7POrjO3W87z2g0vW/NtlLd9Sn+PWOJO4wH/vxEAYqpZQOsTZBLtU9fVV7/iz39TJ7tzfvfOfNDG8aE422hpOeAVItq0k1YSe90Rrp6yoQFQuGuQtNTimkluWKJGuuLrWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rVLnIwBl; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rVLnIwBl"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so3082866a91.2
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 04:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789386719; x=1789991519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tjo/LDgf0JT3PbDxyOorKF5SRzRGH019Y7Xsb5x2tuo=;
        b=rVLnIwBlPoo6rmcbNNO1UradaC8lv2KMOR9etcvBrw+5bIpcK7GRi0LGQEQEMK9lPF
         ADnuTnIBp0MKw7iZbcscsdDqrbz0WhOXEpRM1CqBLehKWYSTpqZLTMy2rJ7KbT2HHt0b
         XXUEFKBcBnE612S6MoCOiaLj4+ZCH8L0mkkhMr4dajOAtxfo9541v1DXtbFL9ht2Wy++
         tpKkhA7m6QcRXSwNjNWqAKRSVbXiSKRkhHWpGdbGCYUJZ98feC4u8Oqdrn0Q6johK6l/
         NJCd7QCNRMAru4bIUH2rp/sLhH2TkD76jdBUa8TnGEIkQOgebzdk6UQjqz77h/oibMtU
         W6mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789386719; x=1789991519;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tjo/LDgf0JT3PbDxyOorKF5SRzRGH019Y7Xsb5x2tuo=;
        b=ogmdWp6EGbvh+CQBl3K1IIt5MjW3zo0YLtKWcK/Wv160+wK6yblzvQl7RiBhbU/pyE
         RG6m458hJ2UyFVLC0F48IRQC8eEai4M8slsVewhdgBat6h3xLCVaWF1M6KIi6npspOL2
         4e71IXKrBbsZ8o43tgyHpJRyNEd4g7T7WrbRQNKdVZQBCLd8DZioaQtEiP7vu0kAfqO8
         D0Z6xtajzr0vF3Q5aFzIqHbC/2cFDQD638eSf369P0tqMMhyEqFlHUgjAN+sYFCUdIuM
         Er9+jszy/4CRue4I2AidKqzl+3LNuULJBtpmJTqe/rSUgkHE2E3Rskxi4keBcJmAsODe
         oVwQ==
X-Gm-Message-State: AFuF++kNoZrw4x41/p7kjt2OqtNDQk7zVKrYuR+6ojm8xOVHmhota75G
	tktjBLAq1mkeek80AQ5DxTm29LbGX0Mm5Q23JMXYsYKd1ANCEP+51XOOgvmcoA==
X-Gm-Gg: AYBFou2p7+tAwE6QM7o8SoORk6VSuE04fVXjdaM64zFhdlj0WB22n7WSQ/hFmK/5wpv
	g4BobGOAIhsjogJDCef+VMU+JjNOM3A3AafgBORH6n+7gExcSFZC690QYjVVu5fvkabcEiy6p9u
	7nwi/JZoiuOC5QS/lX3/usgLXJFNBaxAyd69kH1AgAguHwWmCUKz+/PekKVnY7jOswXunQsRNNw
	f+tlwsz8KMiP2LamYT9M21TAUBaMer/9YvM7YlDsZ8yMTOJdKADHc3bKAdXCKHjlMIUYiZJMii0
	DcxfwQOtulJGq/dn8CQrO07HR3e+WiGupU37mIloG4p3tp1Fhm6O8sl5LTQTSVNiSOtoUwVBQiD
	Z0uLes+72+7HQSMScUwUQonQBWTVD7BQr9UUXB+kOgWlK81ZPeEQJbWvSZUGFLI4fBi2JVF50cZ
	4q9UYg8u5oRroTCL4FoNh2fB4jz3DazN0145cMyYojSOI5gWQ2lnzRU62Zae5P8qTfGisXl2nEj
	hHuz3VZZbbBtBBqbBgKDoQDg7h4PrBjVL85379xzYKZuX8=
X-Received: by 2002:a17:90b:2dd0:b0:39a:e983:d4bd with SMTP id 98e67ed59e1d1-39dec15c01cmr4922034a91.24.1789386718894;
        Mon, 14 Sep 2026 04:51:58 -0700 (PDT)
Received: from localhost.localdomain ([117.88.121.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d9d7ff2c5sm5076020a91.2.2026.09.14.04.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 04:51:58 -0700 (PDT)
From: Aohan Mei <ljp1205831794@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	Aohan Mei <henrymei@tencent.com>,
	TencentOS Corvus AI <corvus@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH nf v3] netfilter: nf_tables: skip expired catchall elements on insert and delete
Date: Mon, 14 Sep 2026 19:51:47 +0800
Message-ID: <20260914115150.3470734-1-ljp1205831794@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aohan Mei <henrymei@tencent.com>

nft_setelem_catchall_insert() looks up duplicates with
nft_set_elem_active() only, while nft_set_catchall_lookup() and the
dump path additionally skip expired elements.

Once a catchall element with a timeout expires, this predicate drift
makes it invisible to userspace dumps, yet it still blocks
re-insertion: with NLM_F_EXCL the request fails with -EEXIST, and
without it the request reports success but silently inserts nothing.
The stale entry only goes away when the (user-tunable) gc interval
elapses, so the catchall rule may silently stop matching for an
arbitrarily long time after its first expiration.

The delete path shows the same drift: nft_setelem_catchall_deactivate()
picks the first active-next entry in the catchall list, so with an
expired entry still pending GC it retires the stale entry instead of
the fresh one, and it deactivates an element that userspace no longer
sees instead of failing with -ENOENT.

Align both walks with the lookup and dump predicates: only an element
that is active and not expired counts as a duplicate or delete
candidate, using the per-netns timestamp taken at transaction start,
in line with the set backend .insert/.deactivate and catchall GC sync
paths.

Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
---
v3: use the per-netns transaction timestamp via nft_net_tstamp() instead
    of sampling current time, per Pablo's review: control plane insert
    and deactivate paths must not let an element expire mid-transaction.
v2: drop the is_dead check, it does not belong to this dedup walk;
    also skip expired catchall elements in the delete path.
v1: https://lore.kernel.org/netfilter-devel/REPLACE-WITH-V1-MESSAGE-ID

 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 765a92fa90d62..7ef2e19e6655a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6991,11 +6991,13 @@ static int nft_setelem_catchall_insert(const struct net *net,
 {
 	struct nft_set_elem_catchall *catchall;
 	u8 genmask = nft_genmask_next(net);
+	u64 tstamp = nft_net_tstamp(net);
 	struct nft_set_ext *ext;
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (nft_set_elem_active(ext, genmask)) {
+		if (nft_set_elem_active(ext, genmask) &&
+		    !__nft_set_elem_expired(ext, tstamp)) {
 			*priv = catchall->elem;
 			return -EEXIST;
 		}
@@ -7088,11 +7090,13 @@ static int nft_setelem_catchall_deactivate(const struct net *net,
 					   struct nft_set_elem *elem)
 {
 	struct nft_set_elem_catchall *catchall;
+	u64 tstamp = nft_net_tstamp(net);
 	struct nft_set_ext *ext;
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (!nft_is_active_next(net, ext))
+		if (!nft_is_active_next(net, ext) ||
+		    __nft_set_elem_expired(ext, tstamp))
 			continue;
 
 		kfree(elem->priv);
-- 
2.43.7

