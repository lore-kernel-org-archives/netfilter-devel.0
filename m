From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests: shell: run-tests.sh: use src/nft binary by
 default
Date: Thu, 23 Jun 2016 13:45:44 +0200
Message-ID: <146668234418.21827.13311786283737930387.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:49225 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750809AbcFWLpu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 07:45:50 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 6AFF951F254
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 11:45:46 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OdZcfVn9Syyl for <netfilter-devel@vger.kernel.org>;
	Thu, 23 Jun 2016 13:45:41 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	(Authenticated sender: servers@cica.es)
	by smtp.cica.es (Postfix) with ESMTP id 54CA851F146
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:45:41 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Better use the local tree nft binary rather than the installed one.

Requested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/README       |    4 +++-
 tests/shell/run-tests.sh |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tests/shell/README b/tests/shell/README
index 2ce4120..cc35cab 100644
--- a/tests/shell/README
+++ b/tests/shell/README
@@ -20,4 +20,6 @@ Also, test-files will receive the environment variable $NFT which contains the
 path to the nftables binary being tested.
 
 You can pass an arbitrary $NFT value as well:
- % NFT=../../src/nft ./run-tests.sh
+ % NFT=/usr/local/nft ./run-tests.sh
+
+By default the tests are run with the nft binary at '../../src/nft'
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index b10445d..3277655 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -3,6 +3,7 @@
 # Configuration
 TESTDIR="./"
 RETURNCODE_SEPARATOR="_"
+SRC_NFT="../../src/nft"
 
 msg_error() {
 	echo "E: $1 ..." >&2
@@ -21,7 +22,7 @@ if [ "$(id -u)" != "0" ] ; then
 	msg_error "this requires root!"
 fi
 
-[ -z "$NFT" ] && NFT="$(which nft)"
+[ -z "$NFT" ] && NFT=$SRC_NFT
 if [ ! -x "$NFT" ] ; then
 	msg_error "no nft binary!"
 else

