From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 04/13] Conditionally enable transparent flow flag when
	connecting
Date: Tue, 02 Oct 2007 22:41:46 +0200
Message-ID: <20071002204146.11052.11896.stgit@nessa.odu>
References: <20071002203942.11052.7303.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:51504 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbXJBUlr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:41:47 -0400
Received: from nessa.odu ([152.66.208.5])
 by balu.sch.bme.hu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTP id <0JPA00DK8XF1E1D0@balu.sch.bme.hu> for
 netfilter-devel@vger.kernel.org; Tue, 02 Oct 2007 22:40:14 +0200 (CEST)
In-reply-to: <20071002203942.11052.7303.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Set FLOWI_FLAG_ANYSRC in flowi->flags if the socket has the
transparent socket option set. This way we selectively enable certain
connections with non-local source addresses to be routed.

Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
---

 include/net/route.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 88fed3c..9788cc2 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -158,6 +158,10 @@ static inline int ip_route_connect(struct rtable **rp, __be32 dst,
 					 .dport = dport } } };
 
 	int err;
+
+	if (inet_sk(sk)->transparent)
+		fl.flags |= FLOWI_FLAG_ANYSRC;
+
 	if (!dst || !src) {
 		err = __ip_route_output_key(rp, &fl);
 		if (err)

