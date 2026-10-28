Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793192539;
	b=ET2EAlm+sQ2zW3CQNgvrEs9bJSaHKOAYcLX+HT4UM99LfmmrUnNRDaROA96OTwNYyII3
	 CV/8XpLPzLlX8o19PxNtvSlUjdBXSQVuKNdRcytm0/J3Bg173jdi3pdAtKJ0sOrHI1suu
	 pUZHiQW6a4HpC4aIf4rsRbVqTRMLfePb8eIaoEhh8r6kiu2DrvVyQD/PePe5730ZTEg2l
	 lg1BslxVNPBbzBqz72Wfq+8yvjChmZijL6ZUX4QjbVspwxT30D4E8J0IFrD9gn+AjFc7V
	 ruRdLoSWUxbTZEe43AmvvR1b6sc/PkiPxJeqp12QTRBwVCPZuqowwKP2EVEQwT9plYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793192539;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=APebxLxTnswIKgLPUCOCW52+Sd3Xl1ba3XHAhIoMikk=;
	b=0soE6F1avvJ3lEihv29uWU7fvrP8mvYfdaZpXilFMzulPMdEjzOgl79DnFk9qvImX/hP
	 E4ixXdW3qYsBgwqrbTRpn8fs40JeBD2IvSA8/awbjVE4px0h4JcEwZ6jhn+NsBmXKnmf0
	 h15ogR1HTiBls/VL6cU/8LIe1d3oZRlx+cXI/OuQ5WB5UldXVTuvEAEjwqmzoJO+eadt9
	 X6vcPaf6dnea7euXPDu4NkH92DaTXY2QqG9H8xd1senvh74vtYlOqaYZsnwgLORD1ckDX
	 TQgygvTljk2frCG+vMWCOi7zJbg3xQ/+DIBuMGn915kJpWr+FBy/EGuyT+bhb4qPAvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546A5606A31C
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 13:02:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 546A5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BABB9609D0; Wed, 28 Oct 2026 14:02:14 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset] tests: hash:net,iface.t: add test case for wildcard matching behaviour
Date: Wed, 28 Oct 2026 14:02:03 +0100
Message-ID: <20261028130203.1398-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
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

Document the existing behaviour of wildcard matching.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 LLM generated.  Passes on nf, fails with
 rhashtable conversion patches.

 tests/hash:net,iface.t | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
index 556d56df5c4b..b1d92bef26f8 100644
--- a/tests/hash:net,iface.t
+++ b/tests/hash:net,iface.t
@@ -235,4 +235,30 @@
 0 ipset list
 # Counters and timeout: destroy set
 0 ipset x test
+# Re-Create the set for wildcard tests.
+0 ipset create test hash:net,iface hashsize 128
+# Add a specific entry first, a wildcard entry for the same net second.
+0 ipset add test 10.0.1.0/24,eth0
+0 ipset add test 10.0.1.0/24,eth wildcard
+# Delete the specific entry.
+0 ipset del test 10.0.1.0/24,eth0
+# The wildcard entry should still be there and match eth1 via its prefix.
+0 ipset test test 10.0.1.0/24,eth1
+0 ipset flush test
+# Same layout: specific entry first, wildcard entry second.
+0 ipset add test 10.0.2.0/24,eth0
+0 ipset add test 10.0.2.0/24,eth wildcard
+# Re-add the specific entry with -exist, expecting a no-op refresh.
+0 ipset -exist add test 10.0.2.0/24,eth0
+# The wildcard entry should have survived the refresh and still match eth1.
+0 ipset test test 10.0.2.0/24,eth1
+0 ipset flush test
+# Add a nomatch exception first, a wildcard entry for the same net second.
+0 ipset add test 10.0.3.0/24,eth0 nomatch
+0 ipset add test 10.0.3.0/24,eth wildcard
+# eth1 isn't excluded, so the wildcard should match it.
+0 ipset test test 10.0.3.0/24,eth1
+# eth0 is excluded by the nomatch entry; it must not match via the wildcard.
+1 ipset test test 10.0.3.0/24,eth0
+0 ipset destroy test
 # eof
-- 
2.55.0

