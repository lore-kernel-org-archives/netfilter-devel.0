From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: nfnetlink_queue: add definition of
	aligned_be64 for user-space apps
Date: Mon, 12 Jul 2010 19:00:19 +0200
Message-ID: <20100712170019.4026.55069.stgit@decadence>
References: <20100712165241.4026.83949.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41252 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab0GLRA1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:00:27 -0400
In-Reply-To: <20100712165241.4026.83949.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, libnl and libnetfilter_queue include in one of their
user-space header files an ad-hoc definition of aligned_be64.
However, applications that use the BSD socket API to communicate
via Netlink sockets (ie. those that do not use these libraries)
would need to define this type by hand if they include the
kernel-space header nfnetlink_queue.h.

This patch adds the definition of aligned_bed64 for user-space
applications in the kernel header. Otherwise, they have to define
it to avoid the following compilation problem:

/usr/include/linux/netfilter/nfnetlink_queue.h:28: error: expected spec=
ifier-qualifier-list before =E2=80=98aligned_be64=E2=80=99

I know, this is ugly but I think that user-space Netlink applications
should compile with the only need of including the kernel-space
header that contains the protocol definitions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink_queue.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/=
netfilter/nfnetlink_queue.h
index 2455fe5..5512a35 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -24,6 +24,12 @@ struct nfqnl_msg_packet_hw {
 	__u8	hw_addr[8];
 };
=20
+#ifndef __KERNEL__
+#ifndef aligned_be64
+#define aligned_be64 u_int64_t __attribute__((aligned(8)))
+#endif
+#endif /* !__KERNEL__ */
+
 struct nfqnl_msg_packet_timestamp {
 	aligned_be64	sec;
 	aligned_be64	usec;

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
