From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: [PATCH] iptables: avoid compile warnings for iptc_insert_chain
Date: Thu, 19 Mar 2009 14:55:37 +0100
Message-ID: <d69a2a7d86c4224396091673aefc59cf25d55713.1237460727.git.christoph.paasch@gmail.com>
References: <49C202EA.40006@trash.net>
Cc: Christoph Paasch <christoph.paasch@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:33430 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZCSNzl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:55:41 -0400
Received: by ewy9 with SMTP id 9so404277ewy.37
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2009 06:55:39 -0700 (PDT)
In-Reply-To: <49C202EA.40006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iptc_insert_chain is too big to get inlined and so it generates
a warning while compiling.

Signed-off-by: Christoph Paasch <christoph.paasch@gmail.com>
---
 libiptc/libiptc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 544a5b2..c3d9bfc 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -841,7 +841,7 @@ static int __iptcc_p_del_policy(struct xtc_handle *h, unsigned int num)
 }
 
 /* alphabetically insert a chain into the list */
-static inline void iptc_insert_chain(struct xtc_handle *h, struct chain_head *c)
+static void iptc_insert_chain(struct xtc_handle *h, struct chain_head *c)
 {
 	struct chain_head *tmp;
 	struct list_head  *list_start_pos;
-- 
1.5.6.3

