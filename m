Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E2CC4321E
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 11:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiJQLEb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 07:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJQLEZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 07:04:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C29D631A
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 04:04:23 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 16/16] doc: add gretap matching expression
Date:   Mon, 17 Oct 2022 13:04:08 +0200
Message-Id: <20221017110408.742223-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221017110408.742223-1-pablo@netfilter.org>
References: <20221017110408.742223-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Document new gretap matching expression. This includes support for
matching the encapsulated ethernet frame layer 2, 3 and 4 headers
within the gre header.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/payload-expression.txt | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index e75cb1fae4cc..9a49439b2252 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -595,6 +595,26 @@ integer (24 bit)
 netdev filter ingress udp dport 4789 geneve tcp dport 80 counter
 ----------------------------------------------------------
 
+GRETAP HEADER EXPRESSION
+~~~~~~~~~~~~~~~~~~~~~~~~
+[verse]
+*gretap* {*vni* | *flags*}
+*gretap* *ether* {*daddr* | *saddr* | *type*}
+*gretap* *vlan* {*id* | *dei* | *pcp* | *type*}
+*gretap* *ip* {*version* | *hdrlength* | *dscp* | *ecn* | *length* | *id* | *frag-off* | *ttl* | *protocol* | *checksum* | *saddr* | *daddr* }
+*gretap* *ip6* {*version* | *dscp* | *ecn* | *flowlabel* | *length* | *nexthdr* | *hoplimit* | *saddr* | *daddr*}
+*gretap* *tcp* {*sport* | *dport* | *sequence* | *ackseq* | *doff* | *reserved* | *flags* | *window* | *checksum* | *urgptr*}
+*gretap* *udp* {*sport* | *dport* | *length* | *checksum*}
+
+The gretap expression is used to match on the encapsulated ethernet frame
+within the gre header. Use the *gre* expression to match on the *gre* header
+fields.
+
+.Matching inner TCP destination port encapsulated in gretap
+----------------------------------------------------------
+netdev filter ingress gretap tcp dport 80 counter
+----------------------------------------------------------
+
 VXLAN HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-- 
2.30.2

