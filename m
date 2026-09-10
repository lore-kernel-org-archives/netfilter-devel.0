Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDD340F721
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 08:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027429; cv=none; b=VHiH3ORgiuPC8Q0Nvnw4+eOdFcI4I6CozEzZEYExf/zSPCE/oYk4ijCrk9XvrEbUTMfg17OSnD+JoW6htIJ0Tjq5Wx63bBe+Nv2NgBTU/op62c3jZKEc8rgD6F4lW1TTMl5D0IbsIdrUDhPTQ1/Zajc0DRsNqwYwufadF4POfk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027429; c=relaxed/simple;
	bh=It3hGucDlDiimzY7cb7O9jAeM6W782d0j84+5HqyF5I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IHBCkFSAf8Qu2jcBsCmNEhmducUbxHoJsuxOamWJadoJsWlEPHf8KoSZRjOG4ydDnOk0t6iW8D47uXqL9+dVdtIhY13Q3ACQG7qhBHJYSr/ls5jryvDQGx3FrPWNMDh0uFfPaialYHZp+vBnFtMWoxP/4iyusyfGITJlOYm/Pv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dGmvS1vx; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dGmvS1vx"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d8f265cbe6so58503065ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 01:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789027414; x=1789632214; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i8zhbFIVLiK3IaZuONcJMvzZFWnMkWhoBnRei/mXFFQ=;
        b=dGmvS1vxQmfm28mdcgr2t/zq4MoCMBORveSLgeaT1V4o+aBUi/6aEaZJ6S7AJl9EWA
         P1vwF8oiWde7dqi6RUz8SNty52wD2NDpDTeWuyb25p9ZSovJxnmcLThGjCveLz1iQETv
         iZ9UwFkAg58UV0GzyMAPhYL9my0ojnvFQbNWwFGhhRUXBl/LBtS2jB2v59niM9QDOCgF
         YPLp76W4sL5CMx5QDyhdTJ70PeztfykU8FEYG2J7nu+sI2eZ8QqdwggVB3PIxyMyHEWQ
         ZVlWkxgIWyMOUKZtY3h/GntjVb0nBdAJPr+Flwwg+DR58Iv84Otk4iK4TFSvEChrbQgm
         ab8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027414; x=1789632214;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i8zhbFIVLiK3IaZuONcJMvzZFWnMkWhoBnRei/mXFFQ=;
        b=aMXvy50sH6mlIKgPA0gux9KTRQ8f70S6MZ2RD+K3Gk5NXJ96biIIPh7D3JO3AicBkk
         HKUQ/os1nryhcsL7cvYFmJ2TTLVrxHTAcJVTfbG/wOMvCIdIWwXHYibkeVIXYWl12myP
         JWCVWyMYlDecEqEOhRGA//HM4hKuIJo6bL8EYWLm6nVj6xhgLjPMw5BSkK0qA+03WO1o
         o4O7GLGuhErDpcD4b8KuFnKXx0VMx+STyRlhiTxnn8Un8E0iY17u7Gnm1xySM0qMUM1o
         zcNyx4hIp63Zs6kb6YrvcGf3PuLI7lfougPauN2jmtRLf3iOlt9yvgYqwzrevpcp0AbH
         CWYQ==
X-Gm-Message-State: AFuF++lsf3Hn0OLyByN+6GCVP1vUDEJBRJiS2tYuJT2uCqC+iwHiwGsb
	jQSOES5ju2KPLXPhigYLmuOYOVp86pcGtUlEz/1RfYkUsVE3Qalu3H88KPzaRLJEo4w=
X-Gm-Gg: AYBFou03S7pguQz/8eexnbl5DtsvHJW1839PaWEVviMBjxshTr5zIXOvkghikZOlqb5
	7UN/DQYWIWNNW4FqFrI3qPdlfjYFMQ43rK0anID5VGi4qYeQcL4ESPYDdF62MY7Ua69wBE842WI
	ntX7S4LwZbxAq6WasXja6CJLrxZSNvAHkht0s0cakRu3ex3HY3lRLsoMQRkT83UdgYpVrKts3Wn
	i2IWsrFXJVinZSHH05vLk+T2qkeIGIfiaa+tWukj/8SfOOX2PvuwOlm4Am06yCr185otOtr8FDH
	iodjfk4el2Nm6UKa0M6CLor5AS0kmRmdMF8NdiPnR6lwIGd/33zCP28HuL9XeL/Xx1DOGw4zFi6
	qdBdEE33ROBKhOi6ONCdodqwtK+O6NpUzPXlL5/anrgrDBZbFjZZWjNh/l29ES4+0o1H1yYXE9+
	TJmrwoO31HAjZb3ick8WDNIY4a4oYUBFoidNgrOV9MM7SKZFquizqUvh4ISbDg+0uZ2ydgi4DB5
	FWegc168IZk+Y0f0FY0sGsx99Z85ua2GLMboRfVSnBVH1wj
X-Received: by 2002:a17:902:b114:b0:2d9:1dee:43e3 with SMTP id d9443c01a7336-2db12757f17mr383673035ad.18.1789027413851;
        Thu, 10 Sep 2026 01:03:33 -0700 (PDT)
Received: from localhost.localdomain ([180.101.244.71])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db2db7f088sm69745075ad.35.2026.09.10.01.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:03:33 -0700 (PDT)
From: Aohan Mei <ljp1205831794@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	Aohan Mei <henrymei@tencent.com>,
	TencentOS Corvus AI <corvus@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH nf v2] netfilter: nf_tables: skip expired catchall elements on insert and delete
Date: Thu, 10 Sep 2026 16:03:19 +0800
Message-ID: <20260910080324.2663491-1-ljp1205831794@gmail.com>
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
candidate, using a single timestamp snapshot for the expiry checks.

Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
---
v2: drop the is_dead check, it does not belong to this dedup walk;
    use __nft_set_elem_expired() with a single timestamp snapshot;
    also skip expired catchall elements in the delete path.
v1: https://lore.kernel.org/netfilter-devel/REPLACE-WITH-V1-MESSAGE-ID

 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 765a92fa90d6..0f3449cca5d2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6991,11 +6991,13 @@ static int nft_setelem_catchall_insert(const struct net *net,
 {
 	struct nft_set_elem_catchall *catchall;
 	u8 genmask = nft_genmask_next(net);
+	u64 tstamp = get_jiffies_64();
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
+	u64 tstamp = get_jiffies_64();
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

