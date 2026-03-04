Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687EF3537CB
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2026 18:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772650117; cv=none; b=cnSpBN7MvdkNC/hZbHGnNbDPQeKe0sRkw2AIoFR89enWxTV5Wr+AUTByyP1n0jab4HSOp5Y1Z3Cl+xhsvRhqlxgkEl0BrfaUg1NzPolfJiXFhpQKdHIhEM4als3N3lXF7odehiAMSds3bWgfnmLyH5DeIcFYgl94m83ZvRAH3hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772650117; c=relaxed/simple;
	bh=pJNBePdV8jZLW9zbQqsbGg8Ie471Fh8UswlnCbHHmiY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=V1tu17zz/pvcdaoYe05mzMKvKA7s73NF0WILYmRJTWRsgPdHSdPEklkAenIUqavZcfz1ynBXyc5somS2e0KoD/tHbyX5kGOG2Nn+bnhxpN6MaFVRaIZAiJT8zOQ21s2xHPwb7nB9/jFBkLoEOvBROTvsF6oyhxLBwBDUhW5TzOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=IddXHR/Q; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="IddXHR/Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WZD8YtNG4glLdXZX1aCzG1fBL8iOlTQFX6mlIqHLMSI=; b=IddXHR/Q2wyCAls2AtOdnf6xMA
	AEbAvj7Qdwpf8XPPkauPiLvlPHuFgFQ2du5ESbSMU6J5PRzDWy6ISW/hpd5Hgg5FbdisJ8sXdYHCs
	3wvsH2Cngey7qQYP/Dd+b8W67fytZKvSRTcX7fbgbG0zEzQc50enV24AvHMEEs9ZMgehuW9kEhcjx
	xm+ke/sf0U1h7dVhToF/DOfVHC6sSiRGeuuVPWYLCX2MpHOOWhNVNGLqFWMJbU+zJdCaAk10d8cX+
	5pSpoj7NrtO4Qd0dfQSzR41g5hqzIUUHkyuEp2dcfNLwpG9oLY1C7LVgOH5KTstMlErGatepCVtpb
	P6rL28cA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vxqie-00000009VOy-3ltc
	for netfilter-devel@vger.kernel.org;
	Wed, 04 Mar 2026 18:13:12 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables] tests: iptables-test, xlate-test: use `os.unshare` Python function
Date: Wed,  4 Mar 2026 18:13:03 +0000
Message-ID: <20260304181304.696423-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

Since Python 3.12 the standard library has included an `os.unshare` function.
Use it if it is available.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables-test.py | 9 ++++++++-
 xlate-test.py    | 9 ++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 66db552185bc..40ed77035c02 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -572,7 +572,14 @@ def show_missing():
     print('\n'.join(missing))
 
 def spawn_netns():
-    # prefer unshare module
+    # prefer stdlib unshare function ...
+    try:
+        os.unshare(os.CLONE_NEWNET)
+        return True
+    except Exception as e:
+        pass
+
+    # ... or unshare module
     try:
         import unshare
         unshare.unshare(unshare.CLONE_NEWNET)
diff --git a/xlate-test.py b/xlate-test.py
index 1c8cfe71ffd4..247852939c9e 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -203,7 +203,14 @@ def load_test_files():
 
 
 def spawn_netns():
-    # prefer unshare module
+    # prefer stdlib unshare function ...
+    try:
+        os.unshare(os.CLONE_NEWNET)
+        return True
+    except Exception as e:
+        pass
+
+    # ... or unshare module
     try:
         import unshare
         unshare.unshare(unshare.CLONE_NEWNET)
-- 
2.51.0

