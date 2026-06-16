Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2881344D88
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2026 19:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781637434; cv=none; b=YN4S81yF4WY6dwL5JYlQZ5PVQLGFbqo7KU2OcNRyJkRX8aVe2uA4ASu9q52XQuYmvubaU8ySEXeu7jWhNTSP/lvlz3u/8vWi5BMi6NOh36aCGBdO1chjYiB/GyIab0I9HRJjyNEK0MNZKYZUzh6tt8/899gTs+tKJEV/xnvwiYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781637434; c=relaxed/simple;
	bh=DLN+0iUfpUi1bdruR4u4FtSpkzyBBNdciRQC97Ub8Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tsgmGisY5dXjPqfy3YrqXJIonxHy8ceK56eBr+3sW+Z1HGygMylEgWlHyKu2S666zzqaKkllLavusWp9ofz4vumOgvsZrecENZSWVns9iNuYVXvaxcYXuNHJfI7IExpOJFkFBmGUMR5XA2oHkHHSBegKFCH7YDkr4OkTM7hjEpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E455560634; Tue, 16 Jun 2026 21:17:04 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nfnetlink: make OOM conditions fatal
Date: Tue, 16 Jun 2026 21:16:56 +0200
Message-ID: <20260616191658.2510-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Batch support design attempts to process the entire batch, even
after a call has returned an error.  The advantage is that userspace
gets all errors in one go.

The disadvantages are:
 1. ->call() needs to cope with bad-state-due-to-previous-error
 2. One error can trigger a cascade of followup errors which
    can obfuscate the real problem.

Make -ENOMEM fatal, if we cannot allocate some object there is
a high chance we're going to report followup errors that are
nonsensical from userspace point of view.

Fixes: 0628b123c96d ("netfilter: nfnetlink: add batch support and use it from nf_tables")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Not strictly required, but I think it makes sense to stop
 the batch early, as-is we might produce many silly followup errors.

 net/netfilter/nfnetlink.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 47f3ed441f64..a1d480e4789c 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -531,6 +531,13 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 				status |= NFNL_BATCH_REPLAY;
 				goto done;
 			}
+
+			/* No point in further processing; followup errors can
+			 * be bogus (e.g. -ENOENT because object that next
+			 * rule/element wants could not be inserted).
+			 */
+			if (err == -ENOMEM)
+				goto ack;
 		}
 ack:
 		if (nlh->nlmsg_flags & NLM_F_ACK || err) {
-- 
2.53.0

