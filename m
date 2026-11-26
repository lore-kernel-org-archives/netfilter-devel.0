Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795663982;
	b=CQP2VilIiL5ir5tIXsXtos5RaZiZverwMIk8RKxovf3sp1kpViWbIrkRJyZ0g35ZudoZ
	 GYgXqC5nFqnv+UabsDM5dHbDa35QF74V3H52s601fljPmh3kxBFnHc5JVXpow+4cvLrbD
	 82mj2U5lfXL5rHlSWxNcHmvwZL9O2rOj8hONUKNlWzmccSmCbDOpQUZwltPGNR3IjDvsC
	 VPFI7r9XX5avv2xd2DDoLoh/0SbNItfUDsTEJJENHjAde8T3qG6NRIQqXyxdzyjVXH5ok
	 Bq5Icf5VmgkXNQAJQbOVSh+v8KHhC9mjQOTRt1s2hr1ouOkWhNLAal6/Wz2h6nV6DWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795663982;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=nrSbC/cs3VsOcUqBfx7h3aM6x4J75RZ4WqBP7khUSIw=;
	b=1JPD8a+WTElHzeH2YPMsS702YEalaE4LcZJlP2mM6kZlotfhm4MMH2WFSbD0aSjsFdMt
	 KfqcdanDU6C4eAbo4mPyPtaOtZbFpNiD9oNq0+XxayKOiDqgzbVF12wMqX95W80w0XhZr
	 8EQkBuBwI6pARsCgtNmR5Z60a5Cyf3N7BrxpcI2EWgWWDGSEuGFJipOBDBJsSUSSZEoo4
	 ZOTd3zFmnFDneBUyAoeKMH2Qf2g6njHr/34exPJ52kMOXF9Ch4IRVFRavdhibsIhMUm1o
	 Pu7gi6bT81lzV2uu9vY1nO80ZcuvMDrUAZUwTkow38/ITPDz1QE7akiWWRTPnF/XNUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2712606A339
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 03:33:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2712606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6B8EC6069E; Thu, 26 Nov 2026 04:33:00 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 2/2] tests: hash:net,iface: add of an interface covered by a wildcard
Date: Thu, 26 Nov 2026 04:32:46 +0100
Message-ID: <20261126033246.25717-3-fw@strlen.de>
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

With a wildcard element in place, adding an interface it covers must
fail with EXIST, as in the array based implementation.  With -exist it
must refresh the wildcard element instead of creating a second one.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/hash:net,iface.t | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
index f509630f9fb5..3e465f1247ed 100644
--- a/tests/hash:net,iface.t
+++ b/tests/hash:net,iface.t
@@ -338,6 +338,16 @@
 1 ipset test test 10.0.0.1,eth0
 # Wildcard refresh ordering: destroy set
 0 ipset destroy test
+# Add vs. wildcard: wildcard element first
+0 ipset create test hash:net,iface
+0 ipset add test 10.0.0.0/24,eth wildcard
+# Add vs. wildcard: an interface covered by the wildcard is a duplicate
+1 ipset add test 10.0.0.0/24,eth0
+# Add vs. wildcard: with -exist the wildcard element is refreshed, not duplicated
+0 ipset -! add test 10.0.0.0/24,eth0 nomatch
+# Add vs. wildcard: the refreshed wildcard element is now nomatch for eth1 too
+1 ipset test test 10.0.0.1,eth1
+0 ipset destroy test
 # Full set: create a set with small maxelem parameter
 0 ipset create test hash:net,iface maxelem 2
 # Full set: add first element
-- 
2.56.1

