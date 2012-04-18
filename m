From: Stephen Hemminger <shemminger@vyatta.com>
Subject: libmnl: fix valgrind warnings about padding
Date: Wed, 18 Apr 2012 11:33:27 -0700
Message-ID: <20120418113327.3d26501b@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:41181 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab2DRSda (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:33:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When using  mnl_nlmsg_put_extra_header() it pads out the addtional
header but only zeros the original size not the padded value. Which
cause valgrind to complain about sendto() with unitialized byte.

--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -105,8 +105,9 @@ void *
 mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
 {
        char *ptr = (char *)nlh + nlh->nlmsg_len;
-       nlh->nlmsg_len += MNL_ALIGN(size);
-       memset(ptr, 0, size);
+       size_t len = MNL_ALIGN(size);
+       nlh->nlmsg_len += len;
+       memset(ptr, 0, len);
        return ptr;
 }
 EXPORT_SYMBOL(mnl_nlmsg_put_extra_header);

