Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109653A1BC
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2024 13:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706795464; cv=none; b=BU+2L9RCdOfUaBFFrGvHlsedLJITEa441pu5DckQ5a3ogq/ebRYvLg9+61bweP3FkfUUmgVj2X9AEJkrUfjKBj6m6hqPD/+GbYn2bBUuw1LrJzwqoLwd29Y5sXfQlxbKEu62WJqgA1M/XeGYfi2ODkwz4fkMMLYesXhZPo4F8NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706795464; c=relaxed/simple;
	bh=B7kEW+kJC3U4oYEAp4pzG2PnOTxnoypIevOEK7lWbv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZDQwTKxPyKrh3FVfSe/eBQttzZm4a/dLN/OvuaYyAAOfQ8eQUws317GwoDcqGpbOz++YVRJAJxKFla86+wvLXUa2w4gTNbDnMYjuzPGAeZGzOIdrRDsc57yAoXNW8A5kXE32ZnR+Rteqb/8NOfpQiAOL59c7XW74WZpWoQmP80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EcdulOrI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EcdulOrI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XzTkx+lKgcykPxOjhNt6dTn+DUe1G9ymXp/SxHNFWRY=; b=EcdulOrIJNIecY1u79hN7ixs/X
	CPHy5gD0ZakBlTnj6PPL9P6TU/OQumhKi+RXaWlC7KeQE/paLjlDcfsjIJX5prvZeiPka8ideLoUq
	bCbbx4HbljA/f+VBK4RYh+tgfoTaE6+sKkFCn4qFCH6herJaCzmKFNYrHg7auSRs78bMdA1LyJT6O
	fDAuLBFMCt+W72WL9NgAJAnZ0GmJ9XeTqNhKGgysZFmKfgtNjP+uUVV5t4kv5DRt2bL+/UhRTu4z0
	s/P3gMjeGWJb7ILns+C+mxAuvxnbS99c/MGd+NSnASsbttZzahJtB4kOe/6D3K7iVyBQBj9gEnd+F
	jAnFUlOQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVXT1-000000001Lx-008B;
	Thu, 01 Feb 2024 14:50:59 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 1/7] tests: iptables-test: Increase non-fast mode strictness
Date: Thu,  1 Feb 2024 14:50:51 +0100
Message-ID: <20240201135057.24828-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240201135057.24828-1-phil@nwl.cc>
References: <20240201135057.24828-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The simple search for the rule in save output accepted arbitrary leading
and trailing rule parts. This was partly desired as it allowed to omit
the leading '-A' flag or ignore the mandatory '-j CONTINUE' in ebtables
rules, though it could hide bugs.

Introduction of fast mode mitigated this due to the way how it searches
for multiple rules at the same time, but there are cases which fast mode
does not support yet (e.g. test cases containing variant-specific rule
output).

Given save output format will never contain the rule in first or last
line, so enclosing the searched rule in newline characters is sufficient
to make the search apply to full lines only. The only drawback is having
to add '-A' and '-j CONTINUE' parts if needed.

The hidden bugs this revealed were:
- Long --nflog-prefix strings are not cut to 64 chars with iptables-nft
- The TCPMSS rule supposed to fail with legacy only must specify an
  expected save output

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_NFLOG.t  | 2 +-
 extensions/libxt_TCPMSS.t | 2 +-
 iptables-test.py          | 6 +++++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_NFLOG.t b/extensions/libxt_NFLOG.t
index 25f332ae16b6b..0cd81c643b2d5 100644
--- a/extensions/libxt_NFLOG.t
+++ b/extensions/libxt_NFLOG.t
@@ -15,7 +15,7 @@
 -j NFLOG --nflog-size 4294967296;;FAIL
 -j NFLOG --nflog-size -1;;FAIL
 -j NFLOG --nflog-prefix xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;=;OK
--j NFLOG --nflog-prefix xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;-j NFLOG --nflog-prefix xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;OK
+-j NFLOG --nflog-prefix xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;-j NFLOG --nflog-prefix xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;OK;LEGACY;=
 -j NFLOG --nflog-threshold 1;=;OK
 # ERROR: line 13 (should fail: iptables -A INPUT -j NFLOG --nflog-threshold 0
 # -j NFLOG --nflog-threshold 0;;FAIL
diff --git a/extensions/libxt_TCPMSS.t b/extensions/libxt_TCPMSS.t
index fbfbfcf88d81a..b3639cc17a935 100644
--- a/extensions/libxt_TCPMSS.t
+++ b/extensions/libxt_TCPMSS.t
@@ -1,6 +1,6 @@
 :FORWARD,OUTPUT,POSTROUTING
 *mangle
 -j TCPMSS;;FAIL
--p tcp -j TCPMSS --set-mss 42;;FAIL;LEGACY
+-p tcp -j TCPMSS --set-mss 42;=;FAIL;LEGACY
 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 42;=;OK
 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --clamp-mss-to-pmtu;=;OK
diff --git a/iptables-test.py b/iptables-test.py
index 179e366e02961..cefe42335d25d 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -143,7 +143,8 @@ STDERR_IS_TTY = sys.stderr.isatty()
         return -1
 
     # find the rule
-    matching = out.find(rule_save.encode('utf-8'))
+    matching = out.find("\n-A {}\n".format(rule_save).encode('utf-8'))
+
     if matching < 0:
         if res == "OK":
             reason = "cannot find: " + iptables + " -I " + rule
@@ -470,6 +471,9 @@ STDERR_IS_TTY = sys.stderr.isatty()
             else:
                 rule_save = chain + " " + item[1]
 
+            if iptables == EBTABLES and rule_save.find('-j') < 0:
+                rule_save += " -j CONTINUE"
+
             res = item[2].rstrip()
             if len(item) > 3:
                 variant = item[3].rstrip()
-- 
2.43.0

