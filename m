Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1372480968
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2026 20:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785874318; cv=none; b=Bo7J15KU/8jCfDCd0s7Om4ULFco2f87xdGc1Ucm2j17PTPT+POLLk+Qh5q4wKm2l0c9RHrVXqjnGkY/jFMS0kYQMiiF0a5DIRh9mWPH6fvz5Um5wDGpEZ0txhmcH5fu7loZj534+LwdmE07yh5CIT8p1R3RPPYJd3GlUKIQ2+eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785874318; c=relaxed/simple;
	bh=D5VOEQjUcgxGJV3YUdOgz0ueZlhARhxKU1C9Qnjncnc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NfIt63/81iRROtEQhkqLPXnhKzSUx6T5dgm0vSQV1XTpIPtKrWOXveRyaFVZrPLNXBMys8bhxQV/JcAW7W9TKFflAVivlLPcERouwYCNWpuXYaSi1rW8SimX3GoHF24wkK2kUq5GUlrZE8M6XDVvMVFrFwqc+yb9InSTxw9qLf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eSEjiaC5; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eSEjiaC5"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso1312905e9.1
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Aug 2026 13:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785874315; x=1786479115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JNGIDbwQT+Z5SX6USDQYc1Kl4Aa2uoNxfSsfqj3vOls=;
        b=eSEjiaC5aLQ4aAAJxcWOAPTH/09t8orsJeenz8F8qqUg+9+ADFUkFGRnx8m192aQWM
         +Rh+qGmU5cS4VQEVbcB3W2bM2zpAKcEhmgBnYHrAD9bh5+JDO4qIkb++KD842YLNJ7U7
         aPUabXCL9m62ClpywdFDji4/rxHYSdOepINv/YYLuYDa5EiTVZBvoHjQ+HgSioSne1Nz
         qne1a9z9QfTzSsheMDoja17WvUJfgj9Xf08IprIXBLllxxQdOAhKOQFGWh7BWM1n7CWE
         M6vasPHFu3bsyyTojgM6uZgvnJzxQcFukfFATOEWcx8cAIigEmlOklOIXFJW1rB7qM3F
         EAfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785874315; x=1786479115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JNGIDbwQT+Z5SX6USDQYc1Kl4Aa2uoNxfSsfqj3vOls=;
        b=M4RQR/6Uc3YZPmUk7lT3qI12hV+LqkX/Q2mlc85Ow2DcuJhGdtFyJmg7R6xhe2Ll3l
         j9vt+IQ0D3RzzfQIgO8mNaCB1I99eCrvfQhSEUkCU1HjCyliRN/XkG7dAf5gT++13jKe
         CVPevc4ciWsjccUbq6V71t9xlIRiI41SIWjY6m+W0jcl4Hr98HozUJkGyxbPXHbGLpXS
         QsrAFiPgvWrKkyQSl2IUrK/irq0cMzKMKSF0ezw8bOCElwZcK/qKCvc3SHjjgRpH7wvg
         je5F8riN5Kknc3NSbBixzmeQQLDwK0IuKzrDs0zfAC/gj/KkTbHkzXhJYd5MqwKkxEQX
         TJ1g==
X-Forwarded-Encrypted: i=1; AHgh+RrbMaPmNPV9FKM1PkEBd2EIKtdSW5RbNwtb8hYBbXqgcANrCfjcyu07yJVD6mLVrx7pRhR9dyxnmayZA3WHwF4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwW8FZ+lM5b62qNcxfqUemSkMBdyCts91FHi4FTChp8+hbLvjaf
	XNBRhhC5oFGxoP7Y9IkB70KwRGYpVSFnaAdyxdpxCDJVFuNegB2u1asv
