Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792467469;
	b=CZ42U+VgMKUcouiPVLd7HecqihiMpQPCQZfZVGwXBDsNTbp2iXVfgvQumeBKKfilD+DC
	 MtZ3b1KNtr8V8sOZi1nrbvdQFU+CFIhlhkdWxTHiE+S4gu1WXJGNmJdI6pMmykUy4ddtz
	 subk83uspR2bWrUexAs37DIZMsolmDjcXN6rFgsN6SPLdwdkSQvYvV0gG3hgq/u9XyaYH
	 9UtcEQM0hkaPM+RUeQ+8oHIR6oHU6vPvcCROEPx0TWtLGhgo+XBT2bHEILPI+TuUt7/aN
	 Eec6PGtyI+cQpA3r32wQDus/FXvzVG1W+BXJ244yNGVq9YnCCYp3QwylR3JqZcNJNdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792467469;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:X-Mailer;
	bh=w0tDSv3cpnMc4Uid9cVH52UuvJ3ZLGLLnvRLmoBwm+Y=;
	b=4R8AIP7I/QyVQiRoL/YwidZM/Pspuv+5eR9I9qLMBFOxmw4KngwXCufe7CXCLhxGAxsw
	 2icpIFuNxj925rnnY1daQ0c/hqakPTB0TZzRV6GyyGiIfpkZj8y7dUAlJ+jMMzW2XyHje
	 6N4uBlTJ7erfvsOKG85Y5P7Esv4Lg82Dx/FtbFW/MJj1yfs/Ad2zQKtzwUtgyDtz1NedI
	 ryNU900pPN6O+1ok8wWyRja747exMk5BeefCcwzPPLoq9PQB/KaDL+S5CDf2wSTLHrAyX
	 4H/LXMjbeibZBtRtd3mp201mAgJKL+60sNYygaVL+mApXKG6e3vDNiGrvgqm8cLPH8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=b6vOF+Fk;
	arc=none smtp.remote-ip=74.125.229.9
Received: from mail-dy2-f9.google.com (mail-dy2-f9.google.com [74.125.229.9])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57A1606A319
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 03:37:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A57A1606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=b6vOF+Fk
Received: by mail-dy2-f9.google.com with SMTP id 5a478bee46e88-35e37b4a43cso503042eec.1
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 20:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792467468; x=1793072268; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w0tDSv3cpnMc4Uid9cVH52UuvJ3ZLGLLnvRLmoBwm+Y=;
        b=b6vOF+Fkog7p9NJYj1mpI6foDtXVIC+Jn2EfosIu36KxBKP1Sl/99ykuQO3meKZ5ig
         OtyyviABMOD8bINTcfS7lHvEsUlDiqB7ykeAMvEV3foMIzwytjgUiF1LfNtMUyxa4Gxs
         1WDGnuvh/gqlcrwjDwa2qFAjnErmEAWwoNAC1+kQFhqb4AO76/3YndsRrPr29t2clsrJ
         T/pUre9GCK4LTOvvJP4hDYSDU8eGOdmDlCbAitzUdav0GN4b9WnYToB8WY+p0qd6AdLE
         wfVtpQ7UtMmHtUHdHjhOBGZxm7PSmFzsd0u1ZwoYQoLc9jr/U2sM3RAd2WnVVRgyTH5a
         ykBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792467468; x=1793072268;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w0tDSv3cpnMc4Uid9cVH52UuvJ3ZLGLLnvRLmoBwm+Y=;
        b=JzTmVNUSFs7y2qFKa0HfawfbxockAIUAz7HHvlGjZv+l2lcP7IC9JzXtiARLQv+Mff
         WyaWXKdcJUHXgJ9s99hEcPGcfcym7vv3C2M/LIyjkLB5t9TmobXwSyH+ujGr2DKYn9KK
         84J5PoCyThT6xqYgHcAvZgS3kMjMZSfj4ThwZ1sbuS8Vga2OXO84d5KI7Q/LMAhYwaLd
         /X4hz/cGizzj+h8U0gqWGxe25pYi8FTeVxlYc7rm3OD4dySvC/KOEUL0iz7NEwG5n8Dt
         Usi0qKr6tKrR/dUcRKjwaqjl6p8GvAEJ7q05+46TTQ/o8txbMuo4JgKMKfZ+A3f3JJ63
         vnPA==
