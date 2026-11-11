Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794392188;
	b=UA23zNMKK3ZwvMngAO4ShxKmOOuQbLn2XWIj8wV7s8cnwCwdRkd0iDV8q9XURajHKmQF
	 aJJc7Y+pSn4VcMsjkLvAvwGfIIQn5RdWvyEG34erO/bbNfwHfMqoEAMp7gT0U+dvDMeTE
	 MHSO78ER/QBcz6sCL0bHyhykzy3MaiDMsE85Ooy2VP2iHtj72Fs2QGDvry2xKQhtABsdZ
	 JGkwFDScANfKqmXCfu/8rYDnqYR/NZ0seNoUrsfT0lZ+2to4m6T6JWYnjyuis8ELyA05f
	 VfD1Ul2IzdavoWV/6us4xX0IDI4EGh7ScyCuUUlprlib+9SareYguK3bRiDDdF7y3Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794392188;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=WiIocgb6DEybfaNpwXfSUKwKvNActBQQMtnzFzjvzwU=;
	b=qqEnGgUDKKslN8ejfu4M+1PajokCxAN1OMeQMZg5fDJ/jHt+q9R0Kze6I01nL+tjgbiR
	 e1uSdu9f83lS4mF3MzwkszXyW6voJS3BvbPJRWDbAqNT9mmEDt5twHYvwBoRxqBB5rure
	 BpGMZP9AAKHI5N8wRebD3s6Nb1OGVnKKyzqNE+CF2bt2Azco7u5mMNTqjBTAB1p+fE4oZ
	 fx3+wUEsLhZtL8eGplJVIeUHFb5IWNuR/op2MZ0TKTVYmizyRlP6cC4UWQBKESK98zFWz
	 LieRaKxVgwbmeeXxCNKxit6aPpbURS1737N8HIT+Gh5JRoTXC7W08dmJX22r8Z1dDVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05092606A336
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 10:16:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05092606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3DA196060B; Wed, 11 Nov 2026 11:16:26 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 3/3] tests: hash:net,iface.t: add test for exceeding the same-key bucket list
Date: Wed, 11 Nov 2026 11:16:03 +0100
Message-ID: <20261111101603.22698-3-fw@strlen.de>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261111101603.22698-1-fw@strlen.de>
References: <20261111101603.22698-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

flush, add 63 duplicate keys again (should work), then add entry 64
(should fail).

This test fails before the rhashtable conversion, the old hash
implementation did not reset h->bucketsize on flush, so post-flush
next duplicate key immediately hits 'set full' error due to the
refusal to expand the bucket further.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Fails on main, but not on rhashtable v8 patches.

 tests/hash:net,iface.t | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
index c4a8de45fced..0386cc7b7921 100644
--- a/tests/hash:net,iface.t
+++ b/tests/hash:net,iface.t
@@ -134,8 +134,12 @@
 0 n=`ipset list test | grep -v Revision: | wc -l` && test $n -eq 71
 # Flush test set
 0 ipset flush test
+# Add clashing elements after flush
+0 (set -e; for x in `seq 0 63`; do ipset add test 10.0.0.0/16,eth$x; done)
+# Check listing
+0 n=`ipset list test | grep -v Revision: | wc -l` && test $n -eq 71
 # Try to add more than 64 clashing entries
-1 (set -e; for x in `seq 0 64`; do ipset add test 10.0.0.0/16,eth$x; done)
+1 ipset add test 10.0.0.0/16,eth64
 # Delete test set
 0 ipset destroy test
 # Check all possible CIDR values
-- 
2.56.0

