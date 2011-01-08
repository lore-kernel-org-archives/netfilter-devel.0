From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 13/13] libipt_REDIRECT: avoid dereference of uninitialized pointer
Date: Sat,  8 Jan 2011 16:20:14 +0100
Message-ID: <1294500015-10691-14-git-send-email-jengelh@medozas.de>
References: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32924 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab1AHPUa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:30 -0500
In-Reply-To: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Stephen Beahm <stephenbeahm@comcast.net>

When using --to-ports with a port name instead of a numerical
specification, a segfault occurs.

References: http://bugzilla.netfilter.org/show_bug.cgi?id=691
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_REDIRECT.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 4760e65..74b3aa1 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -41,7 +41,7 @@ static void REDIRECT_init(struct xt_entry_target *t)
 static void
 parse_ports(const char *arg, struct nf_nat_multi_range *mr)
 {
-	char *end;
+	char *end = "";
 	unsigned int port, maxport;
 
 	mr->range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
-- 
1.7.1