X-Forwarded-Encrypted: i=1; AKwUvBxzIQ9P3cEdvwH4Gk3t9k8jFQ3s+at3jEiNlDp0XnU81OYTQVmicQfzX7WDcDBwlSW5xLtbtQM9rAYVMGHNOg8=@vger.kernel.org
X-Gm-Message-State: AFq9FYJP8aLIOHMnE6DoEHhOn+fy9upGMq/oh9eZOuqaT8lrWj9X8/+G
	uA2wT3x2TtlQuLlfuzGSUKqOnIeWA1s9s2EW4Dlq5POEgk0LQWrAkLSI
X-Gm-Gg: AYBFou1AicLMqTttGfb+CMDyCJjV9iPjqm9R+UQR4gJK7d8D0catkNkvtEgTiyNE3eM
	dNZNZe8Ai96XhFqKdizGFE+HEABT0CTXifNcOKGQ8Sus5oxwMrzBaWOLY/8oCh6VY6/tENXnbho
	J8WMgk07HxP9+eMknfB4eCZ25KHrEQfCLt1z3MlqhB27oj3f2CQAaQ6ctaRqlMao8qImWAwyWCk
	EgMuA0/nSuxk6qturE0Y6fu31sjVAloNIYTyorVFnRC8+uo+igFNmlfK8fA1+pykPYRF1IItuvc
	HinnSp7g2NQ/fJYDtiTOrlAurUu2oL3CCKSSa1wh/yQN40BVDaap0mkegLJCfy2fpvux5rhOh+J
	2FJXV5KPX2L4Ix/um5ar/BApZk9nyPYnXcsrObrzR9vaTPTzKE/3wPItwjGvChp7uBxH8GdjuPh
	kFevYhC6Ev9/or+62GQQaU6CPPy0rULRC8O+KMFyhcyRJR1wTbC5NqIq0D9vdx2Q==
X-Received: by 2002:a05:701b:4248:20b0:14b:1ef8:698d with SMTP id a92af1059eb24-18dbabaac5dmr1309794c88.15.1792467467507;
        Mon, 19 Oct 2026 20:37:47 -0700 (PDT)
Received: from hhost ([120.231.212.164])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831ba424a6sm32858053c88.17.2026.10.19.20.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 20:37:46 -0700 (PDT)
Date: Tue, 20 Oct 2026 11:37:40 +0800
From: Xingyuan Mo <hdthky0@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"open list:NETFILTER" <netfilter-devel@vger.kernel.org>
Cc: Xingyuan Mo <hdthky0@gmail.com>
Subject: [PATCH nf] netfilter: nft_set_rbtree: check catchall_sync return
 before queue_done
Message-ID: <20261020033527.514115-1-hdthky0@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.43.0

nft_rbtree_gc_queue() passes the result of nft_trans_gc_catchall_sync()
straight to nft_trans_gc_queue_sync_done(). When the catchall path flushes
a full GC batch and nft_trans_gc_alloc() fails, catchall_sync returns
NULL and queue_sync_done dereferences trans->net (NULL+0x10). Guard the
call like the pipapo GC path already does.

Fixes: 7d259f021aaa ("netfilter: nft_set_rbtree: prefer sync gc to async worker")
Assisted-by: opencode:deepseek-v4
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
---
 net/netfilter/nft_set_rbtree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 12431b55752f..4338921bd88f 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -953,7 +953,8 @@ static void nft_rbtree_gc_queue(struct nft_set *set)
 	}
 
 	gc = nft_trans_gc_catchall_sync(gc);
-	nft_trans_gc_queue_sync_done(gc);
+	if (gc)
+		nft_trans_gc_queue_sync_done(gc);
 }
 
 static u64 nft_rbtree_privsize(const struct nlattr * const nla[],
-- 
2.43.0

