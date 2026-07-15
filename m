Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86893239E60
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jul 2026 23:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784156557; cv=none; b=est/1SXQVYYc3WBoN2j7b/gr7yi5BTjb+0uG43gOlHM2ipFteTGlbFRvUd6MeXHwBehW3pI3sM9wXM31SjJxV4Ry4EjDyVwCywoyMQuarRDEsS2pz3LBk7wvqi4d3sPoD0nsC0L4ea2CnJROT/vF0w25MqcwGK8uvTjfpUittQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784156557; c=relaxed/simple;
	bh=RYL93oBP9Rn6S6VOHgRaMfzIAdSXavwQkrHKmm5seik=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=jrKh4LCcKMNbAMGQWG/4eqmIM8ID2jcxRqjnMVk8VeExLFzhwet41paUPxLpL2m6XUBh7+ChllLHIYKy6djb8vwKh+vZYvIdibPo/GOpCIg4F0JwHNcgtyouCoUqnKJI7KWVkasByESnSCLbmrFqg31m5q7vPst/bGLfx3MTPY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=STDUJMqU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="STDUJMqU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yddGrkMl/MxTxTPtlAKVXL8aHKgT0CExnOqQxOkwoKY=; b=STDUJMqU77zR7SyaREX06qXwG8
	bMiVEgvEE5bdWSqHy1wC3wwlAfgptovRFJNtRAUx3woMXr1D2tULVWHbNY03h+ElbOfQ/Gq9IOKRs
	L7WwdqWYTPB/7JrOYcGGMBU+yVuQuUKf8QNMiXiDJOz35XN1fEfjEZ1Zykb0d6FPZjE0T41OBwDdC
	j+uubRLod+EDf0M/nLVqMFJIF+0jX6YKshECy6ZD8nwpC5aUTKW/Mn1RBL8R9KRPykJn5587JIR/A
	lCnarl5f0BfgqaOp1Eb3B8b5h7QNO+1E9WfvAOhTewkHoyRYHm4qK4kkWeC961Ji0NNYQr4/Cuis4
	U3v88sEQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wk8cT-000000005vL-44LP
	for netfilter-devel@vger.kernel.org;
	Thu, 16 Jul 2026 01:02:26 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: py: Fix --keep test runner option
Date: Thu, 16 Jul 2026 01:02:20 +0200
Message-ID: <20260715230220.240515-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The boolean flag expected a value, although not used. Set
'action=store_true' to really make it a flag.

While at it, simplify the code by eliminating the inverse-value
auto_delete helper variable.

Fixes: f2b5d6fc26b9a ("tests: py: don't use a fixed filename")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 56d4e0fc9d4e0..4a00ce0cd725a 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -36,7 +36,6 @@ chain_list = []
 all_set = dict()
 obj_list = []
 signal_received = 0
-auto_delete = True
 
 
 class Colors:
@@ -1523,7 +1522,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
     parser.add_argument('-l', '--library', default=None,
                         help='path to libntables.so.1, overrides --host')
 
-    parser.add_argument('-k', '--keep', default=False,
+    parser.add_argument('-k', '--keep', action='store_true',
                         help='keep log file around after tests')
 
     parser.add_argument('-N', '--no-netns', action='store_true',
@@ -1577,11 +1576,6 @@ def set_delete_elements(set_element, set_name, table, filename=None,
               "You need to build the project." % args.library)
         return 99
 
-    global auto_delete
-
-    if args.keep:
-        auto_delete = False
-
     if args.enable_schema and not args.enable_json:
         print_error("Option --schema requires option --json")
         return 99
@@ -1593,8 +1587,8 @@ def set_delete_elements(set_element, set_name, table, filename=None,
     tests = passed = warnings = errors = 0
     global log_file
     try:
-        log_file = tempfile.NamedTemporaryFile(prefix="nftables-test-py-", suffix=".log", mode='w', delete=auto_delete)
-        if auto_delete:
+        log_file = tempfile.NamedTemporaryFile(prefix="nftables-test-py-", suffix=".log", mode='w', delete = not args.keep)
+        if not args.keep:
             print_info("Log file %s will not be retained.  Pass -k to keep it." % log_file.name)
         else:
             print_info("Log will be available at %s" % log_file.name)
-- 
2.54.0

