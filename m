Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34E63822B5;
	Fri, 19 Jun 2026 11:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870111; cv=none; b=tMXuUkqKwpjVKgxqhdT2P4NWFksh3Hjv8BzJLlxv9+nUOdxhHNG7pEPE/qGBkQNsLLD4+obH1QVRau03perU6cinwtj0VUgRZwwFkLsWcD0YnAM4Dckk/bYs5Xrza0GRcsImQKlSgyxFRAOk6x0Ljx4JFKY5OCbEfjbFtEt4RYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870111; c=relaxed/simple;
	bh=R3EscX/WS4xMnCCELneLpQA3bqcziFr+S5pCLhTL7xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5ip9/dQPdU/qNnXF81+qq/ik9e7Nigz9bF1lmao8Edu/ZiB3l3Skcv2428Cba7Kg9GwNfgvAvRkdeLuHGkqIOP5JPQzjZgZrDsLOUtZZL79KLxGVy8TE26vEEZBEzIDeae9cMDukTX/N7cnCUhRQO2Ciw13FhVdz4nDSoHqHz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YOLTLv2r; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YOLTLv2r"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 09130601BD;
	Fri, 19 Jun 2026 13:55:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781870105;
	bh=gcWI4cSoQ5i3BVGY8gh4jVfugum1uSkv7HSv5M4JRPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOLTLv2rxndevlu4RRgSlaiBzEP6p3fgjDg35PZ4Daw+cpolu26o3yMbklEyKgWED
	 IlMTKWjO5vYVwcIzYf7TTA9PzKEP2ZYABKv+JeM3KB2YYn9KiSwff6Ez1cyawLfjgA
	 +sRNmXI6pQD8ZnBFxmGpLHsMQuzue42MpofMDWdIhxYJs6PkjK6zN3RTGvW+3AMAMN
	 iy068zb2iA7/ny0kQ2dTsWMPb1NszDk5tYIV/F0GXoU7WoNaw9TM9kGy7ZyVm35mMv
	 otLgwnrOF+iqDfEAVqpWcFB5MQWi6Ekp3tLqukaDCQtVO3FJbYtKS2+K9tGXYczEkf
	 xn2dg/5AOUaFw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 05/16] netfilter: nfnetlink: make OOM conditions fatal
Date: Fri, 19 Jun 2026 13:54:40 +0200
Message-ID: <20260619115452.93949-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619115452.93949-1-pablo@netfilter.org>
References: <20260619115452.93949-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.47.3

