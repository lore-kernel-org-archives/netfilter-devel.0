From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH 1/2] ip{,6}tables-restore: Don't ignore missing wait-interval value
Date: Wed, 20 Sep 2017 19:34:35 +0200
Message-ID: <20170920173436.20221-2-phil@nwl.cc>
References: <20170920173436.20221-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:41534 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751723AbdITRe6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2017 13:34:58 -0400
In-Reply-To: <20170920173436.20221-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Passing -W without a value doesn't make sense so bail out if none was
given.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 825479c338214..06db72d427e21 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -343,7 +343,7 @@ void parse_wait_interval(int argc, char *argv[], struct timeval *wait_interval)
 	else if (xs_has_arg(argc, argv))
 		arg = argv[optind++];
 	else
-		return;
+		xtables_error(PARAMETER_PROBLEM, "wait interval value required");
 
 	ret = sscanf(arg, "%u", &usec);
 	if (ret == 1) {
-- 
2.13.1

