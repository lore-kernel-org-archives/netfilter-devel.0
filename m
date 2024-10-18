Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EAB3207;
	Fri, 18 Oct 2024 13:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729257481; cv=none; b=NK0koEAnwtMAsOu5yaVSF7f+VoLaEwPYBFq+f/s5FCPjZDoWZkt0lECJ482KgnQDa0xxwySZb5k0AkEy/dvLPTgclk/Doj9edE2gSIDyQRmElFiSCgXDHMn6OjejPdXdSwbwxPAUtlDL6yVtIqVo3RkshX5yOAmQ8UAwWMLlpW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729257481; c=relaxed/simple;
	bh=HPXtxo5Vvpr2Etua6TwUK33NA6Be2AnfOMNRunrFSgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gFuXnnF/OZes5n9X2ZBP0K/9gW7v7nlkxEiuXh2mfNqL/TdrtBnaVJb8SkmjFwOlBsM+rzv2dZwiZZKV2qjVF/XiqIUhrNCaAz5Bxv6URx+WvIn/n5gZ3TuyzheCNu+ltNI6p1xcMzYpY/+Jt4eEM4vaN15MRtzaDuSudqGHSx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SlKgvb+e; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SlKgvb+e"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43158124a54so2544405e9.3;
        Fri, 18 Oct 2024 06:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729257478; x=1729862278; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HYTC1KKmj1Tx4GZAlIt/vCaAXRaBVXXUSQJlK1KgVeE=;
        b=SlKgvb+ejWjnjO+trcuov/kNRLiCQeP1rl+ceWeUFA5Kpj1H+MaA9ppQneWKSYipQz
         2I9gsQjzcf0yVPLBnIxNd3c6zoNsfnEUxfVU0bitnFAppEH8D8y7rB1dTMG1Oobc85Pa
         +AjhhyrW1DXzfEzj4TggmcnjmC+GPOTLrZTqICXX3qYd1uw4i5nwfyx5OZr4fD5KYRm2
         sCkx4AnnNI/++gHmUrrW6bORvGp5rU+CU/wzZx+VuYNfWMfyGVLIq9Fb++XRqyhb83P4
         Asw+c/Wq9l6SMLlNFOcAGPzzDOrdFCejcv8wdOdjB5sZHHMM9PO+hxGBxRB/cj85Ub3a
         xyxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729257478; x=1729862278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HYTC1KKmj1Tx4GZAlIt/vCaAXRaBVXXUSQJlK1KgVeE=;
        b=JdCB1HNQOJVS4YZ+4fhTPpC97b2XGmLyEfF0ixwVkyw7Kwu0cDF9Nmw8Xz6IS4xhHi
         ToD6f1YvltaaKfBKCDgVvliyqtWdqp0sBNlugDTViwj5GqMF7kugWoZPzJmVT4cmEe5d
         ZppZ6IWyTV82Yr+CuYpn6kh1CsGOHAsnmKdE3do73ZC3X9X2BB9kHQ22YHf5eI5fA5BH
         AUdaGiWFtwm0iyc4tN4/70T/TV5m3yKbGkFclJpkrGDGk6wm+5aFm2nesLmYu0J8vJ/C
         jUGXlV/4SXQBgwhTnt0yUTCocHrR+e6anS9Ko304WqKNvLoGou0aQxmj7Qnkn2rB7742
         G1sA==
X-Forwarded-Encrypted: i=1; AJvYcCUlAYJluDJUuMsujy2vetV9To1gquWGP5UH0PHBoqAfFOxmEU3O1Xatd7jYHlKZw9pbP9mel8ev@vger.kernel.org, AJvYcCWk8aEiJF7oki3GfjPIUxHpmafSHWgUFz88hPuzLHav7sQggIA6EA1kI7+zVGxDbkhwLWOQKvre0vksoNQ=@vger.kernel.org, AJvYcCXGJUQt6stym4bVVPT897PLXAiedbTt6lP4EJYsjoyjUlNwZ+4H3Ilxn2icQthB2JPp6OvHLiRFPTkAn4WGJ+FX@vger.kernel.org
X-Gm-Message-State: AOJu0YzeQoNlUtySgosbqcDjtb3za0dR2d37ReIKHv3XlkS4onAUa21V
	QId9CghjHDPiAKakNBXta/UMJkgzC+2rJMcC+HoJnjItDGlx3GsB
