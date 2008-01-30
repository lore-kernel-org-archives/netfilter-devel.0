From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 51/69]: nf_conntrack: kill unused static inline (do_iter)
Date: Wed, 30 Jan 2008 21:18:12 +0100 (MET)
Message-ID: <20080130201810.29874.93908.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60792 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808AbYA3USO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:14 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: kill unused static inline (do_iter)

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 589cbc737eef0c619fc75c099063861ec7540ec7
tree aec04a71a3720e1c37f8620f07b12e9e33e77ffa
parent da5a0452866ad6f4a4967f31d5d5854d9f481e33
author Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi> Tue, 29 Jan 2008 16:=
22:17 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:12 +=
0100

 net/netfilter/nf_conntrack_core.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_connt=
rack_core.c
index 0db7d1d..2392234 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -902,14 +902,6 @@ static void nf_conntrack_attach(struct sk_buff *ns=
kb, struct sk_buff *skb)
 	nf_conntrack_get(nskb->nfct);
 }
=20
-static inline int
-do_iter(const struct nf_conntrack_tuple_hash *i,
-	int (*iter)(struct nf_conn *i, void *data),
-	void *data)
-{
-	return iter(nf_ct_tuplehash_to_ctrack(i), data);
-}
-
 /* Bring out ya dead! */
 static struct nf_conn *
 get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
