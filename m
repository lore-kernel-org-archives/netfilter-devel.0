From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: [PATCH 2/3] Introduce a counter for number of user defined chains.
Date: Fri, 21 Dec 2007 14:47:57 +0100
Message-ID: <1198244877.23885.13.camel@localhost.localdomain>
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
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:46976 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbXLUNwf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:52:35 -0500
In-Reply-To: <1198244659.23885.8.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce a counter for number of user defined chains.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---
 libiptc/libiptc.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 5afaf40..b4d865e 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -132,6 +132,8 @@ STRUCT_TC_HANDLE
 	struct chain_head *chain_iterator_cur;
 	struct rule_head *rule_iterator_cur;
 
+	unsigned int num_chains;         /* number of user defined chains */
+
 	STRUCT_GETINFO info;
 	STRUCT_GET_ENTRIES *entries;
 };
@@ -475,6 +477,7 @@ static int cache_add_entry(STRUCT_ENTRY *e,
 			errno = -ENOMEM;
 			return -1;
 		}
+		h->num_chains++; /* New user defined chain */
 
 		__iptcc_p_add_chain(h, c, offset, num);
 
@@ -1801,6 +1804,7 @@ TC_CREATE_CHAIN(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
 		return 0;
 
 	}
+	(*handle)->num_chains++; /* New user defined chain */
 
 	DEBUGP("Creating chain `%s'\n", chain);
 	iptc_insert_chain(*handle, c); /* Insert sorted */
@@ -1867,13 +1871,15 @@ TC_DELETE_CHAIN(const IPT_CHAINLABEL chain, TC_HANDLE_T *handle)
 	}
 
 	/* If we are about to delete the chain that is the current
-	 * iterator, move chain iterator firward. */
+	 * iterator, move chain iterator forward. */
 	if (c == (*handle)->chain_iterator_cur)
 		iptcc_chain_iterator_advance(*handle);
 
 	list_del(&c->list);
 	free(c);
 
+	(*handle)->num_chains--; /* One user defined chain deleted */
+
 	DEBUGP("chain `%s' deleted\n", chain);
 
 	set_changed(*handle);
-- 
1.5.3


