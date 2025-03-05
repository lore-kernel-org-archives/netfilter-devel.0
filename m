Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A502C209F5F;
	Wed,  5 Mar 2025 10:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170614; cv=none; b=ufWRqdv2r19bL4Jv+xGjaYovXjfpgnLFHKVY+CTk31N+F4xIYBbjayiybAK/CG5dO6N+UeyquUBe/1VvsW9DRAPE0iH/lTJk40FkxFrkuygQHQTMNfe/X/Cwsl5t1pXoLw7SdomV4h9AKdfPGWypl4LISqxiQIW3/QTjTHTx65o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170614; c=relaxed/simple;
	bh=WOvVk2IW6QUSaxpGvpwW6W6ywpdv9Y60/i896yobQ+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHK//LA72xYEOKMxL3l88OKYuAfG9sHHKdXfH3ijk3uprE1kVTbjSiuWFPxPSFei5ZMbkdcLMTqJ1KMudtNiHALJZPjawkC6a58skKSQNL3pu/bvmvzQnUEH/29QACpHOgliXiOd83T5JB3pQ0FlVwKeT2cmwwpnuIMFecZoPn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PXmWDMMp; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PXmWDMMp"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac1f5157c90so291427766b.0;
        Wed, 05 Mar 2025 02:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170610; x=1741775410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukwtTV0ExXBJKM7v4LhbJXSMG6hQJqW8GgzzDxNF23M=;
        b=PXmWDMMpyaFdB8RKyprs3/vUc6WxzDtRuN5iaT4YKQNGpWDFTjexdOdlJkrYNNX9Oe
         coAmECBPuv1iQbnJ1A7zfCZ+8+4YAzOF2pI/ALnSM36ilEfjnNIyRso/MnC/YgUP9VpP
         /IN5b7CvIMwNKJPojZ36iDk9R8d20BEObc+v+lYqL6VBFHWa55DiZ1q8D9GlS0R5KZSe
         ckcLYU1wUMNQPxU3JJpg99NGqN12LhE2iWG9TwL0MqX2y2N8pNjX76NV65CJ8n401zJ9
         UO7riDBGMiX7tEYvR8AQ8LnH95j5v/wmIyZ9Y+qQa65xOGodG57Lifx9JhwghZ2FocPf
         7fYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170610; x=1741775410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ukwtTV0ExXBJKM7v4LhbJXSMG6hQJqW8GgzzDxNF23M=;
        b=UG/9TskEzSuj+Th2hYoXTRgjaru6jH0Of27saIuwtqHEj8eKNmr7KWKc4IO2DFjkt4
         iTl+IvUSA1t2sHHQ6/SHR8/NsFOHRd1+6fyJrzQZmheEGtH0e7DVorgQrilJf0HyRGFT
         BWR6prboRJOzmBj06iDw4NHvmArv4cWztllk79cm6eGns9pNoZCg+jHTFa2dbpkClbu2
         VrGrKqi0Rexb56tyQTd/ljuC7qUGaVJUsy277QcgvOXTP0RPRlc/WhH3iS20ixr3PX3e
         4cgByF3tgm8A6HPf/C1DPbq1v2vwaQXQYcxA9jYEFbg5MVM23NO4xrrgvre8DlOez1+N
         Wc/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVLXwzUQGHMsy5lAEQZmIuXMivrkU4oGKD+vfJFgZlk9s5ZY2oQtlkY+FkmeBdA9ARlh4i1xjbB/0jYf/B8VNA=@vger.kernel.org, AJvYcCWytDEDS+X/uw6rMHiymgPIo27DOVgRQDBdEaWrCaKyn7mbbT3sL3Nwy2LXpI7rZVbiePVkkGBFHpD5fArbeCou@vger.kernel.org, AJvYcCX9vDBq+9JchIdFYNEleIbYlpojayTIDbrEOU4REwvFf0YXMMOS5PeuBNx1tHIEct22z6zqfaZsiZqU6d+0@vger.kernel.org
X-Gm-Message-State: AOJu0YxdR/Q7KYxMCf+gUl2UOngEqx1hGgFcwn7IN0kEzW3RgqyU9l0S
	rtF1fVSH62uflcjZPM+RAG5qKm/6Dmp3vHykl14OQMBu1Q977Dtc
X-Gm-Gg: ASbGncvTqQi2N/m46GN5hV6DC3XpU+2g+ZTCKnrJ8MrpsrLb7QtMxhuR0OCCOrZFGDH
	asTraxBVjI0qWrItDnvbbl7ArBW0y3g/J8ZCSLkBq5hHmpSBp/KZoWv8aSgVbfZdsEz8DOyT3Jl
	VvuBhS7kERBq0iaeYGIEDKofRriUJ7FrZbO+BOSG3OCH9bK5AizGnVefhYkY1U/kh8avituTjDx
	Pe6CQLnupA0x682XbFQEN1b5SOLpAA1KVcA4QKnLoOiSkjix51F+62Lu/rf9OyUm8HMAelCdrZf
	mvx03JZiYB8irCdvZjA/wwJdhDMBMoWiF1Yc39BJ2HnUSJ1xg3xqr8zqNthy0AWiBdABN3MlxbH
	ePpwBHNB0IGgXNjktPZyGXWK35CqEB0TGBKsRXy6VvM5uFAygu+9CywwoYgDjWQ==
X-Google-Smtp-Source: AGHT+IHxPPtoLfRPnCkh6koJ/eG/1JnXDYqS7eXulrdGgVMhsQC/yU7G5LKQ+8CrzPKHzBnta10/cQ==
X-Received: by 2002:a17:906:d54c:b0:abf:6f37:57df with SMTP id a640c23a62f3a-ac20e03ab40mr291110966b.51.1741170609587;
        Wed, 05 Mar 2025 02:30:09 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:09 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
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
Subject: [PATCH v9 nf 05/15] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Wed,  5 Mar 2025 11:29:39 +0100
Message-ID: <20250305102949.16370-6-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250305102949.16370-1-ericwouds@gmail.com>
References: <20250305102949.16370-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds the capability to evaluate 802.1ad, QinQ, PPPoE and PPPoE-in-Q
packets in the bridge filter chain.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_chain_filter.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 19a553550c76..7c7080c1a67d 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -232,11 +232,27 @@ nft_do_chain_bridge(void *priv,
 		    struct sk_buff *skb,
 		    const struct nf_hook_state *state)
 {
+	struct ethhdr *ethh = eth_hdr(skb);
 	struct nft_pktinfo pkt;
+	int thoff;
 
 	nft_set_pktinfo(&pkt, skb, state);
 
-	switch (eth_hdr(skb)->h_proto) {
+	switch (ethh->h_proto) {
+	case htons(ETH_P_PPP_SES):
+		thoff = PPPOE_SES_HLEN;
+		ethh += thoff;
+		break;
+	case htons(ETH_P_8021Q):
+		thoff = VLAN_HLEN;
+		ethh += thoff;
+		break;
+	default:
+		thoff = 0;
+		break;
+	}
+
+	switch (ethh->h_proto) {
 	case htons(ETH_P_IP):
 		nft_set_pktinfo_ipv4_validate(&pkt);
 		break;
@@ -248,6 +264,8 @@ nft_do_chain_bridge(void *priv,
 		break;
 	}
 
+	pkt.thoff += thoff;
+
 	return nft_do_chain(&pkt, priv);
 }
 
-- 
2.47.1

