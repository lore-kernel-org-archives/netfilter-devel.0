Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAD7322A25
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 15:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756482734; cv=none; b=EOWJIY4NbgXw3FwyqGMyOMoM505npN8EDLUSNQluntR/FuCR86DfqZP9B/Jnb0IGGrdH2P1rPK+hhyPK+3u9IF6AARGf5p5nwf/fPQ6c0fc//ktz03W0uE5W5XG99Nx/hp0gO+IGQfIXWvVYqg2y7ZOgRm2V5W0QbqfIEQeD/A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756482734; c=relaxed/simple;
	bh=tnYWVAGmRCVnYm6aeZPX3QuGzokpSOwsNlX83cfs+DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrEI3EGH+esI/M4EGDL/ggmQJffJXGOmr6YuX6j0VFFziSvv+SfiKdT3P1Uf1N5SryxerjHSEK2uKReMm17/RqkRjXdYT37bJ83PyGiDkQT4OZjZVCRN1n9WrGt6S4zwkWGjpCcxm7EN6+0AIzn+9NYUH2RdWe6DsTzUhcLrefk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PQqgEq7D; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PQqgEq7D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QhDK8xPwYPN303hhm1G6CqW3gin/zgX14GzqW/56YoQ=; b=PQqgEq7DwiiICZV1KiYlPoRIeQ
	W7VwinNUWRzwX61Qyea7sNNXpmDcnX91FAAToqiC8a7Hd9IlWpUHFooK/BCifHYpiyyw44Mt72FwP
	Bif5AIJatQPiyqT6FoJDnMyz4TWE0Qlq9epG3J0t3++5RGlPzc+e3qoNJcv/GRV0PQM/tYdsfiHh0
	965Gj8VPTM2w8+jOrjvei2nS7LLCjO9n1XbZu8+HQc2rCS7lPaIM5tL3qhui26qU6ILo6QkhPNlTc
	IH+ryGJChHZWbwKUq+CyIJYj1daJ9f1jjlekK8OsDWgk4tuWzIt370VDdYMZWiNRsi/i1lC/kX3St
	BdpBg5wQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us1Ob-000000001Rj-3ToB;
	Fri, 29 Aug 2025 17:52:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 3/7] tests: py: Set default options based on RUN_FULL_TESTSUITE
Date: Fri, 29 Aug 2025 17:51:59 +0200
Message-ID: <20250829155203.29000-4-phil@nwl.cc>
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

Automake is supposed to set this for a full testrun.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 78f3fa9b27df7..52be394c1975a 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -1517,6 +1517,13 @@ def set_delete_elements(set_element, set_name, table, filename=None,
     signal.signal(signal.SIGINT, signal_handler)
     signal.signal(signal.SIGTERM, signal_handler)
 
+    try:
+        if os.environ["RUN_FULL_TESTSUITE"] != 0:
+            enable_json_option = True
+            enable_json_schema = True
+    except KeyError:
+        pass
+
     if os.getuid() != 0:
         print("You need to be root to run this, sorry")
         return 77
-- 
2.51.0

