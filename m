From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] netfilter: Fix the format of /proc/net/nf_conntrack_expect
Date: Tue, 12 Nov 2013 23:08:06 +0800
Message-ID: <1384268886-6991-1-git-send-email-xiaosuo@gmail.com>
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:34053 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3KLPML (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:12:11 -0500
Received: by mail-pb0-f54.google.com with SMTP id ro12so3946206pbb.41
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2013 07:12:11 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There should not be any white space around `='.

---
 net/netfilter/nf_conntrack_expect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 4fd1ca9..151af72 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -517,7 +517,7 @@ static int exp_seq_show(struct seq_file *s, void *v)
 			   ? (long)(expect->timeout.expires - jiffies)/HZ : 0);
 	else
 		seq_printf(s, "- ");
-	seq_printf(s, "l3proto = %u proto=%u ",
+	seq_printf(s, "l3proto=%u proto=%u ",
 		   expect->tuple.src.l3num,
 		   expect->tuple.dst.protonum);
 	print_tuple(s, &expect->tuple,
-- 
1.7.9.5

