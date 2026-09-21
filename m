Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338822F7F1F
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 02:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789956568; cv=none; b=H5Fm5zdhSzKJ+l93qKzDehtKu3kExWFJtOx03w2A30ui+h/Dj90iZi0ui4TEh+8umgLNiiN5HhR8qqh3vUq3IExq9uc/FPBhnwuBzM3e0/JngQgKvcrBzuFd1A+G4kWj6mF32t8GPVJTO4R5HNkXq8pV6SlQ8z2g/mseF+7mJ2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789956568; c=relaxed/simple;
	bh=8V5OMZOqPq5xk5Df+ymOuJosbuaBwier4A19CKE++mY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EA7cGyilkGwSN3Eqypwx1Z2iIMJlv3/OQ66/tqdwHnRGoItyeJpsHl7NkS0GKtpYfUQRmw5fGYcKd2zGHPnEURkGnZzpMD7lmcF0iT/8UhCAsScfQfILNmn5zpOJAPiUSP/ev4SvqIqazn4tJ2ZrcIf0ytI8vUsh0Xza5xUyvjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jfFzlAZ6; arc=none smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jfFzlAZ6"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-86212a185dcso2902758b3a.1
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2026 19:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789956566; x=1790561366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vZ5lGmm82bDuUdLpxrgGqCRfnXKZWSRYGdIAzjgevKA=;
        b=jfFzlAZ66CFoZhfFF4owR3Y0dgYVcbS9RPwd/3uszMOJYfiggS8vRvZsQt2rY8nmI+
         5VxA6Lia/TkBo4LA+dot/uV5vQpJ34C9eEiGsqBSBgsqZpg0XJKPDrt4EggYdBm1lTC/
         EoLYKtfwab8TxD4ysZMgP0pdZg8gEaJdF61p8T3fnnh2foLTIPU/t01v3mCLfvA017QV
         kusLk4k+17E/DtzySHU4ebiWCaoBA8yfEj7qusCkYSC+y6qUjf2PQkOznnpltXjbpK2Y
         WHDQ9LNqNEQRYZ0XwvjxdDjlFbce9qE7bgLxn1MhdzAe/hWrO4iFp+40vSfevpOxYT6v
         yUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789956566; x=1790561366;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vZ5lGmm82bDuUdLpxrgGqCRfnXKZWSRYGdIAzjgevKA=;
        b=UicMWWgN/JOULmjFhQ3i+wXht3rPtn19zRslBhkPCoXtjizVkppBv1J6WwHooANTTp
         xAsI7v2SWVK1ZZJ9KT3j2VFO0gYoVC2jszBP9aDt/JMHL0LZD1tKi2b/PSlOVIlwQj7J
         QBcxNTV+isZ3Wuo1WLJbONhzIanB8KrZ7rVC8kw2QlzR5+BqGFhQDQRUcLZ1pxTnSu4B
         ddU0stbae6QRaLi/3UCrcA8GbUaSFKfk+24q+ZW/wZ0myxrrhj5CnIFgJkokTDDgYfOs
         A0cvYOi98OgOuGZeTu9xhPHpV3Ams3JXnY8c3ecUqRD4Him9LBuIieCrgH0/1BA/Xgsy
         9v3A==
X-Forwarded-Encrypted: i=1; AKwUvByHaLfxmOYT4VEggx2f2jnVMyOLNr132cZjnVPucAr+3nyBiBL7jyddWBeekDPxYfv5P+vEXeeeYqYyU9gVZJU=@vger.kernel.org
X-Gm-Message-State: AFuF++kP/14Yo4nL8L9xujkFGO0P97mJTYVjvoPsM21FWpwcIZIUN5NN
	8H+Lqm4led7f09BVp8WI0hl/phWtM2m+KKYbpbD+1CwfUyrtZ355G/cX
