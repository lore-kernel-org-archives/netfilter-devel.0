Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EC7291C07
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236102; cv=none; b=UtpzNt0ajz0bsdTU0bplx/PbTe30Mp52PQYs3Naak7+q+sVVWpinly648jjiJnyRuFqH6th8n70bQ0v6LTqJfN2sTW2PrjK33CMhQTb4ZwqlLTriqh5aCOwFhTLrK1vHSFjxdZN/PzWAgNFjKReMQHrBkBh6E/xpRl73sgi75Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236102; c=relaxed/simple;
	bh=7lFyfvPDBLDMxwfx8nuGQVogl+aCrgrKz3GEA3sreOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOl1UjNPxURQ8THRWG4QjEHDZ/posTJAvrYfDVubcsff/+BUIasUIC6VmGWtST6zDbAcZSMLdk+81Z+ynmc2LfuUE7zG99W0x+fOIzrtxFA3qfnxV7RsEnoowVN0cBPwe/i/JzVtB2oUBKV4K7TjZxi0EEf3ulifuVqvLoxevWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UTE5rWSe; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UTE5rWSe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=boxd7M1KCu9uR1NdGp8PasDVZr7N4591Il3cYtdmU6Y=; b=UTE5rWSentXthpCyYIMC/9ORs+
	MI42pZ/q720T0PHtBoymNC2KzDiKD5/EKNxN5bZB4+eo3eg1G8NRVB0g+pAHPqhYfVoU4N2jpt5IJ
	z2KQmq//e/2wW6hbb2VRDq1GQ6sazWW+XlXs3LvcFJ4bF1Izu3IdwwzFE307az6OzDhrvSZPnTsMG
	hrzYhoNZBVRqBajrzdT8dE9TpA9rNoM4J96XEELv3saVnDgvB0bOJHL2Zjgd0MY0Md3WTkLRgcF+P
	d+q7vv62PYu6Xv5T0tWsw7Em/HC5gPb0KZWmzK31zmjlHa78ZqwJFdce1Xfhrv1+1jNr7oDyFOV2b
	zIGE/lmg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxr-0000000008V-118G;
	Thu, 23 Oct 2025 18:14:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 08/28] tests: py: Do not rely upon '[end]' marker
Date: Thu, 23 Oct 2025 18:13:57 +0200
Message-ID: <20251023161417.13228-9-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set element lines reliably start with whitespace followed by the word "element"
and are separated by the same pattern. Use it instead of '[end]' (or anything
enclosed in brackets).

While at it, recognize payload lines as starting with '  [ ' and avoid
searching for the closing bracket.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index dc074d4c3872a..ff2412acc21e9 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -686,7 +686,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
 def payload_check_elems_to_set(elems):
     newset = set()
 
-    for n, line in enumerate(elems.split('[end]')):
+    for n, line in enumerate(elems.split("element")):
         e = line.strip()
         if e in newset:
             print_error("duplicate", e, n)
@@ -698,17 +698,17 @@ def set_delete_elements(set_element, set_name, table, filename=None,
 
 
 def payload_check_set_elems(want, got):
-    if want.find('element') < 0 or want.find('[end]') < 0:
-        return 0
-
-    if got.find('element') < 0 or got.find('[end]') < 0:
-        return 0
+    if not want.strip().startswith("element") or \
+       not got.strip().startswith("element"):
+        return False
 
     set_want = payload_check_elems_to_set(want)
     set_got = payload_check_elems_to_set(got)
 
     return set_want == set_got
 
+def payload_line_relevant(line):
+    return line.startswith('  [ ') or line.strip().startswith("element")
 
 def payload_check(payload_buffer, file, cmd):
     file.seek(0, 0)
@@ -719,11 +719,11 @@ def set_delete_elements(set_element, set_name, table, filename=None,
 
     for lineno, want_line in enumerate(payload_buffer):
         # skip irreleant parts, such as "ip test-ipv4 output"
-        if want_line.find("[") < 0 or want_line.find("]") < 0:
-             continue
+        if not payload_line_relevant(want_line):
+            continue
 
         line = file.readline()
-        while line.find("[") < 0 or line.find("]") < 0 or (line.startswith("family ") and line.find(" [nf_tables]") > 0):
+        while not payload_line_relevant(line):
             line = file.readline()
             if line == "":
                 break
-- 
2.51.0

