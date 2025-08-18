Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5174C28C849;
	Mon, 18 Aug 2025 15:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755531638; cv=none; b=IyEdRq/SwBwMU5+s7S5+Kc9HnPWyrOCmRH+wH2EZCNCOk1SXh2nJ7VCxtB3HS1122TFlsM8lh4+KkvuZx+INsemZHqDoh+QpI/BI/T8hPhuAGy6axwJkP8nG07dGyhlvIv/nwdqUe6VfKTdfC9KsnPcjEneMCGa4dtT5CjoGUvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755531638; c=relaxed/simple;
	bh=NnZxgiK0M1v0pPT5JWfo6ZgqcA1SxytGePluoUKHR44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnQe0MyOHYN6cDKtDV7i/teCH21j2T76mUT96vn3+G/b6nyuZS4J/+Z2cZ94kKK016Ol6sPjHeoJcXj631ScVxeEXMVhywvzE2vY6ND2tOsGMGLVbIF+b37fOG+PfZTj7VAzRgEPeCjI5FQ+fVVG6L/FaA1X2gL/z+VskAkmLNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24458242b33so39896115ad.3;
        Mon, 18 Aug 2025 08:40:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755531636; x=1756136436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=inuSpscDtJ2MQ1kOWy8s6V/eMZ9GranbL4RKE5ldQfI=;
        b=hLAqa5qf1gaMxMRgnepnkwZrMjRdptCe32oCKqro9lcKvFHztVY46MSo4hBwy5iwFz
         ifOsWqn263+F8Y2/YiNTkkSow+wpeu7BFgVvXUVZV1naeb3vkGFcV35TljxOIP5iqjug
         bPrwTVZNqWtKDinMsJVu7I+UNFThuZxeqGOapiM6IiE29XRmmSy5RuPvS4eDWDY6dA3x
         b8sO6r4vHhuBkcgiYjAAt6jC8pamVyrmQjhwLWcN1SBZfvqonaEy+JyZFe/Kknk+kpcn
         ll9FgV/39H3cWpHo2aYmx+6sqMH/mloFMdR1byvIBs/QKFhIGDnzRhCH/CFZ64QEj2XZ
         X9gA==
X-Forwarded-Encrypted: i=1; AJvYcCVnPDCYNNLYIAHAY6OA3UTFZZHTnjoWaKEAV0yQRjPyLi4qu8T9uBLhnz5E9rSjb9ERISUfSNGY49K4pcnqntmW@vger.kernel.org, AJvYcCW1sBC4qpzHBlQCb413mP9u2IvhgeBh5kvlnhInT8tcIUe0JFYKkQ6+cTt2i3SO8hcFveX56DHPm9kH5E4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGTqpOtE0Mw+a4peTtergti2awqALjMCnE77McXm/r0hjyH32T
	aX1J3Sizm+sQOoad+7NrQRqU6km0rtbCuqMHMa64c+8i3l60ohP5AhoXeUUt
X-Gm-Gg: ASbGncu5zjsg9stRLU6BB+ffoe93IJ4iDKYUmvxXy+1Uk3gIh6PGZdXQiCgHboS8rkP
	7vxnoHBGrHdufwKJwBfncHYHZt9ayesNRAhM3b1bwVRALRuVVr7hIM48IdZrYJSJCh9FJh0iU1l
	3xo87UdvGr9Cq/yI3bxp9C/X1dz2V/sIfCc+GHQLnAILwzWDZDCAD3AgNIO8Hjk56M3GJ87/4d4
	d7NviSeiTmQY6LOUZukrUr6dA7qosT29t3xEFZPDhQt6Jxf5dEyed4k4p9r5p0cEPyXt+aiiD38
	Dja1LERXXiMG+5VuHaUzlQZGuAWLloIYEThY0lWm5EHPDOXBIDKgcQlYWmJRDeC+kb8DUX9mkrK
	9nThWB/u/uIeg5ErBaZQc5cZZbhCFAqGV9xTXUM3KkLVx+o9aTkf1E7FSkXU=
X-Google-Smtp-Source: AGHT+IGZZKT3cVuxFCE+hihe8kxfK+wOP2G53VzTXlLX+ith0209HYVW0thSRSUc4qLH6kV+2C3mvw==
X-Received: by 2002:a17:902:f78a:b0:243:43a:fa2b with SMTP id d9443c01a7336-2446d9f30e2mr183864805ad.56.1755531636354;
        Mon, 18 Aug 2025 08:40:36 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2446d54fe2dsm82947475ad.131.2025.08.18.08.40.35
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
Subject: [PATCH net-next v2 3/7] netfilter: Switch to skb_dstref_steal to clear dst_entry
Date: Mon, 18 Aug 2025 08:40:28 -0700
Message-ID: <20250818154032.3173645-4-sdf@fomichev.me>
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
existing entry without doing refcnt. Switch to skb_dstref_steal
in ip[6]_route_me_harder and add a comment on why it's safe
to skip skb_dstref_restore.

Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 net/ipv4/netfilter.c | 5 ++++-
 net/ipv6/netfilter.c | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 0565f001120d..e60e54e7945d 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -65,7 +65,10 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 	if (!(IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED) &&
 	    xfrm_decode_session(net, skb, flowi4_to_flowi(&fl4), AF_INET) == 0) {
 		struct dst_entry *dst = skb_dst(skb);
-		skb_dst_set(skb, NULL);
+		/* ignore return value from skb_dstref_steal, xfrm_lookup takes
+		 * care of dropping the refcnt if needed.
+		 */
+		skb_dstref_steal(skb);
 		dst = xfrm_lookup(net, dst, flowi4_to_flowi(&fl4), sk, 0);
 		if (IS_ERR(dst))
 			return PTR_ERR(dst);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 45f9105f9ac1..46540a5a4331 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -63,7 +63,10 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 #ifdef CONFIG_XFRM
 	if (!(IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED) &&
 	    xfrm_decode_session(net, skb, flowi6_to_flowi(&fl6), AF_INET6) == 0) {
-		skb_dst_set(skb, NULL);
+		/* ignore return value from skb_dstref_steal, xfrm_lookup takes
+		 * care of dropping the refcnt if needed.
+		 */
+		skb_dstref_steal(skb);
 		dst = xfrm_lookup(net, dst, flowi6_to_flowi(&fl6), sk, 0);
 		if (IS_ERR(dst))
 			return PTR_ERR(dst);
-- 
2.50.1

