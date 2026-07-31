Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E6B23394B
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 06:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785479834; cv=none; b=idO4RAXgTpKz7Am5paOsfLG3yGDtHw0bktM1imOuvdk83BCvvQcBKx+3onnbod8QyzNEljCGNYI173L3LB9JdMqqWjBZkppfYtjAEyosoePYz5m4D70jSrhcqf8QjaFc7c9y862xenjIlKuVcLaFhjCDz/euXjvW3SN0zMqwb9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785479834; c=relaxed/simple;
	bh=awBKtuk3P1U8r6U160YAF4cK4MFM4a/YKTdDyMkaeQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfqoW/se8jSnpfk6OWJPZQzLY5D1llPGT5TgPX8s/y0wzOi/oX0Z9hVWTZzJbIfSj2TLCWDj35WuKGxBSaJS+ytflKV/ZtKta9KicgtdY26AOScMj3pRPQfdgCMpZrWMqaODiItg1y1999OwPVsQaQpHIbGOFph3LddynW2xA2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=ogxsZ1iQ; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="ogxsZ1iQ"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-84a2dcede83so982080b3a.3
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 23:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785479832; x=1786084632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d35+JgJtJG1kYmqMSF4QUkguqfOFWu6IqCtN89cldws=;
        b=ogxsZ1iQMTc+jcOuXcaLQrz1ibxRMiQVCxt6/VXnBJ8hvdVGjocR+EiYUq+acoleAN
         /tSy4z5pvt+rJYLxg1HSJjhym3rZjluH78Boy2rKE+xbTdkRDtsiCMAs9N1fpnHtUOGJ
         bF71qRCU1vPcDIwDrnb5Xv/ruTfbYHgBLEQutpBR2mwZy5sL+1YhEMIXBet6vRaiU2im
         jvrPlKsXuzOWX1H9j7MmNZ/3HB8BqL+M80LuD36ky/dlf7NVHDrV1GGcwK9h1WU1VZCQ
         JU8iLQmrEll296PLvXaijKXRx+UgB4uaK0mvdJrNdwB7ciY3NpaNm2Q6GQGWIf5N7LRT
         L5/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785479832; x=1786084632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d35+JgJtJG1kYmqMSF4QUkguqfOFWu6IqCtN89cldws=;
        b=WnT03QUM+1+nDbQL09YrIg3lPDttHQoxvCFkDkuNIgU9li+SyQQrohIrLvHrlTLLzw
         Kcd82se2yRn6Dx6X6WTcAPHMjUN9Pw3IzY1ujQEjCYSgCw2xRYl9UUPKDK+XDM2Dq8g3
         aAcqhz8hddYkP/F36Jxhs93X4p1NqJroI+hLdT5xgnlSxMAT4mvjaYt+TBJebCjS5awN
         LdqwqllL61Bw5SFMbKDzSMd5S+Nm9yv9l5dU1XJsuOTtcu9KAS0VHYy5oVvg1llxdE+0
         QUoD2sg4eauSphtmAaquOISgRHJZfNo35qX7dH2Pj8Tn/mZJGu+ef5pcOSqorzHVDjG0
         +GKQ==
X-Gm-Message-State: AOJu0YzSj3LuKufVF1D7RCeq6LueFfVEvolaKc4KSr9KR9hkyNro8PtW
	0pDC/jM+EIDwHvnmS7o2qNEaMpY78flxiBsWg3cSueNcFRvojONRUnaz1F+HbDLoIYQi0YqdYP7
	n1NE4g0MLfNg=
X-Gm-Gg: AR+sD12TsoyLDPqGFGP5/SbAXmeiR9fl3j6lRWgQizK8VUW+LyFJfpddqFC1xXnlyIs
	q+E/Pcdg4+C3pxiMlqpe1d00jpPyZ0sqK0466XW/Ndg9Rjrx+UYFXPWj8LhC4dRRKL4vPtUi2ox
	iB6BPo3wyYmZDCsMrE2PLTceltExp+F5mGAclHkM8qkFDLnIzjtTGrJO0UaIixLPLrNVvv5wvKx
	TjmIcmtRc/cGi+29WbWet31uvRKw+UT6/YZ2V1zLk8xuK3K/bOd3bklB/KRyUTtDWIuN8T+xDm5
	RUBRn8739IlYtBk6uIEYu4NN7rifxmmrUlszhpjNeK6LOp9qVSIcCDXS96rGKC9kqtpO/1Sx29C
	GVpHh5bPzktZ8U5qoeAVyhjwUynyupWieaYMtCjSkYQg3UI+VFg2z9pZ+jtpv69rT44iS813nPP
	AVLSndaGkelzXv6OosVRJ1DxMdcX6bnCzuuwHYmEQAhlV5GBYqqtdCKbMwNudfyD7H6aRQTEd2s
	VW4
X-Received: by 2002:a05:6a00:1813:b0:845:e08c:a4eb with SMTP id d2e1a72fcca58-84ed6f0a7bemr695627b3a.58.1785479831871;
        Thu, 30 Jul 2026 23:37:11 -0700 (PDT)
Received: from Roxy.localdomain ([203.175.14.58])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc2d7b97sm6102b3a.43.2026.07.30.23.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 23:37:10 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	razor@blackwall.org,
	idosch@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf 1/1] netfilter: bridge: release template ct on non-IP path
Date: Fri, 31 Jul 2026 14:36:53 +0800
Message-ID: <3cf187b612fd78f8835fa9dad870326ce380f82f.1785479514.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785479514.git.zhilinz@nebusec.ai>
References: <cover.1785479514.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A bridge nftables ct zone set rule can attach a conntrack template to
an skb before nf_ct_bridge_pre() sees it. For non-IPv4 and non-IPv6
EtherTypes, nf_ct_bridge_pre() currently overwrites skb->_nfct with
IP_CT_UNTRACKED without releasing the existing template reference.

That makes the per-cpu template, and any temporary templates allocated
for concurrent use, unreachable and leaks memory until the host runs out
of slab.

Reset the skb conntrack state before marking the frame untracked so the
existing template reference is dropped on the non-IP path.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 58a33d0380b00..7ecb8a26bfa3a 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -280,6 +280,7 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 		ret = nf_ct_br_defrag6(skb, &bridge_state);
 		break;
 	default:
+		nf_reset_ct(skb);
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 		return NF_ACCEPT;
 	}
-- 
2.43.0

