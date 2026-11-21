Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795296260;
	b=uew6ZioL1x+44iwKcjGf7E3n49vRB1Ni+O52jayCx/WZmnRatrSUFvHxPGfJ49ffRQdZ
	 WXyL12T8ccxJxEGCFptmAu0jVHDuuTb72F6wYbT+a11pAKihkaHLag6TWROmQmEnsUBfc
	 INOBiRrV9GoHVnQnnfx4Zu7FwRycG6AzwX6hXla0q3688xK66iJN9kXPme2sgKiyi2GwR
	 67C8tvhv7IWoVJ4aZC3QblTHFdC5qXIIxaqXPuRP5/1AEKBjAoHVcYmdHTRxw4tku6b3h
	 k7PbRzsa5uAIXxw6uD9ICc8O7+EIXmIWpRWvcncJCCe1VvruN5iCprCVNiIhgtVmXYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795296260;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=QnN9CxDyovVg8bGKbDx5lj1s9US1BmNCEq5WllIH360=;
	b=v/s+kmKzVaJNjgFHVBBZp4ylFA5qx14mK2B6b3RoxZRLy4kz7yJqfodZEc9aYMSDLHpN
	 WDEDRYM0PL9GiDXZ6Z8rzmYNbpemqVLenQ/XSOPxzqa5A1CG3fXIKRv8ZhRT6gScMlm/u
	 c48WEGc+MtESgGFw0ylnRYiEZXsedZbgj0sqHCeW8sVCFEff8Kl5Sg0xpuXNg9Sni5TG2
	 spDYKn99qj3zEGY3RXe9yTFwqsOYLofL4FRT6YPm+TSAdKnwKaAQIi4dgnYnTsSys4quU
	 o2bYgsAo4gexgX2Lwhe+68sf9Mhq+RrGp1MadB9OiwMTAJfAIsl5Ob6ayEa9bHnzQpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YW2xYQ6p;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941DC606A320
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 21:24:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 941DC606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YW2xYQ6p
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a14so21835105e9.1
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 13:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795296258; x=1795901058; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QnN9CxDyovVg8bGKbDx5lj1s9US1BmNCEq5WllIH360=;
        b=YW2xYQ6p5a+/qxuh6gQeHzVZ3q+n02Ssc0O6m0bU+KNH5dQ6q3GV5o3oloT+NNbWA5
         u9OZgm54775PMXQDC8bpf/J8uQDss7hnYA+QUxDR0JGdmoilqw5laNHTEN2N6UhpV7ge
         Q/AG/VmHISqJFZm4JTQ0lmpnoQdpyXk2hp/nbQ8TyXol1P2k+U6CQZlqi2UlcNjUpHCD
         nHpFKkki+pVOJvNQtcB9sTywJQNK9UcaoIC1wKqVZkrqk8oHvqVbI0Hf7hz1bGYrWVpn
         kFQ+yhL2+RrO+AtSSHWxjyjRRDmbAUlzNN+bdxdp9tjiG1IjtWTYsyo7IPLGVZEiHF3S
         q1Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795296258; x=1795901058;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QnN9CxDyovVg8bGKbDx5lj1s9US1BmNCEq5WllIH360=;
        b=pPLQeGh2eJfb2zzuO3fTsvfldJ7y1qCULFwSEQm62Ym8AvDb30cTYH+Vm68EeB8wNN
         RiUjXMLJay2YXxyLyrdX+Ve2z6dVtxajTPlahsev1uJDcTAQmdG+Z0wgaJobvzycz7d/
         5ktjNFtIw0hvMWM2XyKzHO8+XF7oYSDOG0NnXB6v5E4Q0Xm89zAMpp7bhQCH1RC698eJ
         MSX3UKfYLoY+b6/T8AaA7TusSwxVSv+ePcuph4Nh/87YYE73MiISG99VUPLv7VWYRb2Q
         hk5k6V9VzvgQVOnsIXBlC7XgIndii2MljZ9khNpMiAj78pJztoln6IVHleBAAoL8CwBu
         EKIA==
