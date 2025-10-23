Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA432356D9
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236101; cv=none; b=GlOm6twkxepn/dnDsjYjVshoG+NzpKJ41RrP9BH0Jk18Zh+dx6q13RF7p2//tqT8EyTtCDWRzKymUKG8HVRbgjmQhaKe1YT0ku0ZLfJkcQaQl2aPnmHNi2V+NxqnU4x7ZTAqXXZO5IbpArtmROAtmSv7Z2GIQSAGgR7lpEzMNVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236101; c=relaxed/simple;
	bh=uRUtb1quTs9cmF0LOtvwbPB8g+ICss0JC4yXGCP6zdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H65VSks66w5S55DTBBZ6Y2uKA1ebamNHu2unzEzuobaj1nTWx/FV9ES/j4J2Ctr6Gv799+oR7KgDzfC3sAHoesrcpHrU/1z539ZGUc6EdnJxH+U7Q4AM3dqoq7V5pGsgAqyTMiVlj5epcxWxP8R1aY9sZxZ8CztficP/aXBmm60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XBSaFpxi; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XBSaFpxi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NO2i6P4FkJnrbi1V65+CT8bY/CFq0EfeRofPxnmWr6o=; b=XBSaFpxiJXwkhEItcobn34KGIg
	09c4KZ9SRd2kJxDhs+3hEG/2CXDTowSvk8xm1Uj7CO2+SYzbzpwdmtreKkOKZcHujAgOeeXD0Auop
	F6SfGPt3B5FavAHx1MfLHkEQWhuwE5TokDhDq/XggwqxW2Df9Qjso3RLDEYsPWO3Nt5xoZhyv0fhy
	Om9UUUb4zMB0iHDZNpJJBY7zEFQq7e+zEVvmPGsN3SHxxV14uGGMwAR6/IZAUfDnIayjZzm8fIhX0
	+0bR5TCE2MbDJxGM2H84oJidj5QpRnvQQWseChO/SPAH5Sc/KogIndhlGzWvMOe2ALDyTjh/0FBUB
	CpRNLMuA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxq-0000000008Q-1m6Y;
	Thu, 23 Oct 2025 18:14:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 11/28] tests: py: ip6/vmap.t: Drop double whitespace in rule
Date: Thu, 23 Oct 2025 18:14:00 +0200
Message-ID: <20251023161417.13228-12-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just a harmless typo.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/ip6/vmap.t                | 2 +-
 tests/py/ip6/vmap.t.json           | 2 +-
 tests/py/ip6/vmap.t.payload.inet   | 2 +-
 tests/py/ip6/vmap.t.payload.ip6    | 2 +-
 tests/py/ip6/vmap.t.payload.netdev | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/py/ip6/vmap.t b/tests/py/ip6/vmap.t
index 2d54b8226e426..bfaa0c3bfca80 100644
--- a/tests/py/ip6/vmap.t
+++ b/tests/py/ip6/vmap.t
@@ -32,7 +32,7 @@ ip6 saddr vmap { 1234::1234:1234:1234:1234 : accept};ok
 ip6 saddr vmap { 1234:1234::1234:1234:1234 : accept};ok
 ip6 saddr vmap { 1234:1234:1234::1234:1234 : accept};ok
 ip6 saddr vmap { 1234:1234:1234:1234::1234 : accept};ok
-ip6 saddr vmap { 1234:1234:1234:1234:1234::  : accept};ok
+ip6 saddr vmap { 1234:1234:1234:1234:1234:: : accept};ok
 ip6 saddr vmap { ::1234:1234:1234:1234 : accept};ok
 ip6 saddr vmap { 1234::1234:1234:1234 : accept};ok
 ip6 saddr vmap { 1234:1234::1234:1234 : accept};ok
diff --git a/tests/py/ip6/vmap.t.json b/tests/py/ip6/vmap.t.json
index 1b867ff076928..2ba071cf1140f 100644
--- a/tests/py/ip6/vmap.t.json
+++ b/tests/py/ip6/vmap.t.json
@@ -526,7 +526,7 @@
     }
 ]
 
-# ip6 saddr vmap { 1234:1234:1234:1234:1234::  : accept}
+# ip6 saddr vmap { 1234:1234:1234:1234:1234:: : accept}
 [
     {
         "vmap": {
diff --git a/tests/py/ip6/vmap.t.payload.inet b/tests/py/ip6/vmap.t.payload.inet
index 931cc6bd75a77..26bca5e26f279 100644
--- a/tests/py/ip6/vmap.t.payload.inet
+++ b/tests/py/ip6/vmap.t.payload.inet
@@ -218,7 +218,7 @@ inet test-inet input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
-# ip6 saddr vmap { 1234:1234:1234:1234:1234::  : accept}
+# ip6 saddr vmap { 1234:1234:1234:1234:1234:: : accept}
 __map%d test-inet b
 __map%d test-inet 0
 	element 34123412 34123412 00003412 00000000  : accept 0 [end]
diff --git a/tests/py/ip6/vmap.t.payload.ip6 b/tests/py/ip6/vmap.t.payload.ip6
index 6e077b27a5f09..2aaa0e48f4b10 100644
--- a/tests/py/ip6/vmap.t.payload.ip6
+++ b/tests/py/ip6/vmap.t.payload.ip6
@@ -174,7 +174,7 @@ ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
-# ip6 saddr vmap { 1234:1234:1234:1234:1234::  : accept}
+# ip6 saddr vmap { 1234:1234:1234:1234:1234:: : accept}
 __map%d test-ip6 b
 __map%d test-ip6 0
 	element 34123412 34123412 00003412 00000000  : accept 0 [end]
diff --git a/tests/py/ip6/vmap.t.payload.netdev b/tests/py/ip6/vmap.t.payload.netdev
index 45f2c0b01e9c8..4d81309b9e6eb 100644
--- a/tests/py/ip6/vmap.t.payload.netdev
+++ b/tests/py/ip6/vmap.t.payload.netdev
@@ -218,7 +218,7 @@ netdev test-netdev ingress
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
-# ip6 saddr vmap { 1234:1234:1234:1234:1234::  : accept}
+# ip6 saddr vmap { 1234:1234:1234:1234:1234:: : accept}
 __map%d test-netdev b
 __map%d test-netdev 0
 	element 34123412 34123412 00003412 00000000  : accept 0 [end]
-- 
2.51.0

