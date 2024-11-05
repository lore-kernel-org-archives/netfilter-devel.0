Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B0D1F754B
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 20:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730838979; cv=none; b=OdCPcriQXAfDhqSezAqd9vxhGH63txku0yMfCV5XGY8RtEfW36ZwkziHtY7ezakbNsnkT3Z4eiuNZ2e7Qi3NpshKiCSj9xxKD5NMEr6+cYs4JFoNcgGMYdNVZrFcyWqiv6sQYM0SnXGqCN6D70IxvhNHx0LrM3qYkJcukU0tkx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730838979; c=relaxed/simple;
	bh=0ih9vu2qzbKBHFF2G53eOLKtEnFRnS7ONiE05haYi2M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=picvVi2C0LxjwyMi/Kx6u2nz1qBAtsiP/vv2HtQV4trsZwcUJzgzO2Kn6N0X/JWGpmD6Hf9UsF64YiLq4GgwPssvP5+42mWvBsdD9zG8zSBPdS/4rplncpJGMLIHnitieWZETe6H+NlzES6UYTD48pXYJGFe7CS9jv8l6njspUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KlG1Ilzu; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KlG1Ilzu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7eASEMAyhoaF7nEEFpnGQyjG8JuGj+MGzOpMBkPceU4=; b=KlG1IlzufHKzwU8by3VGQgPz6A
	Q3nCSLZHprRq1naJDV6TfY4kb9OP5aEwP0b0Wf6jey0N8rvJbtJ/19mRQ0GPrAyTt6GNOX1ghcdrr
	YDNsykiaN5OMqxFpzGiHywSDmKTy3yzIYP6Fkms7l0c9nrlCjGAd7SVqqu/foWbn8AiFZ10NzERTB
	D/iP0wE7itqQH4/hkSO7CGpUCTZXb9/mw6TUTk0lwMXoniLh7kA9W28QkauT+wLL58Nj0DbAofs8m
	oHikiPJN+wXMlYnig/7QNXJ/L4DZGMDLfcUFWCBKoZInuUUphJTG5r/tgIlyB53Dax88s2eq75qNF
	2VK+alSQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8QHf-000000002ww-2Dib
	for netfilter-devel@vger.kernel.org;
	Tue, 05 Nov 2024 21:36:15 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] tests: iptables-test: Extend fast mode docs a bit
Date: Tue,  5 Nov 2024 21:36:11 +0100
Message-ID: <20241105203611.11182-2-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241105203611.11182-1-phil@nwl.cc>
References: <20241105203611.11182-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To make things less confusing for new readers, describe at least what
the two significant functions do.

Fixes: 0e80cfea3762b ("tests: iptables-test: Implement fast test mode")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/iptables-test.py b/iptables-test.py
index 413e3fdccc9e3..141fec7b4ed16 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -241,10 +241,14 @@ STDERR_IS_TTY = sys.stderr.isatty()
 
 def fast_run_possible(filename):
     '''
-    Keep things simple, run only for simple test files:
+    Return true if fast test run is possible.
+
+    To keep things simple, run only for simple test files:
     - no external commands
     - no multiple tables
     - no variant-specific results
+
+    :param filename: test file to inspect
     '''
     table = None
     rulecount = 0
@@ -267,6 +271,9 @@ STDERR_IS_TTY = sys.stderr.isatty()
     '''
     Run a test file, but fast
 
+    Add all non-failing rules at once by use of iptables-restore, then check
+    all rules' listing at once by use of iptables-save.
+
     :param filename: name of the file with the test rules
     :param netns: network namespace to perform test run in
     '''
-- 
2.47.0

