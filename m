Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36D436BCC3;
	Mon, 25 May 2026 18:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779733801; cv=none; b=U9CLh1AHb7LLWKqkGN2jhyvku0P5zgzt5cN/YFNVj3Gi8FghDEXsqJ/9lL+HsYkOM3n/bs+v9v9E2LWXSwPt/Y1dZCT1NIldrTSb5whhOmALLc1oO4swGYwT7nFFOsHkwYIuzwGqKqP4AVr5NzCqts4up0920HlkSkzjsTTr9qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779733801; c=relaxed/simple;
	bh=m93Bf6yGk8DKSAN6/i+glOLBSAeDTI0X6DAftrrQucs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2a511DxggbQkc0mFtlRykplrhSPx0/vTgguiBxlGMiwpQQH6Ds8kupi4gYiV2mCP5lwmN3LvQiB6myE7DblUHNISP/MSYghSFmhrC2nIZHEk41sqtk4OEmayLVRjVx7Hp7Kp4YvofYSd2Tgmh+hPD4S8Xsut3P1Lskz3lcFrZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5EC7560595; Mon, 25 May 2026 20:29:58 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 07/11] netfilter: nfnl_cthelper: apply per-class values when updating policies
Date: Mon, 25 May 2026 20:29:20 +0200
Message-ID: <20260525182924.28456-8-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260525182924.28456-1-fw@strlen.de>
References: <20260525182924.28456-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Carlier <devnexen@gmail.com>

When a userspace conntrack helper with multiple expectation classes is
updated via nfnetlink, every class ends up with the first class's
max_expected and timeout values.

nfnl_cthelper_update_policy_all() validates each new policy into the
corresponding slot of the temporary new_policy array, but the second
loop that commits the values into the live helper dereferences
new_policy as a pointer instead of indexing it, so every iteration
reads new_policy[0] regardless of i.  An update that changes per-class
values is silently collapsed onto class 0's values with no error
returned to userspace.

Index the temporary array by i in the commit loop so each class gets
its own validated values.

Fixes: 2c422257550f ("netfilter: nfnl_cthelper: fix runtime expectation policy updates")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_cthelper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 0d16ad82d70c..34af6840803e 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -346,8 +346,8 @@ static int nfnl_cthelper_update_policy_all(struct nlattr *tb[],
 	for (i = 0; i < helper->expect_class_max + 1; i++) {
 		policy = (struct nf_conntrack_expect_policy *)
 				&helper->expect_policy[i];
-		policy->max_expected = new_policy->max_expected;
-		policy->timeout	= new_policy->timeout;
+		policy->max_expected = new_policy[i].max_expected;
+		policy->timeout	= new_policy[i].timeout;
 	}
 
 err:
-- 
2.53.0

