Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBCC3815FD
	for <netfilter-devel@vger.kernel.org>; Sun, 29 Mar 2026 16:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774803102; cv=none; b=aAK3ck7b5KnyDdWzjvPA9JKEKcCLxgGtZjpsFFgF7E8LYTofVBzgjzTzkRtF3Q6kX3/X8apLpcM3AyqJvFLGoh9CuDJ1mJy9JWVI2LBHQgT75T282ClKsYxPzK+UbBrbmqVPOjj0J9L+0bUpPTywwZga/c+r8yv5fbPSPzhPxDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774803102; c=relaxed/simple;
	bh=+/li8ir0cS6ptJjeq5uk7yw+iqBQNmezjlb7upWUo0U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PFbRXq9Y6YbV2q1rCuqtkfLe03tC7AGNS+txDpHj/ks8IQXf3egxb3suN+RcK/U155p+HsR9d8xLTuxao+UblV4ilCnH2a/T4giiHc8/PAafiG/USIQqfY/2dIOtLvQzNcocSohbpDvrlhvdjcNenOu9ChWZ1nFqeQ9eX/xKMtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QbNMOS4w; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QbNMOS4w"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-358e3cc5e7eso1784290a91.0
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Mar 2026 09:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774803099; x=1775407899; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SXMpi9W0ohIEOw0qI/5F6ExlkOwkg6UyfvzQqFC3OoM=;
        b=QbNMOS4wRUWU2R6DenjyxiucOrCYfXMqn1uIZ/2ZRnam2zRVtQz91YcgrJU4TzPAoy
         QReKhxtwVZHWk+g8VT9xGnwYEY+WnSpyIMNKWvhg54iH+i8Gca7RD1QKsRq2m4KBA19+
         fIe8dEPJeeMTTqDwfOB+RRTBujFnWB+RcfmBmUvCVt7zc7SZjRHecKidx88oUax7sXA4
         Q2JoxxZhPkQaNVsRuZZ+pg7D1YRMwcGoQMhmRPGQmjWhw5cY9I11Fs6xgwKnoUpwDgoL
         uLSqWJ8lG9aYpHP5+EvwNW/Byl7p43SB2l3yF1q17JhKll13x9R9ZF2OcTm/pJbVgfW4
         0FOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774803099; x=1775407899;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SXMpi9W0ohIEOw0qI/5F6ExlkOwkg6UyfvzQqFC3OoM=;
        b=Ouwj7BGjC/CvcY2EDUObIu6RKjZTnhwGU+xaMs/3BLP9Ks0OaU0m7ZmMSJi2p5jgNa
         vEBIwDf0mqh8byVXJTzWCz7/iQE1fGO5enGGRD89IO07HVlmemtsvASK4rl1t+M3e/d2
         74tPDoc+CPUMRWRiSrdg2HBvZ73+lKiW+anB+RG+MhntgbQJ0LLeP+b/C0RDs5/emVio
         m1JS7PAaKSjtyjAunShZGn2sN26oRMT19iAmcRVqbD9yuiY/lg/qXzIRLW8lSDeGHWmh
         qCu2GafO8R2kVlk5h8O7XGhbBw4pXugUEs/nfdi5YUG3vSpDIX6fNZha1Xw93WiXyYE0
         DbSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwOBdt+vzvuuiD+ANGg7jFm5EwfCML46ZopL7hb0zqVDTAKgrnGWPniSthrFHWoHspkPA6hwbcuaSDsIeO7fM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+oDYyqpmyvKaDTADkUhw6MEMOc2ju0lT4IVyXU+2lt0B61MyI
	JLZ6uEI9qkLOhAHNJDPkjeHLllbGHna4BpiCBm9h2Ju74XkMFdhUBXRu
X-Gm-Gg: ATEYQzy5mbEHY9r9rZm7+x9m2q2NLfNRusPfg6ZT+IhEpvjALg/cYBflTnfZtqKerZk
	YNDtbtY1FC/jq0WmCfBAhNTmFIyYnRg1JdUAU9K4X3LiaADmsR3IaAxo/g0COeifwBaf/RJiRJh
	hB2Sz75vLGxbM9S8kM5FxWJm3qK2iXP0GHLZ64zzbbf2NdwFkjSjyY0mWSTNYZZwp/oH7naFIdz
	b+VY6vWSkeDD7SQjtVdrbpgd9bhR9YE9vyP2OPEvAznROYopwAsa6fRIRqas9EaniyK1ASZ/QB7
	MvJ/9Z+HsGnocx0/MH3122XTZESAuMTU3rD48MK8ZAv4+kO4ME6yuv2X0UaL2VOt1e/M9xmU6XE
	3wON10dh21/9OfN3EewVsKijDtr03bSmjgIDDM3DBthYhZjcRokXXhikGWOOIswGVZ55YxF7MhY
	wNNzrviwORY4oRXfG7V01WbskU4wQDePVrL6g=
X-Received: by 2002:a17:90b:164a:b0:35c:30a8:322 with SMTP id 98e67ed59e1d1-35c30a80a30mr9555894a91.0.1774803099575;
        Sun, 29 Mar 2026 09:51:39 -0700 (PDT)
Received: from localhost.localdomain ([47.236.127.140])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c22ba5700sm10416654a91.8.2026.03.29.09.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 09:51:38 -0700 (PDT)
From: Qi Tang <tpluszz77@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Qi Tang <tpluszz77@gmail.com>
Subject: [PATCH] netfilter: ctnetlink: validate expect class against master helper
Date: Mon, 30 Mar 2026 00:51:31 +0800
Message-ID: <20260329165131.240989-1-tpluszz77@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ctnetlink_alloc_expect() validates CTA_EXPECT_CLASS against the
helper specified by CTA_EXPECT_HELP_NAME.  However,
__nf_ct_expect_check() and nf_ct_expect_insert() later index the
expect_policy array using the master conntrack's actual helper.

When the supplied helper has a larger expect_class_max than the
master's helper, the class passes validation but produces an
out-of-bounds read on the master helper's heap-allocated policy
array during expectation insertion.

Validate the class against the master conntrack's own helper
instead, since that is the helper whose policy array will actually
be indexed.

  BUG: KASAN: slab-out-of-bounds in nf_ct_expect_related_report+0x2479/0x27c0
  Read of size 4 at addr ffff8880043fe408 by task poc/102
  Call Trace:
   nf_ct_expect_related_report+0x2479/0x27c0
   ctnetlink_create_expect+0x22b/0x3b0
   ctnetlink_new_expect+0x4bd/0x5c0
   nfnetlink_rcv_msg+0x67a/0x950
   netlink_rcv_skb+0x120/0x350

Fixes: b8c5e52c13ed ("netfilter: ctnetlink: allow to set expectation class")
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3f408f3713bb..c57c665363e0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3542,9 +3542,14 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	if (!help)
 		return ERR_PTR(-EOPNOTSUPP);
 
-	if (cda[CTA_EXPECT_CLASS] && helper) {
+	if (cda[CTA_EXPECT_CLASS]) {
+		struct nf_conntrack_helper *master_helper;
+
+		master_helper = rcu_dereference(help->helper);
+		if (!master_helper)
+			return ERR_PTR(-EOPNOTSUPP);
 		class = ntohl(nla_get_be32(cda[CTA_EXPECT_CLASS]));
-		if (class > helper->expect_class_max)
+		if (class > master_helper->expect_class_max)
 			return ERR_PTR(-EINVAL);
 	}
 	exp = nf_ct_expect_alloc(ct);
-- 
2.43.0

