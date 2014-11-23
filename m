From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [nft-tests 2/2] tests: regression: any/meta.t: fix bogus error
Date: Sun, 23 Nov 2014 22:22:48 +0100
Message-ID: <1416777768-1577-2-git-send-email-pablo@netfilter.org>
References: <1416777768-1577-1-git-send-email-pablo@netfilter.org>
Cc: anarey@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45301 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbaKWVUs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Nov 2014 16:20:48 -0500
In-Reply-To: <1416777768-1577-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This suppresses two superfluous errors:

 any/meta.t: ERROR: line 168: nft add rule ip test-ip4 input meta iifgroup {11,33}: This rule should not have failed.
 any/meta.t: ERROR: line 178: nft add rule ip test-ip4 input meta oifgroup {11,33}: This rule should not have failed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/any/meta.t |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/regression/any/meta.t b/tests/regression/any/meta.t
index ba6756d..b3f91c9 100644
--- a/tests/regression/any/meta.t
+++ b/tests/regression/any/meta.t
@@ -165,7 +165,7 @@ meta iifgroup default;ok;iifgroup default
 meta iifgroup != default;ok;iifgroup != default
 meta iifgroup {default};ok;;iifgroup {default}
 - meta iifgroup != {default};ok
-meta iifgroup {11,33};ok;oifgroup {11,33}
+meta iifgroup { 11,33};ok
 meta iifgroup {11-33};ok
 - meta iifgroup != {11,33};ok
 - meta iifgroup != {11-33};ok
@@ -175,7 +175,7 @@ meta oifgroup default;ok;oifgroup default
 meta oifgroup != default;ok;oifgroup != default
 meta oifgroup {default};ok;oifgroup {default}
 - meta oifgroup != {default};ok
-meta oifgroup {11,33};ok;oifgroup {11,33}
+meta oifgroup { 11,33};ok
 meta oifgroup {11-33};ok
 - meta oifgroup != {11,33};ok
 - meta oifgroup != {11-33};ok
-- 
1.7.10.4

