From: Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack] conntrack: add missing break when parsing --id/--secmark options
Date: Wed, 15 Jun 2011 23:39:07 +0200
Message-ID: <1308173947-3122-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48643 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab1FOVjd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:39:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 147ed522f52a62ab0d854ddc443d27d97dbf6cdf
(conntrack: add support for mark mask) failed to add a break
after secmark/id option parsing.

Results in '-m 42 -c 1' to search for mark 1 instead of 42.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Sorry about this; i did not see it until now...

diff --git a/src/conntrack.c b/src/conntrack.c
index 3e1cb11..8eae554 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1566,6 +1566,7 @@ int main(int argc, char *argv[])
 			nfct_set_attr_u32(tmpl.ct,
 					  opt2attr[c],
 					  strtoul(optarg, NULL, 0));
+			break;
 		case 'm':
 			options |= opt2type[c];
 			parse_u32_mask(optarg, &tmpl.mark);
-- 
1.7.3.4

