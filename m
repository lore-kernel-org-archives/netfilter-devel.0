From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 4/5] tests: regression: any/ct: remove wrong output
Date: Mon,  1 Dec 2014 12:45:53 +0100
Message-ID: <1417434354-5782-5-git-send-email-pablo@netfilter.org>
References: <1417434354-5782-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41632 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbaLALnr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:43:47 -0500
In-Reply-To: <1417434354-5782-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ct mark 0x32-0x45

displays:

ct mark >= 0x00000032 ct mark <= 0x00000045
                                 ^^^^^^^^^^
instead of ct mark <= 0x45000000
                      ^^^^^^^^^^

Remove the custom output so this displays a warning. nft should
(at some point) merge the two statements into one single to express
the range from the netlink_delinearize step.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/any/ct.t |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/regression/any/ct.t b/tests/regression/any/ct.t
index 09f72ed..bb26cb8 100644
--- a/tests/regression/any/ct.t
+++ b/tests/regression/any/ct.t
@@ -46,8 +46,8 @@ ct mark xor 0x3 != 0x1;ok;ct mark != 0x00000002
 
 ct mark 0x32;ok;ct mark 0x00000032
 ct mark != 0x32;ok;ct mark != 0x00000032
-ct mark 0x32-0x45;ok;ct mark >= 0x00000032 ct mark <= 0x45000000
-ct mark != 0x32-0x43;ok;ct mark < 0x00000032 ct mark > 0x43000000
+ct mark 0x32-0x45;ok
+ct mark != 0x32-0x43;ok
 ct mark {0x32, 0x2222, 0x42de3};ok;ct mark { 0x00042de3, 0x00002222, 0x00000032}
 - ct mark != {0x32, 0x2222, 0x42de3};ok
 
-- 
1.7.10.4

