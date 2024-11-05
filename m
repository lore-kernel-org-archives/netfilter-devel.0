Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDB41F5829
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 20:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730838978; cv=none; b=lWE8NuVo4+JdZkYQk0in8v04KH6no1kvLE5t+Akb/iBdc6cXuxoX50XccEU0bvVX8FfialBFZgpXXpCHz2oR4oL/mYroz408bn96FRZ1326Roly5wTnS62MrTFI+1OrUYlNTUkw8E9JNorjN1D0lS0QBOhQS+zBbK1gI0aSO0Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730838978; c=relaxed/simple;
	bh=BtXdt+yHFLdkg5PHLZerZGNIWXmZWMJhss0JhLzu0kA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=jBr2/6mYnpDUZwPcXDuxM2oTMxTdJA68/VMbFaB7DfBEhom1lYPtQ+sBU6g8uPETt1DaiFG8IYWnQRzY3VwmiLy+pNOQMA5Xam22W7K5v05AnuECyTwEAmf+t2XbWEg30Heudtll6wlKXaPtUXYLLyLyM4L2hB5aMg0OtCNh6CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HflONKOD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HflONKOD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kZHrQrav0Tq0wQssGviCZsndBZOS31/m2EPHpEbvWMU=; b=HflONKODjbr/ts0NBkYrQqGDLU
	AZfvauGxuFSIspGfY5dj2bdW82Clo8MFCG+RTBLuE4TlpBGzWXLxRbjouvRThNyiyhKI/w2G0k2DW
	2J22jPN5J5f7f+SRzwgwdXX8YhGgH60XJrasUdOuFXjj1CjK8emRK4rK92O4Br3QRJwJ4y6mzhwBz
	CammLQpkY/FJ0oiLjex8lXDfdzL6eNp4+fQ4G3XuTz3FUIpM8adP8fSBx0k7jzAPT+Ebs7YPNHRZY
	W6w5GhICzhsgU3TXwHUfPj481ZrW4NJApCSUQgoXbGGVXOglcZGDp7w1VBOmRZtUvUPTReztyCTba
	ctK03/EA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8QHe-000000002ws-4Bdy
	for netfilter-devel@vger.kernel.org;
	Tue, 05 Nov 2024 21:36:15 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] tests: iptables-test: Properly assert rule deletion errors
Date: Tue,  5 Nov 2024 21:36:10 +0100
Message-ID: <20241105203611.11182-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Capture any non-zero return code, iptables not necessarily returns 1 on
error.

A known issue with trying to delete a rule by spec is the unsupported
--set-counters option. Strip it before deleting the rule.

Fixes: c8b7aaabbe1fc ("add iptables unit test infrastructure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/iptables-test.py b/iptables-test.py
index 0d2f30dfb0d7c..413e3fdccc9e3 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -58,10 +58,23 @@ STDERR_IS_TTY = sys.stderr.isatty()
 def delete_rule(iptables, rule, filename, lineno, netns = None):
     '''
     Removes an iptables rule
+
+    Remove any --set-counters arguments, --delete rejects them.
     '''
+    delrule = rule.split()
+    for i in range(len(delrule)):
+        if delrule[i] in ['-c', '--set-counters']:
+            delrule.pop(i)
+            if ',' in delrule.pop(i):
+                break
+            if len(delrule) > i and delrule[i].isnumeric():
+                delrule.pop(i)
+            break
+    rule = " ".join(delrule)
+
     cmd = iptables + " -D " + rule
     ret = execute_cmd(cmd, filename, lineno, netns)
-    if ret == 1:
+    if ret != 0:
         reason = "cannot delete: " + iptables + " -I " + rule
         print_error(reason, filename, lineno)
         return -1
-- 
2.47.0

