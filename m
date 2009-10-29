From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] libiptc: fix wrong maptype of base chain counters on restore
Date: Thu, 29 Oct 2009 19:11:16 +0100
Message-ID: <1256839878-24358-3-git-send-email-jengelh@medozas.de>
References: <1256839878-24358-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56280 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbZJ2SLS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2009 14:11:18 -0400
In-Reply-To: <1256839878-24358-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When a ruleset that does not reset any chain policies/counters, such as

	*filter
	COMMIT

is sourced by iptables-restore, the previous policy and counters
(i.e. the ones read from the kernel) are reused. The counter skew
offsetting is wrong however, causing the read value to be readded to
the kernel value. This manifests itself in practice by the counter
value almost doubling everytime iptables-restore is called.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 libiptc/libiptc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 670acf5..7a9c742 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -829,7 +829,7 @@ static int __iptcc_p_del_policy(struct xtc_handle *h, unsigned int num)
 
 		/* save counter and counter_map information */
 		h->chain_iterator_cur->counter_map.maptype =
-						COUNTER_MAP_NORMAL_MAP;
+						COUNTER_MAP_ZEROED;
 		h->chain_iterator_cur->counter_map.mappos = num-1;
 		memcpy(&h->chain_iterator_cur->counters, &pr->entry->counters,
 			sizeof(h->chain_iterator_cur->counters));
-- 
1.6.5.1

