Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386F3C4167D
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 11:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiJQLEa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 07:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiJQLEX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 07:04:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40ED755BE
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 04:04:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 13/16] doc: add geneve matching expression
Date:   Mon, 17 Oct 2022 13:04:05 +0200
Message-Id: <20221017110408.742223-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221017110408.742223-1-pablo@netfilter.org>
References: <20221017110408.742223-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Document new geneve matching expression. This includes support for
matching the encapsulated ethernet frame layer 2, 3 and 4 headers.
---
 doc/payload-expression.txt | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 86e364713953..e75cb1fae4cc 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -562,6 +562,39 @@ integer (16 bit)
 netdev filter ingress gre ip daddr 9.9.9.9 counter
 ------------------------------------------------------------
 
+GENEVE HEADER EXPRESSION
+~~~~~~~~~~~~~~~~~~~~~~~~
+[verse]
+*geneve* {*vni* | *flags*}
+*geneve* *ether* {*daddr* | *saddr* | *type*}
+*geneve* *vlan* {*id* | *dei* | *pcp* | *type*}
+*geneve* *ip* {*version* | *hdrlength* | *dscp* | *ecn* | *length* | *id* | *frag-off* | *ttl* | *protocol* | *checksum* | *saddr* | *daddr* }
+*geneve* *ip6* {*version* | *dscp* | *ecn* | *flowlabel* | *length* | *nexthdr* | *hoplimit* | *saddr* | *daddr*}
+*geneve* *tcp* {*sport* | *dport* | *sequence* | *ackseq* | *doff* | *reserved* | *flags* | *window* | *checksum* | *urgptr*}
+*geneve* *udp* {*sport* | *dport* | *length* | *checksum*}
+
+The geneve expression is used to match on the geneve header fields. The geneve
+header encapsulates a ethernet frame within a *udp* packet. This expression
+requires that you restrict the matching to *udp* packets (usually at
+port 6081 according to IANA-assigned ports).
+
+.GENEVE header expression
+[options="header"]
+|==================
+|Keyword| Description| Type
+|protocol|
+EtherType of encapsulated packet|
+integer (16 bit)
+|vni|
+Virtual Network ID (VNI)|
+integer (24 bit)
+|==================
+
+.Matching inner TCP destination port encapsulated in geneve
+----------------------------------------------------------
+netdev filter ingress udp dport 4789 geneve tcp dport 80 counter
+----------------------------------------------------------
+
 VXLAN HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-- 
2.30.2

