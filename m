Return-Path: <SRS0=t5ds=XV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11B7C432C2
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Sep 2019 10:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9519C222C2
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Sep 2019 10:54:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="umfD8TQS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfIZKyB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Sep 2019 06:54:01 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38139 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfIZKyA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Sep 2019 06:54:00 -0400
Received: by mail-lj1-f194.google.com with SMTP id b20so1675404ljj.5
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2019 03:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jcd+vSvP92HMeaQNjQvsB03MgWRZfQFA0pM8Vz3I/fU=;
        b=umfD8TQSEdb7GHT5rOnAdVaGsBfSuAd/gKqDtWSQf2+vdHLF7NLl2yV3Nuvbvcv+Ur
         yn04CYaNnmLATRRot0L5W6ts6UmBAmDYvTauo0x3HZQCvHveU1Jvjq95RM2NslSzVU/s
         r7AB5svNMnDOJp2TAwymyG8l0smw7QM4K74/KM+VDPkNyQyVd/SGvML3y4VNrX1m8Ot6
         zoQZ7ObqWK64rz+ZHpcepsYlTQwIhWDX3QyPsCABuevjwS7W2tje6yR8gzl3TujllBYX
         H8sZasM8P0nWjR+xg3gkmhwWTIGilF7JtObZfLR3XLHULYnxIhLtogatIDqj/D+Eay+l
         lIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jcd+vSvP92HMeaQNjQvsB03MgWRZfQFA0pM8Vz3I/fU=;
        b=toQ3GJm4nSyrS9b4Oqzfc7jDLmfuKWHP9sRyjPO9UfZTP5/6MLf7C86Q+BBACPugIY
         CA2mUGFg2vvitFR+Yei8ym2pn8nsCvDxyq0zEHBh2mAF8i2MG398byvTrExwTPL1oyAD
         2fN60K86dbq7IjbHRBQ3UhUU5v19P6nBntaxm3rVNxssFqkTLYtuxR0aaf551HEoa3w3
         hd7Bxaqs3vLqg0oLJYZ2jWoaaBuFYZPGmQzDJZsdUu5zJwa9AZ22S7Grx0Aoxx2pLBqR
         4Be1lMQe4iAw4irAmKGG459FTZ/RSWPfYvKJUWMXml7h2RUNV25Q3o5AmdgG0MaNjmPk
         mM2Q==
X-Gm-Message-State: APjAAAV3rO0bJyR83/79BP+X/P6muea6AlbvoKDiq/ppmkQuwPObuTcX
        1gkNKYJktDVGrZp9HOnXaz6CLqRXzpo=
X-Google-Smtp-Source: APXvYqzvuiW/L/uqnGx58hkR0dtrWBuSyCANBzm20ae7/D8iHt85ZUUbCD9Y3Q8PhuXer1us72WmLw==
X-Received: by 2002:a2e:3c17:: with SMTP id j23mr2135989lja.200.1569495236510;
        Thu, 26 Sep 2019 03:53:56 -0700 (PDT)
Received: from kristrev-XPS-15-9570.lan ([193.213.155.210])
        by smtp.gmail.com with ESMTPSA id 6sm453114lfa.24.2019.09.26.03.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 03:53:55 -0700 (PDT)
From:   Kristian Evensen <kristian.evensen@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH] ipset: Add wildcard support to net,iface
Date:   Thu, 26 Sep 2019 12:53:54 +0200
Message-Id: <20190926105354.8301-1-kristian.evensen@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The net,iface equal functions currently compares the full interface
names. In several cases, wildcard (or prefix) matching is useful. For
example, when converting a large iptables rule-set to make use of ipset,
I was able to significantly reduce the number of set elements by making
use of wildcard matching.

Wildcard matching is enabled by adding "wildcard" when adding an element
to a set. Internally, this causes the IPSET_FLAG_IFACE_WILDCARD-flag to
be set.  When this flag is set, only the initial part of the interface
name is used for comparison.

