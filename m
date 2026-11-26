Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795663983;
	b=fr6/NECmBEy59oWcff3kcrLFdhMDY+/4lFpB9PrRTt6KQZF4hL9w6aPuO7Mgan9wPnQv
	 F3u+Q6Q8UVW38QuP2ECFoK7FJU3FsdKR+OBynOi6Klruo9iv8HJCEsM4Cq/F5+aVCVXvu
	 vj1fwkmrbjmXZ9KhiTGyD5lFOW4aq7v54Tszn+PIl1CTVZ4x5rP40q7eSC0eldGetNwvj
	 +ykD6WwG5zrLAtmgHFcEMFvt41uQwI4UZVOWqflNdKYI7jo2m5WpPtVMMCnGRl3UchU9z
	 DNMkah8/OHflZXT3pNGL5PV4mKkvhvT6kb2QUegwvseZ9TPLSpi5y7xx57KtxjiiRRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795663983;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=VsnpKA20jQhCf2WaFiFBZt6cGPfmISnDVS2euuf1aF0=;
	b=VXjAo6wZjj5nBb1tgNg/DUeEjwYjRpQTxnZOzW6dLjsXvQVceOdQ/b78t2dtV/v7yjFJ
	 OabfroDSyDvz8xzFEvlqZJMWN9slfnW3+lZtA4minTrUHa+o0UkvWB0BkMvx1wle4zKo9
	 3e6DJxAEfsqUavpHNUn7nvACgfIVxo+2lirFkn3NxpbL17Lm7+yAzRyWobUI1PxvnE2hu
	 corVP4oHW6rRHsDEyZ959WGU7c8XhsB6DCNdnSmndDpH167AJJugYml5GfMqby/UGGoMq
	 OZbXz8Xlf3i3Ph1/9JPwDjR1O0Ycjz1iLWFD6fSyqAdYIiQW8bwD+2N8w5qnkwGX5WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC2C606A6A5
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 03:33:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DC2C606A6A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 28CD460696; Thu, 26 Nov 2026 04:32:56 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 1/2] tests: hash:net,iface: add test for maxelem setting
Date: Thu, 26 Nov 2026 04:32:45 +0100
Message-ID: <20261126033246.25717-2-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126033246.25717-1-fw@strlen.de>
References: <20261126033246.25717-1-fw@strlen.de>
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

check maxelem provides the desired upper bound.
Check forceadd flag.

Forceadd is not guaranteed to work, so we can't fail in case no replacement
happened, but we can print an informal message.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/hash:net,iface.t | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
index f0c54734c580..f509630f9fb5 100644
--- a/tests/hash:net,iface.t
+++ b/tests/hash:net,iface.t
@@ -338,4 +338,36 @@
 1 ipset test test 10.0.0.1,eth0
 # Wildcard refresh ordering: destroy set
 0 ipset destroy test
+# Full set: create a set with small maxelem parameter
+0 ipset create test hash:net,iface maxelem 2
+# Full set: add first element
+0 ipset add test 10.0.0.0/24,eth0
+# Full set: add second element, different key
+0 ipset add test 10.1.0.0/24,eth0
+# Full set: add third element with a new key, must fail
+1 ipset add test 10.2.0.0/24,eth0
+# Full set: third element must not be in the set
+1 ipset test test 10.2.0.1,eth0
+# Full set: add element sharing the key of an existing one, must fail too
+1 ipset add test 10.0.0.0/24,eth1
+# Full set: refresh an existing element with -exist, must still work
+0 ipset -! add test 10.0.0.0/24,eth0
+# Full set: delete one element
+0 ipset del test 10.1.0.0/24,eth0
+# Full set: adding a new key works again
+0 ipset add test 10.2.0.0/24,eth0
+# Full set: destroy set
+0 ipset destroy test
+# Full set with forceadd: create a set with small maxelem parameter
+0 ipset create test hash:net,iface maxelem 2 forceadd
+# Full set with forceadd: add elements with different keys.
+0 ipset add test 10.0.0.0/24,eth0
+0 ipset add test 10.0.1.0/24,eth0
+0 (for i in `seq 1 254`; do ipset add test 192.0.$i.0/24,eth0; done) || true
+# Set contains two elements
+0 n=`ipset list test|grep 'eth0'|wc -l` && test $n -eq 2
+# Soft-check for forceadd eviction
+0 ipset list test | grep -q -F '192.0.' || echo -n "Notice: expected at least one 192 element in the set "
+# Full set with forceadd: destroy set
+0 ipset destroy test
 # eof
-- 
2.56.1

