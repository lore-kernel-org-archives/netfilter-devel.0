From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests: py: allow to run tests with other nft binaries
Date: Thu, 21 Apr 2016 11:43:54 +0200
Message-ID: <146123183481.8142.11138398894868501284.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48289 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751582AbcDUJoE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Apr 2016 05:44:04 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id A378851F277
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Apr 2016 09:44:01 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tsX-rEAaLqJ3 for <netfilter-devel@vger.kernel.org>;
	Thu, 21 Apr 2016 11:43:56 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	by smtp.cica.es (Postfix) with ESMTP id 0086951F276
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Apr 2016 11:43:55 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allow to run tests with other nft binaries by reading a 'NFT'
environment variable, allowing arbitrary locations for the nft binary.

This is what the tests/shell/run-tests.sh script does.

Among other thing, this allow us to properly hook this testsuite
from the Debian CI environment (https://ci.debian.net) where we can perform
tests for packages 'as installed'.

Examples:

 # run with default config (ie src/nft)
 % ./nft-test.py

 # run with installed binary (ie /usr/sbin/nft)
 % NFT=/usr/sbin/nft ./nft-test.py

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/py/nft-test.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 1256a33..df0fbad 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -19,7 +19,7 @@ import subprocess
 import argparse
 import signal
 
-NFT_BIN = "src/nft"
+NFT_BIN = os.getenv('NFT', "src/nft")
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
 TESTS_DIRECTORY = ["any", "arp", "bridge", "inet", "ip", "ip6"]
 LOGFILE = "/tmp/nftables-test.log"

