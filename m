Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA1E2AD00;
	Sun,  7 Dec 2025 01:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765069803; cv=none; b=fJYc0AoVC4FLgiHrWccoGobKh5J/l7X/oBWaGGnsC+sBic6stLakxS3oPyAbTwYHxjLSBAmtWFnxYg3i9iDFRIHKKzpIk2+C+LiKI9ZaIwkLSbqcpvhy+QcVkBSGCOiRa9i9UJEKVakZcGlRZF8gUl8mFSCVbNKLeSnkHxLXBZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765069803; c=relaxed/simple;
	bh=1nvyRIRL+2AMnI1+YsPKhv8ckkhkN5Sb2caHluZRCc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhCyKOR7SP0R9lq6/viuH0URdFyjyQE0cSerJCQzyMZaPhete1y9C2qRN1Urb9eY225Vcv9fhJnm64j4DS3gd4LJOvJFlABUv1anoIQ5ee1RPYlS1hqLYbJOzNxbPs6L5nRhPVUiUE97X9/QLKaiWSQZjeAybgx72CrA8M+TnsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uR52G3RX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uR52G3RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCC2C16AAE;
	Sun,  7 Dec 2025 01:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765069802;
	bh=1nvyRIRL+2AMnI1+YsPKhv8ckkhkN5Sb2caHluZRCc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uR52G3RXIrLhvX5YNo4D+GKTcN45KJd2j9JhXrul+/xkgzMEFsaqrNV0ONczYZwKS
	 UwTGpIBz4cgJWM7WymOZdqGLWRhE5JRtqmmpqpoNdgIa5k5zQwLxwJrY6pZC4Y0u8l
	 2kn/CuwkDMLYDR2QCCznnsDdDdKzyCbBAVdnAWxKyw+F477NfwKcuG4WGWY1u2F2X+
	 3sEpM3fxkNK7B1p3KLbJjGyV3CvBYM+J2ye3zv51nMKc7IUTo1q+WUQbriVzAkAMQG
	 oXzY5XK+Ihpc2ioLdDn6RtxExr+wiG3i19LcJzJradZcANVYEZuIO0Yt1kK5r80V03
	 +Fo7Rgz8GdheQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	willemdebruijn.kernel@gmail.com,
	kuniyu@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/4] inet: frags: avoid theoretical race in ip_frag_reinit()
Date: Sat,  6 Dec 2025 17:09:39 -0800
Message-ID: <20251207010942.1672972-2-kuba@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251207010942.1672972-1-kuba@kernel.org>
References: <20251207010942.1672972-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ip_frag_reinit() we want to move the frag timeout timer into
the future. If the timer fires in the meantime we inadvertently
scheduled it again, and since the timer assumes a ref on frag_queue
we need to acquire one to balance things out.

This is technically racy, we should have acquired the reference
_before_ we touch the timer, it may fire again before we take the ref.
Avoid this entire dance by using mod_timer_pending() which only modifies
the timer if its pending (and which exists since Linux v2.6.30)

Note that this was the only place we ever took a ref on frag_queue
since Eric's conversion to RCU. So we could potentially replace
the whole refcnt field with an atomic flag and a bit more RCU.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/inet_fragment.c | 4 +++-
 net/ipv4/ip_fragment.c   | 4 +---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 025895eb6ec5..30f4fa50ee2d 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -327,7 +327,9 @@ static struct inet_frag_queue *inet_frag_alloc(struct fqdir *fqdir,
 
 	timer_setup(&q->timer, f->frag_expire, 0);
 	spin_lock_init(&q->lock);
-	/* One reference for the timer, one for the hash table. */
+	/* One reference for the timer, one for the hash table.
+	 * We never take any extra references, only decrement this field.
+	 */
 	refcount_set(&q->refcnt, 2);
 
 	return q;
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index f7012479713b..d7bccdc9dc69 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -242,10 +242,8 @@ static int ip_frag_reinit(struct ipq *qp)
 {
 	unsigned int sum_truesize = 0;
 
-	if (!mod_timer(&qp->q.timer, jiffies + qp->q.fqdir->timeout)) {
-		refcount_inc(&qp->q.refcnt);
+	if (!mod_timer_pending(&qp->q.timer, jiffies + qp->q.fqdir->timeout))
 		return -ETIMEDOUT;
-	}
 
 	sum_truesize = inet_frag_rbtree_purge(&qp->q.rb_fragments,
 					      SKB_DROP_REASON_FRAG_TOO_FAR);
-- 
2.52.0

