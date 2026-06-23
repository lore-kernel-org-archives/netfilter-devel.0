Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF762EEE7A;
	Tue, 23 Jun 2026 22:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782252959; cv=none; b=BMqL3g9qmT/aW9omepX+yipPW7jv/8ycwTXgCl6u3J7mhRgd8W9w5lXiPxcIMMmONfYpTYMVU+MfOqCq0auvDlXYDOuFc5OmR/U9CbBr5C3kAN/aLkdkYPK46lewkD6c+qwWB/J2EKP68yDSoWcOUd58x17+Xrd5Jm2rBx0Xhd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782252959; c=relaxed/simple;
	bh=nkHxwDl8N+UxbHgNPbgDn5hO6GkwhcO2r6cZEijuhDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nin4Vx1tjvuhR763pplRKRaklSg7B33hNuTMqCsfddBOHPYgZdyQPpa3dsU7Mz4FxIgr0ljHrvUsO/DydnNp/XGFS0TZqf+FyuLQaooJoA5uCa/vjMToDYtJjeSQv4zwuF57Sbfy9AgkR15WN14lEkKD/W32991IxeSuFigLsTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aC/sdJS0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aC/sdJS0"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 88AF860578;
	Wed, 24 Jun 2026 00:15:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782252955;
	bh=g3O7UlSRluXheseBwM3JMmdU729WJJxHm16X5R/wfHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aC/sdJS0lX0I0b9J5RxMhqwYnCoyfBoaTsjiBO79FejEikPSF56g6P1pgp8VW4pjL
	 Zjz9mPJ7cE+XyF9EukPFXEopE/8d7bMfmusSTT7/EPWJqt8ymUocEd+2afE5ALqfH0
	 jwl0XraT2zdd8n8htL5ok0QF/XNYljXzQqbkEhO2fKFfeT4T4rEO/OYfJ8EoambZ7x
	 EdRKaJMCqsskLb7PhNxQDOlDXvUNPmlYfO+Ot0dCpOvOI/FpGad3dNJtgmA4JVtMb3
	 N2i6BxhJVzQnRmwCYROqmw734f7gWmac0pOayS7iB205j0OlddkBYDFJUXYTix5EPH
	 sZRT008m+48jg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 02/14] netfilter: nf_conncount: prevent connlimit drops for early confirmed ct
Date: Wed, 24 Jun 2026 00:15:35 +0200
Message-ID: <20260623221548.701545-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623221548.701545-1-pablo@netfilter.org>
References: <20260623221548.701545-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Commit 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add
was skipped") introduced a regression where packets for valid
connections are dropped when using connlimit for soft-limiting
scenarios.

The issue occurs when a new connection reuses a socket currently in
the TIME_WAIT state. In this scenario, the connection tracking entry
is evaluated as already confirmed. Previously, __nf_conncount_add()
assumed that if a connection was confirmed and did not originate from
the loopback interface, it should skip the addition and return -EEXIST.

Skipping the addition triggers a garbage collection run that cleans up
the TIME_WAIT connection. Consequently, the active connection count
drops to 0, which xt_connlimit mishandles, leading to the false rejection
of the perfectly valid new connection.

Fix this by replacing the interface check with protocol-agnostic state
checks. We now skip the tree insertion and preserve the lockless garbage
collection optimization only if the connection is IPS_ASSURED. This
allows early-confirmed setup packets (such as reused TIME_WAIT sockets
or locally generated SYN-ACKs) to be properly evaluated and counted
without falsely dropping. The goto check_connections path is maintained
to ensure these setup packets are deduplicated correctly.

This has been tested with slowhttptest and HTTP server configured
locally to ensure we are not breaking soft-limiting scenarios for local
or external connections. In addition, it was tested with a OVS zone
limit too.

Fixes: 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add was skipped")
Reported-by: Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/177349610461.3071718.4083978280323144323@eldamar.lan/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index dd67004a5cc0..91582069f6d2 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -183,17 +183,16 @@ static int __nf_conncount_add(struct net *net,
 		return -ENOENT;
 
 	if (ct && nf_ct_is_confirmed(ct)) {
-		/* local connections are confirmed in postrouting so confirmation
-		 * might have happened before hitting connlimit
+		/* Connection is confirmed but might still be in the setup phase.
+		 * Only skip the tracking if it is fully assured. This guarantees
+		 * that setup packets or retransmissions are properly counted and
+		 * deduplicated.
 		 */
-		if (skb->skb_iif != LOOPBACK_IFINDEX) {
+		if (test_bit(IPS_ASSURED_BIT, &ct->status)) {
 			err = -EEXIST;
 			goto out_put;
 		}
 
-		/* this is likely a local connection, skip optimization to avoid
-		 * adding duplicates from a 'packet train'
-		 */
 		goto check_connections;
 	}
 
-- 
2.47.3

