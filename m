Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793973535;
	b=c5LLyJ00LRSv4vOetEiEc9jTv6v75Ocg9FlKcViiMpX/+Y1MZhGgtbvd0wUODOK82VGO
	 XsRU/gpjdidRMEATnuYD5ZOEB4lFI/oT+mudC3ocz98tNWhCmgszKTPl07zugCTsn1JVl
	 RaoE4SmvkSomNF9jSUnMCDi3VNoYDEfYR4PVJOzEYX6Ak4IHJI0iphkcdKux0qNFSF1iY
	 lwW6n5vp4UsZmmRZbMkn+816FfUNd+S78SmybipXjAieB7tY1cyaoWG4HfRfCgGsH0aGb
	 b9+5+wnozXy+XixIdZ6SYl6WDANx1RBlLHsZDolPdNOvvaZoErbs4pSPDxnMQZmmJXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793973535;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Z2AkjhN0vu7z8IdZXbynrd0h3RzJFiI/Xv85qagqDOM=;
	b=1JzBjDNpNH+sP02h1+BAU+mYkgcJ1m7DGu7hPwkmVc2bGC/AxumENsp6KK5mwr5Y7gBo
	 BF9nK/f2GImtgV69k2E8v2IAY138SLJSpTYQYIGbAuR30B4MpyQTHQbjSU7PVLdI6l/lg
	 iyEYkotWC+LT2HaMHQbKB86eorcEvLsYdrnALjup7zpZA8JutgD1wK5tbC1VlbLM/D1Yv
	 NmLCfDtqCKtzeg4mvCijOUDyLK4VBy0FgQsMZEUTkYHr85zCKJnnmthuhbojXZHu0truJ
	 4H5Ww5kcTEyYXHSeHrUjn4FN1zRtlboK4fc7FJzD+5zwUlDE6piWrieufSdWUmlpG2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HPvN6mW9;
	arc=none smtp.remote-ip=74.125.229.4
Received: from mail-dy2-f4.google.com (mail-dy2-f4.google.com [74.125.229.4])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322FF606A330
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 13:58:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 322FF606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HPvN6mW9
Received: by mail-dy2-f4.google.com with SMTP id 5a478bee46e88-36f2f262b19so379235eec.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Nov 2026 05:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793973533; x=1794578333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z2AkjhN0vu7z8IdZXbynrd0h3RzJFiI/Xv85qagqDOM=;
        b=HPvN6mW928ycuDMcBjjVNvGKHBgJeGw79uKoH02bKVYjig+ECc1+S+QQYFIYm4RdBB
         mrPrF9jRDvlhrBvvIH5cxpITgkuwZQRvL+KW5HiPNX4vmyNmISvP38XkDIMpli2NrOnH
         Jj/akKklvfSDdQkBi2rLPzb44aJ1M+zytxOp2u+zp23fo/p2FpKVTtxT6OWPAZ3gvLG6
         oE6jqR5d3TdWzmTLYQKdP9uwSqXOkP6g4ALedlE3riXd1QoeyhgEIWZvXvL5k1BvoyHo
         mFnV5TLoXNFsFAPyjl5qhntChhk/4auHMqSiHurU6BtEZVERnImRI7Wqoj7buVg4DbfM
         kbqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793973533; x=1794578333;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z2AkjhN0vu7z8IdZXbynrd0h3RzJFiI/Xv85qagqDOM=;
        b=yCg/RsOHfFRU6+nbF/icr1JEr0f9+I8m0tT4XGdlLrKAvUAFreQk0t9ZZAuUP3g+B8
         bUqbBKMu91X9QaezffxTROuR5usbiv/0wxDPBa6YS4rO0dRMLprJyckVKmNJ8WIVUd/t
         q8PTSHLFmtkvznK0ySy7MFm0ipKpc82AB06jgy0RDToidUmiafXNZf4B63cWoTX9OP8Q
         P5LUIHyT7Eysq2DBtcdUDYNukZFQfDE3GRF6ue/4vlCYc4y3aRkzO4k5AB0KjzopUP8s
         sr9r4rQVqkRSS9Ide77/iYKBnetbh2WI1iWYLJFIWydXLh5CWpRVHWsoj3suQo4gCTie
         jDrw==
