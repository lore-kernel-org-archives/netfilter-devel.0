Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E02B2E2DEF;
	Fri,  2 Jan 2026 11:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767354127; cv=none; b=NTtNvlGrtiKiPyz8lS4YbscVY2JJhojKDoIkXEEEPIlRMiLv85gE46Eq6OTJDwKB02gU8975GxWNEbIAWOKO+zauIxBaXxvJaSt9vrj/iB92DkWsjWsXlACT6mmhuOhfq6gCayaiQbfgVMN3v39ley7tSHB+1B3k7gKuNo0QILg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767354127; c=relaxed/simple;
	bh=hPqtqKs3LeUx8cIiSpzHzCjCcJVEQ5gbLifCNJwaEEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVtB/xn0N+eP5TB5V8Zi7tXWDtJMA0LAgeg0D4XqVWvS7vWa2hl1HdqDWtRVolFVYdcUUS2dCUrOHXe2YAJtGrd9A+Iqa+jED0SimxbUH+Ul9X5CzGDK2ktD3ZdjtT4QodM5LMn/6r19axkupRYSBwisAu6oft6dh0FRnibvxqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 99793602F8; Fri, 02 Jan 2026 12:42:03 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 6/6] netfilter: nf_conncount: update last_gc only when GC has been performed
Date: Fri,  2 Jan 2026 12:41:28 +0100
Message-ID: <20260102114128.7007-7-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260102114128.7007-1-fw@strlen.de>
References: <20260102114128.7007-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Currently last_gc is being updated everytime a new connection is
tracked, that means that it is updated even if a GC wasn't performed.
With a sufficiently high packet rate, it is possible to always bypass
the GC, causing the list to grow infinitely.

Update the last_gc value only when a GC has been actually performed.

Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conncount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 3654f1e8976c..8487808c8761 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -229,6 +229,7 @@ static int __nf_conncount_add(struct net *net,
 
 		nf_ct_put(found_ct);
 	}
+	list->last_gc = (u32)jiffies;
 
 add_new_node:
 	if (WARN_ON_ONCE(list->count > INT_MAX)) {
@@ -248,7 +249,6 @@ static int __nf_conncount_add(struct net *net,
 	conn->jiffies32 = (u32)jiffies;
 	list_add_tail(&conn->node, &list->head);
 	list->count++;
-	list->last_gc = (u32)jiffies;
 
 out_put:
 	if (refcounted)
-- 
2.51.2

