Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70465287506
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Feb 2026 17:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771262622; cv=none; b=HDjLxHxpddyQZp/M/86k/Y7jum1GhAB0sWaPuFiX3fQnegAidPUhIagOlHbra/ZF37X0pX3Bn+7rxdTpuAtICd2hcHvg9ya/f14vgTwEcJtVINuLNL/ZuXYjk3/UlRuMTVc3FuoFeDWt4QnHZrlDL01dvmAxd5/PpBVrXqB44mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771262622; c=relaxed/simple;
	bh=QWkGM1A80m1+jEmrtMlDKXkreTVZZRtbMrGZC3dsBA4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=NAFR7lpV1d2Xa0Zei012GLb/4C2GEHJiG7NQxKW1/Ulb1ApjbphKDltX6dAhaRFY/slvYBUfqKMqZbTiwTkr0+IUxPs/i6VT+Ece2v/6eslu9h90Os4jWgk+7uY5hfXXHc47sSh7E5FX6CbMIwLOqkOxf2cjbTyHAMKyh5roTTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=i4+cYZ5p; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="i4+cYZ5p"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4B17F602C8
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Feb 2026 18:23:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1771262618;
	bh=T9Fq5wm9vKAsrdWj/dREWOOFpnCtLMAJhT0NBVW2U4s=;
	h=From:To:Subject:Date:From;
	b=i4+cYZ5p4JiHhkxGYT74m72TyjRFxeAJ6g45/le+00rsqD/aV3bphZiEXMmuIhNbd
	 PJPRMgiISEeX9O0SyHib3shNalW2ZQl+g/1+nqgvql7JC/GjWW94aNum5kVlCH8M1m
	 4RhjhCblql++6mmf0mZ2NjeCcn5pvvo57M3hyLjAJB3BercCjvPFKGHsCMVYyO+AOL
	 Si1xdX6YX5Fg3bFXrlzT/eAnBJebIJi/adRxFVzoZNcIU8TfwBFEub3x7ya44c/NEm
	 UOlV7A2Uv3zBbKWWBSURK8DrUVEKrJvi9vta+MZf+5T0zhKZivIXjOG79QjfODVpdW
	 hmw7+kX7jpjyg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] Tree-wide use of python3
Date: Mon, 16 Feb 2026 18:23:35 +0100
Message-ID: <20260216172335.1745811-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It seems that unversioned Python shebangs are discouraged these days:

- See the lintian web on Debian:
  https://lintian.debian.org/tags/script-uses-unversioned-python-in-shebang.html

- Also, see "Finalizing Fedora's Switch to Python3":
  https://fedoraproject.org/wiki/FinalizingFedoraSwitchtoPython3

Replace them all tree-wide.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 INSTALL                            | 4 ++--
 py/setup.py                        | 2 +-
 py/src/nftables.py                 | 2 +-
 tests/json_echo/run-test.py        | 2 +-
 tests/py/nft-test.py               | 2 +-
 tests/shell/helpers/json-pretty.sh | 4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/INSTALL b/INSTALL
index 0c48c98950d8..05282a44c71f 100644
--- a/INSTALL
+++ b/INSTALL
@@ -93,11 +93,11 @@ Installation instructions for nftables
  CPython bindings are available for nftables under the py/ folder.  They can be
  installed using pip:
 
-	python -m pip install py/
+	python3 -m pip install py/
 
  A legacy setup.py script can also be used:
 
-	( cd py && python setup.py install )
+	( cd py && python3 setup.py install )
 
  However, this method is deprecated.
 
diff --git a/py/setup.py b/py/setup.py
index beda28e82166..229b2ebbbc90 100755
--- a/py/setup.py
+++ b/py/setup.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 
 from setuptools import setup
 
diff --git a/py/src/nftables.py b/py/src/nftables.py
index f1e43ade2830..abb4fc9aaab6 100644
--- a/py/src/nftables.py
+++ b/py/src/nftables.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/python3
 # Copyright(C) 2018 Phil Sutter <phil@nwl.cc>
 
 # This program is free software; you can redistribute it and/or modify
diff --git a/tests/json_echo/run-test.py b/tests/json_echo/run-test.py
index 7d0eca0aacae..ed8360bcfbd9 100755
--- a/tests/json_echo/run-test.py
+++ b/tests/json_echo/run-test.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/python3
 
 from __future__ import print_function
 import sys
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index ff2412acc21e..53fd3f7ae6fe 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # (C) 2014 by Ana Rey Botello <anarey@gmail.com>
 #
diff --git a/tests/shell/helpers/json-pretty.sh b/tests/shell/helpers/json-pretty.sh
index 31739b02bc6d..e8679583e89b 100755
--- a/tests/shell/helpers/json-pretty.sh
+++ b/tests/shell/helpers/json-pretty.sh
@@ -1,7 +1,7 @@
 #!/bin/bash -e
 
 exec_pretty() {
-	# The output of this command must be stable (and `jq` and python
+	# The output of this command must be stable (and `jq` and python3
 	# fallback must generate the same output.
 
 	if command -v jq &>/dev/null ; then
@@ -9,7 +9,7 @@ exec_pretty() {
 		exec jq
 	fi
 
-	# Fallback to python.
+	# Fallback to python3.
 	exec python3 -c '
 import json
 import sys
-- 
2.47.3

