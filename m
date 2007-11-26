From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: [PATCH 1/2] iptables/libiptc perf issue: Sorting chain during
	pull-out
Date: Mon, 26 Nov 2007 14:56:37 +0100
Message-ID: <1196085397.3866.58.camel@localhost.localdomain>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Paul C. Diem" <PCDiem@FoxValley.net>,
	Martin Josefsson <gandalf@netfilter.org>
To: Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:33992 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbXKZN6i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 08:58:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Performance optimize scalability issue:
  Sorting chain during pull-out give worst-case runtime O(Chains^2).

When pulling out the blob, every chain name is inserted alphabetically
into a linked list (by function iptc_insert_chain()).  The problem
with this approach is that the chain names delivered in the blob is
already sorted (as we push it back to the kernel sorted).

This cause chain parsing to always process every element in the chain
list and finish with a tail add.  Causing worst-case runtime O(C^2/2)
for alphabetically sorting of chains.

The patch solves this by only calling iptc_insert_chain() when
creating new chains.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---
 libiptc/libiptc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 472b81e..e7ffb01 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -420,8 +420,8 @@ static void __iptcc_p_add_chain(TC_HANDLE_T h, struct chain_head *c,
 	c->head_offset = offset;
 	c->index = *num;
 
-	iptc_insert_chain(h, c);
-	
+	list_add_tail(&c->list, &h->chains); /* Its already sorted */
+
 	h->chain_iterator_cur = c;
 }
 
@@ -1791,7 +1791,7 @@ TC_CREATE_CHAIN(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
 	}
 
 	DEBUGP("Creating chain `%s'\n", chain);
-	list_add_tail(&c->list, &(*handle)->chains);
+	iptc_insert_chain(*handle, c); /* Insert sorted */
 
 	set_changed(*handle);
 