Wildcard matching is done per element and not per set, as there are many
cases where mixing wildcard and non-wildcard elements are useful. This
means that is up to the user to handle (avoid) overlapping interface
names.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/libipset/args.h                       |  1 +
 include/libipset/data.h                       |  4 +-
 include/libipset/linux_ip_set.h               |  2 +
 .../uapi/linux/netfilter/ipset/ip_set.h       |  2 +
 .../netfilter/ipset/ip_set_hash_netiface.c    | 23 ++++-
 lib/args.c                                    |  8 ++
 lib/data.c                                    |  8 ++
 lib/ipset_hash_netiface.c                     | 95 +++++++++++++++++++
 src/ipset.8                                   |  8 +-
 9 files changed, 144 insertions(+), 7 deletions(-)

diff --git a/include/libipset/args.h b/include/libipset/args.h
index ce14251..616cca5 100644
--- a/include/libipset/args.h
+++ b/include/libipset/args.h
@@ -44,6 +44,7 @@ enum ipset_keywords {
 	IPSET_ARG_FORCEADD,			/* forceadd */
 	IPSET_ARG_MARKMASK,			/* markmask */
 	IPSET_ARG_NOMATCH,			/* nomatch */
+	IPSET_ARG_IFACE_WILDCARD,		/* interface wildcard match */
 	/* Extensions */
 	IPSET_ARG_TIMEOUT,			/* timeout */
 	IPSET_ARG_COUNTERS,			/* counters */
diff --git a/include/libipset/data.h b/include/libipset/data.h
index 9749847..851773a 100644
--- a/include/libipset/data.h
+++ b/include/libipset/data.h
@@ -66,6 +66,7 @@ enum ipset_opt {
 	IPSET_OPT_SKBMARK,
 	IPSET_OPT_SKBPRIO,
 	IPSET_OPT_SKBQUEUE,
+	IPSET_OPT_IFACE_WILDCARD,
 	/* Internal options */
 	IPSET_OPT_FLAGS = 48,	/* IPSET_FLAG_EXIST| */
 	IPSET_OPT_CADT_FLAGS,	/* IPSET_FLAG_BEFORE| */
@@ -128,7 +129,8 @@ enum ipset_opt {
 	| IPSET_FLAG(IPSET_OPT_ADT_COMMENT)\
 	| IPSET_FLAG(IPSET_OPT_SKBMARK)	\
 	| IPSET_FLAG(IPSET_OPT_SKBPRIO)	\
-	| IPSET_FLAG(IPSET_OPT_SKBQUEUE))
+	| IPSET_FLAG(IPSET_OPT_SKBQUEUE) \
+	| IPSET_FLAG(IPSET_OPT_IFACE_WILDCARD))
 
 struct ipset_data;
 
diff --git a/include/libipset/linux_ip_set.h b/include/libipset/linux_ip_set.h
index 3cd151f..d2337f9 100644
--- a/include/libipset/linux_ip_set.h
+++ b/include/libipset/linux_ip_set.h
@@ -204,6 +204,8 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_WITH_FORCEADD = (1 << IPSET_FLAG_BIT_WITH_FORCEADD),
 	IPSET_FLAG_BIT_WITH_SKBINFO = 6,
 	IPSET_FLAG_WITH_SKBINFO = (1 << IPSET_FLAG_BIT_WITH_SKBINFO),
+	IPSET_FLAG_BIT_IFACE_WILDCARD = 7,
+	IPSET_FLAG_IFACE_WILDCARD = (1 << IPSET_FLAG_BIT_IFACE_WILDCARD),
 	IPSET_FLAG_CADT_MAX	= 15,
 };
 
diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
index a89c596..d8ab718 100644
--- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -204,6 +204,8 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_WITH_FORCEADD = (1 << IPSET_FLAG_BIT_WITH_FORCEADD),
 	IPSET_FLAG_BIT_WITH_SKBINFO = 6,
 	IPSET_FLAG_WITH_SKBINFO = (1 << IPSET_FLAG_BIT_WITH_SKBINFO),
