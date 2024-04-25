Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC3D8005C
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 08:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714035067; cv=none; b=TJ4QY/ywDp3Jvc9c7pE+9ycv9rtOUhVJW/V3czrMrr7KhiAqhqUmMxgtjnukt/56TnCHVlHo8jDSASMNTAWHVthwazAFInyG5AA4oc+qyYbc7FbwmUfjVEohyMCMTSSGmBoCC0ywjBPvrSlAoQ3Oy6WkhXoWdxILzPMQnU9pja4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714035067; c=relaxed/simple;
	bh=4+5ufroLsp7+QOppbDi9XtkehsElhb0MOUyNrWX7bRo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=WXO38WTNaIP6tbKIpdt5s+CRVPv1SQpgVAM1bD28iRXpqL27yLsmTAYFV59NiGLCaR8Bf8iHSiZxefBWgKo+C6+elHPRUoamSantynIOkYpncYb4TAiEnJM0NQg7O58xQr2wUPZop9VB5PDhsi6jZOlOo+3DlaNNkxCBs9vZBuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=L0mCBZwm; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=6qoSKypz; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="L0mCBZwm";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="6qoSKypz"
From: Alexander Kanavin <alex@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1714035062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vGZrz31VRywk9Kr2tFM+E2LwH3II9gcrv9VHdHgqzw0=;
	b=L0mCBZwm1ylNveb+bgLoofkkyvgYdNn0I+MEEEUf7mV+PaNzakMyED8ymHbkpZ4KnmJVaR
	3ZNnBD4IY1gUUfZbU/007RJdYss62L4PIOINjppX682AStTORmHaQ7Grx+FwGBSY+KjXPl
	HsEZCwRdO+uI/RjjeEQqpc6cS5eIIGaszbGsG41sP8hu+ttqwSbXB1ByDTRBnhEaaKasFa
	WgG8EG4w5QCmAkrAZfsaezSeGDH5+4bxrwc80i/zxnYidQ1SyfNPEjP2ZVaI1iwfhfuUEl
	6EGCKtG2iGcE4iB/JsoTLzKmiT4r7kp08ImMGUs9qTeailO2+opsXbHuMd8MMA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1714035062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vGZrz31VRywk9Kr2tFM+E2LwH3II9gcrv9VHdHgqzw0=;
	b=6qoSKypzMlAExr39QE/jJBvBSsqmnvtcajsXD93ti1QKYHBnk15VqipfErAfu7lp1mEi+T
	hfqIzcV23ya8qxDA==
To: phil@nwl.cc,
	netfilter-devel@vger.kernel.org
Subject: [iptables][PATCHv2] configure: Add option to enable/disable libnfnetlink
Date: Thu, 25 Apr 2024 10:51:02 +0200
Message-Id: <20240425085102.3528036-1-alex@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Maxin B. John" <maxin.john@intel.com>

Default behavior (autodetecting) does not change, but specifying
either option would explicitly disable or enable libnfnetlink support,
and if the library is not found in the latter case, ./configure will error
out.

Signed-off-by: Khem Raj <raj.khem@gmail.com>
Signed-off-by: Maxin B. John <maxin.john@intel.com>
Signed-off-by: Alexander Kanavin <alex@linutronix.de>
---
 configure.ac | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index d99fa3b9..c9194da0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -63,6 +63,9 @@ AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
 AC_ARG_ENABLE([nftables],
 	AS_HELP_STRING([--disable-nftables], [Do not build nftables compat]),
 	[enable_nftables="$enableval"], [enable_nftables="yes"])
+AC_ARG_ENABLE([libnfnetlink],
+    AS_HELP_STRING([--disable-libnfnetlink], [Do not use netfilter netlink library]),
+    [enable_libnfnetlink="$enableval"], [enable_libnfnetlink="auto"])
 AC_ARG_ENABLE([connlabel],
 	AS_HELP_STRING([--disable-connlabel],
 	[Do not build libnetfilter_conntrack]),
@@ -113,8 +116,14 @@ AM_CONDITIONAL([ENABLE_SYNCONF], [test "$enable_nfsynproxy" = "yes"])
 AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nftables" = "yes"])
 AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" = "yes"])
 
-PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
-	[nfnetlink=1], [nfnetlink=0])
+# If specified explicitly on the command line, error out when library was not found
+AS_IF([test "x$enable_libnfnetlink" = "xyes"], [
+    PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0], [nfnetlink=1])
+    ])
+# Otherwise, disable and continue
+AS_IF([test "x$enable_libnfnetlink" = "xauto"], [
+    PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0], [nfnetlink=1], [nfnetlink=0])
+    ])
 AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "$nfnetlink" = 1])
 
 if test "x$enable_bpfc" = "xyes" || test "x$enable_nfsynproxy" = "xyes"; then
-- 
2.39.2

