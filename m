Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0A62F39B8
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 04:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788151088; cv=none; b=j/GV+n8jbDj2ReQlE7qxSxy31uG0yAjEActhUq1YuVjdT1v4tFPgC5jh1bF+txxh6wHXffcbaCMtEvZzKr8k+X/tyR3YHEWpTi0Q631xNgAOc97CYjJ9CZBvWFsBk3g8ZrxhjjPfB+epV3JTyneVgnAgIOUEX0tJMx+gb9X0NwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788151088; c=relaxed/simple;
	bh=TSPukoHwuGOtlLSCKsfDe7vaSQqehsHcKRp+PP2zfx8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HEyKlCnQvrcljfUq0WtZQRvEi7ukKS+yPk90i0zDGVeYLBXoRMzrEu1QYQQ3cEPZUS/jKxwhcz0Gtw234+oxg/hpKDAGxfPo+Zrc/yDR6mAm3+lKbzEsnyeDtzEQ2XtYrjrxw3OmRrhGZUvJEMACW+6MShzyFro14n58KDWBUAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Aq9BLN8k; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Aq9BLN8k"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-495590dde14so28264365e9.0
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Aug 2026 21:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788151084; x=1788755884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TGoBedQqRgsKG7wNi45We7BTQ5QQ5aS5jrqdXZyohA0=;
        b=Aq9BLN8k6bsE4sId3E2D0ABNkFXHZiC3HNXKofNT33evMqYLykTK9GFxD2WCWiI2PB
         MHnFmKFT0nIEvxN0kRpImutCmbe8kT9D8wz9uhCUlcwpan0jhcV2LZ7MlbTcB65FLtRt
         vTDA50OwF8Fr7kVXBFAq3Tj8ivdRTENez2zX2YmCF61vg8gwKj23S8Iquvz8PwFZNu77
         A6HoJ/53Krzhi1E9rZVBuDk4IynVtTdWpJaDn8QtB3ymLxzfFZ3dzfkOBx5nnjnEzURk
         Pgkg0MsLA/Cijt1vCz8cvNFdYBf/xSSw76/flw02sS8zEFvlDNC0WCBxgnuHJmhSUxnz
         zQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788151084; x=1788755884;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TGoBedQqRgsKG7wNi45We7BTQ5QQ5aS5jrqdXZyohA0=;
        b=aq4KtNxVS9o9siqvdTbyJxH1FgGxc6EapOjyL2E9BqNUusnPbMZ7tkkR5wQYdDphu7
         mJhi8ZcsjKKUn8lWD8XUddhSg4jFWdHmp3Fob8cfvvoqU5AvMtR+p1P9O2HBxNzghqpS
         ViwQ2CK5sIvUAdmbOXv38J+V63w6v+0S8I+YV2sAmDghA0G4T5CLM5KH3zpvguHnF5KK
         xDDHPPw/tEs+AYSFABG84PmvcnBfte0ISGs8+I9ufuI/DSoJMZSv+3jCZoTzDTb3Vkxq
         YtDIGY0iwGJbmSe0er5xDtxlkWtM/GwfcAImk6+6G7uHZlyeIG43Gz9vhOCyPYsbpC8v
         /thg==
X-Forwarded-Encrypted: i=1; AHgh+Rp+QSzF8obtInqtRNJmicaPBMN2Dp802xXKbuBv5HitUBkjfejwS5+KAL1Lot0djAIXAaLMQFCM8ZUGD45etFg=@vger.kernel.org
X-Gm-Message-State: AFuF++nPxAjiemSMdAkx5JqGU1O0fCyFRVgg+t2y6e8vxd0OZ9py3vka
	873z0pBmmEzghHwWY9dLZ7mVCXcMdQnKNToALV3/3597+iAPEG1NA/nz