+	IPSET_FLAG_BIT_IFACE_WILDCARD = 7,
+	IPSET_FLAG_IFACE_WILDCARD = (1 << IPSET_FLAG_BIT_IFACE_WILDCARD),
 	IPSET_FLAG_CADT_MAX	= 15,
 };
 
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
index 4916acc..2e6eeb7 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -29,7 +29,8 @@
 /*				3    Counters support added */
 /*				4    Comments support added */
 /*				5    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	6 /* skbinfo support added */
+/*				6    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	7 /* interface wildcard support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -61,6 +62,7 @@ struct hash_netiface4_elem {
 	u8 cidr;
 	u8 nomatch;
 	u8 elem;
+	u8 wildcard;
 	char iface[IFNAMSIZ];
 };
 
@@ -75,7 +77,9 @@ hash_netiface4_data_equal(const struct hash_netiface4_elem *ip1,
 	       ip1->cidr == ip2->cidr &&
 	       (++*multi) &&
 	       ip1->physdev == ip2->physdev &&
-	       strcmp(ip1->iface, ip2->iface) == 0;
+	       (ip1->wildcard ?
+		strncmp(ip1->iface, ip2->iface, strlen(ip1->iface)) == 0 :
+		strcmp(ip1->iface, ip2->iface) == 0);
 }
 
 static inline int
@@ -107,7 +111,8 @@ static bool
 hash_netiface4_data_list(struct sk_buff *skb,
 			 const struct hash_netiface4_elem *data)
 {
-	u32 flags = data->physdev ? IPSET_FLAG_PHYSDEV : 0;
+	u32 flags = (data->physdev ? IPSET_FLAG_PHYSDEV : 0) |
+		    (data->wildcard ? IPSET_FLAG_IFACE_WILDCARD : 0);
 
 	if (data->nomatch)
 		flags |= IPSET_FLAG_NOMATCH;
@@ -233,6 +238,8 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 			e.physdev = 1;
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
+		if (cadt_flags & IPSET_FLAG_IFACE_WILDCARD)
+			e.wildcard = 1;
 	}
 	if (adt == IPSET_TEST || !tb[IPSET_ATTR_IP_TO]) {
 		e.ip = htonl(ip & ip_set_hostmask(e.cidr));
@@ -284,6 +291,7 @@ struct hash_netiface6_elem {
 	u8 cidr;
 	u8 nomatch;
 	u8 elem;
+	u8 wildcard;
 	char iface[IFNAMSIZ];
 };
 
@@ -298,7 +306,9 @@ hash_netiface6_data_equal(const struct hash_netiface6_elem *ip1,
 	       ip1->cidr == ip2->cidr &&
 	       (++*multi) &&
 	       ip1->physdev == ip2->physdev &&
-	       strcmp(ip1->iface, ip2->iface) == 0;
+	       (ip1->wildcard ?
+		strncmp(ip1->iface, ip2->iface, strlen(ip1->iface)) == 0 :
+		strcmp(ip1->iface, ip2->iface) == 0);
 }
 
 static inline int
@@ -330,7 +340,8 @@ static bool
 hash_netiface6_data_list(struct sk_buff *skb,
 			 const struct hash_netiface6_elem *data)
 {
-	u32 flags = data->physdev ? IPSET_FLAG_PHYSDEV : 0;
+	u32 flags = (data->physdev ? IPSET_FLAG_PHYSDEV : 0) |
+		    (data->wildcard ? IPSET_FLAG_IFACE_WILDCARD : 0);
 
 	if (data->nomatch)
 		flags |= IPSET_FLAG_NOMATCH;
@@ -444,6 +455,8 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 			e.physdev = 1;
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |= (IPSET_FLAG_NOMATCH << 16);
+		if (cadt_flags & IPSET_FLAG_IFACE_WILDCARD)
+			e.wildcard = 1;
 	}
 
 	ret = adtfn(set, &e, &ext, &ext, flags);
diff --git a/lib/args.c b/lib/args.c
index 204c544..c25bb80 100644
--- a/lib/args.c
+++ b/lib/args.c
@@ -195,6 +195,14 @@ static const struct ipset_arg ipset_args[] = {
 		.print = ipset_print_flag,
 		.help = "[nomatch]",
 	},
+	[IPSET_ARG_IFACE_WILDCARD] = {
+		.name = { "wildcard", NULL },
+		.has_arg = IPSET_NO_ARG,
+		.opt = IPSET_OPT_IFACE_WILDCARD,
+		.parse = ipset_parse_flag,
+		.print = ipset_print_flag,
+		.help = "[wildcard]",
+	},
 	/* Extensions */
 	[IPSET_ARG_TIMEOUT] = {
 		.name = { "timeout", NULL },
diff --git a/lib/data.c b/lib/data.c
index 47c9ddb..f28d1d3 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -410,6 +410,9 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 	case IPSET_OPT_NOMATCH:
 		cadt_flag_type_attr(data, opt, IPSET_FLAG_NOMATCH);
 		break;
+	case IPSET_OPT_IFACE_WILDCARD:
+		cadt_flag_type_attr(data, opt, IPSET_FLAG_IFACE_WILDCARD);
+		break;
 	case IPSET_OPT_FLAGS:
 		data->flags = *(const uint32_t *)value;
 		break;
@@ -433,6 +436,9 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 		if (data->cadt_flags & IPSET_FLAG_WITH_SKBINFO)
 			ipset_data_flags_set(data,
 					     IPSET_FLAG(IPSET_OPT_SKBINFO));
+		if (data->cadt_flags & IPSET_FLAG_IFACE_WILDCARD)
+			ipset_data_flags_set(data,
+					     IPSET_FLAG(IPSET_OPT_IFACE_WILDCARD));
 		break;
 	default:
 		return -1;
@@ -564,6 +570,7 @@ ipset_data_get(const struct ipset_data *data, enum ipset_opt opt)
 	case IPSET_OPT_CREATE_COMMENT:
 	case IPSET_OPT_FORCEADD:
 	case IPSET_OPT_SKBINFO:
+	case IPSET_OPT_IFACE_WILDCARD:
 		return &data->cadt_flags;
 	default:
 		return NULL;
@@ -630,6 +637,7 @@ ipset_data_sizeof(enum ipset_opt opt, uint8_t family)
 	case IPSET_OPT_NOMATCH:
 	case IPSET_OPT_COUNTERS:
 	case IPSET_OPT_FORCEADD:
+	case IPSET_OPT_IFACE_WILDCARD:
 		return sizeof(uint32_t);
 	case IPSET_OPT_ADT_COMMENT:
 		return IPSET_MAX_COMMENT_SIZE + 1;
diff --git a/lib/ipset_hash_netiface.c b/lib/ipset_hash_netiface.c
index a709816..6755782 100644
--- a/lib/ipset_hash_netiface.c
+++ b/lib/ipset_hash_netiface.c
@@ -619,6 +619,100 @@ static struct ipset_type ipset_hash_netiface6 = {
 		 "      Adding/deleting multiple elements with IPv4 is supported.",
 	.description = "skbinfo support",
 };
+/* interface wildcard support */
+static struct ipset_type ipset_hash_netiface7 = {
+	.name = "hash:net,iface",
+	.alias = { "netifacehash", NULL },
+	.revision = 7,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_iface,
+			.print = ipset_print_iface,
+			.opt = IPSET_OPT_IFACE
+		},
+	},
+	.cmd = {
+		[IPSET_CREATE] = {
+			.args = {
+				IPSET_ARG_FAMILY,
+				/* Aliases */
+				IPSET_ARG_INET,
+				IPSET_ARG_INET6,
+				IPSET_ARG_HASHSIZE,
+				IPSET_ARG_MAXELEM,
+				IPSET_ARG_TIMEOUT,
+				IPSET_ARG_COUNTERS,
+				IPSET_ARG_COMMENT,
+				IPSET_ARG_FORCEADD,
+				IPSET_ARG_SKBINFO,
+				IPSET_ARG_NONE,
+			},
+			.need = 0,
+			.full = 0,
+			.help = "",
+		},
+		[IPSET_ADD] = {
+			.args = {
+				IPSET_ARG_TIMEOUT,
+				IPSET_ARG_NOMATCH,
+				IPSET_ARG_IFACE_WILDCARD,
+				IPSET_ARG_PACKETS,
+				IPSET_ARG_BYTES,
+				IPSET_ARG_ADT_COMMENT,
+				IPSET_ARG_SKBMARK,
+				IPSET_ARG_SKBPRIO,
+				IPSET_ARG_SKBQUEUE,
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_IFACE),
+			.full = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_CIDR)
+				| IPSET_FLAG(IPSET_OPT_IP_TO)
+				| IPSET_FLAG(IPSET_OPT_IFACE)
+				| IPSET_FLAG(IPSET_OPT_PHYSDEV),
+			.help = "IP[/CIDR]|FROM-TO,[physdev:]IFACE",
+		},
+		[IPSET_DEL] = {
+			.args = {
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_IFACE),
+			.full = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_CIDR)
+				| IPSET_FLAG(IPSET_OPT_IP_TO)
+				| IPSET_FLAG(IPSET_OPT_IFACE)
+				| IPSET_FLAG(IPSET_OPT_PHYSDEV),
+			.help = "IP[/CIDR]|FROM-TO,[physdev:]IFACE",
+		},
+		[IPSET_TEST] = {
+			.args = {
+				IPSET_ARG_NOMATCH,
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_IFACE),
+			.full = IPSET_FLAG(IPSET_OPT_IP)
+				| IPSET_FLAG(IPSET_OPT_CIDR)
+				| IPSET_FLAG(IPSET_OPT_IFACE)
+				| IPSET_FLAG(IPSET_OPT_PHYSDEV),
+			.help = "IP[/CIDR],[physdev:]IFACE",
+		},
+	},
+	.usage = "where depending on the INET family\n"
+		 "      IP is a valid IPv4 or IPv6 address (or hostname),\n"
+		 "      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+		 "      Adding/deleting multiple elements with IPv4 is supported.",
+	.description = "skbinfo and wildcard support",
+};
 
 void _init(void);
 void _init(void)
