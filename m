Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C0D3932E9
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 22:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786400269; cv=none; b=FsTx7ZvReknfXkw65J1AbTU6JPHnLXXBtPzjzoyKTHogwGh+RO+MaeMeLHIV/WLLNy8Fy8EbMQ7QMCQAnFHF28x1yuRoRXH3U0en+YrEIaJtVy59XJBUEPNG3Rqiesw1nvLScwjux5g7FTCYyBGEqTWa9WoAQfLx+QrbALEf2pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786400269; c=relaxed/simple;
	bh=ZhNKW6g/+oomwKLg7OPXq3/1lKLTs4nkOCQ711e8Xgk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G4SVvCJWNbqfw3H0tP+KwnrlEpHcDfeH9rG6cYyg7Vf/xfSIXPqiCrwCJM6lBI3pCZsYqtWONCtufsAOQht+Ke5yragBeswxA2KBfak79YowOze3rQwH53iKT5Kq/MRBHvG+O7Rf/rkXbFNSv8DsKji1fqCRpyocM+GWggPTcdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com; spf=pass smtp.mailfrom=openai.com; dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b=e73Jtd4N; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b="e73Jtd4N"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cacb8416a1so24381875ad.1
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 15:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1786400268; x=1787005068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xyx4aLVuNIym2aqZSu/GBDUgtkyzDL0TaIKLCAoxUHg=;
        b=e73Jtd4NkAIS1dxafE7BDnugB7nY74QcIV5Eff87Hj46Qgi3MqBv1sl4ncupa9lRkx
         T16xGW+QLKUANWlNn9z7buP6v9S8airljz0MptH/kIlY6a2gULV5/7PkQuEx4ldZk4ZE
         jEQBO02J9sa/gGqERpfydylNQVJNO6Iif05e0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786400268; x=1787005068;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xyx4aLVuNIym2aqZSu/GBDUgtkyzDL0TaIKLCAoxUHg=;
        b=FIUwnu5UPEPGf6zRxljvBtt6jQMUCTQVxWG4KRghKVOB+hG3GVg3TnIOWH+9tAhbW8
         49heqbpBLV0AOj7I+CtG7iAvLzJy234o+CWapdCOfXVlOz3NEro2jWgl9+t3dObCTeZ+
         wqIdFquZI0EbPp2EawzVpHER0BS69+76vJ/mRAcAOc9shn/Ii9UQCLbVRStMy9WVzsC6
         y9I0y+y1iIFmAnmKz9pEa+UAAgicAdgsq3DWiOQ/qPwGvpu0KgkG1ZUiprf7Z6ik2Ouo
         ZUbMUI2iSG9WGnwZjGvfZaRV8zCCAc/fnvsyshPSIEzcA4EDcCY0q+hmDBFL0NBlk2rV
         pK7Q==
X-Gm-Message-State: AOJu0Yx8fbDTu9caZ5XJn4ZthRCul+e3aLV2CHHakLGx4BARFrZSx8uj
	Yp2fPWuvm0ni6C1HqsMmerWu0igEd7c2n5m0VnRVRZXzEEwm+iX1rJ5xUYGUpruWTDvkejvxjuF
	5H/mEtbZgAQ==
X-Gm-Gg: AR+sD13jrRXLYPiH/NZxT9p/Y5YEV8aNg07dQafLga+7HQozMF964D9nCw2JkzluFTL
	nTDt992kplqJldEd/leEdpDm0j9jTrSp7MM94tHsRv+e7dXu03L7KJq2aZW1Ym/QvvMvb2eT70N
	evx6FQBanlG8cWcZhZSC7VANIDIO2gMP/MOl/cqsjmCic2ghYq2R8a3sks87zKLScD1G7lzXxtU
	OoBdENjbk17N3ijhmsBCvm8O9qsbpMiFe4NWljwjIxFtJMrPKJLkzfYy6DmNNycs2Ceqf7mT9Vg
	L/66sDGFnurpqWDvV81QXSYPWuV2yoMnLaGxfM0EW5yIwLQ7fogdVmzc5xs0HV4lDPGORdskVgL
	rZ8oo7Oic4u/IQ/6rlRVxJwRp++7WbqEELvFJEE9lguqH8otbJ9QC0XXqPdQZmTI6bdiLXqw1N6
	tJ4Dc9qonBd3jP1CVS5bf3ta3EO/jKyAexap5JB4f3iuth9ZuqG0i/LRSdjg2wZ0T4pWoWvUHJG
	WG+xRmN2xjOrM9mylF7nBsqiOI3hTIchmQAKf+47tG7iBq387nuFwJrlaAvZK5DEgah571BgmE=
X-Received: by 2002:a05:6a21:33a0:b0:3c3:7762:5d5f with SMTP id adf61e73a8af0-3cbce8d45e2mr24390555637.19.1786400267996;
        Mon, 10 Aug 2026 15:17:47 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315be86f98esm47392553eec.6.2026.08.10.15.17.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 10 Aug 2026 15:17:47 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org,
	Kyle Zeng <kylebot@openai.com>
Subject: [PATCH] netfilter: nft_ct: validate timeout object protocol
Date: Mon, 10 Aug 2026 15:17:44 -0700
Message-ID: <20260810221744.35007-1-kylebot@openai.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_ct_timeout_obj_eval() only compares the timeout object protocol with
packet metadata. A packet header can be changed after conntrack attaches
an entry, so this metadata does not necessarily describe the entry.

Timeout objects contain protocol-specific arrays. Attaching an object for
a protocol with fewer timeout states to an entry for one with more states
lets the conntrack tracker read beyond the object.

Require the object protocol to match the conntrack tuple protocol before
attaching it. This mirrors validation by named timeout policies and
nftables conntrack helper objects.

Fixes: 0434ccdcf883 ("netfilter: nf_tables: rework ct timeout set support")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
 net/netfilter/nft_ct.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 03a88c7..d618bfa 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -885,7 +885,8 @@ static void nft_ct_timeout_obj_eval(struct nft_object *obj,
 	if (priv->l4proto != pkt->tprot)
 		return;
 
-	if (!ct || nf_ct_is_template(ct) || nf_ct_is_confirmed(ct))
+	if (!ct || nf_ct_is_template(ct) || nf_ct_is_confirmed(ct) ||
+	    priv->l4proto != nf_ct_protonum(ct))
 		return;
 
 	timeout = nf_ct_timeout_find(ct);