X-Forwarded-Encrypted: i=1; AL+hErGRsZ7OO1BhvyMl6RlkjAhAb4mTA4noz12WXWShKZvA+LSloJLBDPqqzme+mHlcwiHyWfQ/xw3K0BqDIaENluY=@vger.kernel.org
X-Gm-Message-State: APuU4Z9jK5SLWP8vg1sZEVDw+umirFS704uzuP7jqdkhj36CNW2asT8P
	bC+159KmYcgmsikjx1FS0iA6RqJobLs5Nc0FMpzTsyO3wI062LRzgExy
X-Gm-Gg: AZFdTZdqkZMxd84M9r4AAV1eupGT9X6i/gYUyKH10UFx1xxCGA37X/dApUfaKEOoopz
	C3AFk5Fysdiz2ahx6okFhf4Yd0uTbnpeo4zbR4/zxnatUjrGM6q83zAruP8Ad9q1DBuRbdaxapw
	9NMEWEQ+jiJdRL0EnELlf2jlYxQe1tskVaU9pNONlM6/JGc7gmCRoFqDzO3jk513Zcgg1wjTauG
	Tc94Q41zUi6q3D0502IZqKmycggMiXlIL5JvL2tcFi53Pz2AekpyKqP5NAPexaIlewYqGO5MPqe
	vnXUtWPa1JVihfCtSyHE5FpaevlcIBONF0gC+6S+M2X3Gc7c2Y/g98WwgAjfZ/rrpZ3iQMoSUqj
	WHSlmjGKHlcf5ZoO0zKMt+KP51f5rgEvdF5ZeDPd/rb41unEPyITXa+RYBc1OfBfjD5OXSA909f
	mQs1paju5BPvIZGpNO4eU6CKqBUCBPCIIgpfwD/NH2k5BpXKngxMdzW+yjPo6ljp1zUOZ8fap9u
	Iwoe1Q1pc0998TrZD8WwdBVaxtAzMS7ieXqblOdzMkrudCfPj6KMWVdwD2IL4y+WAQJRoNncpGd
	O+aw01ndzTtr+Z8Iy3lYk/faeA==
X-Received: by 2002:a05:600c:4f15:b0:4bb:6861:657d with SMTP id 5b1f17b1804b1-4bb88923954mr173957455e9.21.1795296257761;
        Sat, 21 Nov 2026 13:24:17 -0800 (PST)
Received: from metepc ([46.197.185.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb905f1489sm79231845e9.0.2026.11.21.13.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 13:24:17 -0800 (PST)
From: =?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>
Subject: [PATCH nf] netfilter: ipset: fix extension leak during hash resize
Date: Sun, 22 Nov 2026 00:15:27 +0300
Message-ID: <20261121212037.149722-1-omermetekaya0@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

During hash table resizing, mtype_resize() skips expired elements
without freeing their extensions. The old table is then destroyed
with ext_destroy=false, so these extensions are never freed.

Fix this by calling ip_set_ext_destroy() on expired elements in the
resize copy loop. The cleanup is done under the region lock with the
bucket re-read into a separate variable to avoid races with
mtype_add() concurrently reusing or reallocating the bucket, while
preserving the original bucket pointer for subsequent loop iterations.

Discovered by Sashiko, not triggered, not runtime tested.

Fixes: 80571a9ea4ca ("netfilter: ipset: Fix hash resizing with comments")
Signed-off-by: Ömer Mete Kaya <omermetekaya0@gmail.com>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 80ca523f304b..47aab02c9d23 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -823,8 +823,19 @@ mtype_resize(struct ip_set *set, bool retried)
 				if (!test_bit_acquire(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
-				if (SET_ELEM_EXPIRED(set, data))
+				if (SET_ELEM_EXPIRED(set, data)) {
+					struct hbucket *cur;
+
+					spin_lock_bh(&orig->hregion[r].lock);
+					cur = __ipset_dereference(hbucket(orig, i));
+					if (cur && test_bit(j, cur->used)) {
+						data = ahash_data(cur, j, dsize);
+						if (SET_ELEM_EXPIRED(set, data))
+							ip_set_ext_destroy(set, data);
+					}
+					spin_unlock_bh(&orig->hregion[r].lock);
 					continue;
+				}
 #ifdef IP_SET_HASH_WITH_NETS
 				/* We have readers running parallel with us,
 				 * so the live data cannot be modified.
-- 
2.56.0

