From: Eric Leblond <eric@regit.org>
Subject: [PATCH libnfntl] set: free user data
Date: Thu,  6 Jul 2017 14:05:39 +0100
Message-ID: <20170706130539.22515-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:34020 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752457AbdGFNZP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jul 2017 09:25:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This was causing a memory leak when using set.

Catched by an ASAN run:

==21004==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 12 byte(s) in 2 object(s) allocated from:
    #0 0x4cde58 in malloc (/usr/local/sbin/nft+0x4cde58)
    #1 0x7ffff79b8c19 in nftnl_set_set_data /home/eric/git/netfilter/libnftnl/src/set.c:179

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/set.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/set.c b/src/set.c
index cce5e63..1158e38 100644
--- a/src/set.c
+++ b/src/set.c
@@ -48,6 +48,8 @@ void nftnl_set_free(const struct nftnl_set *s)
 		xfree(s->table);
 	if (s->flags & (1 << NFTNL_SET_NAME))
 		xfree(s->name);
+	if (s->flags & (1 << NFTNL_SET_USERDATA))
+		xfree(s->user.data);
 
 	list_for_each_entry_safe(elem, tmp, &s->element_list, head) {
 		list_del(&elem->head);
-- 
2.13.1

