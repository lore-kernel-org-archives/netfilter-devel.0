Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3C9213235
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 19:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742413834; cv=none; b=nN96e01o5V9iIWQc5I/1716zQdnRBSeyKXOA3JMpPqRn4JTiWLjv7fhZXN8jISfFJDdxZl90REYno6eeo+2pM/d8S9TfOIHUZ5KbvNwQufs9lA77O2s9xQE3mBbg/5a4eksosooK6U8us9GtuVGVn0MoZge4Mkn/vPYyuuz6pi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742413834; c=relaxed/simple;
	bh=v59XltM8uQQ+KUCb53z50qzUzJuh28iAFOL+RdNCSfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pH+iZKnMbrGn7r/kp/zpeuAv8p7HiD5RaYnDD/nIYXEQaPh2QvUKP7YZhawnIt2hfV20B3Pwx/K/X1ZwEbXGQL3J0+fTD/izqVB1m09yoN/eObog6ssbszMe1ua4IyXm9zu5RxitUUTNucTVy704vt/olkuFVWGxCins+Q58iAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sSWfrnvE; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sSWfrnvE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742413820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=byfiCU8fvjOZ+pAiCn4TzZ0P7EaHu1Y5GqBocSeFh7E=;
	b=sSWfrnvEk2+rxhJK9xMy1vTfDisKz5u1r7lMzVqpPQ/S91NNiyKOvhOtPZerygChZEFufZ
	boN6kGj878dpMvKHT/bTmZCquNU0wk+amb9ZZ4uBkBQPDpHPFM9qUTrX7EL0KTq1BTMGfH
	F3Cr5F/vQwu5S6Xd9pNyMSLaamo84+8=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next] netfilter: x_tables: Remove unnecessary strscpy() size arguments
Date: Wed, 19 Mar 2025 20:49:33 +0100
Message-ID: <20250319194934.3801-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If the destination buffer has a fixed length, both strscpy_pad() and
strscpy() automatically determine its size using sizeof() when the
argument is omitted. This makes the explicit sizeof() calls unnecessary.
Remove them.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 net/netfilter/x_tables.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 709840612f0d..8607852dadec 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -766,9 +766,9 @@ void xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
 
 	msize += off;
 	m->u.user.match_size = msize;
-	strscpy(name, match->name, sizeof(name));
+	strscpy(name, match->name);
 	module_put(match->me);
-	strscpy_pad(m->u.user.name, name, sizeof(m->u.user.name));
+	strscpy_pad(m->u.user.name, name);
 
 	*size += off;
 	*dstptr += msize;
@@ -1147,9 +1147,9 @@ void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
 
 	tsize += off;
 	t->u.user.target_size = tsize;
-	strscpy(name, target->name, sizeof(name));
+	strscpy(name, target->name);
 	module_put(target->me);
-	strscpy_pad(t->u.user.name, name, sizeof(t->u.user.name));
+	strscpy_pad(t->u.user.name, name);
 
 	*size += off;
 	*dstptr += tsize;
