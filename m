Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8347F204F76
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 16:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730911367; cv=none; b=GnWfAnphcKIZEuwpRcPh7QQiP88Ug79Orsz9uRsf/CId1b7aiz7eA7XntCOwBuPDo4l+pkD+SgJRt5Mw/m45+iXl/FZPe0AlxepxHUtOCIV30NI4B/eiZHP+nhI8Zo4mL6JK78bMNfWaaQo5/AsHDC2p+HZuTgxfLBtI3sMSjUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730911367; c=relaxed/simple;
	bh=/TdvhV+DvjjV5g9DKdRFP+ZEmPAQmC0xuGrUBcyz+N0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rc0gY1d+fGR+ZH0nWGOVht/fvv0/mcLvOff9Dr0Wa0Caaztnb5f7kc763pXsqVOKHepsh5UspUx3RVbT4gaWdjj33tbyOgCkT2jfhZ96TpTLFRWoRjDGzvuDlUNffvSuj8gsjxZmhEP/E6LUOFfH511W7nG0dGVxMMJjJR1WWoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cAbCRqWw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cAbCRqWw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aNOrLLimL9kTESuQ7Oj5amxku+BTZaKjRcHWdtzgWAI=; b=cAbCRqWwTUSBtTMZlc4lUfp+fH
	LhTpIwxVAw1L/xpMSyvkFwIZbWxaMl4dBB7XjMCoHy8kdOIClgo+5usf8ttXxY3v8g6aJK6nqAOt5
	uzxwuD7WYqUoxGX7o4f5qgk24JEvgLlHEWWRx9bHlrXVo7Kdnc4ceOtYy6PWov3Ik58iI9jPMZs0D
	hRSkjOF2XWureMw4ol0qdjbc23ntpnyXCjmTk2TDpqJhyhSmTuEGyTMGGKDEdb1KIXc65PUdPF50d
	D/eHFas7PFlbZ7+3YmoOEiWKmHI7/jepvGJ+6dn7TwKbVjLRKupbo3ZT5EmEEDk5H+ibzlG7QsJ22
	FcYXVmvA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8j77-000000005P5-3BHn
	for netfilter-devel@vger.kernel.org;
	Wed, 06 Nov 2024 17:42:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/5] tests: xlate-test: Fix for 'make distcheck'
Date: Wed,  6 Nov 2024 17:42:31 +0100
Message-ID: <20241106164232.3384-4-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106164232.3384-1-phil@nwl.cc>
References: <20241106164232.3384-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar problem as with the other suites: The build directory does not
contain test cases, only build results.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 xlate-test.py | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index b6a78bb250e27..1c8cfe71ffd46 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -188,8 +188,10 @@ xtables_nft_multi = 'xtables-nft-multi'
 
 def load_test_files():
     test_files = total_tests = total_passed = total_error = total_failed = 0
-    tests = sorted(os.listdir("extensions"))
-    for test in ['extensions/' + f for f in tests if f.endswith(".txlate")]:
+    tests_path = os.path.join(os.path.dirname(sys.argv[0]), "extensions")
+    tests = sorted(os.listdir(tests_path))
+    for test in [os.path.join(tests_path, f)
+                 for f in tests if f.endswith(".txlate")]:
         with open(test, "r") as payload:
             tests, passed, failed, errors = run_test(test, payload)
             test_files += 1
-- 
2.47.0

