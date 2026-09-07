Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4488C521210;
	Mon,  7 Sep 2026 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801470; cv=none; b=GTnBN4tK9Xw8/0XE3byeOQqiHdGMz6GGjdSlkHZI12z8+yZygG+WSyCjeClzoYaJDgGZdBKfxKgFqlBSAwfQkD4+ywFHEhd/krZptz9CUQsk0uogZthDJcyeR82+Om52gXa5sEAX2aQ5VGy53ciE91lSMvgWmKFxS+27YSpE08Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801470; c=relaxed/simple;
	bh=M7GILb7a3ZSjQOaiKONK940WhxlKwmFXhn67ZTZnX8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dg3iSCEgkwzbbUivKWI9wGVbpK1kS2A760x0J7bryaL6KzykVM1SRWaGAOPm0GaqTROhm9bf7hvrQNxhFnYUe2e3IYNf6vK0W4NxOs5wX5p4bLJ84n3cp0djsC4p9Iiy82O9AvcZ/hMubDMAPiBvxbFQ/X6PwbsGYeJkBA+cFgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=or93Foii; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="or93Foii"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788801465;
	bh=aC6nXRLp5ci2lipBNlpSOKOCDVA8haAPZwzv5qFn8Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=or93FoiipXdlzdTwIWYjzC0hpBz4I3rNsJIMa/P+ZI6f/Nrm6UIYetnJ28QO/JcgC
	 5INhYF84hxFDf1+BwBXe7DjNqIZyvb2ZS3eqeh8NNAW/KyhLi2NxYfEuXVyIQsTWnv
	 sqBhz2SzkOrBiWZxbyfGI5nSa6wuhEcr22LoQbTkDDuq6WPcemFSw3Nomaw2X+i2WM
	 5ory4800eLsgU7reFzDSXKohKNlANQ4/KtsNKYlWfgWUp2nrjeljr3wlDwosgz5+cU
	 0TacpxrXT2yJ9ZbOLgCKc/PDYe07Wuo3a6/RqSw0Ml9IaH3dPPS1Uua19GDEAU00Du
	 qhalCgc5YBGEA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BBF4F607D5;
	Mon,  7 Sep 2026 19:17:44 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 6/9] netfilter: nfnetlink_log: cope with concurrent instance destruction
Date: Mon,  7 Sep 2026 19:17:29 +0200
Message-ID: <20260907171732.1407739-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171732.1407739-1-pablo@netfilter.org>
References: <20260907171732.1407739-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Instances are refcounted. However, only memory release happens on the
1 -> 0 transition; the unlink from hashes can occur with any refcount.

Uncooperative userspace can force a situation where a queue is pending
for destruction from netlink event while a different socket with same
portid processes an UNBIND request.

With right timing, this will unhash the instance again:

Oops: general protection fault, [..]
Call Trace:
 <TASK>
 nfulnl_recv_config+0x31a/0xd50
 nfnetlink_rcv_msg+0x7c2/0xeb0

Fixes: 0597f2680d66 ("[NETFILTER]: Add new "nfnetlink_log" userspace packet logging facility")
Reported-by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 9d7fec570abe..d923f2cb1398 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -228,13 +228,18 @@ static void __nfulnl_flush(struct nfulnl_instance *inst);
 static void
 __instance_destroy(struct nfulnl_instance *inst)
 {
+	spin_lock(&inst->lock);
+	if (inst->copy_mode == NFULNL_COPY_DISABLED) {
+		/* attempt to UNBIND a queue already pending
+		 * destruction via netlink close event. Ignore.
+		 */
+		spin_unlock(&inst->lock);
+		return;
+	}
+
 	/* first pull it out of the global list */
 	hlist_del_rcu(&inst->hlist);
 
-	/* then flush all pending packets from skb */
-
-	spin_lock(&inst->lock);
-
 	/* lockless readers wont be able to use us */
 	inst->copy_mode = NFULNL_COPY_DISABLED;
 
-- 
2.47.3

