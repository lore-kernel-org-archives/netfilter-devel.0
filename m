Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91B434BA24;
	Fri, 10 Jul 2026 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783694304; cv=none; b=UaZiXhg3olUNZSxPHw2JdC3WtbF+wm2iIjMWC6onKnbQxWfikIrQ9pry1sqFYK9W+5jhJffSaD6zhQG/0VRlY0DGpaC6XWUlfJpQJWUBdUkaAr0ZqWwm5/Lred2DMW4sMl1VxuHu0mQ7WH/fOlf774TEee9rep3sso/TUZ9U31c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783694304; c=relaxed/simple;
	bh=KKGIM6zOLU/HugjefWhG4K+DlRpyzK05p2KB/HClii0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGueueutBegyRdyFj8hn7LZBQKlIb5RFofAJ+73wXVnSsCdd1CyVWw85roguGOgEyb7B4SK4Y9KRFptjMis30li71AKRmm6yuW7fgEiKUxRqeIk0vc1d+cCnXHYVZKRHAZF/rsou0EQ88ooaQOJMAwetmZtKiwWYK1SGEiL/n4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 450B4606BC; Fri, 10 Jul 2026 16:38:21 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 9/9] netfilter: xt_physdev: masks are not c-strings
Date: Fri, 10 Jul 2026 16:37:33 +0200
Message-ID: <20260710143733.29741-10-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710143733.29741-1-fw@strlen.de>
References: <20260710143733.29741-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

... and must not be subjected to the 'nul terminated' constraint.
If the interface name is 15 characters long, the mask is 16-bytes
'0xff' (to cover for \0) and the valid device name is rejected.

Fixes: 8df772afc9d0 ("netfilter: x_physdev: reject empty or not-nul terminated device names")
Closes: https://bugs.launchpad.net/neutron/+bug/2159935
Cc: stable@vger.kernel.org
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_physdev.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index dd98f758176c..a388881c68d4 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -130,11 +130,6 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 		if (X(physoutdev))
 			return -ENAMETOOLONG;
 	}
-
-	if (X(in_mask))
-		return -ENAMETOOLONG;
-	if (X(out_mask))
-		return -ENAMETOOLONG;
 #undef X
 
 	if (!brnf_probed) {
-- 
2.54.0

