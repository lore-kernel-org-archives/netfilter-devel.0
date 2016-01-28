From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 09/11] proto: proto_dev_type() returns interface type for base protocols too
Date: Thu, 28 Jan 2016 22:24:58 +0100
Message-ID: <1454016300-29969-10-git-send-email-pablo@netfilter.org>
References: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43812 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbcA1VZV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 16:25:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8EA4A347
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7C977DA814
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9BBFCDA801
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:18 +0100 (CET)
In-Reply-To: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The device protocol definition provides a mapping between the interface
type, ie. ARPHDR_*, and the overlying protocol base definition, eg.
proto_eth.

This patch updates proto_dev_type() so it also returns a mapping for
these overlying ethernet protocol definitions, ie. ip, ip6, vlan, ip,
arp.

This patch required to resolve problems with automatic dependency
generation for vlan in the netdev and inet families.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/proto.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/src/proto.c b/src/proto.c
index 65ee158..0cd9fdb 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -94,13 +94,21 @@ static const struct dev_proto_desc dev_proto_desc[] = {
  */
 int proto_dev_type(const struct proto_desc *desc, uint16_t *res)
 {
-	unsigned int i;
+	const struct proto_desc *base;
+	unsigned int i, j;
 
 	for (i = 0; i < array_size(dev_proto_desc); i++) {
-		if (dev_proto_desc[i].desc == desc) {
+		base = dev_proto_desc[i].desc;
+		if (base == desc) {
 			*res = dev_proto_desc[i].type;
 			return 0;
 		}
+		for (j = 0; j < array_size(base->protocols); j++) {
+			if (base->protocols[j].desc == desc) {
+				*res = dev_proto_desc[i].type;
+				return 0;
+			}
+		}
 	}
 	return -1;
 }
-- 
2.1.4

