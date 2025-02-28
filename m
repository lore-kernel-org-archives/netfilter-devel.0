Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E0D1C7018;
	Fri, 28 Feb 2025 20:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773781; cv=none; b=C4QPmHDbxqC31TyoFpt9mpSRlRiJWDaPUM5+91LeBhxE6o0XqpCk2ATbarC8nvsvPeXLo70JlgGKIugb0FCIF13FhfObrnvWZ6PENiYFRNRRYF/L9oBmurrJshBt+a4TZ8pkC6/vDafFTNt1krunBiNuVoIV81QZG6YVHlFHogs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773781; c=relaxed/simple;
	bh=Fbp3oCenr8igYjoHqNHoL3I5wq9RcaWF0Ekl0eI6nvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ueeuym4QSjv92BDgcm6rWW8qrWq9knuWnwAgH0QLFSdGxireqc/4v+vh429fEdOd9btSEesv4bK/KGV3q4lcXiLVg5OONC7PzSB+HP/Z/aTO4HCrnf4eMdXV04Mhzk+BsXFhj3trxMMb+bCCXOjf7DjHQAbFVQEPaSJsKoeiBNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F934oh3J; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F934oh3J"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-abf4d756135so23811966b.1;
        Fri, 28 Feb 2025 12:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773778; x=1741378578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fA9Vmw88RokN6ZVcNFAMZ81OI6e/RLQJpo3MGu4wt9I=;
        b=F934oh3JoHqH4pA0xRajUqpm5kuMDzWBKONQ+tdXA4KoFio5YNPcfOFoc3uqpqj/vW
         G8ZkX3ctCW3l4WOu4XKhsZN5MCYwyR6675Ini3cjK859tNyglV8dIBl+9P4Gfd71kON5
         IPUOl74H1bAGL58XjcQxA3ta+44TTHN7uFM/6vzTLT/BhMSdTape42uS++ewEKs7jmbz
         UESERnDzmZFT3b+klSV/H5NgPLsKJ+Wbikb5ZJkk/nNeBGPZnd4bGKp+dzdZMIzy2hZW
         Zqv149VSmgc+s7K+2VXeBO/nIuJIsZrU7o3lmi9vKZIHf1xRP3+SY+uquIZ9fUJeyVXP
         seuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773778; x=1741378578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fA9Vmw88RokN6ZVcNFAMZ81OI6e/RLQJpo3MGu4wt9I=;
        b=PlHrVX/o5poaJMU5KM1sin+Zail4fLPwTiOJnZirJsrYj2FIj6gUatynX1T/qvguzx
         tEe4oLuNVUPjX9GMVOR5RecJeEoeYaoo43A6KAgPiGjxX1xkRrIvxXgylnpRZGOXou1j
         g7cVdw71nE73TMjvvV6fdFAFVsPn18r4w4sOIQJQO/tc+RgIKai0nhJLgTUDWOAOKK9i
         Lr7DKtSBj2gy9+BDNouZfT0SbLYT6lGWNGpcvxDeHe2tMihfMIxMDUrQTwRetmfN4zYz
         Z7CXygReGHSRDQ2S21XXpRTd+mMKQO1PYojxJ0wweFt9bLQ3kBSyB2BmdAl9mZSVJNDi
         AGYQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1/crzf7LWBxwPflKSDXPoQwssBZiTOAnhnNZu6iEgdaEKBOSr7faZ+caozFxSY8A/7ewJXPZPO2uLfHoBksk=@vger.kernel.org, AJvYcCWKuqnuriYyJ7qJcYwAX6oWjbn4EbJUTbilUWxwmpuRigeNjqlLf5s+NAeWm8s4Ez5DNyB4Zzyph53rZVeB@vger.kernel.org, AJvYcCXDyvASwzTa0B+lS7xGoD0cbsa1QLniG5pa99QtYRkX5In6wWJrx55Sgb+YPKd/ZWWBelUnmnZMant7moO8qE4u@vger.kernel.org