X-Gm-Gg: AR+sD12BAqHQUbRaX7lE48PsqJNNEbN0Ok/IIprp2XvqZStkIcYht75OaQ/abDC7FDB
	k9To0dzYpt8DBPSEg6yEYPx+m4q+nbrGoU2YPmk2zO1GjSi10i51jtf72afFwYcyjcfDlq8LRus
	qWO2Rub6kmSj81Msd5KM4ZvNNdQPEKgLXxqxPuszv487hqvGTfkzBNsktMaEAk9rj0OEl6scA7v
	MEgMJIS8Y6BsDIYFdQN0tXbpFWL0uS4pskXMz1fe39PnPrN0avaI7o1wktytSKVUwYx4K+NylmZ
	doHQODH0c3Da8C97S9SqI6H/dyXt5leTZa1qI2QTkAzjbD1SToYHxW6JX1EA60GBtTs80OPOmyT
	GKJduHCp9BqkNX+5UZxOI8MtejbTHpiCLVtCDUrTGQHYm2Y7dJAwyyER/6JtX7JWZyh1bUNnq44
	Tc0dJbKlQ+80lVxCooiBztZ4ie9RbN6DRiizA6sp6q4u0nLAR6eFuH3h4kJZNdzYwAcZlv9NGnG
	Yeq6iirCnmxQgrGQfW1sqFPdKXTEQQln64cIfuNVckbNootAtm6p/3Bd7jSs6zHzHdPMgaeqydh
	oLtXRA+SN1Sa1OcPcvnG/3TaUXHP9a5uODdf/VMpq+YxNtHOwcX5fRlqtZBZYWLS3Q==
X-Received: by 2002:a05:600c:1c29:b0:499:b65d:1250 with SMTP id 5b1f17b1804b1-49cd940c70emr9007825e9.2.1788151083769;
        Sun, 30 Aug 2026 21:38:03 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-acb9-0201-68d0-34d2-ad1a-175a.310.pool.telefonica.de. [2a02:3100:acb9:201:68d0:34d2:ad1a:175a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cd775dae8sm79057735e9.9.2026.08.30.21.38.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 30 Aug 2026 21:38:02 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bin Lan <lanbincn@139.com>,
	XiaoHua Wang <561399680@139.com>,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: [PATCH 6.1.y 6.6.y] netfilter: nft_set_pipapo: account mapping table allocation
Date: Mon, 31 Aug 2026 06:37:55 +0200
Message-Id: <20260831043755.29692-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[ Upstream commit 69e687cea79fc99a17dfb0116c8644b9391b915e ]

The pipapo set backend data structure is one of the ruleset objects
that upstream changed to use GFP_KERNEL_ACCOUNT for memory accounting.

The 6.1.y and 6.6.y adaptations changed the other pipapo allocations,
but omitted the mapping table allocation in pipapo_realloc_mt() because
that helper does not exist in these branches.  The equivalent allocation
is in pipapo_resize() and still uses GFP_KERNEL, so the persistent mapping
table is not charged to the allocating memory cgroup.

Update this allocation to use GFP_KERNEL_ACCOUNT.

Fixes: a0bb39980635 ("netfilter: nf_tables: missing objects with no memcg accounting")
Fixes: 1c4f72fa9699 ("netfilter: nf_tables: missing objects with no memcg accounting")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
This patch is based on 6.6.155 and applies unchanged to the tested 6.1.y
tip.  The test configurations and full serial logs are retained in the
audit dossier.

A/B tests with a 32,768-element two-field concatenation set left two
262,144-byte mapping tables.  The fixed kernels charged approximately
512 KiB more kernel memory to the child cgroup:
  6.1.186: +524,288 bytes
  6.6.155: +516,096 bytes

The two-page difference on 6.6.y is within memory.stat measurement
variation.  Ruleset loading and element lookup succeeded before and after
the change on both branches.

Tested on:
  6.1.y d64a499eea6b62b5121beceed9e8a1f57b00d863 (Linux 6.1.186)
  6.6.y a4a971135a2ff64382ae4235b3ae60503bb1036a (Linux 6.6.155)

 net/netfilter/nft_set_pipapo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7c8d28a031ad5..8ba76eea3eb18 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -705,7 +705,7 @@ static int pipapo_resize(struct nft_pipapo_field *f, int old_rules, int rules)
 		return -ENOMEM;
 	}
 
-	new_mt = kvmalloc(rules * sizeof(*new_mt), GFP_KERNEL);
+	new_mt = kvmalloc(rules * sizeof(*new_mt), GFP_KERNEL_ACCOUNT);
 	if (!new_mt) {
 		kvfree(new_lt);
 		return -ENOMEM;
-- 
2.39.5 (Apple Git-154)
