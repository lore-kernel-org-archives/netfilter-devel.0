Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27EAC10F03
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 20:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F681208E4
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 20:18:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="OvCuub6d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfDWUSr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 16:18:47 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36102 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfDWUSr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 16:18:47 -0400
Received: by mail-qt1-f193.google.com with SMTP id c35so2949064qtk.3
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2019 13:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=from:to:subject:date:message-id;
        bh=88D/5FOUIXfTX8GBbyudFbBaL4NTlhNied0gs4EJMfk=;
        b=OvCuub6d8KuSa9nfzmLvpdruWcY6byhk5TveWluiNAcSxKgTb+jGxZ5iF5elbtQgoq
         bTNv4IcLyzfidBpDo/2JBxnwFxXAhFv7Yae9m6EZ2plXQ/OENDPD+jni/Gn+zaZ/jdPv
         TG1jqw6itsivILdg+zGjT3V7/sNqxdo18NQvY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=88D/5FOUIXfTX8GBbyudFbBaL4NTlhNied0gs4EJMfk=;
        b=PInpMQ//FflnxkDNJbTB00dpQwL3Y72vgMvB8BDPgXtSSer5E4rnbkCwvYuS6RJbSl
         8v3ObS1GKFfTExiah2hDipnh8NLSOE9qt06aLlbbp4HcSbwoONf4mBU5fCplSibvYAlH
         SGs9Z9S6DfyN9I8aqrX9vPWEDaYLTq+AMRuOFOYeYdYlhvZJFUPzyhdH2v58KKwaOAkX
         yIAZeFDEzcM4JAMzMpzbkWVqkWxNOt954PGCvj8t0KkNRpuAnOzpcxSAgT1Q4klLOWiv
         IcV6aTvrnE2CapJRiZMK1zmVPKfLj2WEiikppMntZgh8lgkAnzJj4nKsYTYvDqfVj3gr
         dVuw==
X-Gm-Message-State: APjAAAU1VDL6LALg01CCvMFI3p4xImT6XRtDay4xBhGk3lOaDTOTFbZv
        j6dzAnC3yVsTo3fTAs8AWLPzJd0eUH8=
X-Google-Smtp-Source: APXvYqxyVpVZUpHs10oT29KaOXh0pmbKHJWgTmn95ErfGQQy6+xVmC+9Cytb1e1SozUQDmaKj1ekFA==
X-Received: by 2002:a0c:b14d:: with SMTP id r13mr22637872qvc.80.1556050725560;
        Tue, 23 Apr 2019 13:18:45 -0700 (PDT)
Received: from osboxes.example.com (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id m18sm8951776qki.64.2019.04.23.13.18.44
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 13:18:45 -0700 (PDT)
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] ct: Add support for the 'id' key
Date:   Tue, 23 Apr 2019 16:18:41 -0400
Message-Id: <20190423201841.8539-1-bmastbergen@untangle.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The 'id' key allows for matching on the id of the conntrack entry.

This is most useful as a key for maps

nft add map nat conntoip { type ct_id: ipv4_addr \; }
nft add rule ip nat postrouting snat ct id map @conntoip

Signed-off-by: Brett Mastbergen <bmastbergen@untangle.com>
---
 doc/payload-expression.txt          |  5 ++++-
 include/ct.h                        |  1 +
 include/datatype.h                  |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/ct.c                            | 11 +++++++++++
 src/datatype.c                      |  1 +
 src/parser_bison.y                  |  1 +
 7 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 28061f3..e93022b 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -588,7 +588,7 @@ is true for the *zone*, if a direction is given, the zone is only matched if the
 zone id is tied to the given direction. +
 
 [verse]
-*ct* {state | direction | status | mark | expiration | helper | label | l3proto | protocol | bytes | packets | avgpkt | zone}
+*ct* {state | direction | status | mark | expiration | helper | label | l3proto | protocol | bytes | packets | avgpkt | zone | id}
 *ct* {original | reply} {l3proto | protocol | proto-src | proto-dst | bytes | packets | avgpkt | zone}
 *ct* {original | reply} {ip | ip6} {saddr | daddr}
 
