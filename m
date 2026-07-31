Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752E83D4105
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 14:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785506894; cv=none; b=KF3PYLS5Z3yzSGQgakDVuF8VXffb+5ajC0lETCpLp3HWt2yKNuAZXFpHd6MGU9eHTrIsL9gEVOv9buGLmHpSDFSq3qktTTqixHUxBw22lAMwLPPaG/8BaRHFrK8rcQkk6FBOdFxsmcrOwiQN0DPORErtnMjlxIjBi6bzSAwO3H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785506894; c=relaxed/simple;
	bh=lWYS/jQQIXC0y44IHuPBs/Bn1BGmlDCz4C7AQHJjUxw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZAGh1bRTuhYSli7NqZH3T03KiRtSAkysigzoKpTfIxuCpAp2SiIB2hZLRmtvLQCm2aB1cZYjjbQr6MvAZk2QvTaRrMsADsbN4vkf+GBe2Hs3l2tkOVAN6sG6iL2RIym7K2cn88VZBnerKyvaVppchruDVF0WJQT3t5MXQkIRRiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=cnikELOM; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="cnikELOM"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c4436d02cso4868691cf.1
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 07:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1785506892; x=1786111692; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=H1m5R8ifW3apJu3sUYJF9SxlauvcUbf0bTaC1a+0HJY=;
        b=cnikELOMVZ6CYvzmcILg9PK74aKJ0kKV6sqj0IdsEMOUZEpdES8YwbzjOlHH6QOyLf
         T+uaLvOSZoGp7FSjuzV3pQLfp2EKKDZCdcW+ohyyZeEvLQAT8W7oehQN/n/glDFePoqC
         Ze4tbdaK8nXM/jDQavdRIpSE/cRzGXKaopwENnYjup4chbRsk8QWcJK0RPAGxnr6F/ta
         4DMnVXz4gbkG1YTHCwTCaF+w+AMKlj562OSr7AX9GG1wCozqUyRWiGeGlN3A/wFQfd4T
         9mLxIq1mlPqwDRvz6910m/O8XkjzRvIgzzjLNkEqazKsVOYFCzxxv0sg6umtb8rqYXK0
         aVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785506892; x=1786111692;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H1m5R8ifW3apJu3sUYJF9SxlauvcUbf0bTaC1a+0HJY=;
        b=l+Uw+iUKJ+rDM/ofLHdxU0xhwJxKTFHpbx+XJ3Vae4UWNIhXU9NwpAJK+7Q6r4AyLm
         PMy3MG9LNbKU4UTr2x85RCZOMTDcOuQaJMB4mkac/eihu1zwbA/y3ihMVwuWve84M6wl
         1x9InbFZ5P5i0cigFDvHgtOMTX1SpmYAVhMXPA1b5FRlLvYW+lMtBE8DnEHwJzUWke2I
         E2Y5/kxEIS27BB3gpTc5fx9LJH+11F8FOqpRemCD2rAX2Dq2tIV57PiQ8ZIG21IFoB2e
         ieWXWuMZ0lSUetY7R1T9JjUUvFaLQ+ArWcuVOxVw1u5WpkECrjojkx7ZMthlxFQyQQ33
         cecQ==
X-Forwarded-Encrypted: i=1; AHgh+RpTXgeFXZIhcsIBjR4xPf+2KQqflvWREfccHqaiLZICKj4OnMQx9NxnQJBAKisnUT1y9qWVEQnJk7ucL11mOms=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdXO4ZNzb1M5yVVYuxP5tt62p4w4Pw7KCdDxOmMEMSjZGcU41L
	Qmu0HOg1bXIRfETGJgMlTewXz1QeQcRA01tc4H7WpJeaTm3oZ5dt9GOldIFHY08pe+Q=
X-Gm-Gg: AR+sD11GFX8+VaOc8rcSg5EKZC7PtlekyiKN48IX0rJ0TdGbISG/dnUDr/0Hagn2zGU
	heAJQllZCKCawkgcScDNq3y4jlCW/n+hlxpT+A52dTRP9iAuXeJIEmqQ7ghPlrxZyHcPtg1XtYm
	0b2e93df3pkWHGpN443OZEQTJPfLPwO1D/+xj6mXv7vqA1G60xtoTwmlRTvyipN81HJyUCOyV5C
	SxBz9BPPr3s+rC6sc9WktZIJTU1vnJeo1QBl0Jk45pPe4GU1MtFhZ2/YtXzoJEqW7Sdn2hzstQy
	UgPoNQrkYGZyKBQU3yVFUcPvpDrlEUi8V5EdGEXVSLIFgoLPfNcrgyYWCOFb45vrYm6x385ChZL
	6WdVa5vs0G5G8jAJHuh7rSL513AZ8Fho0GZeriF65of7yJqNOzQLDfqlFMqTd9O/vEzFLTgSa7f
	CBd+YxKzegsa/buJYJaD7gWqJRxeba7ofqqBPH3bE1V0M2KoAJGrqXtSSD82hdcnVEq0OKbJbmK
	aHB
X-Received: by 2002:a05:622a:400d:b0:528:3d62:16c8 with SMTP id d75a77b69052e-52b56794317mr4487941cf.31.1785506892382;
        Fri, 31 Jul 2026 07:08:12 -0700 (PDT)
Received: from localhost ([146.190.222.192])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-52b4e81edadsm8626151cf.8.2026.07.31.07.08.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 07:08:12 -0700 (PDT)
From: David Lee <david.lee@trailofbits.com>
To: pablo@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: David Lee <david.lee@trailofbits.com>,
	Kyle Zeng <kylebot@openai.com>,
	Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
	phil@nwl.cc,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: nf_conntrack: prevent helper extension relocation
Date: Fri, 31 Jul 2026 14:08:10 +0000
Message-ID: <20260731140811.566714-1-david.lee@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct nf_conn_help contains the head of the per-master expectation
list. hlist_add_head_rcu() makes the first expectation node point back to
that head, but nf_ct_ext_add() can later move the extension buffer with
krealloc(). This leaves the node backpointer aimed at freed memory, so
unlinking the expectation writes through a stale pointer.

Reserve the full u8-addressable extension space when adding the helper
extension and reuse the existing buffer once the helper is present. This
keeps the expectation list head stable while allowing later extensions
to be added.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Bug found and triaged by OpenAI Security Research and 
validated by Trail of Bits.

Assisted-by: Codex:gpt-5.6-sol gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
Trail of Bits has a reproducer for this bug that triggers a
KASAN use-after-free and can share if needed.

 net/netfilter/nf_conntrack_extend.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 0da105e1d..1421944a3 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -112,9 +112,21 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	newlen = newoff + nf_ct_ext_type_len[id];
 
 	alloc = max(newlen, NF_CT_EXT_PREALLOC);
-	new = krealloc(ct->ext, alloc, gfp);
-	if (!new)
-		return NULL;
+	/*
+	 * Once an expectation is linked, its list node points back to the
+	 * hlist head in the helper extension. Reserve all available extension
+	 * space for the helper and do not move it afterward.
+	 */
+	if (ct->ext &&
+	    __nf_ct_ext_exist(ct->ext, NF_CT_EXT_HELPER)) {
+		new = ct->ext;
+	} else {
+		if (id == NF_CT_EXT_HELPER)
+			alloc = U8_MAX;
+		new = krealloc(ct->ext, alloc, gfp);
+		if (!new)
+			return NULL;
+	}
 
 	if (!ct->ext)
 		memset(new->offset, 0, sizeof(new->offset));
-- 
2.53.0
