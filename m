Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7611F320A27
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756920193; cv=none; b=Ilq/5VERwVP+3NPfAFaHrpNI8kNnKrOAiwyJxy+SlsWbKvOa7Bzt7r80EJXE+6fS2ZY0oSayBA/j1cdjYHf7rsM2eenOIH000kpoCTJzSQWlkkrkzgDdz4pvSvCBSI1ZGqR9CUaHdOpT6QLu7/0I24CQA29DvVR+qgRzVioOCRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756920193; c=relaxed/simple;
	bh=OQ4KV9oUu3OMzd/7+veLHTHVHp9qFzf6mlSjIEfTtOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OL4OygsT8G6CMNz4G07+pX7aR5GoodH9DBXZPuy/bpZo7tkXjrpsY9jYHcBcQfeGmKx9meqb8fOSc89tb6Yyuh+LU8HqIyKJ9mXk6PXb6pa5e4u3Ez46SSnkbO1C8inizFtvfCw0rSv3T4PkvX32B+YqYdCBUNiAmoYRcG1E5q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=eoPEMIFq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eoPEMIFq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sRBUUuFY5v3dbqnceWoN6yCLcoPJu0D/Z5a1FqPlGiI=; b=eoPEMIFqdfJHRZ0gqg8G6nrp9m
	GoK4rJFCf8WO8xtF7+cJfLOPAgjrycY2KKZyhz2JmfcRrmtvKfOj9InC+O9MsKIkeSxLUD7SXFmbJ
	r+k9XIDhs5XLLOY/CSnTVZt7qbWYLyxxINwQDhh+yBfWNemINhFrcHEtj9M5qrcM4Ekh9/Jgs+voy
	4EDXRhN3Iopdon3FcPY1IvgusCEgqF1EAfpINyQ5D0/zqXLoVgpav40vEq30G5K1asvjwPMW7RgiB
	ukAIYxu+rbRY5wqgUm91JNjqe4zEnn+py76P65FiJLhTdbF6Oy45SQEWLnk5Q6tTFQUAYEsm1x5cZ
	0JK+uD3g==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utrCQ-0000000080y-3nmH;
	Wed, 03 Sep 2025 19:23:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 11/11] Makefile: Enable support for 'make check'
Date: Wed,  3 Sep 2025 19:22:59 +0200
Message-ID: <20250903172259.26266-12-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250903172259.26266-1-phil@nwl.cc>
References: <20250903172259.26266-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With all test suites running all variants by default, add the various
testsuite runners to TESTS variable so 'make check' will execute them.

Introduce --enable-distcheck configure flag for internal use during
builds triggered by 'make distcheck'. This flag will force TESTS
variable to remain empty, so 'make check' run as part of distcheck will
not call any test suite: Most of the test suites require privileged
execution, 'make distcheck' usually doesn't and probably shouldn't.
Assuming the latter is used during the release process, it may even not
run on a machine which is up to date enough to generate meaningful test
suite results. Hence spare the release process from the likely pointless
delay imposed by 'make check'.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v2:
- Drop RUN_FULL_TESTSUITE env var, it is not needed anymore

Changes since v1:
- Add an internal configure option set by the distcheck target when
  building the project
- Have this configure option define BUILD_DISTCHECK automake variable
- Leave TESTS empty if BUILD_DISTCHECK is set to avoid test suite runs
  with 'make distcheck'
---
 Makefile.am  | 9 +++++++++
 configure.ac | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index 5190a49ae69f1..9112faa2d5c04 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -23,6 +23,7 @@ libnftables_LIBVERSION = 2:0:1
 ###############################################################################
 
 ACLOCAL_AMFLAGS = -I m4
+AM_DISTCHECK_CONFIGURE_FLAGS = --enable-distcheck
 
 EXTRA_DIST =
 BUILT_SOURCES =
@@ -429,3 +430,11 @@ doc_DATA = files/nftables/main.nft
 tools/nftables.service: tools/nftables.service.in ${top_builddir}/config.status
 	${AM_V_GEN}${MKDIR_P} tools
 	${AM_V_at}sed -e 's|@''sbindir''@|${sbindir}|g;s|@''pkgsysconfdir''@|${pkgsysconfdir}|g' <${srcdir}/tools/nftables.service.in >$@
+
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

