Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3E536F42A
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Mar 2026 15:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773589593; cv=none; b=qgnb1KvdZxY3+RHmnHJZokKFszAznaCuUgUXxA+F6M+POpWWoX7cTwysK3POZLNitMAauHM6TM6/rDmRvU3/9K7dMz3cXpd9SmqSIu7gDTWZ9YySxAwil4R/A/A02AhoPOJktaxgqfufWm6ot3Vvrl/c0+tdiQ150yCVtnIUtDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773589593; c=relaxed/simple;
	bh=cHsfQEX6nJtrDQcvkGLpiDB2ls4Eg6ZwQbI/nM5TG70=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ciZsvZ5FqIfYBaIheeAYUuHo31jWk2fMgur+5PCaALj7CM74ujzFIaXPfzRP1bSPfXCzQ7OoE5tj0Set+jVuVZ8Qcs8RhH0GYPYvJNiPwGqmjOR5aL3aNbcE//B2NhXlX7pdiG/qBzhVfVPpKApHF7U8zlKW0XKRJhl5gMBReXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S1Le3zAV; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S1Le3zAV"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-483487335c2so35890425e9.2
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Mar 2026 08:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773589590; x=1774194390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VgZy+Q1L27OWqLYYEqVJekt4sFF+frCP6hIfuOIBpPA=;
        b=S1Le3zAVfnqrhswZMfa4Xsdq5NR+MTVL9ZPUpks2aU/jkMBv3zzvUAuugOdti/QppP
         esRpQ32983P+fd4UjCCoYuMVbicek2Cx6h8JGVUQP+DB3vRvGXHKqolEbsxp1ugd0kOc
         GMRpuW16S1MrHvt2NqFW7DljZpTyxlGm3g2wktTg/P4A9xMJgw93R5eLrZ8I2jwlxIzq
         HvGHB5/OcLDuERCT0nMY3/0JdnzAOxL9k1uEKOs6PD2MjwkqlR0niCfdWQezwc+PdM/S
         Kn9teIpYrLereAAnqg6wlYXxJBz1ycPqXSzHwjw622H2NZuKmBIE0vlayCvvw8DKc7YH
         hRPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773589590; x=1774194390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VgZy+Q1L27OWqLYYEqVJekt4sFF+frCP6hIfuOIBpPA=;
        b=XIzRjvwDo0TNJfRmsOZD/4yEk6kxcyRxzM0l0pv3BWk+MaB4cPKanCQDR5Ke1NaVjx
         gYOKTjjEOalxBma6qbQ7sNAojEBYjk7eaYdeRobm72O4UQoOYuPwMNGePXvSD0Ru4nsk
         1+FX07tYLvV7AqPdbvn3nCHmaf2O9liiRImHGCb7z1TtdU2Scv2Inw6vncsf0BLsaiEL
         ALzlDQmv/DvDPS6tYh4tXqkm0lS7lyqh8b4mNu0ZN2N6XNKID6VNon72vx+N7a5SQ7wV
         Ee8tOiLObtiBDBGXF9DgoYG9Noaf+5CVqX0OufBQOjBDzkXrc+5M3u/HKVVhlPyHFG7N
         VNJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdeTdKMHR1TWZ1p7CCHCtrJZxezWA4BnAV35aFvx1Id2jd3dQk4H38bDyRHVxa7ccH2jPDsKynfVQIJflEEJo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxST6PDZb7w0PlNPr86qeBsYbNXpySXrlObH0hymg7lNdwkbhK0
	WWYIe4KdyfFWqu1HTsmAsg047R5L8ZoJJh9hmAI58q/AceT4LgKh/B1E
X-Gm-Gg: ATEYQzy2EA/CfVtMmwX5N+nKTMhV36BMcirsFHxJUHhfbwMYKIsJwZmybsUVYJghdYn
	Ewt8/MlIHOEL5lccN4nRElA0mFsB/9x0z+WXqaI8xPMUrbvACu6+cR6fXbAjGSucyY4LCATV7Zx
	E2E5GR7i3LkgZBallihAHEjeF27FSG43OL4xSrVrBJJVQCnXMkg5LH0iRSi1QpGSfE++oPbpwPp
	RB2L/qtJ5Qqmo9lXoT0ipDU68KjjdOFNaLw6DeJsCvSzvIqLTd2VBKnIGaJwhLj9E6Dz96RUgTu
	LNOR2yUUYZ7VlmXxH923nl+RW1urE9cihdU/8eJXYJpYCevZn30yWzXxAYrR/KMa+066wpysyo+
	8g4eRUGB8E+tGClkbhGsUl6fmS579Jlk3EMra6u1Grb9hhmCTvrKvQo9IpbF3jBLNUPAjuIrqbs
	0051B3HjVALc+LQoHJzwfzznqfpmD0VqTyaJSWsC4n8Pu9rzNaN43XaHDzQZmALOE3MqDeXWi9X
	hD9paHI4dduhbm0A6cMBJQQUlgohs1PgOpwgdCZ
X-Received: by 2002:a05:600c:4753:b0:485:3a93:3aa3 with SMTP id 5b1f17b1804b1-485566d3094mr163674105e9.12.1773589590016;
        Sun, 15 Mar 2026 08:46:30 -0700 (PDT)
Received: from DESKTOP-TILNSD1.localdomain ([139.47.104.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b6070acsm312793115e9.8.2026.03.15.08.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 08:46:29 -0700 (PDT)
From: Kit Dallege <xaum.io@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	Kit Dallege <xaum.io@gmail.com>,
	Claude <noreply@anthropic.com>
Subject: [PATCH 2/3] netfilter: add missing kernel-doc parameters for nf_hook()
Date: Sun, 15 Mar 2026 16:46:19 +0100
Message-ID: <20260315154619.50964-1-xaum.io@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document all 8 parameters of nf_hook() that were missing from the
kernel-doc comment.

Assisted-by: Claude <noreply@anthropic.com>
Signed-off-by: Kit Dallege <xaum.io@gmail.com>
---
 include/linux/netfilter.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index efbbfa770d66..a67fa43955bd 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -219,6 +219,14 @@ void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
 		       const struct nf_hook_entries *e);
 /**
  *	nf_hook - call a netfilter hook
+ *	@pf:	protocol family (e.g. NFPROTO_IPV4)
+ *	@hook:	hook number (e.g. NF_INET_PRE_ROUTING)
+ *	@net:	network namespace
+ *	@sk:	socket associated with the packet, or NULL
+ *	@skb:	socket buffer holding the packet
+ *	@indev:	input network device, or NULL
+ *	@outdev: output network device, or NULL
+ *	@okfn:	function to call if the hook allows the packet to pass
  *
  *	Returns 1 if the hook has allowed the packet to pass.  The function
  *	okfn must be invoked by the caller in this case.  Any other return
-- 
2.53.0