@@ -650,6 +650,9 @@ integer (16 bit)
 |count|
 count number of connections
 integer (32 bit)
+|id|
+Connection id
+ct_id
 |==========================================
 A description of conntrack-specific types listed above can be found sub-section CONNTRACK TYPES above.
 
diff --git a/include/ct.h b/include/ct.h
index 4c5bd80..1e707e7 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -39,5 +39,6 @@ extern const char *ct_label2str(unsigned long value);
 extern const struct datatype ct_dir_type;
 extern const struct datatype ct_state_type;
 extern const struct datatype ct_status_type;
+extern const struct datatype ct_id_type;
 
 #endif /* NFTABLES_CT_H */
diff --git a/include/datatype.h b/include/datatype.h
index 14ece28..73a9cf2 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -90,6 +90,7 @@ enum datatypes {
 	TYPE_CT_EVENTBIT,
 	TYPE_IFNAME,
 	TYPE_IGMP_TYPE,
+	TYPE_CT_ID,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 09a7b9e..150f32a 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -986,6 +986,7 @@ enum nft_osf_flags {
  * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
  * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
  * @NFT_CT_TIMEOUT: connection tracking timeout policy assigned to conntrack
+ * @NFT_CT_ID: conntrack id
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -1012,6 +1013,7 @@ enum nft_ct_keys {
 	NFT_CT_SRC_IP6,
 	NFT_CT_DST_IP6,
 	NFT_CT_TIMEOUT,
+	NFT_CT_ID,
 	__NFT_CT_MAX
 };
 #define NFT_CT_MAX		(__NFT_CT_MAX - 1)
diff --git a/src/ct.c b/src/ct.c
index 2256ce3..21bc182 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -239,6 +239,15 @@ void ct_label_table_exit(void)
 	rt_symbol_table_free(ct_label_tbl);
 }
 
+const struct datatype ct_id_type = {
+	.type		= TYPE_CT_ID,
+	.name		= "ct_id",
+	.desc		= "conntrack id",
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.size		= 4 * BITS_PER_BYTE,
+	.basetype	= &integer_type,
+};
+
 #ifndef NF_CT_HELPER_NAME_LEN
 #define NF_CT_HELPER_NAME_LEN	16
 #endif
@@ -291,6 +300,8 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
 					      BYTEORDER_HOST_ENDIAN, 16),
 	[NFT_CT_EVENTMASK]	= CT_TEMPLATE("event", &ct_event_type,
 					      BYTEORDER_HOST_ENDIAN, 32),
+	[NFT_CT_ID]		= CT_TEMPLATE("id", &ct_id_type,
+					      BYTEORDER_BIG_ENDIAN, 32),
 };
 
 static void ct_print(enum nft_ct_keys key, int8_t dir, uint8_t nfproto,
diff --git a/src/datatype.c b/src/datatype.c
index ac9f2af..6b76fc9 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -71,6 +71,7 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_BOOLEAN]		= &boolean_type,
 	[TYPE_IFNAME]		= &ifname_type,
 	[TYPE_IGMP_TYPE]	= &igmp_type_type,
+	[TYPE_CT_ID]		= &ct_id_type,
 };
 
 const struct datatype *datatype_lookup(enum datatypes type)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 4a2a81c..92660ce 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4100,6 +4100,7 @@ ct_key			:	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
 			|	LABEL		{ $$ = NFT_CT_LABELS; }
 			|	EVENT		{ $$ = NFT_CT_EVENTMASK; }
 			|	TIMEOUT 	{ $$ = NFT_CT_TIMEOUT; }
+			|	ID	 	{ $$ = NFT_CT_ID; }
 			|	ct_key_dir_optional
 			;
 
-- 
2.11.0

