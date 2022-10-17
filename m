Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A62AC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 11:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiJQLEW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 07:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiJQLEU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 07:04:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F6002AC1
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 04:04:19 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 06/16] doc: add vxlan matching expression
Date:   Mon, 17 Oct 2022 13:03:58 +0200
Message-Id: <20221017110408.742223-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221017110408.742223-1-pablo@netfilter.org>
References: <20221017110408.742223-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Document new vxlan matching expression. This includes support for
matching the encapsulated ethernet frame layer 2, 3 and 4 headers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/payload-expression.txt | 71 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 113f5bfc597c..c80198878c1a 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -532,6 +532,77 @@ compression Parameter Index |
 integer (16 bit)
 |============================
 
+VXLAN HEADER EXPRESSION
+~~~~~~~~~~~~~~~~~~~~~~~
+[verse]
+*vxlan* {*vni* | *flags*}
+*vxlan* *ether* {*daddr* | *saddr* | *type*}
+*vxlan* *vlan* {*id* | *dei* | *pcp* | *type*}
+*vxlan* *ip* {*version* | *hdrlength* | *dscp* | *ecn* | *length* | *id* | *frag-off* | *ttl* | *protocol* | *checksum* | *saddr* | *daddr* }
+*vxlan* *ip6* {*version* | *dscp* | *ecn* | *flowlabel* | *length* | *nexthdr* | *hoplimit* | *saddr* | *daddr*}
+*vxlan* *tcp* {*sport* | *dport* | *sequence* | *ackseq* | *doff* | *reserved* | *flags* | *window* | *checksum* | *urgptr*}
+*vxlan* *udp* {*sport* | *dport* | *length* | *checksum*}
+
+The vxlan expression is used to match on the vxlan header fields. The vxlan
+header encapsulates a ethernet frame within a *udp* packet. This expression
+requires that you restrict the matching to *udp* packets (usually at
+port 4789 according to IANA-assigned ports).
+
+.VXLAN header expression
+[options="header"]
+|==================
+|Keyword| Description| Type
+|flags|
+vxlan flags|
+integer (8 bit)
+|vni|
+Virtual Network ID (VNI)|
+integer (24 bit)
+|==================
+
+.Matching inner TCP destination port encapsulated in vxlan
+----------------------------------------------------------
+netdev filter ingress udp dport 4789 vxlan tcp dport 80 counter
+----------------------------------------------------------
+
+ARP HEADER EXPRESSION
+~~~~~~~~~~~~~~~~~~~~~
+[verse]
+*arp* {*htype* | *ptype* | *hlen* | *plen* | *operation* | *saddr* { *ip* | *ether* } | *daddr* { *ip* | *ether* }
+
+.ARP header expression
+[options="header"]
+|==================
+|Keyword| Description| Type
+|htype|
+ARP hardware type|
+integer (16 bit)
+|ptype|
+EtherType|
+ether_type
+|hlen|
+Hardware address len|
+integer (8 bit)
+|plen|
+Protocol address len |
+integer (8 bit)
+|operation|
+Operation |
+arp_op
+|saddr ether|
+Ethernet sender address|
+ether_addr
+|daddr ether|
+Ethernet target address|
+ether_addr
+|saddr ip|
+IPv4 sender address|
+ipv4_addr
+|daddr ip|
+IPv4 target address|
+ipv4_addr
+|======================
+
 RAW PAYLOAD EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-- 
2.30.2

