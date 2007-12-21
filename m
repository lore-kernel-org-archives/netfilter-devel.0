From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: [PATCH 1/3] Inline functions iptcc_is_builtin() and set_changed().
Date: Fri, 21 Dec 2007 14:46:14 +0100
Message-ID: <1198244774.23885.10.camel@localhost.localdomain>
References: <1198244659.23885.8.camel@localhost.localdomain>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Harald Welte <laforge@netfilter.org>,
	Martin Josefsson <gandalf@netfilter.org>
To: Netfilter Developers <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:46815 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbXLUNux (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:50:53 -0500
In-Reply-To: <1198244659.23885.8.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The two functions are obvious candidates for inlining.
Using gprof(1) shows that they actually affects performance.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---
 libiptc/libiptc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 29f671e..5afaf40 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -166,7 +166,7 @@ static struct rule_head *iptcc_alloc_rule(struct chain_head *c, unsigned int siz
 }
 
 /* notify us that the ruleset has been modified by the user */
-static void
+static inline void
 set_changed(TC_HANDLE_T h)
 {
 	h->changed = 1;
@@ -268,7 +268,7 @@ iptcb_ent_is_hook_entry(STRUCT_ENTRY *e, TC_HANDLE_T h)
  **********************************************************************/
 
 /* Is the given chain builtin (1) or user-defined (0) */
-static unsigned int iptcc_is_builtin(struct chain_head *c)
+static inline unsigned int iptcc_is_builtin(struct chain_head *c)
 {
 	return (c->hooknum ? 1 : 0);
 }
-- 
1.5.3


