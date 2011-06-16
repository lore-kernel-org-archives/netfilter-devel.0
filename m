From: kaber@trash.net
Subject: [PATCH 02/20] IPVS remove unused var from migration to netns
Date: Thu, 16 Jun 2011 21:47:02 +0200
Message-ID: <1308253640-29942-3-git-send-email-kaber@trash.net>
References: <1308253640-29942-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64137 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1FPTrY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:47:24 -0400
In-Reply-To: <1308253640-29942-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Hans Schillstrom <hans.schillstrom@ericsson.com>

Remove variable ctl_key from struct netns_ipvs,
it's a leftover from early netns work.

Signed-off-by: Hans Schillstrom <hans.schillstrom@ericsson.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 include/net/ip_vs.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 481f856..34a6fa8 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -836,8 +836,6 @@ struct netns_ipvs {
 	int			num_services;    /* no of virtual services */
 
 	rwlock_t		rs_lock;         /* real services table */
-	/* semaphore for IPVS sockopts. And, [gs]etsockopt may sleep. */
-	struct lock_class_key	ctl_key;	/* ctl_mutex debuging */
 	/* Trash for destinations */
 	struct list_head	dest_trash;
 	/* Service counters */
-- 
1.7.2.3

