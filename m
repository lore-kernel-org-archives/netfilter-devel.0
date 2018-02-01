From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/6] netfilter: x_tables: avoid out-of-bounds reads in xt_request_find_{match|target}
Date: Thu,  1 Feb 2018 19:02:13 +0100
Message-ID: <20180201180217.24356-3-pablo@netfilter.org>
References: <20180201180217.24356-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57834 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753177AbeBASCp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Feb 2018 13:02:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CC1E0392E18
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 19:02:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BCC40BAC2C
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 19:02:43 +0100 (CET)
In-Reply-To: <20180201180217.24356-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Dumazet <edumazet@google.com>

It looks like syzbot found its way into netfilter territory.

Issue here is that @name comes from user space and might
not be null terminated.

Out-of-bound reads happen, KASAN is not happy.

v2 added similar fix for xt_request_find_target(),
as Florian advised.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index e02a21549c99..d7070d18db20 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -209,6 +209,9 @@ xt_request_find_match(uint8_t nfproto, const char *name, uint8_t revision)
 {
 	struct xt_match *match;
 
+	if (strnlen(name, XT_EXTENSION_MAXNAMELEN) == XT_EXTENSION_MAXNAMELEN)
+		return ERR_PTR(-EINVAL);
+
 	match = xt_find_match(nfproto, name, revision);
 	if (IS_ERR(match)) {
 		request_module("%st_%s", xt_prefix[nfproto], name);
@@ -251,6 +254,9 @@ struct xt_target *xt_request_find_target(u8 af, const char *name, u8 revision)
 {
 	struct xt_target *target;
 
+	if (strnlen(name, XT_EXTENSION_MAXNAMELEN) == XT_EXTENSION_MAXNAMELEN)
+		return ERR_PTR(-EINVAL);
+
 	target = xt_find_target(af, name, revision);
 	if (IS_ERR(target)) {
 		request_module("%st_%s", xt_prefix[af], name);
-- 
2.11.0

