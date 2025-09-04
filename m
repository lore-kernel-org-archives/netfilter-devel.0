Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4098D26A087
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999510; cv=none; b=UEz3J+TD/z5GdUCpZp5oxRwlpL5YZy7d3WUJZNrPlmmGOo/fRIi+MT0bkKVpjyT6ppv6npXFqiyBFcR8L0OD9OGMt+2bq8/hXxzOcp1tNBmZHhzvZkx3y9bFA36AHxzI3m4JxT3AZCsb0BEO4x9Q3BquLAsovDyrCHkP/e3dfkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999510; c=relaxed/simple;
	bh=H1T5fzOtJZZ+FXW2o27XChl65NfUO9YxhrEpurJ155s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUGg3H7vIn3trHMmgzucvGM5M2/K65LCVoVqoBlIO/MfCxe5ObkkVxA7YFIdLW0MxTomTAINUIQCACihDZ+SDFQPBizd98AT8vuCtiGHapav/yEMd0IW7UBE4+E+ANerHm5Syv7rlkz5TUSD3/iTKdscbwLL3Gk8Fi1KTRS5Xdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Z+R1IQuV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Z+R1IQuV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wsAK9zq/7Ig08ePSDYgSXS3wmi7Kr3XOibTmv5kC0qs=; b=Z+R1IQuVmpOG1OSeWsH1jywyER
	FMMvSK22lI/B2TrM5ktTkORl0Hphf0cW5dw0GsGvldTw4pgAUUnIn+cDDz0yqe4+jTJHboj6Czquv
	v2/dKyIocyQVjezWty92hM5uxhfM+qxUYNj6DLd39p0Cl2XJ3stOTLCW+a12He4f1FU2bf925bxgp
	XXm+4jVAaPtmH55RzvzrQZ5BaWEOSDFt/HrW3M57nvZ8tJgBWLzF8hO1GYyZ7yifkvsODCDMDJzW6
	wXMn5XWlF3OIltWnHu5+58kg+/9rcttEpFyVR9E1R5E2V+J44LIMGgjeOGlyzFDFs9jjYJXLXv1QH
	yxKdayKQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuBpj-000000001px-1qpx;
	Thu, 04 Sep 2025 17:25:07 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v4 8/8] Makefile: Enable support for 'make check'
Date: Thu,  4 Sep 2025 17:24:54 +0200
Message-ID: <20250904152454.13054-9-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250904152454.13054-1-phil@nwl.cc>
References: <20250904152454.13054-1-phil@nwl.cc>
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
Changes since v3:
- gitignore 'make check' generated logs and reports

Changes since v2:
- Drop RUN_FULL_TESTSUITE env var, it is not needed anymore

Changes since v1:
- Add an internal configure option set by the distcheck target when
  building the project
- Have this configure option define BUILD_DISTCHECK automake variable
- Leave TESTS empty if BUILD_DISTCHECK is set to avoid test suite runs
  with 'make distcheck'
---
 .gitignore   | 13 +++++++++++++
 Makefile.am  |  9 +++++++++
 configure.ac |  5 +++++
 3 files changed, 27 insertions(+)

diff --git a/.gitignore b/.gitignore
index 1e3bc5146b2f1..db329eafa5298 100644
--- a/.gitignore
+++ b/.gitignore
@@ -23,6 +23,19 @@ nftversion.h
 *.payload.got
 tests/build/tests.log
 
+# make check results
+/test-suite.log
+/tests/build/run-tests.sh.log
+/tests/build/run-tests.sh.trs
+/tests/json_echo/run-test.py.log
+/tests/json_echo/run-test.py.trs
+/tests/monitor/run-tests.sh.log
+/tests/monitor/run-tests.sh.trs
+/tests/py/nft-test.py.log
+/tests/py/nft-test.py.trs
+/tests/shell/run-tests.sh.log
+/tests/shell/run-tests.sh.trs
+
 # Debian package build temporary files
 build-stamp
 
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

