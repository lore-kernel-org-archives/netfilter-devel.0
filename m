From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/10] extensions: add missing checks for specific flags (2)
Date: Wed,  6 Apr 2011 13:31:08 +0200
Message-ID: <1302089478-15022-2-git-send-email-jengelh@medozas.de>
References: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46480 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab1DFLbV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:31:21 -0400
In-Reply-To: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Addendum to v1.4.10-75-g4e5d4bf. It does not make sense to use
ipv6header's --soft without specifying any options.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_ipv6header.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 187e0a4..c05cedb 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -202,7 +202,9 @@ ipv6header_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static void ipv6header_check(unsigned int flags)
 {
-	if (!flags) xtables_error(PARAMETER_PROBLEM, "ip6t_ipv6header: no options specified");
+	if (!(flags & IPV6_HDR_HEADER))
+		xtables_error(PARAMETER_PROBLEM,
+			"ip6t_ipv6header: no options specified");
 }
 
 static void
-- 
1.7.1

