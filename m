From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/3] tests/shell: add testcase for 'nft -f' load with
 actions
Date: Wed, 11 May 2016 13:30:08 +0200
Message-ID: <146296620808.3706.13506048150591268571.stgit@nfdev2.cica.es>
References: <146296620273.3706.17267671338035433056.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37903 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751551AbcEKLaQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 07:30:16 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 3D2AE51F215
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 11:30:14 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ql1YsemSsBES for <netfilter-devel@vger.kernel.org>;
	Wed, 11 May 2016 13:30:09 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	(Authenticated sender: servers@cica.es)
	by smtp.cica.es (Postfix) with ESMTP id 4664851F22F
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 13:30:09 +0200 (CEST)
In-Reply-To: <146296620273.3706.17267671338035433056.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's tests loading a ruleset with actions.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/testcases/nft-f/0006action_object_0 |   68 +++++++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100755 tests/shell/testcases/nft-f/0006action_object_0

diff --git a/tests/shell/testcases/nft-f/0006action_object_0 b/tests/shell/testcases/nft-f/0006action_object_0
new file mode 100755
index 0000000..f4ec41d
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0006action_object_0
@@ -0,0 +1,68 @@
+#!/bin/bash
+
+# test loading a ruleset with the 'action object' pattern
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -f $tmpfile" EXIT # cleanup if aborted
+
+set -e
+
+FAMILIES="ip ip6 inet arp bridge"
+
+generate1()
+{
+	local family=$1
+	echo "
+	add table $family t
+	add chain $family t c
+	add rule $family t c accept
+	add set $family t s {type inet_service;}
+	add element $family t s {8080}
+	insert rule $family t c meta l4proto tcp tcp dport @s accept
+	replace rule $family t c handle 2 meta l4proto tcp tcp dport {9090}
+	add map $family t m {type inet_service:verdict;}
+	add element $family t m {10080:drop}
+	insert rule $family t c meta l4proto tcp tcp dport vmap @m
+	add rule $family t c meta l4proto udp udp sport vmap {1111:accept}
+	" >> $tmpfile
+}
+
+generate2()
+{
+	local family=$1
+	echo "
+	flush chain $family t c
+	delete element $family t m {10080:drop}
+	delete element $family t s {8080}
+	delete chain $family t c
+	delete table $family t
+	" >> $tmpfile
+}
+
+for family in $FAMILIES ; do
+	generate1 $family
+done
+
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+	echo "E: unable to load ruleset 1" >&2
+	exit 1
+fi
+
+echo "" > $tmpfile
+for family in $FAMILIES ; do
+	generate2 $family
+done
+
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+	echo "E: unable to load ruleset 2" >&2
+	exit 1
+fi
+
+exit 0

