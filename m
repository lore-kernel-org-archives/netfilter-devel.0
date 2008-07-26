From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 06/06: nf_conntrack_extend: avoid unnecessary "ct->ext" dereferences
Date: Sun, 27 Jul 2008 01:37:15 +0200 (MEST)
Message-ID: <20080726233714.15283.89711.sendpatchset@localhost.localdomain>
References: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43543 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbYGZXhQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 19:37:16 -0400
In-Reply-To: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack_extend: avoid unnecessary "ct->ext" dereferences

As Linus points out, "ct->ext" and "new" are always equal, avoid unnecessary
dereferences and use "new" directly.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d928bf64722c65a7723ebff4161c4ca1256db6cf
tree 0f9bf278b49529096f187b48b286f4dbe3c289b5
parent dfecb922fa57237ef11bad7b95cbbceb5fdaccce
author Patrick McHardy <kaber@trash.net> Sun, 27 Jul 2008 00:40:14 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 27 Jul 2008 00:40:14 +0200

 net/netfilter/nf_conntrack_extend.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index c956ef7..4b2c769 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -115,10 +115,10 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 		ct->ext = new;
 	}
 
-	ct->ext->offset[id] = newoff;
-	ct->ext->len = newlen;
-	memset((void *)ct->ext + newoff, 0, newlen - newoff);
-	return (void *)ct->ext + newoff;
+	new->offset[id] = newoff;
+	new->len = newlen;
+	memset((void *)new + newoff, 0, newlen - newoff);
+	return (void *)new + newoff;
 }
 EXPORT_SYMBOL(__nf_ct_ext_add);
 