X-Gm-Gg: AYBFou0eQdk8/6EtffbTjTRuaXLRvaP5bQjEwfaQklRKe1K0Mx1CL2yaOGpJvGzxOma
	HKnwU0X6+MQtOMKuvYCDWwDi4ld7nGxLJ7hyUl641S26Scs+H5Lsq2U3taZkawOkr9CEoS3Q9MQ
	ZI5MIdjUzA+z4Kv8UYw41ahZEpWTQa9ccDmhyshllShyYC33ccSPaEl1a6jZVSw4BWEUcuQhzPV
	AqK/Au1e7omFZv4RimfqRjFlyWysyOtxcixde8Oj7v+1kJl450Mnjwcbw8hkN4CsAY/4lnpEFI4
	nyTvOLHpYFhjRwA3UNSxEP5cPmuTphNkqSFlJgYBL3vUwry4ms9zG0ndhFllkaNk0KAv28ovqbP
	jXVPC3p3IMI15eI60u748xkfXuagfUXYzvurSbY5lG0k789mWYehiESEjV65BqocxgFWEgIiZCM
	RJmWaFY8cMadGKxA9X4xwy2Uy26CIyeCh1ACWGtruhT0rwK+m4uQcOFFk2G7p47aRCiXyCy/Nse
	n8PVe6NqEHEzrm+SCZBi7VPO+4G6TaR
X-Received: by 2002:a05:6a21:a02:b0:3d2:2afa:d77 with SMTP id adf61e73a8af0-3dd8c44a3camr15132958637.14.1789956566440;
        Sun, 20 Sep 2026 19:09:26 -0700 (PDT)
Received: from 192.168.50.3 ([198.176.50.208])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc72ae9bac5sm2648184a12.15.2026.09.20.19.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 19:09:25 -0700 (PDT)
From: bestswngs@gmail.com
To: pablo@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: phil@nwl.cc,
	xmei5@asu.edu,
	Weiming Shi <bestswngs@gmail.com>,
	co+ee5e50ef2670e5f4@bugs.sh
Subject: [PATCH nf] netfilter: nft_set_rbtree: skip transaction elements during GC
Date: Mon, 21 Sep 2026 10:08:22 +0800
Message-ID: <20260921020821.2587086-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Weiming Shi <bestswngs@gmail.com>

Since nft_set_commit_update() runs set commit callbacks before processing
NEWSETELEM transactions, nft_rbtree_gc_scan() can observe elements added by
the transaction being committed.

The scan records an interval end in rbe_end without checking the element's
transaction state. A later, unrelated expired start then moves both
elements to the expired list. The synchronous GC queue can free the new end
element before the transaction subsequently activates it, causing a
use-after-free.

Only consider elements that are fully active in both generations. This
keeps transaction-state elements out of the GC scan and preserves interval
pairing across skipped elements.

KASAN reports:

  BUG: KASAN: slab-use-after-free in nft_setelem_activate
  nft_setelem_activate net/netfilter/nf_tables_api.c:7047
  nf_tables_commit net/netfilter/nf_tables_api.c:11137

  Allocated by task 130:
  nft_set_elem_init net/netfilter/nf_tables_api.c:6794
  nft_add_set_elem net/netfilter/nf_tables_api.c:7523

  Freed by task 130:
  nft_trans_gc_trans_free net/netfilter/nf_tables_api.c:10506
  rcu_core kernel/rcu/tree.c:2919

Fixes: 1e3b9e1c77fe ("netfilter: nf_tables: call set ops .commit when building new ruleset blob")
Reported-by: <co+ee5e50ef2670e5f4@bugs.sh>
Assisted-by: LLM
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 net/netfilter/nft_set_rbtree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 9894832281c4b..12431b55752fb 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -900,6 +900,8 @@ static void nft_rbtree_gc_scan(struct nft_set *set)
 		next = rb_next(node);
 
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
+		if (!nft_set_elem_active(&rbe->ext, NFT_GENMASK_ANY))
+			continue;
 
 		/* elements are reversed in the rbtree for historical reasons,
 		 * from highest to lowest value, that is why end element is
-- 
2.55.0

