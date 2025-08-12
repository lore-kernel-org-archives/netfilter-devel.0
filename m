Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AF723D7EE;
	Tue, 12 Aug 2025 15:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755013973; cv=none; b=oLJ15eF0BXmTuXoO2BLHk6wFT23YGxTMFbsAuLwGEEd4vxIbDuRVGtWR5vsBE6toXtpvStYXSC2lDaZ7k6KVi5a2p7vh0JTGXqOumnBFI2b9G4uQ3nodPwiHoa+QHOVx/Z5Zw1nXi/maE7vSpyKrEnEYkAhR2BNnOpEsfFk/lcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755013973; c=relaxed/simple;
	bh=aD8GbCKvKiWaTtzd6D9lq/XvzMzboWn1cL6psXbvr88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srhlZcrF6rdxK1PcZEd83zaZqHS3zB10KO4GT62r3E84gVi2ICi0jbnp58w427bpH3dfnasBhH+cpomyT9h/hIHC6hLkyVk20hmkjM6KfDQYlahYPyxjOhwWXwlYSusA+fAfjrKw+OjXTiIS/WQyEgM0aYqRvfjmzZXB7qLFrpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-24099fade34so41283625ad.0;
        Tue, 12 Aug 2025 08:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755013970; x=1755618770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mfa3i9rOipmYMsnw23KZ5Tctd8O9telY4wmzE+SpLWU=;
        b=wQiB896WanZX2YHbi+fdqunfOsY3vlmDsaa6NAEYgLMyfLwgq7otu+AIHpxFIW4r4+
         FOErrts/jfIRFFjxSasLIz+hC78ZmXjZNzzuXV6ex2ClKx14lKlVjmvgTXyd8/KfUHlV
         0GgUs70JUKhlJrqTJTKigLHZG7noxG1COMwAA99Fp0RtJAg7U5HH1+A/EC4G2W/j9sfK
         vY1Mheri1pfpJ/ua5ZF5Y4YMXASMnvnrDJUBobhuq37P8zcoW/GpwYA6AD6gMbOYISIm
         D2Wqfritbd4Um95fTLf8nsqsNC0fIafw9TBhJQnnS2ZcaXlYH+GJJRxA6Ew200ccCB4Z
         TfXA==
X-Forwarded-Encrypted: i=1; AJvYcCW0OK2AL/EVWv5+zmSZqO+G22ZWkYtghiDt0J8ENFuidLD+AjISjdwTfHvIf8noN+NTZYkZ04dcBiTgg2lIM0Vf@vger.kernel.org, AJvYcCWZQYbyU/zTepGY7cGehcPmQFw5lITNo5C3MhtdU5OlG+xcUqy7q/b5mze6WSOgCXcvwqNavPdgXKvqWxI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJI766cflGKtaJlLMt4LKdsPnS7eU4PktcYB+Lo0TsVJevk91f
	HZnBSeyJQPqaiTgl/beTesWwQrThZP6o73HJ+FdV+XO2AFgxDHlLnYot3CQM
X-Gm-Gg: ASbGnct7X6KVLMyzrj3eVExS+shC1h2Ba9DlLO39X8BrUEBAjfRV5Yszgi3N8uBr1vY
	MLi747mXLTeBzdsNlrvK89nQk+UHUMu47PaLimY9PoodnBG59MW2e+dyeMf9aiqLAoae1RyUNIr
	RhMGEdcXcqHMZb2WSM/IdB4y533+hgUJdiGlZZugRbsONofCyRNWPpwubjWpxQzrX2m1jP1/kOS
	gyImYNEc5ceZ+ZgHw75PQe4xsyC02NKf1u7sB6JVwty9aSTolAqdfAnczhcUYHKo6KCQ6xMcA42
	Ae+uv8mlW6ho3sPZd0R9KuZp/ILe7sNUa68oRnOJh3DhIRCrvcNpqIT8NlLzjjO9WmEXss+1BLi
	QbwWJi6LzTMo2FfMsK46c+jD/e+Ks+eG4vZa9nNDRpgk6aqp/kf4rD2t5bnI=
X-Google-Smtp-Source: AGHT+IGBGkmr9pZr40H+xsMkIBamZYWaMKPk4BVzM+vCAsfxbVPqNX7XjaIWfAH5MMccHcGWAr36sg==
X-Received: by 2002:a17:902:f551:b0:240:6766:ac01 with SMTP id d9443c01a7336-2430bfeb488mr3595155ad.2.1755013970508;
        Tue, 12 Aug 2025 08:52:50 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-241e8975c94sm303016765ad.93.2025.08.12.08.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 08:52:50 -0700 (PDT)
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
	steffen.klassert@secunet.com,
	sdf@fomichev.me,
	mhal@rbox.co,
	abhishektamboli9@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-staging@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	herbert@gondor.apana.org.au
Subject: [PATCH net-next 4/7] net: Switch to skb_dst_reset/skb_dst_restore for ip_route_input callers
Date: Tue, 12 Aug 2025 08:52:42 -0700
Message-ID: <20250812155245.507012-5-sdf@fomichev.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812155245.507012-1-sdf@fomichev.me>
References: <20250812155245.507012-1-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Going forward skb_dst_set will assert that skb dst_entry
is empty during skb_dst_set. skb_dst_reset is added to reset
existing entry without doing refcnt. skb_dst_restore should
be used to restore the previous entry. Convert icmp_route_lookup
and ip_options_rcv_srr to these helpers. Add extra call to
skb_dst_drop to icmp_route_lookup to clear the ip_route_input
entry.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 net/ipv4/icmp.c       | 7 ++++---
 net/ipv4/ip_options.c | 5 ++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 2ffe73ea644f..93a166a7ec8d 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -544,14 +544,15 @@ static struct rtable *icmp_route_lookup(struct net *net, struct flowi4 *fl4,
 			goto relookup_failed;
 		}
 		/* Ugh! */
-		orefdst = skb_in->_skb_refdst; /* save old refdst */
-		skb_dst_set(skb_in, NULL);
+		orefdst = skb_dst_reset(skb_in);
 		err = ip_route_input(skb_in, fl4_dec.daddr, fl4_dec.saddr,
 				     dscp, rt2->dst.dev) ? -EINVAL : 0;
 
 		dst_release(&rt2->dst);
 		rt2 = skb_rtable(skb_in);
-		skb_in->_skb_refdst = orefdst; /* restore old refdst */
+		/* steal dst entry from skb_in, don't drop refcnt */
+		skb_dst_reset(skb_in);
+		skb_dst_restore(skb_in, orefdst);
 	}
 
 	if (err)
diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index e3321932bec0..95f113dc37d8 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -615,14 +615,13 @@ int ip_options_rcv_srr(struct sk_buff *skb, struct net_device *dev)
 		}
 		memcpy(&nexthop, &optptr[srrptr-1], 4);
 
-		orefdst = skb->_skb_refdst;
-		skb_dst_set(skb, NULL);
+		orefdst = skb_dst_reset(skb);
 		err = ip_route_input(skb, nexthop, iph->saddr, ip4h_dscp(iph),
 				     dev) ? -EINVAL : 0;
 		rt2 = skb_rtable(skb);
 		if (err || (rt2->rt_type != RTN_UNICAST && rt2->rt_type != RTN_LOCAL)) {
 			skb_dst_drop(skb);
-			skb->_skb_refdst = orefdst;
+			skb_dst_restore(skb, orefdst);
 			return -EINVAL;
 		}
 		refdst_drop(orefdst);
-- 
2.50.1