X-Gm-Message-State: APuU4Z8eNqgVwsFvZv6W3lA/q+19Q08mZXpFNMl+4Sujex4wIO3Ici15
	xOF0LpO8mnhpAcE0mUcfN1CSAnHfLnNzfHS2MCZopHGLU7COP/xNXb0gM1GxAXyd
X-Gm-Gg: AYBFou0mHAM/PEN1CZKx8qTg8ln7P/IOcOR7fEfCU5nOOmEbF2+SEoZnuU5N+hJ7QRD
	ZRHGGZVJBBaZjMXkURRCvU5SRSS1oDbglfTHjLM9qSppL6nCsPRK6KDNevEAGLh18puh6OzeOii
	mpaxUqk9/OpkS+m6aX5nCZGIlXmzpNMpscDvnYOWa79TagyHcYnVKYS4BdPv7Bf52I+71FDFHE5
	ul7M3dhVVtuD1MXagJU9bjwKDIgmnba9ojJrj6nD3na9KzegMZphpLxPoNaNiDmYW1AMKhFJksm
	2Rqpti+9nZyobXxwZwFueqM/mtCcRQWYyvdrmn8HRz2Hg3YFXPAXZtRmRILFWd5WcmC3i9H1HuO
	fQE0dbX4HOaTa+2IQdZp/iWI5uQClTnp5bHc0PkbmgQyVWofcnf36kWidUsk5W6I3doB4XRSiUC
	Mzu2pWzeMYj6TBhdZcb1icDB9ZR6VzpTS1+aJSp5EfyO17FV0tY+buv3z6kgGF/x/mfOtwuKdr1
	oVn61BC+JHzPjgXOmKRkvBe2lFQWOAd3ZR+h22y4feJA3gTpj+SsOpOQ6jUoV91q7sEGy27fuJ/
	atiXIlu9/Zxhnz1MrTa5pzk0Zez1PZc1kP0mPLxcoAyxZ8ysRnNrAsLo8sKoqA==
X-Received: by 2002:a05:701b:418d:20b0:191:a5b2:ef4a with SMTP id a92af1059eb24-1b25d35531dmr3162580c88.28.1793973533048;
        Fri, 06 Nov 2026 05:58:53 -0800 (PST)
Received: from localhost.localdomain ([2405:201:e056:a8e3:ff2b:1543:5b95:16e2])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e407cd1sm6754973c88.3.2026.11.06.05.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:58:52 -0800 (PST)
From: Vikash SS <thisisforspotifyvikash@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	linux-doc@vger.kernel.org,
	corbet@lwn.net,
	Vikash SS <thisisforspotifyvikash@gmail.com>
Subject: [PATCH] netfilter: conntrack: document sparse hash table eviction
Date: Fri,  6 Nov 2026 13:58:16 +0000
Message-Id: <20261106135816.391285-1-thisisforspotifyvikash@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When nf_conntrack_max is significantly smaller than
nf_conntrack_buckets, the hash table can become sparsely populated.

The early_drop() path examines at most 8 consecutive hash buckets
when searching for eviction candidates. Under table exhaustion,
this bounded search may fail to find an eligible entry even when
evictable connections exist elsewhere in the table.

Document this limitation to clarify the implications of configuring
nf_conntrack_max significantly below nf_conntrack_buckets.

Signed-off-by: Vikash SS <thisisforspotifyvikash@gmail.com>
---
 Documentation/networking/nf_conntrack-sysctl.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 4426cce2a..fc07a950b 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -99,6 +99,10 @@ nf_conntrack_max - INTEGER
         the reversed address). This means that with default settings a maxed-out
         table will have a average hash chain length of 2, not 1.
 
+        Setting nf_conntrack_max much lower than nf_conntrack_buckets
+        may cause early eviction to fail under table exhaustion, as
+        the eviction search may not find entries in sparse hash tables.
+
 nf_conntrack_tcp_be_liberal - BOOLEAN
 	- 0 - disabled (default)
 	- not 0 - enabled
-- 
2.34.1

