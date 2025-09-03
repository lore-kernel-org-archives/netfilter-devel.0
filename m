Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BE02FE586
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756920190; cv=none; b=DYVarIPBdukNEULj6N2VRKt7CKMDKqfpY0LcAWGfmbDzf2aoh65d1vFcJpMNkvLxShtq6P61HmNsZQoRNLodI3Dy9YUoUMzokZyeaDJbr8xgDqMYO59RnGjV4pBLT2eNqyTUDbZNPn5qwRogkcMbzl7YcKrAYAP4IgJRv7IkGTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756920190; c=relaxed/simple;
	bh=MgNd/tGBSS1iElT9yi4aaHAus0poqchT+xRCPPlG22o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWiYK7H17Q3R/xXTAVi3hPWTgRwsPlqope3asSLfpIxbb2LCjSSBB37ZT9Nxaj+Rt0AIpqDr7nyUNCabAQwmr7rzkMVxlPceOd28lpcIC/jjzNN7hPwWPegHnFz8ZjFNfyrsSFjvuADcRwfV22l5EelmBpaweWwVvSDZf+3f75M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=NgBbzin+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="NgBbzin+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gcZmOOHv1RYYl+k9egiwllbrnC2TAl6QC4BhzMrc2lk=; b=NgBbzin+Xn6EzXSnyiRMqV6lvQ
	WgQg137K8hlCooS+fUGh17DnhCn1woUo0JUxQxs0TyrPJDyi6Xp1cmVBX20DV0M6cylPNsm0d35xI
	bUUJYP+BRKUo058mrdvTO7AoGB7BgqQKHAa0a3U29dKRQ+642/ZqPIyVt542vkcnjE6MSwaFt4ztp
	hLR796fO7MFVbJBWndMGnJXdhm99Vd6Nysuz1yCMaDD2TzQXADQlwIpgU915M3AJQHM1R59jaMEdd
	3vtz2GgCFWim78fKJ35zZVPsrKtD3u/8pn1kS0N6pdqLxrzfQAMINykkWCNflgA64j11eWlX8X+UF
	faA9rA1g==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utrCN-0000000080V-2Gnx;
	Wed, 03 Sep 2025 19:23:07 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 06/11] tests: py: Enable JSON and JSON schema by default
Date: Wed,  3 Sep 2025 19:22:54 +0200
Message-ID: <20250903172259.26266-7-phil@nwl.cc>
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

Introduce -J/--disable-json and -S/--no-schema to explicitly disable
them if desired.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 984f2b937a077..12c6174b01257 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -1488,7 +1488,11 @@ def set_delete_elements(set_element, set_name, table, filename=None,
 
     parser.add_argument('-j', '--enable-json', action='store_true',
                         dest='enable_json',
-                        help='test JSON functionality as well')
+                        help='test JSON functionality as well (default)')
+
+    parser.add_argument('-J', '--disable-json', action='store_true',
+                        dest='disable_json',
+                        help='Do not test JSON functionality as well')
 
     parser.add_argument('-l', '--library', default=None,
                         help='path to libntables.so.1, overrides --host')
@@ -1499,7 +1503,11 @@ def set_delete_elements(set_element, set_name, table, filename=None,
 
     parser.add_argument('-s', '--schema', action='store_true',
                         dest='enable_schema',
-                        help='verify json input/output against schema')
+                        help='verify json input/output against schema (default)')
+
+    parser.add_argument('-S', '--no-schema', action='store_true',
+                        dest='disable_schema',
+                        help='Do not verify json input/output against schema')
 
     parser.add_argument('-v', '--version', action='version',
                         version='1.0',
@@ -1510,8 +1518,8 @@ def set_delete_elements(set_element, set_name, table, filename=None,
     debug_option = args.debug
     need_fix_option = args.need_fix_line
     force_all_family_option = args.force_all_family
-    enable_json_option = args.enable_json
-    enable_json_schema = args.enable_schema
+    enable_json_option = not args.disable_json
+    enable_json_schema = not args.disable_json and not args.disable_schema
     specific_file = False
 
     signal.signal(signal.SIGINT, signal_handler)
-- 
2.51.0

