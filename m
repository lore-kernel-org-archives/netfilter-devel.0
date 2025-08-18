Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A35C2FE07C;
	Mon, 18 Aug 2025 15:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755531639; cv=none; b=HVcr/D0V6En5n5/TyTsMr98cnQedU1z8+b5CT9oxFPdeMdooh5aeW1UxQpaOs5R6QedHYIyOjbeioZ/3sOKaTtZTQ+J1vDE6ZDC8mTIs+JxZc0shuu7ePE7u5FXtAI568ARQxtY9+uR1QI9HYZuZYuECQmA8Qp7Z1oOTVCuacxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755531639; c=relaxed/simple;
	bh=b/DA3hf0cVwROHnJBEhkEAOx5XAE7XNZqUHrKBEfjU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFIRyYlH2sKefW5g5HTe9IMt+NntNxl+6VuAsJuXddIB8zstt40kNv4fG3bYmsukOC+ZkmjG5S0ErUGWYSX1n4y16FMf/dQwNNv18CXnLoJvE4YPL9hTrt+jpMKw2GENKoYslm5OGrrBg7uWAcqNjcOew2tbWrkROz8VAsNTXek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-76e2eb49b83so2624241b3a.3;
        Mon, 18 Aug 2025 08:40:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755531637; x=1756136437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8GN9S1zXQyMdeN/NDuSaubUJIlHc9oqqxz49+rYEkd8=;
        b=pWn7frdJXby2KOx6qDE9j7OGqN1ZTHPbDYxFqiNWqoVINKufdLRTvGts759sPL0071
         bVA7CtWJ7NMI6ydkX+lSmvdHsqflGcCirn5BaQRzW5u8BcbpncWRUE/0fn3VI+XXYRBb
         GIsz+65LyxwNyfzEf9SWP0dh9kdz2UwrZ3uGc+hIfU+nT1EBDc/s94pbVu9w/+0LTu3h
         Pwp3c97dxd30Nc/nr4IvIAbc+ioKOvy8bsO4OqIDy0xXnkIdD5ttN0hWf2X55VRW9YlD
         eJiaLKcybEbBNcgdLb+gxhT7oyIfh0zbvv1GJ6xHXZlHnO1pRloPEXlm8tdY/RMhbFef
         aSDA==
X-Forwarded-Encrypted: i=1; AJvYcCVR9AC8tJ2D9dY2O6zHt+8IWdrqDSqL0pPCBTVNUHYrMLPRO6xqZoXCn6iKloDWZ1az6s1A7j8ich8ZlRS1Js42@vger.kernel.org, AJvYcCXWpBdOY1j2CY0FE6nZ+YXvMOnILTjREqzr2p2QftJYH/gSFTvmJZEAmDE0zLslsDG4+gMaJuPIztn+O4Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyISCYWTRM6sFXvr+zCm9L28OLksMuGsHNSUbVbNxhQ79Ihmkob
	GzaQRwfPVM0Z736RgPGdZNqOIoUkBHvq0R22C1GO/F8PcpLbIudLPcLAEuEi
X-Gm-Gg: ASbGncvXr2JqGu28xtMOTq6aYPFr4NBUqUAPWLTu5uaX7EpqSS0lICE4Od6Qymm4EBq
	EmCSXUwamiZvVjXhGdXzr7nwv99hIP3edTXWhB+0x4dWi8VIGbCNaOTMvMcnTZY58BN9Xi2L7/v
	HXnrw4/uAe1v5BY7AA9R5Xt34ybgbao+MPSjywB6Lfx/gTxmBGqdDfUWv0KbEKrqrlNehMaQ92G
	t4aUalGXsWD7r2nmKZHE8wCJNiXQk+YXlyrIFXqTVPyvOp9ueh85ui4gGvu2jc49+39k8vODi9o
	REc2Ims1X9tEG0Ecgt2Q5LXa6kOUJMsZ34TaL//iv2r7LuuTdQb1CyGjb1L//ItTjA5DrK4KqML
	a2rnYkCDH2AnVASsDyiYhY6DSTO5WAZL1kmJNSrtWOCKa+kN1p666MCn3tRk=
