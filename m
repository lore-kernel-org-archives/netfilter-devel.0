Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30480372EE9
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Mar 2026 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773594421; cv=none; b=CS+JLVMjzfQVrmzz8cuyaYh7LLG0K+BJq8mj2wxFfNGwxIf2rVdTIHNiVkKOoYu1w1KIRwm4Nvv9F2a9fpuhV6pCKmz7R8umZ2knJoNvVa6QYzZ/kjx4+/tIJeFgpPD8XHQFEAdfryO1dZ0jDXItKDLXyud6I5/5xnXyjeXvZjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773594421; c=relaxed/simple;
	bh=eOGpMA8qVtM90PA4Wysawgv/ZkvGeglP7kk/8/jMk3w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fEHLASzXqQAo+LCsoOMAmcHJ04FTOAGtlkaAS4wD6H65CDEnWc/F8IXX1mN/ObbasCnI4UnTyGarrG0I1wGZMI92TT1rXfxo7oI7BHDvVXr/L7Ar1UYlDMBd5wLglRc9Pnfzrj9szUI5bTtRRLEx0UgLefvY9TK87wbBDjmmv8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KUt/1pFE; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KUt/1pFE"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-439c9bdc1eeso3938825f8f.3
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Mar 2026 10:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773594418; x=1774199218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M1z8UWOd6RkMrQUKtKrxFU+DDrBHIpszvheyTcnYPWU=;
        b=KUt/1pFECdqi4Db1CBTp9Hmhs5TDubc7xKwDSUXad9rvC9iut6pC/lB2BHkVGn+9ta
         AdltYWoCJKP9uF4GcRhC6aO+N1ZrzDIR8GmmDkxrTMkewtnJjvQ2kRz0SlJYJfe3gYDh
         keMiioBjRTyuKnRfikshnoK/UtFXLPxj/r7L5rWKU3sZIpq93W/1bZwlNM0YVSEUc7Yc
         u4hi+eT+bTo1EIS2CFCE084pCPDJIgKy/10HEMFiyUXnIUw/VUrEdj0lXCUS5m6XPZWT
         Y5AXTlp8qeDLUwZJQKGgqR08vKvb5bKMLFhjvIG5sXU77esH9FTTyCU0HqYQxwhAbTUI
         w9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773594418; x=1774199218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M1z8UWOd6RkMrQUKtKrxFU+DDrBHIpszvheyTcnYPWU=;
        b=Nrd4L/c3ol8r+7QwGz3aqh2748GYZ2poRN5OVyCyzAuStD3Bc261spiZzZfJV+gqq4
         kr5kEgvO4U5i90DG7Jz5jQcQWUPoKVZMkTMyAdCn9TJhMcHUQtNsxWthjxSvxajtkRPh
         2CNsHr19FzoEIKmwfBoDaoSV+wXW3mKI7KLji5k3L5eGNEqle584QYXeqqjT53lb5MuB
         983jedKwGuC2rn5DEXTpTdZ6YCogBlc+ATJe78nHQxV1dKN1us5aTXXJSC8IIMh8OEtg
         TVfa/5JcPJFWTR2fa3VRreiHLcCMgyVMTwxPzK0mScQMIH1qLMl3XMRXwG90VT6okLp+
         1o5w==
X-Forwarded-Encrypted: i=1; AJvYcCWR+UhDg08ZgBsZSt4WPf68ikFM7Ua2txOrHDtCi/LAyn7rtNi86TG0ESR9Bqy49D49mpz5WuesyLkwmzL5bJY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/hPyelqrmMPzpb0xwe0RozNZ1jy4ON+CNlBIpnGjFHDbm0J3V
	sLEySzqVWpB+dspsKLxf14QkMqeNvTWbLFQUTyZ0jv1M/2V/UQl1I8bYq1mTWi8hKvY=
X-Gm-Gg: ATEYQzyN2okUVEiTCosT1Vjd7AkuxdtWZ8abHDlhjmYNTJ/uwas7JKH1lbfndXxORNa
	IaW+JchhSobLP6lE6ZKmP5JbgghamQ+3BeTok6GLIc/rr0W3Apxv8APgOwvP5vKeN6tewL9L/UD
	2oHu0ZHFx6RvysMprbXbuzEkI1IwozW6vc2tul6YoToywF08Kkm4OMcLymPE0ApxgjLRMMCuQkm
	FSgVvwPZExpFEGpdP4yip3scH6cle3RK52jdgpFhZuui4muMLPO/SEiToRlBlh+0oOWpqjl9djh
	iS+4YnrFwtOAXMPfcGqBU+XZ2O1jWyHpgL2fBZ4jYhxSLbgmVHokxk+bjIjbxefUcbc97hXGC4z
	IKz/mYeTwGIcgHsAmvqdpDfhHYufAOlq0QSd/6dDvASVJIbQLI6iMIqTm0T/EbhGldGGUmtX7P1
	0jZk0/J3d5TrkAaPrAv6x629HuxxE3UD5HMNT/ws/fsiMJ4uc4pjgumgWOOEqjNaMQMBqqn/9sc
	NXp7oqXIjkMP6ck/X7/p8RoIjrfJQ==
X-Received: by 2002:a05:6000:22c4:b0:43b:3ffe:be70 with SMTP id ffacd0b85a97d-43b3ffebfadmr4393586f8f.20.1773594418415;
        Sun, 15 Mar 2026 10:06:58 -0700 (PDT)
Received: from DESKTOP-TILNSD1.localdomain ([139.47.104.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe1affe9sm36599863f8f.15.2026.03.15.10.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 10:06:57 -0700 (PDT)
From: Kit Dallege <xaum.io@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] netfilter: add missing kernel-doc parameters for nf_hook()
Date: Sun, 15 Mar 2026 18:06:47 +0100
Message-ID: <20260315170647.65044-1-xaum.io@gmail.com>
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

Assisted-by: Claude:claude-opus-4-6
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

