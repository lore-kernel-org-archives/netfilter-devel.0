Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD02326D7C
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 15:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756482737; cv=none; b=X+/S8sYxxILXdmY+hFLtqrJHBu8D3PMtejsA0jvSOBaZoiVekVXTgIhk5Y8RAslUAFsiSLv0GWvrSbfVz77JLsMUC6LrGFWB9nnGoa2VOGqRjUQ4uHKNN3lQ/tLeG61a2ipI0dob8QxGwudYsZDkjCyGJOz+0gPfAnk4G3ccf5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756482737; c=relaxed/simple;
	bh=Td1xP4wUHR0ypUxklaBJtYsC6I3Z51Zjrf4q49UISX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRQ0ODK6fiyFu+EjbT03KQWv7r88qIHncgXUl58J0fsemnGsUpUWgo2ElJxbkgcGU3e7VESfvlM9GWNTV5W7BLhnpkbZMfMS4dhAoAw5C3Bct/zFn9BYoSDV0f2fLG4EdCfpB2sqKBnkExoa2buCH2BCv9FX8ICRDdIx94CY9zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YAM6sjWx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YAM6sjWx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pplAXLuz8im6XbCgnLnj2A+itEK38ExTiCGMZEMnBkg=; b=YAM6sjWxNevH0s0cZh7vm4QuGU
	v+LrwY/YX0dnz0GyBbvVAoEHQjFG08CvBtULy78dHLgCRFwxMG+jizKmgO21jOYZxuSAtFo7kyo9W
	Li+OuHRzyVHBHBK5UTy40F5EDZrLfZ4HJUFX3tCKAL41SFtkmzYd4b+O+Q4GU7GoH8toeBbm3imsY
	jHUL8Ed+/A/0S143AT+QehttvMB7FeXhUACbSnGBd0fBK5tOl6GcK/Wkwwcnd3Qx4nI0Auk4pnaJ8
	q9Z8ZRI0kx79wjr30+qQ3CVJgizZJQWVYIw2LZSJSCywmIOvWH/vESI3++vQ2n0eXnTcNLTj0gDPB
	uq3H4Pyg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us1Og-000000001SS-0vbq;
	Fri, 29 Aug 2025 17:52:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 7/7] Makefile: Enable support for 'make check'
Date: Fri, 29 Aug 2025 17:52:03 +0200
Message-ID: <20250829155203.29000-8-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829155203.29000-1-phil@nwl.cc>
References: <20250829155203.29000-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the various testsuite runners to TESTS variable and have make call
them with RUN_FULL_TESTSUITE=1 env var.

Most of the test suites require privileged execution, 'make distcheck'
usually doesn't and probably shouldn't. Assuming the latter is used
during the release process, it may even not run on a machine which is up
to date enough to generate meaningful test suite results. Hence spare
the release process from the likely pointless delay imposed by 'make
check' by keeping TESTS variable empty when in a distcheck environment.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Add an internal configure option set by the distcheck target when
  building the project
- Have this configure option define BUILD_DISTCHECK automake variable
- Leave TESTS empty if BUILD_DISTCHECK is set to avoid test suite runs
  with 'make distcheck'
---
 Makefile.am  | 10 ++++++++++
 configure.ac |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index 5190a49ae69f1..f65e8d51b501e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -23,6 +23,7 @@ libnftables_LIBVERSION = 2:0:1
 ###############################################################################
 
 ACLOCAL_AMFLAGS = -I m4
+AM_DISTCHECK_CONFIGURE_FLAGS = --enable-distcheck
 
 EXTRA_DIST =
 BUILT_SOURCES =
@@ -429,3 +430,12 @@ doc_DATA = files/nftables/main.nft
 tools/nftables.service: tools/nftables.service.in ${top_builddir}/config.status
 	${AM_V_GEN}${MKDIR_P} tools
 	${AM_V_at}sed -e 's|@''sbindir''@|${sbindir}|g;s|@''pkgsysconfdir''@|${pkgsysconfdir}|g' <${srcdir}/tools/nftables.service.in >$@
+
+AM_TESTS_ENVIRONMENT = RUN_FULL_TESTSUITE=1; export RUN_FULL_TESTSUITE;
+if !BUILD_DISTCHECK
+TESTS = tests/build/run-tests.sh \
+	tests/json_echo/run-test.py \
+	tests/monitor/run-tests.sh \
+	tests/py/nft-test.py \
+	tests/shell/run-tests.sh
+endif
diff --git a/configure.ac b/configure.ac
index da16a6e257c91..8073d4d8193e2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -155,6 +155,11 @@ AC_CONFIG_COMMANDS([nftversion.h], [
 AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
 CFLAGS="${CFLAGS} -DMAKE_STAMP=\${MAKE_STAMP}"
 
+AC_ARG_ENABLE([distcheck],
+	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),
+	      [enable_distcheck=yes], [])
+AM_CONDITIONAL([BUILD_DISTCHECK], [test "x$enable_distcheck" = "xyes"])
+
 AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
-- 
2.51.0

