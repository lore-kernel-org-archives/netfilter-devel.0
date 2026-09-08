Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82D653CA6B
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2026 12:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870785; cv=none; b=RUReoZ9VVQO5qME/Ljc41AwIpOxPssUdoy/tWJnD6tWcvg+YUQNaiiw0F71BeM/OK1icH+0P7j+r+GrQwYFoOO589SRcNFyQWPzWghnxeMqR6TuC7NWABT4Jrwv7jIoSl9mL1K5ec28OeQilNtLD++KQtI6ovQfpIYn5xjk7QyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870785; c=relaxed/simple;
	bh=zGQ45INhV+e8yZFj84FGEy4sP5CCpL1qdRdz893lRTg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f3COowbLm/B0NdBM170wxnDZCZ6UK6Tak58BZL5zCggv4RkoOEe5tiys90OKKJSVOu3TO/B1ZM6+Pq6k5ELI71h1FYVW38nFpDWQ7OjGJ6qlnB4b2W7D5zx7H59EtA0zFuebu4iDR6QrtONgbDzGMiZpugtNEEV3THEEYW3KfTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+4p7DyG; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+4p7DyG"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cbee846deecso5300766a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Sep 2026 05:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788870782; x=1789475582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zq7zuTRm/ZBDJwfmL2/GYPh9/WXjQmK9pRLqW0xElQA=;
        b=a+4p7DyGQo+1sHa9RpgIAvM+j7GiMPQB+QfQAvrC/Gus1PCKOWPV7eN2AP6J3mcAoR
         0mH8kn27SB43+cMrdf9RF3NJNPE4I+GmH24VYyq/jlearkfPGDXp/2WUteyM3dNJR+I6
         YHmsx6fqmXGa+o3tC/6kSCgyBgK+zt5q0GFIYOEMNEXJPsmBbUOuyTbw4c3TKfoPag9f
         XybMyfBu9KKYMoM1LmG/chGrL48tjuU3TxysQg2KTv3SmxJqQPKlOlTjjdZXO8AXpEIv
         Ilii6JCPq6cBTxKodquai7FMsnmUUGXyy8gQ1yA4AtwB1UdVj0dIrRX1Jvuj9sChZcEQ
         LY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788870782; x=1789475582;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zq7zuTRm/ZBDJwfmL2/GYPh9/WXjQmK9pRLqW0xElQA=;
        b=Oubkhul/4Ud1lbCII2qHMkPappQeAyPTZDtj02EFP84KmBYSJAwc2zi6o7S6zW+hUr
         WA0bo7CTEt+6FwIIq4bohB2qN677gfxtary/XfD+bH1p9+r4qBuXGQOF5Nkw8kKQFy+s
         Vx8rGXqAPfM231SyBUy+kiynOWN0dX+aHmB+TWgYQpaQZshXIXYmzjxIiUN2sSi09dog
         OCkZULwoKdbU/SVgoGBDPQLdKwRb4aV0w7aMeWqoK+RGYVdOx/GAXbQ7uDRHmxC4Glkm
         rNWzHTnzmNTExYTcofh4NCwUKe+c8zgMS+FNXpVnp+R/ekry3xC7aCdTaLdZl1j1TBn6
         1r4Q==
X-Gm-Message-State: AFuF++mpJxNkS9MG5wOvzFZX/+9yf7sX+ESeEJnzMJa6TlHI7Zfe51Fq
	f62xieyzw4UZI/FzYQYlutBY0wFkIqRKdwWhUhruMgsqzta/XfjPczc+ezKMq1JsQCc=
X-Gm-Gg: AYBFou3Tiy12plqIaxXYS10nQQjdDPUXVwKnDRJFWlC9RP0EmsxBfGp7mYea/DBAQTg
	20SlC7u2UBrNogcmy3Rdr6LwHzhe3fXz7whQhBM+d0H4ZD4mMEKueik32zcpu0z+NLGVPFCXzUn
	Y6LTwK4Zs8UAdYXkXu6+VjVi5VArBrhnyif1EaNvhDmMZh+gnIWZUJrORAbLsbhubfgfj+BhcU1
	CsmSAlKJfVYzv7lwQXXAGY+ZRTpSYW34k/3eQAB3t6SD24lD5/ojTaABmSeFp3Z/pSBoZVNrDut
	octy8cmAjghP2/4RHjsgyYI50FOeAf2Uq+C9lpxd2dXM/890qaSUb0m8lT2POqJP/gpRDwIjUSN
	SUUVMGOSUvU+cHsq8DMrhiVb9/989C3Uaq4SwvT45a9siFQv2QOrbXEptjIHHLjAvhusC8Y4e3F
	NO5GzN4VwS8c9AA5wHsWdlrlgbCG6txH/SuJhq1G3Ee28nVovwIMloELcSMwzqnLzwKyN5/Eiau
	uFw7I+bcYiJaQKzZNCrPf/V6QY=
X-Received: by 2002:a17:90a:64f:b0:39b:370e:c807 with SMTP id 98e67ed59e1d1-39b370eca6fmr24154970a91.17.1788870781754;
        Tue, 08 Sep 2026 05:33:01 -0700 (PDT)
Received: from localhost.localdomain ([180.101.244.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae8ccc72fsm12511958a91.2.2026.09.08.05.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 05:33:01 -0700 (PDT)
From: Aohan Mei <ljp1205831794@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	Aohan Mei <henrymei@tencent.com>,
	TencentOS Corvus AI <corvus@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: skip expired catchall elements in dedup walk
Date: Tue,  8 Sep 2026 20:32:47 +0800
Message-ID: <20260908123252.1162896-1-ljp1205831794@gmail.com>
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
dump path additionally skip expired and dead elements.

Once a catchall element with a timeout expires, this predicate drift
makes it invisible to userspace dumps, yet it still blocks
re-insertion: with NLM_F_EXCL the request fails with -EEXIST, and
without it the request reports success but silently inserts nothing.
The stale entry only goes away when the (user-tunable) gc interval
elapses, so the catchall rule may silently stop matching for an
arbitrarily long time after its first expiration.

Align the dedup walk with the lookup and dump predicates: only an
element that is active, not expired and not dead counts as a
duplicate.

Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 765a92fa90d6..6458ee26dcd9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6995,7 +6995,9 @@ static int nft_setelem_catchall_insert(const struct net *net,
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (nft_set_elem_active(ext, genmask)) {
+		if (nft_set_elem_active(ext, genmask) &&
+		    !nft_set_elem_expired(ext) &&
+		    !nft_set_elem_is_dead(ext)) {
 			*priv = catchall->elem;
 			return -EEXIST;
 		}
-- 
2.43.7

