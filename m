Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1362321771B
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 13:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775741218; cv=none; b=g8/W7onNOqxpm8PT4ruS8pS6zBGo3aLutMKh0zvKcRxzipfHjCScgs+vks/1iAxc/JBrdMlh2/WKR4gBu4RAxvDRwmohyCirQPxG5/KZJDV1NJAoJO/HFCGQRH5fKISAQFrj63CTeQNLseiemDtEuSamqQeTV41AM+GeP4JmMpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775741218; c=relaxed/simple;
	bh=I/kljcSCxDcjv4VxTrdEkqEAQo4Zr1vYKOimfwifzE0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nSWMZCtKW4VEKuw5WnU2WQEpmO2pkYjeYeUlUQcfbwRzyXoSt8ftUrUO19eHank8zD8mrDDXYdc/d46LODBWlxlewsVod2L+hp7LUAVI3BSOVZkVm7BED78C4YIFGsHWIUbmHCE8tsTpyp56CeC5jDkqQQJTlMa6znl5FvX/9gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DB70B60636; Thu, 09 Apr 2026 15:26:54 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: py: don't use a fixed filename
Date: Thu,  9 Apr 2026 13:58:47 +0200
Message-ID: <20260409132649.8571-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using a predicatable filename in /tmp is not good practice.

This test runs with uid 0 and stray symlink could lead to unwanted
effects.  Use a temporary file and auto-delete it unless -k/--keep gets
passed to us.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/nft-test.py | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 53fd3f7ae6fe..c83a737a5f3b 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -30,13 +30,13 @@ os.environ['TZ'] = 'UTC-2'
 from nftables import Nftables
 
 TESTS_DIRECTORY = ["any", "arp", "bridge", "inet", "ip", "ip6", "netdev"]
-LOGFILE = "/tmp/nftables-test.log"
 log_file = None
 table_list = []
 chain_list = []
 all_set = dict()
 obj_list = []
 signal_received = 0
+auto_delete = True
 
 
 class Colors:
@@ -1523,6 +1523,9 @@ def main():
     parser.add_argument('-l', '--library', default=None,
                         help='path to libntables.so.1, overrides --host')
 
+    parser.add_argument('-k', '--keep', default=False,
+                        help='keep log file around after tests')
+
     parser.add_argument('-N', '--no-netns', action='store_true',
                         dest='no_netns',
                         help='Do not run in own network namespace')
@@ -1574,6 +1577,11 @@ def main():
               "You need to build the project." % args.library)
         return 99
 
+    global auto_delete
+
+    if args.keep:
+        auto_delete = False
+
     if args.enable_schema and not args.enable_json:
         print_error("Option --schema requires option --json")
         return 99
@@ -1585,10 +1593,13 @@ def main():
     tests = passed = warnings = errors = 0
     global log_file
     try:
-        log_file = open(LOGFILE, 'w')
-        print_info("Log will be available at %s" % LOGFILE)
+        log_file = tempfile.NamedTemporaryFile(prefix="nftables-test-py-", suffix=".log", mode='w', delete=auto_delete)
+        if auto_delete:
+            print_info("Log file %s will not be retained.  Pass -k to keep it.")
+        else:
+            print_info("Log will be available at %s" % log_file.name)
     except IOError:
-        print_error("Cannot open log file %s" % LOGFILE)
+        print_error("Cannot create a temporary log file")
         return 99
 
     file_list = []
-- 
2.52.0

