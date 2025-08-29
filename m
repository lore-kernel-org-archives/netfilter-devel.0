Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D5B322A35
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 15:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756482734; cv=none; b=UX7iKaodMdOXL9lIvVcBlfsIh6cbhFOPC/gJBCrHYy1CLj5eJiMdMkPs5HFjWVt2SukjQwTl+/FQbhfPaTBgF2tbU0NoW471aJrvpXN2ux0onr5r8QceWgZ148AYcTsIaFhFm+shUXPLjCsWeZg1K/Xl+iSax0CQCpMvk++CkTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756482734; c=relaxed/simple;
	bh=i9wQUNPKdE+OpEGDIuUlx3TRXfviaCzyftvlrhSVNKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARlRoc0KlIwaKlge+4SoDdNVqCpjCUV46C5prsepHGLhCLmlQWoNEe/WWUQsTo5VVh0hu4NiMC1udCH5/UwINUr0HD+9FDD3+mkjRP5YB7b+NOr9OF3H0IZ3ANU19ceTL+T7RhCLeA8nomdniznYzsAaPJoNGNTUJqE7D23hiHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fCfj0dbC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fCfj0dbC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BgaRtftEw1A1TnJlKYBRv5KNdLVPAf/orwnFx7LWiAY=; b=fCfj0dbC6QsltYMI+rxdiP7E4Y
	66cNOLQ2SQ7j1LX+E7Ta4OcHemsKtIVxuXOrz5A/1V3qLHWBmu5vWGgF5wHpOOGb3jWL24Y09DCLg
	v78HFeXEC7Z+i3+2iZaMeXFvduvzAGoUFatpFmrqMmF4a8+787DUGw8ksHNuIGftaWlhrBfX6jfyN
	gFLA3nemFg8RffgDbHuhDly0bCUwS06I/uqlzgm2dQdGJItmMVUoZ9m4UdqJXo5fB12sP2vd5PiUh
	+Ckv+GtZ2DyLtDuOZYIBzsYC2UOBuJjIAk9UDQ8MmFQj1rIk/OpON36SC4dinu2lyvhO6pcsulQfp
	rArtRuig==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us1Od-000000001Rt-0Bri;
	Fri, 29 Aug 2025 17:52:11 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 1/7] tests: Prepare exit codes for automake
Date: Fri, 29 Aug 2025 17:51:57 +0200
Message-ID: <20250829155203.29000-2-phil@nwl.cc>
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

Make the test suite runners exit 77 when requiring root and running as
regular user, exit 99 for internal errors (unrelated to test cases) and
exit 1 (or any free non-zero value) to indicate test failures.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 11 ++++-------
 tests/py/nft-test.py       | 12 +++++++-----
 tests/shell/run-tests.sh   |  2 +-
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 67d3e618cee07..969afe249201b 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -12,18 +12,15 @@ err() {
 	echo "$*" >&2
 }
 
-die() {
-	err "$*"
-	exit 1
-}
-
 if [ "$(id -u)" != "0" ] ; then
-	die "this requires root!"
+	err "this requires root!"
+	exit 77
 fi
 
 testdir=$(mktemp -d)
 if [ ! -d $testdir ]; then
-	die "Failed to create test directory"
+	err "Failed to create test directory"
+	exit 99
 fi
 trap 'rm -rf $testdir; $nft flush ruleset' EXIT
 
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 984f2b937a077..78f3fa9b27df7 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -1519,7 +1519,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
 
     if os.getuid() != 0:
         print("You need to be root to run this, sorry")
-        return
+        return 77
 
     if not args.no_netns and not spawn_netns():
         print_warning("cannot run in own namespace, connectivity might break")
@@ -1538,11 +1538,11 @@ def set_delete_elements(set_element, set_name, table, filename=None,
     if check_lib_path and not os.path.exists(args.library):
         print("The nftables library at '%s' does not exist. "
               "You need to build the project." % args.library)
-        return
+        return 99
 
     if args.enable_schema and not args.enable_json:
         print_error("Option --schema requires option --json")
-        return
+        return 99
 
     global nftables
     nftables = Nftables(sofile = args.library)
@@ -1555,7 +1555,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
         print_info("Log will be available at %s" % LOGFILE)
     except IOError:
         print_error("Cannot open log file %s" % LOGFILE)
-        return
+        return 99
 
     file_list = []
     if args.filenames:
@@ -1601,5 +1601,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
                 print("%d test files, %d files passed, %d unit tests, " % (test_files, files_ok, tests))
                 print("%d error, %d warning" % (errors, warnings))
 
+    return errors != 0
+
 if __name__ == '__main__':
-    main()
+    sys.exit(main())
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 2d2e0ad146c80..46f523b962b13 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -96,7 +96,7 @@ _msg() {
 		printf '%s\n' "$level: $*"
 	fi
 	if [ "$level" = E ] ; then
-		exit 1
+		exit 99
 	fi
 }
 
-- 
2.51.0

