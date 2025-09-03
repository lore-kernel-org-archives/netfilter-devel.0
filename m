Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35453126B3
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756920191; cv=none; b=U6ihhDZLPQt+QBFQWwJl52KrpjGIMymupCZX6LpyEP2qliPw9pk9wnFx5NxTzPz4obgy0/x/sD4Wo4gwW9TTP/2V5zLOoRXQYrKE7fM56KkweAgP/4qu6G0LpVeSvTZiRdJmkJ2yac4A6aezfSls/FZp7cdGh7HG9STD8a/5lPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756920191; c=relaxed/simple;
	bh=cbDPoQde1DPgsr1F7RCqQsAgpAcmnN/dr1qI4e3x0bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvZn/rcNsyP4vNw4ux+tq/IGD4xfLdjydLyCdojQd0iJx+7XTv5h6rwFEpVAPHfOp2K8D8t7dJGDapm/PO5Jn47Rf1/1xi0IO/kSYdCA/ovL/D1aTDvOz5KsGyRqipW7iiM4A3q0p5ACcwxvwwBLxwukqzSX5NjXBtFNd6Mctp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VXoyZ4tk; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VXoyZ4tk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=280HOq13Ejg1bx9dziI3yfxsZWR8g9s/m2k5i3fklXQ=; b=VXoyZ4tk3Cx0CbYHj4ErX80Zsy
	X43bCQElYAc/hvTr+HeFfgr43p2fMaX/akTXE+Yr5sygU2l3gQukcJGDqVrs//lY2lmi3E8gTM+xV
	ORIBEwZdCziiHxbzKuB6wBzgg0GYZtYUiw1xtmaw7NcPxS+UgeAte4aGcVkwRswWJWqcay8pj1mvb
	geT31AjG4gnTgixEC41ivtM2LcDhcDjQ8hXGoVEQmhFLczDKAs+m1rTbxi+D+zZqDaEXIHXZHsn4Z
	MQg2WLj6NFDU6xl+UL/mA/GekQbx1C1JgOxRX9AJ17/jRVnkbfV8rnl3zFt9eKEPUC1oqahRT3N5H
	BuDsfRlw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utrCO-0000000080a-0CyG;
	Wed, 03 Sep 2025 19:23:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 07/11] tests: Prepare exit codes for automake
Date: Wed,  3 Sep 2025 19:22:55 +0200
Message-ID: <20250903172259.26266-8-phil@nwl.cc>
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
index 32b1b86e0cc6e..44f21a285b17c 100755
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
index 12c6174b01257..35b29fc90870b 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -1527,7 +1527,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
 
     if os.getuid() != 0:
         print("You need to be root to run this, sorry")
-        return
+        return 77
 
     if not args.no_netns and not spawn_netns():
         print_warning("cannot run in own namespace, connectivity might break")
@@ -1546,11 +1546,11 @@ def set_delete_elements(set_element, set_name, table, filename=None,
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
@@ -1563,7 +1563,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
         print_info("Log will be available at %s" % LOGFILE)
     except IOError:
         print_error("Cannot open log file %s" % LOGFILE)
-        return
+        return 99
 
     file_list = []
     if args.filenames:
@@ -1609,5 +1609,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
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

