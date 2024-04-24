Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DEB15B153
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 12:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713961796; cv=none; b=INMfBepR7F0+vC0Lt2IdsCiNDx5ACGcKJfE96vhhrJfahJnKKQxnGkuFDboU4QTlYK0v9nnUZ2WHdpYpyIOlPPcN6tZfOdzTSKSGQFeU+WkbAGUds2PUHaBHRXc5oZ8zJZWVJCnlPkE4xF4d251Ya23V21B0Ect85sx698x+1/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713961796; c=relaxed/simple;
	bh=8cSOEYRJZBdc3Lypsx/aEkDuaF3/cyvE4R4c261zQas=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=hQMzcs8S687r7P4MAwGlSGoLD0LJl5iMuDUMqMoeQ7gTy4lC1ub596TxwRjhFa5m3YwEH9QLagA50PIHcr4OdTuhEgWJo0GuNbrGmVQ7aQi607ynImkHAoxy1Sa1dQlzgK3+Tvfk/4Dsy3tOo3n8v7ipcUlRpG2XjS+l7hDASuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=YuWXmT8c; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=g0wvTOjD; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="YuWXmT8c";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="g0wvTOjD"
From: Alexander Kanavin <alex@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1713961793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MxsGLGGu73akh7wmSnXuKw30+CAJucHbKFupEsJrPpQ=;
	b=YuWXmT8cvLSUQXhH8hOtvH2eNu6z72GMqO0/IbjvpFps+v8H45xGXo9mE30XixbeJhvgaD
	sL229sXdkqgxwFWPSPXfEchNrtjzVP7SrNOLr+/PYrjnDe8iU4JbqKLtpvzezGqegv2lVV
	Jd5DFKXTPt3rWl3gpXbTrsSKDrBKD/CbyLyLSjK2W+rsNF6tOO/LiNxVZtDK1RYx+5cJ9q
	yQ6BEuBSRloA2Ym6eWV9BWbuout4VUKU6OzWOXVT4yXzFyJ2MV1S4ShOmYdAYfmHKyUV6x
	0U6f4Yi2I6tw2M48dcPJr3uWnHpeBIpk1o7VbzmPJwGPvEpY0ba0YSTOLqnmDg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1713961793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MxsGLGGu73akh7wmSnXuKw30+CAJucHbKFupEsJrPpQ=;
	b=g0wvTOjDZ8Yk9mJIrsvNWr96flVpwZ3p+Z4Umqd8dOIAQwl+mn8MF4E0w2keK8b7NzoQvT
	GMyFTOClpERzK3BA==
To: phil@nwl.cc,
	netfilter-devel@vger.kernel.org
Subject: [iptables][PATCH] configure: Add option to enable/disable libnfnetlink
Date: Wed, 24 Apr 2024 14:29:52 +0200
Message-Id: <20240424122952.981359-1-alex@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Maxin B. John" <maxin.john@intel.com>

This changes the configure behaviour from autodetecting
for libnfnetlink to having an option to disable it explicitly.

Signed-off-by: Khem Raj <raj.khem@gmail.com>
Signed-off-by: Maxin B. John <maxin.john@intel.com>
Signed-off-by: Alexander Kanavin <alex@linutronix.de>
---
 configure.ac | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index d99fa3b9..d6077723 100644
--- a/configure.ac
+++ b/configure.ac
@@ -63,6 +63,9 @@ AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
 AC_ARG_ENABLE([nftables],
 	AS_HELP_STRING([--disable-nftables], [Do not build nftables compat]),
 	[enable_nftables="$enableval"], [enable_nftables="yes"])
+AC_ARG_ENABLE([libnfnetlink],
+    AS_HELP_STRING([--disable-libnfnetlink], [Do not use netfilter netlink library]),
+    [enable_libnfnetlink="$enableval"], [enable_libnfnetlink="yes"])
 AC_ARG_ENABLE([connlabel],
 	AS_HELP_STRING([--disable-connlabel],
 	[Do not build libnetfilter_conntrack]),
@@ -113,9 +116,10 @@ AM_CONDITIONAL([ENABLE_SYNCONF], [test "$enable_nfsynproxy" = "yes"])
 AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nftables" = "yes"])
 AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" = "yes"])
 
-PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
-	[nfnetlink=1], [nfnetlink=0])
-AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "$nfnetlink" = 1])
+AS_IF([test "x$enable_libnfnetlink" = "xyes"], [
+    PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0])
+    ])
+AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "x$enable_libnfnetlink" = "xyes"])
 
 if test "x$enable_bpfc" = "xyes" || test "x$enable_nfsynproxy" = "xyes"; then
 	PKG_CHECK_MODULES([libpcap], [libpcap], [], [
-- 
2.39.2

