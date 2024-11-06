Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0201E04AC
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 16:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730911368; cv=none; b=IAPA7pfUM5vYBC6gECExPvw7RHwkGqR3Kn53+spQu6moi8/OX/sbuItfTc5HJv9LhtpNA4k9K8LKAgXT8dVtUyhpJdx0prpA82DbdHRZn04n3kTUmK9yBwQ6GPOd4JEEQ1eLoOh02TQ0iuw6wYDmfjkc7KrjqZepfe0P7k9XzGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730911368; c=relaxed/simple;
	bh=DsiOkyrRfUFgWXPsgtU2O3D3jscBPf++45HlhjeDzqU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3LMSCZ15+fLJDR6uqyoxwY/R1aUSvqlUU3dL1bOPHWrFH6wfOaCBODJH9HkS9/kAsg8wof6nv5RF33A0+png2uJEWhIr6M2W5JAxTXkOM9OsAqiZh7jygIP8jvUFCiKGsam0qN0iXLkyHnC+DBsZNjJKM5lkKVtgVcdWE3QZF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=piAlpwGA; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="piAlpwGA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=shWelwBIoOw6pjFDL487LlVa6trGDV8qMzSJEHrguFU=; b=piAlpwGAwSlbqX7ew2xNkoxkfv
	XKunmu+Kh1C/8bxMojdk/02SEQwyNjq641hvMN4RMV/DFp/HPoIaObx5gBoNNsgwjWdjuJtieAfCP
	cSIZO92rP1cv/uX8OXRppgrbZ0QFgxO2/mi799gsaMA9dEZNyPFLbLVVQ9ds3/5muwIaNp3Z+YrG+
	xle3OBevi78wbeVo3r5jYEHjmWbBe2DxJNBgOw1xkzwqMs0pPXzBuMkaVXEpcwVCq3hn/3X5woNzD
	hjIWe/xnaVHwdYncyPZ7uahiPbqOWrdJzuAipkEO+m6wVYg64QfMyF6KrGFL/c78Dvp56qf//8iHB
	IH8qv+Sg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8j77-000000005P0-0mve
	for netfilter-devel@vger.kernel.org;
	Wed, 06 Nov 2024 17:42:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/5] tests: iptables-test: Fix for 'make distcheck'
Date: Wed,  6 Nov 2024 17:42:30 +0100
Message-ID: <20241106164232.3384-3-phil@nwl.cc>
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

This was a tricky one: Since called from VPATH topdir, extensions/ do
not contain test files at all. The script consequently passed since 0
tests failed (of 0 in total).

Fix this by introducing TESTS_PATH which is extensions/ below the directory
of the running iptables-test.py. Keep EXTENSIONS_PATH as-is: The built
extensions are indeed there and XTABLES_LIBDIR must point to them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 141fec7b4ed16..66db552185bc3 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -30,6 +30,7 @@ EBTABLES_SAVE = "ebtables-save"
 #IP6TABLES_SAVE = ['xtables-save','-6']
 
 EXTENSIONS_PATH = "extensions"
+TESTS_PATH = os.path.join(os.path.dirname(sys.argv[0]), "extensions")
 LOGFILE="/tmp/iptables-test.log"
 log_file = None
 
@@ -558,7 +559,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
     '''
     Show the list of missing test files
     '''
-    file_list = os.listdir(EXTENSIONS_PATH)
+    file_list = os.listdir(TESTS_PATH)
     testfiles = [i for i in file_list if i.endswith('.t')]
     libfiles = [i for i in file_list
                 if i.startswith('lib') and i.endswith('.c')]
@@ -669,8 +670,8 @@ STDERR_IS_TTY = sys.stderr.isatty()
         if args.filename:
             file_list = args.filename
         else:
-            file_list = [os.path.join(EXTENSIONS_PATH, i)
-                         for i in os.listdir(EXTENSIONS_PATH)
+            file_list = [os.path.join(TESTS_PATH, i)
+                         for i in os.listdir(TESTS_PATH)
                          if i.endswith('.t')]
             file_list.sort()
 
-- 
2.47.0

