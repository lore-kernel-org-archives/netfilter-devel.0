From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] netfilter: x_tables: avoid out-of-bounds reads in
 xt_request_find_match()
Date: Wed, 24 Jan 2018 14:49:48 -0800
Message-ID: <1516834188.3715.35.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33002 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932845AbeAXWtu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jan 2018 17:49:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Dumazet <edumazet@google.com>

It looks like syzbot found its way into netfilter territory.

Issue here is that @name comes from user space and might
not be null terminated.

Out-of-bound reads happen, KASAN is not happy.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
No Fixes: tag, bug seems to be a day-0 one.

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 55802e97f906d1987ed78b4296584deb38e5f876..8516dc459b539342f44d2b2b3e21b140677c7826 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -210,6 +210,9 @@ xt_request_find_match(uint8_t nfproto, const char *name, uint8_t revision)
 {
 	struct xt_match *match;
 
+	if (strnlen(name, XT_EXTENSION_MAXNAMELEN) == XT_EXTENSION_MAXNAMELEN)
+		return ERR_PTR(-EINVAL);
+
 	match = xt_find_match(nfproto, name, revision);
 	if (IS_ERR(match)) {
 		request_module("%st_%s", xt_prefix[nfproto], name);