X-Google-Smtp-Source: AGHT+IHUbWr0pNMEsgIWzW54IUCJF/L8KUZQxQTwcLqu+QkbVHZsmGBkmSVhRfa/ryj+iyNTFbMzBA==
X-Received: by 2002:a05:6a20:918a:b0:235:2cd8:6cd1 with SMTP id adf61e73a8af0-240e636e9d6mr14498211637.34.1755531637220;
        Mon, 18 Aug 2025 08:40:37 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-76e7d0d1714sm3540b3a.15.2025.08.18.08.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 08:40:36 -0700 (PDT)
From: Stanislav Fomichev <sdf@fomichev.me>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ayush.sawal@chelsio.com,
	andrew+netdev@lunn.ch,
	gregkh@linuxfoundation.org,
	horms@kernel.org,
	dsahern@kernel.org,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	steffen.klassert@secunet.com,
	sdf@fomichev.me,
	mhal@rbox.co,
	abhishektamboli9@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-staging@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	herbert@gondor.apana.org.au
Subject: [PATCH net-next v2 4/7] net: Switch to skb_dstref_steal/skb_dstref_restore for ip_route_input callers
Date: Mon, 18 Aug 2025 08:40:29 -0700
Message-ID: <20250818154032.3173645-5-sdf@fomichev.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818154032.3173645-1-sdf@fomichev.me>
References: <20250818154032.3173645-1-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Going forward skb_dst_set will assert that skb dst_entry
is empty during skb_dst_set. skb_dstref_steal is added to reset
existing entry without doing refcnt. skb_dstref_restore should
be used to restore the previous entry. Convert icmp_route_lookup
and ip_options_rcv_srr to these helpers. Add extra call to
skb_dstref_reset to icmp_route_lookup to clear the ip_route_input
entry.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 net/ipv4/icmp.c       | 7 ++++---
 net/ipv4/ip_options.c | 5 ++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 2ffe73ea644f..91765057aa1d 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -544,14 +544,15 @@ static struct rtable *icmp_route_lookup(struct net *net, struct flowi4 *fl4,
 			goto relookup_failed;
 		}
 		/* Ugh! */
-		orefdst = skb_in->_skb_refdst; /* save old refdst */
-		skb_dst_set(skb_in, NULL);
+		orefdst = skb_dstref_steal(skb_in);
 		err = ip_route_input(skb_in, fl4_dec.daddr, fl4_dec.saddr,
 				     dscp, rt2->dst.dev) ? -EINVAL : 0;
 
 		dst_release(&rt2->dst);
 		rt2 = skb_rtable(skb_in);
-		skb_in->_skb_refdst = orefdst; /* restore old refdst */
+		/* steal dst entry from skb_in, don't drop refcnt */
+		skb_dstref_steal(skb_in);
+		skb_dstref_restore(skb_in, orefdst);
 	}
 
 	if (err)
diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index e3321932bec0..be8815ce3ac2 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -615,14 +615,13 @@ int ip_options_rcv_srr(struct sk_buff *skb, struct net_device *dev)
 		}
 		memcpy(&nexthop, &optptr[srrptr-1], 4);
 
-		orefdst = skb->_skb_refdst;
-		skb_dst_set(skb, NULL);
+		orefdst = skb_dstref_steal(skb);
 		err = ip_route_input(skb, nexthop, iph->saddr, ip4h_dscp(iph),
 				     dev) ? -EINVAL : 0;
 		rt2 = skb_rtable(skb);
 		if (err || (rt2->rt_type != RTN_UNICAST && rt2->rt_type != RTN_LOCAL)) {
 			skb_dst_drop(skb);
-			skb->_skb_refdst = orefdst;
+			skb_dstref_restore(skb, orefdst);
 			return -EINVAL;
 		}
 		refdst_drop(orefdst);
-- 
2.50.1

