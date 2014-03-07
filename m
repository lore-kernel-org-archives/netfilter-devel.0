From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] update coreteam members from manpage
Date: Fri,  7 Mar 2014 18:43:40 +0100
Message-ID: <1394214220-18346-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58212 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaCGRn4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:43:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/iptables.8.in |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index d67e12a..c611556 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -453,9 +453,10 @@ Jozsef Kadlecsik wrote the REJECT target.
 .PP
 Harald Welte wrote the ULOG and NFQUEUE target, the new libiptc, as well as the TTL, DSCP, ECN matches and targets.
 .PP
-The Netfilter Core Team is: Marc Boucher, Martin Josefsson, Yasuyuki Kozakai,
-Jozsef Kadlecsik, Patrick McHardy, James Morris, Pablo Neira Ayuso,
-Harald Welte and Rusty Russell.
+The Netfilter Core Team is: Jozsef Kadlecsik, Patrick McHardy, Pablo Neira
+Ayuso, Eric Leblond and Florian Westphal. Emeritus Core Team members are: Marc
+Boucher, Martin Josefsson, Yasuyuki Kozakai, James Morris, Harald Welte and
+Rusty Russell.
 .PP
 Man page originally written by Herve Eychenne <rv@wallfire.org>.
 .\" .. and did I mention that we are incredibly cool people?
-- 
1.7.10.4

