Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB66149DFF
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Apr 2025 14:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122135; cv=none; b=T0F0mljHiR4Ph72G6y+GtStFEWwFAyMhptOk4iB87g/95Pn7O3TuFnAjFhu7vIlgfcoDWJhBwB8Jq/dbEwq1bJkqKhJMUimQOjxFciPd4VDtekaUGpDWtKV8TVepUlMPDcJPkDhh9P1f7sIdYzblxVWyUJmLPJBmjJ0zqryowls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122135; c=relaxed/simple;
	bh=jPFrdLx1u4jq4TBtT950PPtfjQf0649LTlewKZzOQXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVN/duEfZ3MY1fOWsV1oHmuO8y5bLI29UVtGITEv0U4dTWLE4Bx/V25tCNQExzdew1wtVqqs6w3dIXkDFpDNXnptfJ1LHHa8rcYCIPUibAbvLrTNe9mF8/ejFmvc1r+SyN0ExvLIth/1VuHYZjI7kVVlqlNJVjlg+1q+MVPzZI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u29q7-0002xd-KM; Tue, 08 Apr 2025 16:22:11 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nftables 1/4] tests/py: prepare for set debug change
Date: Tue,  8 Apr 2025 16:21:29 +0200
Message-ID: <20250408142135.23000-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408142135.23000-1-fw@strlen.de>
References: <20250408142135.23000-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Next patch will make initial set dump from kernel emit set debug
information, so the obtained netlink debug file won't match what is
recorded in tests/py.

Furthermore, as the python add rules for each of the family the test is
for, subsequent dump will include debug information of the other/previous
families.

Change the script to skip all unrelated information to only compare the
relevant set element information and the generated expressions.

This change still finds changes in [ expr ... ] and set elem debug output.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/nft-test.py | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 7acdb77f2d0a..ea70f19b196d 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -717,17 +717,20 @@ def payload_check(payload_buffer, file, cmd):
         return False
 
     for lineno, want_line in enumerate(payload_buffer):
+        # skip irreleant parts, such as "ip test-ipv4 output"
+        if want_line.find("[") < 0 or want_line.find("]") < 0:
+             continue
+
         line = file.readline()
+        while line.find("[") < 0 or line.find("]") < 0:
+            line = file.readline()
+            if line == "":
+                break
 
         if want_line == line:
             i += 1
             continue
 
-        if want_line.find('[') < 0 and line.find('[') < 0:
-            continue
-        if want_line.find(']') < 0 and line.find(']') < 0:
-            continue
-
         if payload_check_set_elems(want_line, line):
             continue
 
@@ -877,6 +880,8 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
                     gotf.write("# %s\n" % rule[0])
                     while True:
                         line = payload_log.readline()
+                        if line.startswith("family "):
+                            continue
                         if line == "":
                             break
                         gotf.write(line)
-- 
2.49.0

