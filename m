Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E54BC3A589
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 16:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46D382054F
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 16:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfHTQqH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 12:46:07 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:59732 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfHTQqH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 12:46:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id BF33064B5;
        Tue, 20 Aug 2019 18:46:04 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LWajoeAoeJaB; Tue, 20 Aug 2019 18:46:01 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP;
        Tue, 20 Aug 2019 18:46:00 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id DA3EE30AD0EB; Tue, 20 Aug 2019 18:46:00 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH] src: add vlan_id type
Date:   Tue, 20 Aug 2019 18:45:23 +0200
Message-Id: <20190820164523.18464-1-michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This enables using vlan id in a set or a concatenation.

table bridge filter {
	set dropvlans {
		type vlan_id
		elements = { 123 }
	}
	chain FORWARD {
		type filter hook forward priority filter; policy accept;
                vlan id @dropvlans drop
	}
}

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 include/datatype.h |  2 ++
 src/datatype.c     |  1 +
 src/proto.c        | 11 ++++++++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/datatype.h b/include/datatype.h
index c1d08cc2..9678d0da 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -90,6 +90,7 @@ enum datatypes {
 	TYPE_CT_EVENTBIT,
 	TYPE_IFNAME,
 	TYPE_IGMP_TYPE,
+	TYPE_VLANID,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
@@ -264,6 +265,7 @@ extern const struct datatype time_type;
 extern const struct datatype boolean_type;
 extern const struct datatype priority_type;
 extern const struct datatype policy_type;
+extern const struct datatype vlanid_type;
 
 void inet_service_type_print(const struct expr *expr, struct output_ctx *octx);
 
diff --git a/src/datatype.c b/src/datatype.c
index c5a01346..2bf0bb18 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -71,6 +71,7 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_BOOLEAN]		= &boolean_type,
 	[TYPE_IFNAME]		= &ifname_type,
 	[TYPE_IGMP_TYPE]	= &igmp_type_type,
+	[TYPE_VLANID]		= &vlanid_type,
 };
 
 const struct datatype *datatype_lookup(enum datatypes type)
diff --git a/src/proto.c b/src/proto.c
index 40ce590e..efcd6119 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -918,6 +918,15 @@ const struct proto_desc proto_arp = {
 
 #include <net/ethernet.h>
 
+const struct datatype vlanid_type = {
+	.type		= TYPE_VLANID,
+	.name		= "vlan_id",
+	.desc		= "802.1Q VLAN ID",
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.size		= 12,
+	.basetype	= &integer_type,
+};
+
 #define VLANHDR_BITFIELD(__name, __offset, __len) \
 	HDR_BITFIELD(__name, &integer_type, __offset, __len)
 #define VLANHDR_TYPE(__name, __type, __member) \
@@ -938,7 +947,7 @@ const struct proto_desc proto_vlan = {
 	.templates	= {
 		[VLANHDR_PCP]		= VLANHDR_BITFIELD("pcp", 0, 3),
 		[VLANHDR_CFI]		= VLANHDR_BITFIELD("cfi", 3, 1),
-		[VLANHDR_VID]		= VLANHDR_BITFIELD("id", 4, 12),
+		[VLANHDR_VID]		= HDR_BITFIELD("id", &vlanid_type, 4, 12),
 		[VLANHDR_TYPE]		= VLANHDR_TYPE("type", &ethertype_type, vlan_type),
 	},
 };
-- 
2.20.1

