From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/1]: nf_conntrack_expect: fix error path unwind in nf_conntrack_expect_init()
Date: Tue, 27 May 2008 07:00:22 +0200
Message-ID: <483B9566.3030105@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090504030209080102040409"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42333 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbYE0FAY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2008 01:00:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090504030209080102040409
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Attached is a fix from Alexey for incorrect error handling
in nf_conntrack_expect. I'll also queue it up for -stable.



--------------090504030209080102040409
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit 4a000134ae4d0092de7ef5d8536e3a21d18eb46c
Author: Alexey Dobriyan <adobriyan@parallels.com>
Date:   Tue May 27 06:18:46 2008 +0200

    [NETFILTER]: nf_conntrack_expect: fix error path unwind in nf_conntrack_expect_init()
    
    Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index e31beeb..e8f0dea 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -587,10 +587,10 @@ int __init nf_conntrack_expect_init(void)
 	return 0;
 
 err3:
+	kmem_cache_destroy(nf_ct_expect_cachep);
+err2:
 	nf_ct_free_hashtable(nf_ct_expect_hash, nf_ct_expect_vmalloc,
 			     nf_ct_expect_hsize);
-err2:
-	kmem_cache_destroy(nf_ct_expect_cachep);
 err1:
 	return err;
 }

--------------090504030209080102040409--
