From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 04/13] Conditionally enable transparent flow flag when
	connecting
Date: Sun, 30 Sep 2007 22:52:23 +0200
Message-ID: <20070930205223.10969.76486.stgit@nessa.odu>
References: <20070930205141.10969.27205.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:40438 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbXI3VL4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:11:56 -0400
In-Reply-To: <20070930205141.10969.27205.stgit@nessa.odu>
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

