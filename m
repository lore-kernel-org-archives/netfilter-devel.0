From: Alexey Dobriyan <adobriyan@sw.ru>
Subject: [PATCH] conntrack: add \n to "expectation table full" message
Date: Fri, 7 Mar 2008 12:26:26 +0300
Message-ID: <20080307092626.GD2560@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:4781 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794AbYCGJ0f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:26:35 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 net/netfilter/nf_conntrack_expect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -375,7 +375,7 @@ int nf_ct_expect_related(struct nf_conntrack_expect *expect)
 	if (nf_ct_expect_count >= ve_nf_ct_expect_max) {
 		if (net_ratelimit())
 			printk(KERN_WARNING
-			       "nf_conntrack: expectation table full");
+			       "nf_conntrack: expectation table full\n");
 		ret = -EMFILE;
 		goto out;
 	}

