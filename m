Return-Path: <SRS0=OxIk=DL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D733AC4363D
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 15:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41CBB206DD
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 15:35:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lIvvRuLn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgJDPfn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Oct 2020 11:35:43 -0400
Received: from m12-12.163.com ([220.181.12.12]:48590 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgJDPfn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Oct 2020 11:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=DRj++
        rTYnioE6DyHj9kP5YSKC9vzNZX5bcQm6i2E0k0=; b=lIvvRuLnVPzdgx0unGR4l
        AyBs6OdzBg0o2cBRTYuE+MGPwCyyCaSj/rwb/gBLdM51xmnRPPTn8TivttUvw1dq
        yTk+c6o9eAOkr97eIElwXCqRZiu9HwOwcyHau0Q2j3XukMsCPEty579ubCPINqcb
        65bfRoeduc5rt9/UV1WNeo=
Received: from localhost.localdomain (unknown [114.247.184.147])
        by smtp8 (Coremail) with SMTP id DMCowABHTcXp53lfwlgOQQ--.65499S2;
        Sun, 04 Oct 2020 23:19:06 +0800 (CST)
From:   "longguang.yue" <bigclouds@163.com>
Cc:     ja@ssi.bg, kuba@kernel.org, wensong@linux-vs.org,
        horms@verge.net.au, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, yuelongguang@gmail.com,
        "longguang.yue" <bigclouds@163.com>
Subject: [PATCH v6] ipvs: adjust the debug info in function set_tcp_state
Date:   Sun,  4 Oct 2020 23:18:57 +0800
Message-Id: <20201004151857.83621-1-bigclouds@163.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <alpine.LFD.2.23.451.2009300803110.6056@ja.home.ssi.bg>
References: <alpine.LFD.2.23.451.2009300803110.6056@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowABHTcXp53lfwlgOQQ--.65499S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJryDWr1fWry5KryUKw4DArb_yoW8Ww1Up3
        Zay3yagrW7JrZ3JrsrJrWUW3s8CFsYqrn0qF45K34fAas8XrsxtFnYkayj9ayUArZ7X3yx
        Xr1Yk3y5A3Z2y3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U0JmUUUUUU=
X-Originating-IP: [114.247.184.147]
X-CM-SenderInfo: peljuzprxg2qqrwthudrp/1tbiQAqzQ1SIgjBQxgAAsC
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Outputting client,virtual,dst addresses info when tcp state changes,
which makes the connection debug more clear

---
v5,v6: fix indentation and add changelogs
v3,v4: fix checkpatch
v2: IP_VS_DBG_BUF outputs src,virtual,dst of ip_vs_conn
v1: fix the inverse of src and dst address

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