X-Google-Smtp-Source: AGHT+IEq019Hq1TIXR/qIFJskJJDma7tgLtYd48CED4u+gZEDmakAyaK8oGFTjQd2kcXyOKjRJnT+g==
X-Received: by 2002:a05:600c:1c08:b0:42c:aeee:e603 with SMTP id 5b1f17b1804b1-4316168f7f2mr8301575e9.7.1729257477692;
        Fri, 18 Oct 2024 06:17:57 -0700 (PDT)
Received: from skbuf ([188.25.134.29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43160695d8fsm27244935e9.27.2024.10.18.06.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 06:17:57 -0700 (PDT)
Date: Fri, 18 Oct 2024 16:17:54 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Frank Wunderlich <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC v1 net-next 02/12] netfilter: bridge: Add conntrack
 double vlan and pppoe
Message-ID: <20241018131754.ikrrnsspjsu5ppfz@skbuf>
References: <20241013185509.4430-1-ericwouds@gmail.com>
 <20241013185509.4430-3-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241013185509.4430-3-ericwouds@gmail.com>

On Sun, Oct 13, 2024 at 08:54:58PM +0200, Eric Woudstra wrote:
> This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
> packets that are passing a bridge.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---

Whatever you choose to do forward with these patches, please squash this
build fix here (you can drop my authorship info and commit message):

From e73315196c3143de2af2fe39e3b0e95391849d6c Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri, 18 Oct 2024 13:59:27 +0300
Subject: [PATCH] netfilter: bridge: fix build failures in nf_ct_bridge_pre()

clang-16 fails to build, stating:

net/bridge/netfilter/nf_conntrack_bridge.c:257:3: error: expected expression
                struct ppp_hdr {
                ^
net/bridge/netfilter/nf_conntrack_bridge.c:262:20: error: use of undeclared identifier 'ph'
                data_len = ntohs(ph->hdr.length) - 2;
                                 ^
net/bridge/netfilter/nf_conntrack_bridge.c:262:20: error: use of undeclared identifier 'ph'
net/bridge/netfilter/nf_conntrack_bridge.c:262:20: error: use of undeclared identifier 'ph'
net/bridge/netfilter/nf_conntrack_bridge.c:262:20: error: use of undeclared identifier 'ph'
net/bridge/netfilter/nf_conntrack_bridge.c:265:11: error: use of undeclared identifier 'ph'
                switch (ph->proto) {
                        ^

net/bridge/netfilter/nf_conntrack_bridge.c:278:3: error: expected expression
                struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data);
                ^
net/bridge/netfilter/nf_conntrack_bridge.c:283:17: error: use of undeclared identifier 'vhdr'
                inner_proto = vhdr->h_vlan_encapsulated_proto;
                              ^

One cannot have variable declarations placed this way in a switch/case
statement, a new scope must be opened.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index fb2f79396aa0..31e2bcd71735 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -253,7 +253,7 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 		return NF_ACCEPT;
 
 	switch (skb->protocol) {
-	case htons(ETH_P_PPP_SES):
+	case htons(ETH_P_PPP_SES): {
 		struct ppp_hdr {
 			struct pppoe_hdr hdr;
 			__be16 proto;
@@ -273,7 +273,8 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 			return NF_ACCEPT;
 		}
 		break;
-	case htons(ETH_P_8021Q):
+	}
+	case htons(ETH_P_8021Q): {
 		struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data);
 
 		data_len = 0xffffffff;
@@ -281,6 +282,7 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 		outer_proto = skb->protocol;
 		inner_proto = vhdr->h_vlan_encapsulated_proto;
 		break;
+	}
 	default:
 		data_len = 0xffffffff;
 		break;
-- 
2.43.0