@@ -630,4 +724,5 @@ void _init(void)
 	ipset_type_add(&ipset_hash_netiface4);
 	ipset_type_add(&ipset_hash_netiface5);
 	ipset_type_add(&ipset_hash_netiface6);
+	ipset_type_add(&ipset_hash_netiface7);
 }
diff --git a/src/ipset.8 b/src/ipset.8
index 9c12889..f1a1368 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -385,6 +385,12 @@ succeed and evict a random entry from the set.
 .IP
 ipset create foo hash:ip forceadd
 .PP
+.SS wildcard
+This flag is valid when adding elements to a \fBhash:net,iface\fR set. If the
+flag is set, then prefix matching is used when comparing with this element. For
+example, an element containing the interface name "eth" will match any name with
+that prefix.
+.PP
 .SH "SET TYPES"
 .SS bitmap:ip
 The \fBbitmap:ip\fR set type uses a memory range to store either IPv4 host
@@ -957,7 +963,7 @@ address and interface name pairs.
 .PP
 \fIADD\-ENTRY\fR := \fInetaddr\fR,[\fBphysdev\fR:]\fIiface\fR
 .PP
-\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ]  [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ] [ \fBskbmark\fR \fIvalue\fR ] [ \fBskbprio\fR \fIvalue\fR ] [ \fBskbqueue\fR \fIvalue\fR ]
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ]  [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ] [ \fBskbmark\fR \fIvalue\fR ] [ \fBskbprio\fR \fIvalue\fR ] [ \fBskbqueue\fR \fIvalue\fR ] [ \fBwildcard\fR ]
 .PP
 \fIDEL\-ENTRY\fR := \fInetaddr\fR,[\fBphysdev\fR:]\fIiface\fR
 .PP
-- 
2.20.1

