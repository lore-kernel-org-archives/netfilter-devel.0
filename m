Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CFC1FECD5
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Dec 2024 17:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733247666; cv=none; b=Usk9iLCCpg6S6oRZzyiHtpCzdWgESlqnGBaL+Mnt+WaNLy/RKG5F6OZgczCGlc5azIwZQEw9J09DZwPSFvCdTn7j3lxTEGj5F/ZpijOPnPC2pOvA0EbSiQin/tZ98EyMQj7lGz071wk86vzX+mOUF6AYxhhw8gkrEb3Xbh9wFtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733247666; c=relaxed/simple;
	bh=WIkJkytl332izrlZvPK+ne+DemxHft3JFQ3LMMg1eSs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Orh+ASsyHxC8IMk5ovr8zOhUFXD7gcKO5fu2JIHa3JAJJcG1vKfL7oTfiHJFdxnFx1yPUARepjm9sbDT5PQK4PMfUiReH6e2g97HmlCUGpEYTZovqABRV9lcnAf0r/KdRatWTlKQagn68iMsO0/76NhAck6WMxw/6Da0n2GY1uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=pd3cGtxZ; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="pd3cGtxZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sTV9UWPyCzdFGTJtpJnGzn+ZV9lvZAdMqBJM5pPmiT4=; b=pd3cGtxZO7ZOBi81FORt4m7Qmf
	pA/WyJTgH7SyGBexBUm+nbslemEMosaOeeJLyQF2BQ8mmH0lE0rVHyZ0UAP1odQjS86cR3uluXL35
	5tnvg+AVaweACwmrwzKtzBOEtk9iq3BorVN5y9paTDsaCx0k2Kz4uBSN4nfbJh1Ssa33m18pao/TN
	579ZeopmuD6dsExrqT6lMpzYByiI4VFgh5x+gowT73rxR3JOdzRzQKZq5CdSRQqkYSB0YmB9U4qAh
	IniOGtCadf0GUBr7LcR7QE31KzBFHmZIszvd5l/5RpPQZBxMN5Tz4Th12l4R9gCRWiwGBQUA931q3
	AMwSMI4w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tIWiw-0092FB-2H
	for netfilter-devel@vger.kernel.org;
	Tue, 03 Dec 2024 17:30:10 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons] build: fix inclusion of Makefile.extra
Date: Tue,  3 Dec 2024 17:30:01 +0000
Message-ID: <20241203173001.2575351-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.45.2
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

Commit 08a16d90ceae ("build: use `$(top_srcdir)` when including Makefile.extra")
replaces hard-coded relative paths used to include Makefile.extra with
variables.  However, despite the commit message, the variables are enclosed with
braces, not parentheses, and it transpires that automake does not support the
use of braces in this context.  As a result, Makefile.extra is not included, and
the libxt_ACCOUNT.so and libxt_pknock.so extensions are not built.

Use parentheses instead.

Link: https://bugs.launchpad.net/ubuntu/+source/xtables-addons/+bug/2080528
Fixes: 08a16d90ceae ("build: use `$(top_srcdir)` when including Makefile.extra")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/ACCOUNT/Makefile.am | 2 +-
 extensions/Makefile.am         | 2 +-
 extensions/pknock/Makefile.am  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/ACCOUNT/Makefile.am b/extensions/ACCOUNT/Makefile.am
index 2514386f00b8..473a739f981a 100644
--- a/extensions/ACCOUNT/Makefile.am
+++ b/extensions/ACCOUNT/Makefile.am
@@ -3,7 +3,7 @@
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${abs_top_srcdir}/extensions
 AM_CFLAGS   = ${regular_CFLAGS} ${libxtables_CFLAGS}
 
-include ${top_srcdir}/Makefile.extra
+include $(top_srcdir)/Makefile.extra
 
 sbin_PROGRAMS = iptaccount
 iptaccount_LDADD = libxt_ACCOUNT_cl.la
diff --git a/extensions/Makefile.am b/extensions/Makefile.am
index 8f0aeb5666da..b99712dfcd38 100644
--- a/extensions/Makefile.am
+++ b/extensions/Makefile.am
@@ -26,4 +26,4 @@ install-exec-local: modules_install
 
 clean-local: clean_modules
 
-include ${top_srcdir}/Makefile.extra
+include $(top_srcdir)/Makefile.extra
diff --git a/extensions/pknock/Makefile.am b/extensions/pknock/Makefile.am
index 1ca5f91025b7..5fcae4794230 100644
--- a/extensions/pknock/Makefile.am
+++ b/extensions/pknock/Makefile.am
@@ -3,7 +3,7 @@
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${abs_top_srcdir}/extensions
 AM_CFLAGS   = ${regular_CFLAGS} ${libxtables_CFLAGS}
 
-include ${top_srcdir}/Makefile.extra
+include $(top_srcdir)/Makefile.extra
 
 sbin_PROGRAMS = pknlusr
 dist_man_MANS = pknlusr.8
-- 
2.45.2

