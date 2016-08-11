From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 5/7] common: Avoid integer overflow in nftnl_batch_is_supported()
Date: Fri, 12 Aug 2016 01:33:37 +0200
Message-ID: <1470958419-32602-6-git-send-email-phil@nwl.cc>
References: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44486 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbcHKXeR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:34:17 -0400
In-Reply-To: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

time() may return -1 which is then assigned to an unsigned integer type
and used as sequence number. The following code increments that number
multiple times, so it may overflow and get libmnl confused. To avoid
this, fall back to a starting sequence number of zero in case the call
to time() failed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/common.c b/src/common.c
index bf4176ceb76eb..2189cc8a3e882 100644
--- a/src/common.c
+++ b/src/common.c
@@ -192,6 +192,9 @@ int nftnl_batch_is_supported(void)
 	uint32_t seq = time(NULL), req_seq;
 	int ret;
 
+	if (seq == (uint32_t)-1)
+		seq = 0;
+
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL)
 		return -1;
-- 
2.8.2

