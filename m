From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/3] tests: shell: delete useless stderr output in
 testcase
Date: Thu, 03 Nov 2016 13:04:36 +0100
Message-ID: <147817467643.6881.13545899574878544844.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:35052 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752047AbcKCMEe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2016 08:04:34 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 7D6D351F325
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 12:04:30 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id b4SfPDRnKBhj for <netfilter-devel@vger.kernel.org>;
        Thu,  3 Nov 2016 13:04:25 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 8E88C51F2A7
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:04:24 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo@debian.org>

This stderr output is expected.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 tests/shell/testcases/transactions/0014chain_1 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/testcases/transactions/0014chain_1 b/tests/shell/testcases/transactions/0014chain_1
index a03ef12..955860d 100755
--- a/tests/shell/testcases/transactions/0014chain_1
+++ b/tests/shell/testcases/transactions/0014chain_1
@@ -16,5 +16,5 @@ delete chain x y
 delete chain x y"
 
 echo "$RULESET" > $tmpfile
-$NFT -f $tmpfile
+$NFT -f $tmpfile 2>/dev/null
 echo "E: allowing double-removal of chain" >&2

