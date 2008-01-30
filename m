From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 50/69]: ipt_CLUSTERIP: kill clusterip_config_entry_get
Date: Wed, 30 Jan 2008 21:18:10 +0100 (MET)
Message-ID: <20080130201808.29874.2596.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60779 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbYA3USN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:13 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ipt_CLUSTERIP: kill clusterip_config_entry_get

It's unused static inline.

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit da5a0452866ad6f4a4967f31d5d5854d9f481e33
tree 98fb53d9fd7a6bfa1f854f52ecf699a83a5cbc91
parent 8bf50a16334291fa18d090ad11221e802327b26f
author Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi> Tue, 29 Jan 2008 16:=
22:16 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:11 +=
0100

 net/ipv4/netfilter/ipt_CLUSTERIP.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ip=
t_CLUSTERIP.c
index 1b31f7d..c6cf84c 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -76,13 +76,6 @@ clusterip_config_put(struct clusterip_config *c)
 		kfree(c);
 }
=20
-/* increase the count of entries(rules) using/referencing this config =
*/
-static inline void
-clusterip_config_entry_get(struct clusterip_config *c)
-{
-	atomic_inc(&c->entries);
-}
-
 /* decrease the count of entries using/referencing this config.  If la=
st
  * entry(rule) is removed, remove the config from lists, but don't fre=
e it
  * yet, since proc-files could still be holding references */
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
