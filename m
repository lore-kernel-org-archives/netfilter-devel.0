Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794392184;
	b=FlcLkBlOWeCceNg6ullMVeN6ZE35l06nf9EBxWlOmfHcpcz45JMurcEqA+/EtPf6QlPN
	 JsXEGty0I8HVsPKGvOy9uB5G/sTnFs8/pvEduVUnggfFg5i6cIDcApZhE6wOe/XPemxIz
	 rM/oIMjasLwJ4UN+EU9yhUHGtANR3QEBGDJ5Mz018azPL+IJ4BNL42OZpqQwZx8aT22Rf
	 7K/98nr7f2NlEKMvLQUT6iPP5fAMCtNwqVLZmjYeGjcTof+rbGvJpXBAFMeOVkSx6+L+c
	 oppM6kwxMTyAxfcN0qrFc95bVzXsCK+QUB+wiMrEaF9QdXcwj+jMv6NjHI/nESagDtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794392184;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=hEn5+W4I5DkbryWX9Xx6+U2ScmSj/KyR3NnsUmVcVDs=;
	b=ynhQQzahTTz6mpnLlA4x0CggoqAxvSCxislio2yFrsPXH74u2U7xi3cGQWPeP6MTMT5L
	 cxnbrZ9+F+BXoDMBG4TrG3pdfrrwkZQgQ1Gydyn6E5PJbLIo1jnfivtxCykVRO3ZN4tiD
	 M6lUwgyUONnBxd+zQe9596kNT47XUzftEl3wRfTEMeuxGH+dIervW9DevT5SVuVjhpZrd
	 b69f5e0s4/81MozsjO7+D+3b2pe+BhgFSS3TKIB08rLYE62u7yVahS5enbDJWyMCbu7Nt
	 SjsZ/SZ2iKB6dpMU2vRsx7xTm/9Bz4+fO6/QXg4C9ZywelVWChxBifwQRWAHO9p1Kww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D0C606A31C
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 10:16:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91D0C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EFD456060B; Wed, 11 Nov 2026 11:16:21 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 2/3] tests: hash:net,iface: timed-out entries must be ignored
Date: Wed, 11 Nov 2026 11:16:02 +0100
Message-ID: <20261111101603.22698-2-fw@strlen.de>
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

When a timed-out entry in a `hash:net,iface` set expires, it should no
longer affect matching: lookups must behave as if the entry had already
been reaped by GC.

As-is, the expired entry continues to shadow the broader one until GC
removes the entry from the set, creating a window where matching is
inconsistent with the entry's logical state.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Fails on main, but not on rhashtable v8 patches.

 tests/hash:net,iface.t | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
index 6566fb407e81..c4a8de45fced 100644
--- a/tests/hash:net,iface.t
+++ b/tests/hash:net,iface.t
@@ -190,6 +190,8 @@
 0 ipset -T test 1.1.1.3,eth0
 # Check live entry on intermediate /30 net blocks fallthrough to broader eth1 net
 1 ipset -T test 1.1.1.1,eth1
+# Check expired net no longer blocks fallthrough to the broader other-interface net
+0 ipset -T test 9.9.9.1,eth1
 # Delete test set
 0 ipset destroy test
 # Timeout: Check that resizing keeps timeout values
-- 
2.56.0

