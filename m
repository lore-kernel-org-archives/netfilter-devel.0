From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables: set errno correctly in iptcc_chain_index_alloc
Date: Wed, 3 Jul 2013 18:16:10 -0700
Message-ID: <20130704011610.GA9791@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40807 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3GDBQN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jul 2013 21:16:13 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so777824pad.37
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jul 2013 18:16:13 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As reported by Robert Barnhardt, iptcc_chain_index_alloc does not populate
errno with the appropriate ENOMEM on allocation failures.  This causes
incorrect error messages to be passed back to user such as "can't initialize
iptables table 'X'" even if the issue was caused by OOM condition.  Fix
this by passing back ENOMEM if allocation failure occurs.

This closes bugzilla #619.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-enomem

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index f0f7815..004b0ec 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -502,7 +502,8 @@ static int iptcc_chain_index_alloc(struct xtc_handle *h)
 	h->chain_index = malloc(array_mem);
 	if (h->chain_index == NULL && array_mem > 0) {
 		h->chain_index_sz = 0;
-		return -ENOMEM;
+		errno = ENOMEM;
+		return -1;
 	}
 	memset(h->chain_index, 0, array_mem);
 	h->chain_index_sz = array_elems;

--5mCyUwZo2JvN/JJP--
