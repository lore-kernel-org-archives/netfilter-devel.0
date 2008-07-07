From: Patrick McHardy <kaber@trash.net>
Subject: textsearch 12/13: convert kmalloc + memset to kzalloc
Date: Mon,  7 Jul 2008 14:05:31 +0200 (MEST)
Message-ID: <20080707120530.4975.73891.sendpatchset@localhost.localdomain>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58403 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbYGGMFc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:32 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

textsearch: convert kmalloc + memset to kzalloc

convert kmalloc + memset to kzalloc for alloc_ts_config

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1dca522180f8a6f882cdef795f49595c05467bb2
tree 857aaaea2e4ec8266bf6fc06d75ef9eee349fb43
parent 9506e421d3283116e5c0648be7a6233b7b841e35
author Joonwoo Park <joonwpark81@gmail.com> Mon, 07 Jul 2008 13:00:18 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:18 +0200

 include/linux/textsearch.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/textsearch.h b/include/linux/textsearch.h
index 6c34cf2..d9a85d6 100644
--- a/include/linux/textsearch.h
+++ b/include/linux/textsearch.h
@@ -162,11 +162,10 @@ static inline struct ts_config *alloc_ts_config(size_t payload,
 {
 	struct ts_config *conf;
 
-	conf = kmalloc(TS_PRIV_ALIGN(sizeof(*conf)) + payload, gfp_mask);
+	conf = kzalloc(TS_PRIV_ALIGN(sizeof(*conf)) + payload, gfp_mask);
 	if (conf == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	memset(conf, 0, TS_PRIV_ALIGN(sizeof(*conf)) + payload);
 	return conf;
 }
 
