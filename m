Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD4115A4AA
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 12:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713961696; cv=none; b=JOVzsILFi3NPXI3eUmM4PUY1vBWjZp/ABQfjcFXERfEOfnaHtHN5QkmgKY0+37soen4SUr3csA/OOYy4ZxDBGwZXAJ4qVnQCn++IV+Eu4v5Af3xV34RqWVNvbwN4u41cMOLeLedsRwnBra2gP67ppEQsaqN0fe1NbH0Mprn/Low=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713961696; c=relaxed/simple;
	bh=8cSOEYRJZBdc3Lypsx/aEkDuaF3/cyvE4R4c261zQas=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VGSTUoWUL63AoRFfYzxcS0fEqFuoHdh7lw5NttncMq6WFiXjP0hwCUZxKSNUtyLJQ+aQpMRcBALCE48tqcpv4Yng96i5UBkfTd8lqXJgYZkM8Q8FTfQJyjCJHrPl6/a9m6E2UKpbYK3F3Q8p2Sr2GGaaiN5Y0HtZK+42F8kSIOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=i/MyiMZQ; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=JwfWtyl4; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="i/MyiMZQ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="JwfWtyl4"
From: Alexander Kanavin <alex@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1713961693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MxsGLGGu73akh7wmSnXuKw30+CAJucHbKFupEsJrPpQ=;
	b=i/MyiMZQmrO4wYI6/cQcKRACuG6FuW+qhemtn9IKmcA8bxQxWtri5MaaYGAZtUVPVmbXvb
	64KcgwrIS6bXWLytjWXDDsiv/lPN1/ncosiQfvEK2VJpD25LH5zBryr6Jso+ofJsRLw6XJ
	0Kp0cG7XLEly03l+dOe++cs9bCoDdGRhIF2n/t1sbEew+LI1BBn+2omHUyifzehtERk8ID
	Bs2bIeH+5XEzq5R0jzvtNW3PIKxDpAZIWDudD2oZmjqnJ6I85KuAxVf6dY8PFI7yqixf03
	uDaoqENwJWCojGUQmwxInrToWPWa5j2rCS5ITzDRam/6kWrURHubf8/myIcxkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1713961693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MxsGLGGu73akh7wmSnXuKw30+CAJucHbKFupEsJrPpQ=;
	b=JwfWtyl4NX4qsivW9ORNn0pBXmVWqbzU5oyJ1q4p0NKSSavkO4NLXSK9wWCmPSaXrD6QYi
	atoDOUKblxrNXnDg==
To: phil@nwl.cc,
	netfilter-devel@vger.kernel.org
Cc: "Maxin B. John" <maxin.john@intel.com>,
	Khem Raj <raj.khem@gmail.com>,
	Alexander Kanavin <alex@linutronix.de>
Subject: [iptables][PATCH] configure: Add option to enable/disable libnfnetlink
Date: Wed, 24 Apr 2024 14:28:04 +0200
Message-Id: <20240424122804.980366-1-alex@linutronix.de>
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