X-Gm-Gg: AR+sD13ds6BS4uXHx49m/Ku9aZkE32aRgB8nqrArmJGqnyFOEWTH1lZ22Tah0oFekJR
	px8AdM484na74lmQDwiJVsxwJo0WVDwfykP8jg1AM3rRUm2XKdSE5aLLYbdtDxkLdUpVXPactjp
	rQlweq1jbUkT2fsG7uyI3wn7eGSoNyBtYtkLtuE/ibhZS+s4mfGtR7uZS4myhcIw/WlAtDepbAH
	UJtywTo2mhgpNIkMBIAX7LxNdd9RnLjP/wrMZaCB1V5PJYpyVwvOpAZYxo55O/8kR6cwjXDgQRJ
	/mN2r9YqfkHulBOP/ifc3ZyuU20EDEEiQJmQSd/ayeQRqb/0v/OztIkuAxnor7kYRtgqFjH+VAp
	ydyO0yqCX68x6ZiXg5DPGr60ESQm1T6jPw5q7NGAXE8PG1AhOS42SFUoc3A5wJauqp/I6u98t+g
	2pxu4uYI0W8YvFgvpJD3YBMAedMG78WfSzOiUXN2qARMtmXQ39VlJOPMp2cvrJZi7VtHdfgp3Qg
	aKXmwY/TIz+MHb+bBu/U6DjrweyPKBsMDDc585tg/v/6QgTZeHcEiY5vw5BJQmaZrDJV3/WAAqn
	wvpAZudDH20FACds7dGAJ7psHhLSKJ0pX4x60aqoudQ=
X-Received: by 2002:a05:600c:37c9:b0:495:4b24:1b64 with SMTP id 5b1f17b1804b1-4994e6eacc1mr13592935e9.0.1785874314990;
        Tue, 04 Aug 2026 13:11:54 -0700 (PDT)
Received: from thpalex.rd.francetelecom.fr (2a01cb08943588009f8850ffc9c1993c.ipv6.abo.wanadoo.fr. [2a01:cb08:9435:8800:9f88:50ff:c9c1:993c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4994e0356d4sm25752775e9.10.2026.08.04.13.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 13:11:54 -0700 (PDT)
From: Alexandre Ferrieux <alexandre.ferrieux@gmail.com>
X-Google-Original-From: Alexandre Ferrieux <alexandre.ferrieux@orange.com>
To: coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: edumazet@google.com,
	alexandre.ferrieux@orange.com,
	netdev@vger.kernel.org
Subject: [PATCH net] netfilter: nf_dup_netdev: scrub duplicates to preserve the direct path
Date: Tue,  4 Aug 2026 22:11:50 +0200
Message-ID: <20260804201150.16364-1-alexandre.ferrieux@orange.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nftables 'dup' action clones the skb with its full glory of
metadata, including references to its destination and conntrack
information. As a consequence, a link failure on the duplicate's
egress path ends up doing the same as it would for the direct path,
for example invalidating the original packet's destination, which
typically breaks all TCP connections to that address.

In other words, the "dup" path has the potential to wreak havoc
in the direct path as a consequence of secondary link failures. This
is very bad behavior for a monitoring tool, which is the most
obvious application of 'dup'.

This patch fixes all similar scenarii by calling skb_scrub_pkt()
on the clone, severing its link to precious direct-path state.

Note: the second argument of skb_scrub_pkt(), the boolean "packet
is crossing netns", is intentionally set to 'false', as a 'true'
involves exaggerate scrubbing, e.g. of the timestamp, which a
monitoring 'dup' typically wants to preserve.

Signed-off-by: Alexandre Ferrieux <alexandre.ferrieux@orange.com>
---
 net/netfilter/nf_dup_netdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index c6bd5c29bed6..0f47a2135955 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -63,8 +63,10 @@ void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 		return;
 
 	skb = skb_clone(pkt->skb, GFP_ATOMIC);
-	if (skb)
+	if (skb) {
+		skb_scrub_packet(skb, false);
 		nf_do_netdev_egress(skb, dev, nft_hook(pkt));
+	}
 }
 EXPORT_SYMBOL_GPL(nf_dup_netdev_egress);
 
-- 
2.47.3

