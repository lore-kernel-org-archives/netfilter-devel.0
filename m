Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793901499;
	b=AEii3Jos5HjJ3Musi+BXzYAAO4Xvtt8C0JJX+sPHmCYtu95lLCamc3B7zImngt4wK2Ob
	 z+Nh0ZJcUSesjYTnFTLJT+qUbijToFDoctkb2kUr+o5ItOt7c/JhWVQJudfVnyvPujiFN
	 tFRuvv8Gdg/1AHirF4AhylxDLCOov8K0Vc14RNfspWEH50Ojaa+CQHAXVN5ft6daco/y+
	 H/I0BJ0dEY7LVSYEklofQ5n97IdvEp8v2StBYt+DCJ+3VT6rVn4+MnCX1qVQq4rVyuQQi
	 pJKLuMzExF/+AmvOMymQ5Cc8F7ObHgvaoNrHae0w+zAz7vJ+ujqByLMph8R8RsBrREg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793901499;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R06pgEfktyfQZu+A3hIs6OXlbuliUPbW7nq6VXPE0zs=;
	b=xpPrU3qmy2U3BlUWFd77Ck1wBWV/tXXlaeMAVodoXuRZQCWnNLVAKwmuqPyQFwRfAD47
	 kL7jUet59GTa1OPQepBOZA6bXxnilq/8LDIhkdJZvTd/fRN1lwqIMs4ODF9bkTB35W30A
	 wfk4EcOuSuOaZuLdd6Q5tXlMyeJvCDBqOaxfp+ycTiAHpJmi8Eh0n4W01i2WSMY9gkwAk
	 2ywz2/bJS1WZvR/priEECSwGhXygGZyoW2tjYdHT0nSl4j6YxpYf/upx+4l0irZHuY1qH
	 I1XsGzeyzKsgO3PK1M5mkpJ7bVE9QEkXePDtZljcpR9YD5OuBlNj1y+R03IuyVc5FEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2293D606A329
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 17:58:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2293D606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E425660380; Thu, 05 Nov 2026 18:58:15 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset] tests: hash:net,iface.t: check wildcard refresh ordering
Date: Thu,  5 Nov 2026 18:58:10 +0100
Message-ID: <20261105175810.22833-1-fw@strlen.de>
X-Mailer: git-send-email 2.56.0
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

When the first wildcard element gets re-added while '-exist (-!)' option
is given that request must not have side effects.

Check that the verdict isn't altered.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Yet another problem with the rewrite.

 tests/hash:net,iface.t | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
index 9f3d9e36e232..216f7e8a0253 100644
--- a/tests/hash:net,iface.t
+++ b/tests/hash:net,iface.t
@@ -289,5 +289,17 @@
 0 ipset del test 10.0.6.0/24,eth
 # Check the wildcard element was removed
 1 ipset test test 10.0.6.0/24,eth1
+0 ipset flush test
+# Wildcard refresh ordering: add first wildcard, marked nomatch
+0 ipset add test 10.0.0.0/24,eth wildcard nomatch
+# Wildcard refresh ordering: add second, overlapping wildcard, matching
+0 ipset add test 10.0.0.0/24,et wildcard
+# Wildcard refresh ordering: first-added wildcard must win: nomatch verdict
+1 ipset test test 10.0.0.1,eth0
+# Wildcard refresh ordering: refresh the first wildcard with -exist, data unchanged
+0 ipset -! add test 10.0.0.0/24,eth wildcard nomatch
+# Wildcard refresh ordering: verdict must still be nomatch.
+1 ipset test test 10.0.0.1,eth0
+# Wildcard refresh ordering: destroy set
 0 ipset destroy test
 # eof
-- 
2.56.0

