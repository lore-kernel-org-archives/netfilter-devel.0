Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AE315C3
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jul 2024 00:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720483938; cv=none; b=tE321Yit9Q7VexyX/uNico4Jshxi3F6R2YelvWnlbOB5cbcnKd7riGMZOGJfOZsmU3/XKYBNYqFTtJqIluDZsEwlNgIipuLACAmgcgLMN3xw/n2/xPmWNtvvpor68MjXG2mNtnwcOhPzNXbYyIJQDXMHqbkTqHVv1tWsW2m9RIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720483938; c=relaxed/simple;
	bh=mN5wGvh9FYYP0SPYKwxKo5DOdVoECKvbCr9rgkanBoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irlroGFrOhAhH1OKNyX2wTHDr/6GWY2/WLoqrh+6444JkQjDba9A/VONk+JCJ1miRnt5cXnf4k2s8+sNp0T8aqKUSmgEWKzv8wTcEgtPL2UwPmxUK0zMsp/NFZzVzKAMfIGJ1OsD7S5lSiJ+2G3r07IM2NEHIuHp8xzO1h0CMY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sQySr-0005Mo-PF; Tue, 09 Jul 2024 02:12:13 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH nf] netfilter: nfnetlink_queue: drop bogus WARN_ON
Date: Tue,  9 Jul 2024 02:02:26 +0200
Message-ID: <20240709000356.12732-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <202407081453.11ac0f63-lkp@intel.com>
References: <202407081453.11ac0f63-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Happens when rules get flushed/deleted while packet is out, so remove
this WARN_ON.

This WARN exists in one form or another since v4.14, no need to backport
this to older releases, hence use a more recent fixes tag.

Fixes: 3f8019688894 ("netfilter: move nf_reinject into nfnetlink_queue modules")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202407081453.11ac0f63-lkp@intel.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index f1c31757e496..55e28e1da66e 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -325,7 +325,7 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
 
 	i = entry->hook_index;
-	if (WARN_ON_ONCE(!hooks || i >= hooks->num_hook_entries)) {
+	if (!hooks || i >= hooks->num_hook_entries) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
 		nf_queue_entry_free(entry);
 		return;
-- 
2.44.2

