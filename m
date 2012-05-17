From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/2] tests: add rateest match rules
Date: Thu, 17 May 2012 13:03:09 +0200
Message-ID: <1337252589-1363-2-git-send-email-fw@strlen.de>
References: <1337252589-1363-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46589 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761607Ab2EQLDx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 May 2012 07:03:53 -0400
In-Reply-To: <1337252589-1363-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

also, -p mobility gets us EINVAL from kernel, use -p ipv6-mh instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/options-most.rules |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/tests/options-most.rules b/tests/options-most.rules
index 7573361..30dac16 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -54,8 +54,7 @@
 -A INPUT -p tcp -m tcpmss --mss 1:2 -m tcp --tcp-flags FIN,SYN,RST,ACK SYN
 -A INPUT -p ipv6-icmp -m icmp6 --icmpv6-type 4/0
 -A INPUT
--A INPUT -p mobility
--A INPUT -p mobility -m mh --mh-type 3
+-A INPUT -p ipv6-mh -m mh --mh-type 3
 -A OUTPUT -m owner --socket-exists --uid-owner 1-2 --gid-owner 2-3
 -A OUTPUT -m owner ! --socket-exists ! --uid-owner 0 ! --gid-owner 0
 -A matches -m connbytes --connbytes 1 --connbytes-mode bytes --connbytes-dir both
@@ -184,20 +183,17 @@
 -A ntarg
 -A ntarg -j RATEEST --rateest-name RE2 --rateest-interval 250.0ms --rateest-ewmalog 500.0ms
 -A ntarg
-#-A zmatches -m rateest --rateest RE1 --rateest-lt --rateest-bps 8bit
-#-A zmatches -m rateest --rateest RE1 --rateest-eq --rateest-bps 8bit
-#-A zmatches -m rateest --rateest RE1 --rateest-gt --rateest-bps 8bit
-#-A zmatches -m rateest --rateest RE1 --rateest-lt --rateest-pps 5
-#-A zmatches -m rateest --rateest RE1 --rateest-eq --rateest-pps 5
-#-A zmatches -m rateest --rateest RE1 --rateest-gt --rateest-pps 5
-#-A zmatches -m rateest --rateest-delta --rateest RE1 --rateest-bps1 8bit --rateest-lt --rateest-bps2 16bit
-#-A zmatches -m rateest --rateest1 RE1 --rateest-lt --rateest2 RE2 --bytes
-#-A zmatches -m rateest --rateest1 RE1 --rateest-lt --rateest2 RE2 --packets
-#-A zmatches -m rateest --rateest-delta --rateest RE1 --rateest-bps1 8bit --rateest-eq --rateest-bps2 16bit
-#-A zmatches -m rateest --rateest-delta --rateest RE1 --rateest-bps1 8bit --rateest-gt --rateest-bps2 16bit
-#-A zmatches -m rateest --rateest-delta --rateest RE1 --rateest-pps1 8 --rateest-lt --rateest-pps2 9
-#-A zmatches -m rateest --rateest-delta --rateest RE1 --rateest-pps1 8 --rateest-eq --rateest-pps2 9
-#-A zmatches -m rateest --rateest-delta --rateest RE1 --rateest-pps1 8 --rateest-gt --rateest-pps2 9
+-A zmatches -m rateest --rateest RE1 --rateest-lt --rateest-bps 8bit
+-A zmatches -m rateest --rateest RE1 --rateest-eq --rateest-pps 5
+-A zmatches -m rateest --rateest RE1 --rateest-gt --rateest-bps 5kbit
+-A zmatches -m rateest --rateest-delta --rateest RE1 --rateest-bps1 8bit --rateest-lt --rateest-bps2 16bit
+-A zmatches -m rateest --rateest1 RE1 --rateest-lt --rateest-bps --rateest2 RE2
+-A zmatches -m rateest --rateest-delta --rateest1 RE1 --rateest-lt --rateest2 RE2 --rateest-pps2 42
+-A zmatches -m rateest --rateest-delta --rateest RE1 --rateest-bps1 8bit --rateest-eq --rateest-bps2 16bit
+-A zmatches -m rateest --rateest-delta --rateest RE1 --rateest-bps1 8bit --rateest-gt --rateest-bps2 16bit
+-A zmatches -m rateest --rateest-delta --rateest RE1 --rateest-pps1 8 --rateest-lt --rateest-pps2 9
+-A zmatches -m rateest --rateest-delta --rateest RE1 --rateest-pps1 8 --rateest-eq --rateest-pps2 9
+-A zmatches -m rateest --rateest-delta --rateest RE1 --rateest-pps1 8 --rateest-gt --rateest-pps2 9
 COMMIT
 *mangle
 :PREROUTING ACCEPT [0:0]
-- 
1.7.3.4

