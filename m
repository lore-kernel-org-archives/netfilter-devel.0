From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 8/8] tests: silence test case
Date: Fri, 27 Oct 2017 01:06:11 +0200
Message-ID: <20171026230611.14269-9-fw@strlen.de>
References: <20171026230611.14269-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59782 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932334AbdJZXGX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2017 19:06:23 -0400
In-Reply-To: <20171026230611.14269-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

removes this harmless warning:
'ip saddr 1.2.3.4 tcp dport 22' mismatches 'ip protocol 6 ip saddr 1.2.3.4 tcp dport 22'

alternative fix is to track the number of payload expressions seen
in the current dependency base so we know that we had another expression
(ip saddr in this case) besides the 'ip protocol' statement.

But because nft doesn't add such a dependency on its own (it would
have added 'meta l4proto tcp' without the ip protocol 6 statement)
it seems simpler to just let nft print the rule as-is instead of
adding more code.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/ip_tcp.t | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/py/inet/ip_tcp.t b/tests/py/inet/ip_tcp.t
index f2a28ebdd531..4eebe3865d76 100644
--- a/tests/py/inet/ip_tcp.t
+++ b/tests/py/inet/ip_tcp.t
@@ -8,8 +8,8 @@
 # must not remove ip dependency -- ONLY ipv4 packets should be matched
 ip protocol tcp tcp dport 22;ok;ip protocol 6 tcp dport 22
 
-# can remove it here, ip protocol is implied via saddr.
-ip protocol tcp ip saddr 1.2.3.4 tcp dport 22;ok;ip saddr 1.2.3.4 tcp dport 22
+# could be remove here, ip protocol is implied via saddr.
+ip protocol tcp ip saddr 1.2.3.4 tcp dport 22;ok;ip protocol 6 ip saddr 1.2.3.4 tcp dport 22
 
 # but not here.
 ip protocol tcp counter ip saddr 1.2.3.4 tcp dport 22;ok;ip protocol 6 counter ip saddr 1.2.3.4 tcp dport 22
-- 
2.13.6

