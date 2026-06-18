Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3CA3B2FE4
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 12:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787576; cv=none; b=pnmSua/lrGaBtykNIuLXFku49HRzWmlivh69guiU1XKH2+T3HDTzkQ22QXoD7o38wDpvvDpP1N19VuzGg8OoACkRCqnz5usS4XpQsUZuEOlEfri+l5mL4Hb6N7WSuBLL4LrRM0TRYO9pzjEtAaEFxZ3iUwb5NyhwxXvXdPC+wgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787576; c=relaxed/simple;
	bh=yIsTclutRAUcQDJ1z2fx19eGQmCProIOCrZK1URJW4w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TcyoBzzi7F2D2FOAdAowo05Xo0W5jbxl/s/vcr42NojuK5aYXXc+TNkHhVY4+zEj1qgrGwR3+j04KH1vys/OskQ620jvGpuGZTxrixLHyr1xlt4sXEi+LFjb9q6MN6wB17gEtoXdDp4U2AfYX0LCBPb//qZZ6RQxfKqYbV8ZwZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cdmarSB0; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cdmarSB0"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c6d31bfc70so5610775ad.3
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 05:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781787573; x=1782392373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GvlYYaTQFdpc8xS2DhS0Qq3G5MuVOkm1bSjyAI/p1NE=;
        b=cdmarSB0XHnHpnKSw++A1SLbfX5GXNKnXvMpfqPEdWVWEi8zHcXHwHVoW/2bW4heAv
         TGLPyadGiXEhElICJ8sv4RnJE3UP/iVqiLN9uw17peK3iqWYtzgu76Rr/UBJKyTkfv9o
         CLATCM3L0EM31e3TfxYtqZ5Px0WLqDW495X/BHIS5r5jTByjttG2k/AVm+9oAOVERmRq
         8gLpbwq4AmaPQmPbJh2hik7banKyyIfmJeSGMk9adBPpHiN/XRvCuN+tVwCepGMCrU1J
         vra/AdGAp54hUfHfhipiUpcQCenaPXUFSdgkUC9NaYphYMhbvNf3Ji2dJjYkVVVdSH6l
         408w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781787573; x=1782392373;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GvlYYaTQFdpc8xS2DhS0Qq3G5MuVOkm1bSjyAI/p1NE=;
        b=fdphLCw+Qxm6DrkLDAJuKSbCCBHkd8oQ4RNQOe5Lm7ehn7ADtoNUl2OHad9k5Nntg2
         HKSYuCaEkIInCuQ6t7M4zsJ9TFt+szMq1avHwmqWT/5YZJzPX0IgZZOOE62+cklRJgJv
         hcq3haU46uQKGvnDanBBltWE1e+RbyDYdviUob8qZpOc6AMvyRjY1KQWYK7aUwdXJDJz
         rMpLSAIfv+XO6hT+yekZtNJEgmRlqk34O3UOz8w/oIBVFBnfRXFHbw+QA7d0fBvA/VUX
         IXwUNBeni5qxTtMg4GHHoF4qQTEmy2U8m/KLbicJGZi+fMQEUg1dkZTAILEZd4Rhdlhw
         mrBg==
X-Forwarded-Encrypted: i=1; AFNElJ92iC1mRqtyMEtOdDtZnLZezykrnMMnAw77mHlm12UhB5WtCknpFhdIwhC2U2QliPSZKdaHs+SQpzp2c52Tpm4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxD/6Rt1pPSUMPl4UkggDi2lG0n8o3aM/HUn1ro6uViNlsiDxr
	w19SkSq7P8Mok80Vm8oKOk65Dpjncw5b4uvhlL/JzY3hoiYnVG5Ei5v6
X-Gm-Gg: AfdE7cnurCDrU5qO/2XdFNNp09OG5FOBCSGykhORc4k6B9KJ4NncGdWgFcSS2nx6lBI
	vuqC0GQUy1lNyD7ve70Znqt8BdnzTQ4XTsgh12wWTGty2KGYJEyoT05FxRxF2fb4s2PMTwatAQb
	0ahHvIODp7lIBLuqSYrSzzpEg+HVhwUi0nOtURE6EXjc+FKPZawkUoXKdc7UKLPDwQxMXuIhEpU
	54pk5iJii7gHF0BYt1u94p07Tc64Qinm+v7Ne6wlZowjpcVAw+VfGBPQo7swV38xJr7J/PhGvhk
	1/RDCNVMhiWRUpB3TFvKBhWCW2Ao5JIuI5K8duR/pjSKosustigt51TBa8iq7RpW5RMUDzIDJVi
	pbuVW5/jcB4fKTy4oPfueyvHvTBcFbwgN9MbNM6ehZrK4U1j5HlTTMhMjL6D6/XrGqa1oJuSjhh
	EsuE8FDKaah19qkrpcu7LFG4F3Cg==
X-Received: by 2002:a17:902:ecca:b0:2bf:356f:4e0c with SMTP id d9443c01a7336-2c6bbf8ca0fmr96767445ad.1.1781787572984;
        Thu, 18 Jun 2026 05:59:32 -0700 (PDT)
Received: from c79home.localdomain ([2409:8a55:35d3:46d0:20c:29ff:fe83:eeda])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c432c8c1f9sm202857735ad.59.2026.06.18.05.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 05:59:32 -0700 (PDT)
From: Zhixing Chen <running910@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Zhixing Chen <running910@gmail.com>
Subject: [PATCH nf] netfilter: ip6t_ah: validate AH header length
Date: Thu, 18 Jun 2026 20:58:48 +0800
Message-Id: <20260618125848.93550-1-running910@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ip6t_ah checks that the fixed AH header is present, then uses hdrlen to
derive the advertised AH header length for matching.

Return false if the skb does not contain the advertised AH header length.
This avoids matching AH headers whose advertised length is not present in
the skb.

Signed-off-by: Zhixing Chen <running910@gmail.com>
---

I noticed ip6t_hbh and ip6t_rt already do this advertised-length check
for their IPv6 extension headers, so this keeps ip6t_ah in line with
those matches.

---
 net/ipv6/netfilter/ip6t_ah.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 70da2f2ce064..a40240125a1b 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -56,6 +56,10 @@ static bool ah_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	hdrlen = ipv6_authlen(ah);
+	if (skb->len - ptr < hdrlen) {
+		/* Packet smaller than its length field */
+		return false;
+	}
 
 	pr_debug("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
 	pr_debug("RES %04X ", ah->reserved);
-- 
2.34.1

