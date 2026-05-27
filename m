Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FD03B7767
	for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 13:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779890277; cv=none; b=ap+KU2zo6efLyNdH0gLXq+SqcKTQvra3+1PFByJK7KZD0E68K4C7iDKn8Wn/i7N5f2sgo5a6yIOwpSShpRoXJkPfVoAuxwoxsH9MhYyvPrp+MISBzYPiTTNkppito2pZgQKFdWEEc5jRQqZOTS6OESmdF/ORcu46Z50NPAjadFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779890277; c=relaxed/simple;
	bh=eZu08mVs02TntUL7GMXdknTj6wwcyvaBBkvZpAxupeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JgInCsaHhoMd0AFrBGIcxFQrgW+B2xyIEs2Jq+QZkApmztF3B3BoJWTLuZ85qISWtwaa4tXgZrt2JdacjG1z6fWOyKnvPosAupo15gh7FDAHrTTCzmVZdgWIrUbfyKKu6p++LTx4C/n+lJjLRX63vyxObsheKLOp9vFVJPnzgb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kRbl+Os/; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kRbl+Os/"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43d76dd4ee8so7125930f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 06:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779890273; x=1780495073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ylxspOikl//hUYOHTbCgkMeRhn08cWcQtF58xpwNlyg=;
        b=kRbl+Os/RBeRxw8GuAPgMwvooTT2cYkvimcE2CiNAhVYRID4+FsN/KmJ/n0BPPyYZG
         7mFp3XSaQkjZL2kW9zzRIunJPgPIbeoKUyUKrq98QbgjAuux4AF1aEuSRLA9zbH/VZNc
         e53CpKo6CicERJpmoF9vojJCZBabseM3uaL7ZbpSnbn/R4vnXjrs/wHDpCq1SdtH7VaL
         /xjps3af4vjbFagMPDdVf8RUj6wsg5ug8l1D0qrXAXarP/93tgybnN7Q9IPOlxNdvRAl
         DZg4KdVTPCi31K5FVOswFa6y3mNPp5S5t9XuH2p2AdmlaOV3GArh0y3M2S+ur2YLHl4/
         yErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779890273; x=1780495073;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ylxspOikl//hUYOHTbCgkMeRhn08cWcQtF58xpwNlyg=;
        b=a5KVRVrOVPFuSCOcfGgM0tKJ3vaksv9M2cYWDVSI0NX2oRBNdERDzEs1Qewoze3U+c
         myYFB0aKqcWe30FSj3eaiFz//ypTQgU+JAFGz3dC8yWw5wpgJKAoJfbxr8y3ba2Jd58D
         5Osh/SJzKeHMkHhngLn6N7Bek/3H9sn7kjFJvzfcSrbTYokWZBfBteUH64fKp2W4IsLv
         DO/0tylt+DuPyjpqdJgTQpD9+d48b9YNjS1gmDkJhgPQ+PffonkcZzv4/s/LRssVxrzt
         ntM7s510F/9BHRcIgjgvP4+BTIgV5IEB1pU1tBYfL2DZ1idSG8tqDQ4oAG7+8LuNuEVM
         X/wg==
X-Forwarded-Encrypted: i=1; AFNElJ/f5AL344Gl6FcSit03DzH12JhupfE/+rqm33dTBoTX+8BMXO5yyqFiGol3apmNIi7ad8ZXUqIfYLOk3PZpnE8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaGVMCiYE1xnr0w0LN7JbqOrAyZZRHBZjCLJQVOnb8GU7i54sj
	nAURYK7+mn2xMav/ui+I28+Zjixw5Nbwiddzg0djCWR3nawXxOYrZmQ=
X-Gm-Gg: Acq92OHFIjRbSeaCP9IyF/IwMpkUPOMKGg3+V/wBjejk1REF/R9QIWPcqO0LCVpeqOW
	Rl8sbjGoGgkJABH71vFCLpKybIOZg4P+RESFw8ZR7QDrVpfQNtT/mUBupWYL/S8jFEPlN/pYJZ5
	WUXdMW1ODNE9PCijJeH5sdgxo/yVRz7muHs7VHESc8MH2B9EF+PIGQ6D921V9TZKoHSKcF2l4uF
	ddD1ak3q4fzumCI9ulGhDg3uX4OhAh5SvAGpg/RCgXTfQAU07tzHSxtHVPkjQa/FW5Cp7fuwJtG
	NOElYHBRWtCBMC8QRQCHjzJAshceVpUs6ztBhyss6G1hihQEG7CXnl6w9bGFX2hYYUjsg6Kjjuf
	P5b2OHY4qvl+p1jVf8RRyyJqmdh8MdpWbnKIr0cD2HZhJ0SXCoTsigw41kiU+87L7Ob/C697p3I
	MARjA=
X-Received: by 2002:a05:6000:144c:b0:43d:77e1:6a69 with SMTP id ffacd0b85a97d-45eb38c2026mr39606398f8f.38.1779890272700;
        Wed, 27 May 2026 06:57:52 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb5c2323sm6388642f8f.34.2026.05.27.06.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 06:57:51 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH] netfilter: nft_tunnel: fix use-after-free on object destroy
Date: Wed, 27 May 2026 13:57:50 +0000
Message-ID: <20260527135751.1031891-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

nft_tunnel_obj_destroy() calls metadata_dst_free() which directly
kfree()s the metadata_dst, ignoring the dst_entry refcount. Packets
that took a reference via dst_hold() in nft_tunnel_obj_eval() and
are still queued (e.g. in a netem qdisc) are left with a dangling
pointer. When these packets are eventually dequeued, dst_release()
operates on freed memory.

Replace metadata_dst_free() with dst_release() so the metadata_dst
is freed only after all references are dropped. The dst subsystem
already handles metadata_dst cleanup in dst_destroy() when
DST_METADATA is set.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 net/netfilter/nft_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 0b987bc2132ae..68f7cfbbee063 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -676,7 +676,7 @@ static void nft_tunnel_obj_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_tunnel_obj *priv = nft_obj_data(obj);
 
-	metadata_dst_free(priv->md);
+	dst_release(&priv->md->dst);
 }
 
 static struct nft_object_type nft_tunnel_obj_type;
-- 
2.47.3

