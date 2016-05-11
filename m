From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 3/3] tests/shell: add testcase to catch segfault if
 invalid syntax was used
Date: Wed, 11 May 2016 13:30:13 +0200
Message-ID: <146296621327.3706.18265491927507888269.stgit@nfdev2.cica.es>
References: <146296620273.3706.17267671338035433056.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37909 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751647AbcEKLaV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 07:30:21 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 5497B51F1FC
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 11:30:19 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sm2QFjhiY0ic for <netfilter-devel@vger.kernel.org>;
	Wed, 11 May 2016 13:30:14 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	(Authenticated sender: servers@cica.es)
	by smtp.cica.es (Postfix) with ESMTP id 776B651F21E
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 13:30:14 +0200 (CEST)
In-Reply-To: <146296620273.3706.17267671338035433056.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's add

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 .../nft-f/0007action_object_set_segfault_1         |   21 ++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100755 tests/shell/testcases/nft-f/0007action_object_set_segfault_1

diff --git a/tests/shell/testcases/nft-f/0007action_object_set_segfault_1 b/tests/shell/testcases/nft-f/0007action_object_set_segfault_1
new file mode 100755
index 0000000..3a4183b
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0007action_object_set_segfault_1
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# test for a segfault if bad syntax was used in set declaration
+# and the set is referenced in the same batch
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -f $tmpfile" EXIT # cleanup if aborted
+
+echo "
+add table t
+add chain t c
+add set t s {type ipv4_addr\;}
+add rule t c ip saddr @s
+" > $tmpfile
+
+$NFT -f $tmpfile 2>/dev/null

