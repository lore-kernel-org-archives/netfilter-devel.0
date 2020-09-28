Return-Path: <SRS0=suW2=DF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EDE4C4346E
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 03:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDB142311C
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 03:06:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="UutTpSCI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgI1DGN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Sep 2020 23:06:13 -0400
Received: from mail-m975.mail.163.com ([123.126.97.5]:60194 "EHLO
        mail-m975.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgI1DGM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Sep 2020 23:06:12 -0400
X-Greylist: delayed 933 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Sep 2020 23:06:11 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=HDfLA
        qYVfb3Z0S+amqSDOqr45I27vSggNM6rJRnL+Bk=; b=UutTpSCIgUClsa27oNpmC
        LOtikznCIargqvC808q0xr3TdErNG4V8K6AQ7uxMv/TpXkRGVBEQVly9ktOpWT3B
        WMF6gqgzFf7sYQWNJ6VIF4MYiRDqOqKmRV1c8uKQWpdjivoF7xEp2QEFrclcu+KJ
        QtNCH1QvEbpntZSXJCXzv8=
Received: from localhost.localdomain (unknown [111.202.93.98])
        by smtp5 (Coremail) with SMTP id HdxpCgAXFuZKT3FfGVziOA--.341S2;
        Mon, 28 Sep 2020 10:49:46 +0800 (CST)
From:   "longguang.yue" <bigclouds@163.com>
To:     yuelongguang@gmail.com
Cc:     "longguang.yue" <bigclouds@163.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:IPVS),
        lvs-devel@vger.kernel.org (open list:IPVS),
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5] ipvs: adjust the debug info in function set_tcp_state
Date:   Mon, 28 Sep 2020 10:49:38 +0800
Message-Id: <20200928024938.97121-1-bigclouds@163.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <alpine.LFD.2.23.451.2009271625160.35554@ja.home.ssi.bg>
References: <alpine.LFD.2.23.451.2009271625160.35554@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgAXFuZKT3FfGVziOA--.341S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw1UZr48Cr45JrW8ZFW5Wrg_yoW8XrWDpa
        sayayagrW7JrZ7JrsrJr48u398Cr4vvrn0qFW5K34fJas8Xrs3tFnYkay09a1UArZ7X3yx
        Xr1Yk3y5Aa92y3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j0OJ5UUUUU=
X-Originating-IP: [111.202.93.98]
X-CM-SenderInfo: peljuzprxg2qqrwthudrp/xtbBzwqtQ1aD8mLZkwAAsk
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Outputting client,virtual,dst addresses info when tcp state changes,
which makes the connection debug more clear

Signed-off-by: longguang.yue <bigclouds@163.com>
---
 net/netfilter/ipvs/ip_vs_proto_tcp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index dc2e7da2742a..7da51390cea6 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -539,8 +539,8 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 	if (new_state != cp->state) {
 		struct ip_vs_dest *dest = cp->dest;
 
-		IP_VS_DBG_BUF(8, "%s %s [%c%c%c%c] %s:%d->"
-			      "%s:%d state: %s->%s conn->refcnt:%d\n",
+		IP_VS_DBG_BUF(8, "%s %s [%c%c%c%c] c:%s:%d v:%s:%d "
+			      "d:%s:%d state: %s->%s conn->refcnt:%d\n",
 			      pd->pp->name,
 			      ((state_off == TCP_DIR_OUTPUT) ?
 			       "output " : "input "),
@@ -548,10 +548,12 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 			      th->fin ? 'F' : '.',
 			      th->ack ? 'A' : '.',
 			      th->rst ? 'R' : '.',
-			      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
-			      ntohs(cp->dport),
 			      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
 			      ntohs(cp->cport),
+			      IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
+			      ntohs(cp->vport),
+			      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
+			      ntohs(cp->dport),
 			      tcp_state_name(cp->state),
 			      tcp_state_name(new_state),
 			      refcount_read(&cp->refcnt));
-- 
2.20.1 (Apple Git-117)

