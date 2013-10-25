From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] nft: nft_set_attr_get_u32 null pointer deref
Date: Fri, 25 Oct 2013 09:55:31 -0700
Message-ID: <20131025165531.GA18336@home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54080 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3JYQze (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:55:34 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp16so4609377pbb.14
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2013 09:55:33 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As reported by John Sager, nft_set_attr_get_u32 can cause a segfault because
nft_set_attr_get can return NULL.  Check for a non-NULL pointer before
dereferencing.

This closes netfilter bugzilla #868.

Signed-off-by: Phil Oester <kernel@linuxace.com>


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-get_u32

diff --git a/src/set.c b/src/set.c
index 74ec1e3..85f73cf 100644
--- a/src/set.c
+++ b/src/set.c
@@ -183,8 +183,8 @@ EXPORT_SYMBOL(nft_set_attr_get_str);
 
 uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr)
 {
-	uint32_t val = *((uint32_t *)nft_set_attr_get(s, attr));
-	return val;
+	const void *val = nft_set_attr_get(s, attr);
+	return val ? *(uint32_t *)val : 0;
 }
 EXPORT_SYMBOL(nft_set_attr_get_u32);
 

--FCuugMFkClbJLl1L--
