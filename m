Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16D327CB35
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Sep 2025 20:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758141313; cv=none; b=kSWdhGT//zD0lbecWUosagoqhcYQUejtWpNaIQJHuci9qgxVc1Up42tyzyev0Dyhd2qVBHYRWRtyWvp0X81inWEkP3g0e0ybaEXwmCi13K9f3R1kyKoBzDOJ6aNyFbmogACHIO3kuAfJvk+8kPTtaS6DIxrrJwfirKcP+YBK6nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758141313; c=relaxed/simple;
	bh=FhZydW7VqznyAqJ2u9TNlTMHOikiiExyIv5NvWaCjGg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOQu4raOhN6eE6NhDqTsFN/VAoFrFrQxJC3T7W6Zdmsd7e3LI6YBYYvBAQTGZih/AtB2+eT/XkcPan+lSJEEXhpTZW6NtAvsJR87vetX8MCOK05Gb0nnCGFZHkO+6wfkXPl/a72Kj/rWtKffkt6EaGcAaKQR4J3XRsA9bKL7lC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=XkBazgxb; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="XkBazgxb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ky1QX7sM2ph09OXf+rSYrXaScZ9Ml6Si/QcWL4a4I3Y=; b=XkBazgxbvf/EacL1IuLFOv60I9
	R03UQ77v4F7jOs8dah4kI5RooeIbGCS10sifqxLGPLzILu0QyeUq58LA4MC6O301VH9laok5GUlf0
	jOE20uCKyh42S/kPHbeokWf958b/eHmPzmL6E3BfLivkfPMjV1jy3NB6HezdCvtxuTF9/OjLVphaa
	Gb+8aVhUUwNacNObItcDtZ80Ps793iCFoiPvFe+9woP36JzzgN7vQn/8nUZGRL//B4+r9xTFDl1eV
	OVCclRHsbHrr86ffkcaT1mg6op3+aTejpXPhzdzReVnpsXqJH5982v05LfoPubixwZpKq6ditOI+E
	2IkPgRUA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1uyyrm-000000076ym-413n
	for netfilter-devel@vger.kernel.org;
	Wed, 17 Sep 2025 21:35:02 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 2/2] build: don't install ancillary files without systemd service file
Date: Wed, 17 Sep 2025 21:34:54 +0100
Message-ID: <20250917203458.1469939-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917203458.1469939-1-jeremy@azazel.net>
References: <20250917203458.1469939-1-jeremy@azazel.net>
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

If the systemd service file is not installed, currently the related man-page
and example nft file are still installed.  Instead only install them when the
service file is installed.

Fixes: 107580cfa85c ("build: disable --with-unitdir by default")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Makefile.am  | 5 +++++
 configure.ac | 1 +
 2 files changed, 6 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index fac7ad55cbe7..bf1c3c443d40 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -421,10 +421,14 @@ EXTRA_DIST += \
 	tools/nftables.service.in \
 	$(NULL)
 
+if BUILD_SERVICE
 CLEANFILES += tools/nftables.service
+endif
 
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnftables.pc
+
+if BUILD_SERVICE
 unit_DATA = tools/nftables.service
 man_MANS = tools/nftables.service.8
 doc_DATA = files/nftables/main.nft
@@ -432,6 +436,7 @@ doc_DATA = files/nftables/main.nft
 tools/nftables.service: tools/nftables.service.in ${top_builddir}/config.status
 	${AM_V_GEN}${MKDIR_P} tools
 	${AM_V_at}sed -e 's|@''sbindir''@|${sbindir}|g;s|@''pkgsysconfdir''@|${pkgsysconfdir}|g' <${srcdir}/tools/nftables.service.in >$@
+endif
 
 if !BUILD_DISTCHECK
 TESTS = tests/build/run-tests.sh \
diff --git a/configure.ac b/configure.ac
index a3ae2956cdf3..f3f6ad436bed 100644
--- a/configure.ac
+++ b/configure.ac
@@ -130,6 +130,7 @@ AC_ARG_WITH([unitdir],
 	[unitdir=""]
 )
 AC_SUBST([unitdir])
+AM_CONDITIONAL([BUILD_SERVICE], [test "x$unitdir" != x])
 
 AC_ARG_WITH([stable-release], [AS_HELP_STRING([--with-stable-release],
             [Stable release number])],
-- 
2.51.0