X-Gm-Message-State: AOJu0Yzao1akpwHGK+YrhWYIyAxxl2T8uS9pjh8LdvFtcI3vfhebNsCv
	mu2UvferwLMS2xRoN2UP41wUtjM0ny4y3F9RZ85XCX/jTuGbtACS
X-Gm-Gg: ASbGncsGD9hKELuZEi9KccFeMU+inI9p41Mn/wnkSKg7NMpfDBTNitQLOetzQGLwz5q
	viAuqfVEpdE9A9e/9WLC2lenc/Z02PgbYfruRiikdBRuzdT7eQEPE+z6QoJ19JNEw9vHvu85v8v
	Od4NoFnVDPY8u3BslLp97aiwpOYnTfBgA/YBm4LD01CB2LwRYGW0tAMQlvGrNnohMsE314H3ou2
	0DDo63b4jR6b+UCiWnIYPKax0zYEp45LoaBiNGTvboLrlxtMtMke5myO2ETKTwCipAyl8NwJnM+
	JgtynIkaTJst4CYtKuvqB1P/BwwDLa03G83Eru8fmi4Tx+QC5VqeVH0/R6EuIBnA5/x2h8Qd1Cr
	swvTpR7jbDlC7H2UpNQ/fjmWVDn2GuifXTFAxMvCQ5VY=
X-Google-Smtp-Source: AGHT+IG9CXfC9QShMuEkr891X2vbkzQ2uh+igw8zIKBPddpTAHKgNLtJZSPLkYYg96Gm41ClW4AX7A==
X-Received: by 2002:a17:907:3206:b0:abe:e981:f152 with SMTP id a640c23a62f3a-abf265a2a06mr522572366b.37.1740773777757;
        Fri, 28 Feb 2025 12:16:17 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:17 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v8 net-next 01/15] net: pppoe: avoid zero-length arrays in struct pppoe_hdr
Date: Fri, 28 Feb 2025 21:15:19 +0100
Message-ID: <20250228201533.23836-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250228201533.23836-1-ericwouds@gmail.com>
References: <20250228201533.23836-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jakub Kicinski suggested following patch:

W=1 C=1 GCC build gives us:

net/bridge/netfilter/nf_conntrack_bridge.c: note: in included file (through
../include/linux/if_pppox.h, ../include/uapi/linux/netfilter_bridge.h,
../include/linux/netfilter_bridge.h): include/uapi/linux/if_pppox.h:
153:29: warning: array of flexible structures

It doesn't like that hdr has a zero-length array which overlaps proto.
The kernel code doesn't currently need those arrays.

PPPoE connection is functional after applying this patch.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 drivers/net/ppp/pppoe.c       | 2 +-
 include/uapi/linux/if_pppox.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 2ea4f4890d23..cb86b78de429 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -881,7 +881,7 @@ static int pppoe_sendmsg(struct socket *sock, struct msghdr *m,
 	skb->protocol = cpu_to_be16(ETH_P_PPP_SES);
 
 	ph = skb_put(skb, total_len + sizeof(struct pppoe_hdr));
-	start = (char *)&ph->tag[0];
+	start = (char *)ph + sizeof(*ph);
 
 	error = memcpy_from_msg(start, m, total_len);
 	if (error < 0) {
diff --git a/include/uapi/linux/if_pppox.h b/include/uapi/linux/if_pppox.h
index 9abd80dcc46f..29b804aa7474 100644
--- a/include/uapi/linux/if_pppox.h
+++ b/include/uapi/linux/if_pppox.h
@@ -122,7 +122,9 @@ struct sockaddr_pppol2tpv3in6 {
 struct pppoe_tag {
 	__be16 tag_type;
 	__be16 tag_len;
+#ifndef __KERNEL__
 	char tag_data[];
+#endif
 } __attribute__ ((packed));
 
 /* Tag identifiers */
@@ -150,7 +152,9 @@ struct pppoe_hdr {
 	__u8 code;
 	__be16 sid;
 	__be16 length;
+#ifndef __KERNEL__
 	struct pppoe_tag tag[];
+#endif
 } __packed;
 
 /* Length of entire PPPoE + PPP header */
-- 
2.47.1

