From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/11] libipset: remove redundant indirection via union name
Date: Sun, 19 Dec 2010 06:18:10 +0100
Message-ID: <1292735894-17534-9-git-send-email-jengelh@medozas.de>
References: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42675 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab0LSFSY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 00:18:24 -0500
In-Reply-To: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There are no uses of C99 static initializers, so let's make the union
anonymous and reduce accessor lengths.
---
 lib/data.c |   82 ++++++++++++++++++++++++++++++------------------------------
 1 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/lib/data.c b/lib/data.c
index 6bc423b..2719b84 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -72,7 +72,7 @@ struct ipset_data {
 			char name[IPSET_MAXNAMELEN];
 			char nameref[IPSET_MAXNAMELEN];
 		} adt;
-	} u;
+	};
 };
 
 static void
@@ -233,71 +233,71 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 		break;
 	/* Create-specific options */
 	case IPSET_OPT_GC:
-		data->u.create.gc = *(const uint32_t *) value;
+		data->create.gc = *(const uint32_t *) value;
 		break;
 	case IPSET_OPT_HASHSIZE:
-		data->u.create.hashsize = *(const uint32_t *) value;
+		data->create.hashsize = *(const uint32_t *) value;
 		break;
 	case IPSET_OPT_MAXELEM:
-		data->u.create.maxelem = *(const uint32_t *) value;
+		data->create.maxelem = *(const uint32_t *) value;
 		break;
 	case IPSET_OPT_NETMASK:
-		data->u.create.netmask = *(const uint8_t *) value;
+		data->create.netmask = *(const uint8_t *) value;
 		break;
 	case IPSET_OPT_PROBES:
-		data->u.create.probes = *(const uint8_t *) value;
+		data->create.probes = *(const uint8_t *) value;
 		break;
 	case IPSET_OPT_RESIZE:
-		data->u.create.resize = *(const uint8_t *) value;
+		data->create.resize = *(const uint8_t *) value;
 		break;
 	case IPSET_OPT_SIZE:
-		data->u.create.size = *(const uint32_t *) value;
+		data->create.size = *(const uint32_t *) value;
 		break;
 	/* Create-specific options, filled out by the kernel */
 	case IPSET_OPT_ELEMENTS:
-		data->u.create.elements = *(const uint32_t *) value;
+		data->create.elements = *(const uint32_t *) value;
 		break;
 	case IPSET_OPT_REFERENCES:
-		data->u.create.references = *(const uint32_t *) value;
+		data->create.references = *(const uint32_t *) value;
 		break;
 	case IPSET_OPT_MEMSIZE:
-		data->u.create.memsize = *(const uint32_t *) value;
+		data->create.memsize = *(const uint32_t *) value;
 		break;
 	/* Create-specific options, type */
 	case IPSET_OPT_TYPENAME:
-		ipset_strlcpy(data->u.create.typename, value,
+		ipset_strlcpy(data->create.typename, value,
 			      IPSET_MAXNAMELEN);
 		break;
 	case IPSET_OPT_REVISION:
-		data->u.create.revision = *(const uint8_t *) value;
+		data->create.revision = *(const uint8_t *) value;
 		break;
 	case IPSET_OPT_REVISION_MIN:
-		data->u.create.revision_min = *(const uint8_t *) value;
+		data->create.revision_min = *(const uint8_t *) value;
 		break;
 	/* ADT-specific options */
 	case IPSET_OPT_ETHER:
-		memcpy(data->u.adt.ether, value, ETH_ALEN);
+		memcpy(data->adt.ether, value, ETH_ALEN);
 		break;
 	case IPSET_OPT_NAME:
-		ipset_strlcpy(data->u.adt.name, value, IPSET_MAXNAMELEN);
+		ipset_strlcpy(data->adt.name, value, IPSET_MAXNAMELEN);
 		break;
 	case IPSET_OPT_NAMEREF:
-		ipset_strlcpy(data->u.adt.nameref, value, IPSET_MAXNAMELEN);
+		ipset_strlcpy(data->adt.nameref, value, IPSET_MAXNAMELEN);
 		break;
 	case IPSET_OPT_IP2:
 		if (!(data->family == AF_INET || data->family == AF_INET6))
 			return -1;
-		copy_addr(data->family, &data->u.adt.ip2, value);
+		copy_addr(data->family, &data->adt.ip2, value);
 		break;
 	case IPSET_OPT_CIDR2:
-		data->u.adt.cidr2 = *(const uint8_t *) value;
+		data->adt.cidr2 = *(const uint8_t *) value;
 		break;
 	case IPSET_OPT_PROTO:
-		data->u.adt.proto = *(const uint8_t *) value;
+		data->adt.proto = *(const uint8_t *) value;
 		break;
 	/* Swap/rename */
 	case IPSET_OPT_SETNAME2:
-		ipset_strlcpy(data->u.setname2, value, IPSET_MAXNAMELEN);
+		ipset_strlcpy(data->setname2, value, IPSET_MAXNAMELEN);
 		break;
 	/* flags */
 	case IPSET_OPT_EXIST:
@@ -348,7 +348,7 @@ ipset_data_get(const struct ipset_data *data, enum ipset_opt opt)
 		if (ipset_data_test(data, IPSET_OPT_TYPE))
 			return data->type->name;
 		else if (ipset_data_test(data, IPSET_OPT_TYPENAME))
-			return data->u.create.typename;
+			return data->create.typename;
 		return NULL;
 	case IPSET_OPT_FAMILY:
 		return &data->family;
@@ -367,47 +367,47 @@ ipset_data_get(const struct ipset_data *data, enum ipset_opt opt)
 		return &data->timeout;
 	/* Create-specific options */
 	case IPSET_OPT_GC:
-		return &data->u.create.gc;
+		return &data->create.gc;
 	case IPSET_OPT_HASHSIZE:
-		return &data->u.create.hashsize;
+		return &data->create.hashsize;
 	case IPSET_OPT_MAXELEM:
-		return &data->u.create.maxelem;
+		return &data->create.maxelem;
 	case IPSET_OPT_NETMASK:
-		return &data->u.create.netmask;
+		return &data->create.netmask;
 	case IPSET_OPT_PROBES:
-		return &data->u.create.probes;
+		return &data->create.probes;
 	case IPSET_OPT_RESIZE:
-		return &data->u.create.resize;
+		return &data->create.resize;
 	case IPSET_OPT_SIZE:
-		return &data->u.create.size;
+		return &data->create.size;
 	/* Create-specific options, filled out by the kernel */
 	case IPSET_OPT_ELEMENTS:
-		return &data->u.create.elements;
+		return &data->create.elements;
 	case IPSET_OPT_REFERENCES:
-		return &data->u.create.references;
+		return &data->create.references;
 	case IPSET_OPT_MEMSIZE:
-		return &data->u.create.memsize;
+		return &data->create.memsize;
 	/* Create-specific options, TYPE */
 	case IPSET_OPT_REVISION:
-		return &data->u.create.revision;
+		return &data->create.revision;
 	case IPSET_OPT_REVISION_MIN:
-		return &data->u.create.revision_min;
+		return &data->create.revision_min;
 	/* ADT-specific options */
 	case IPSET_OPT_ETHER:
-		return data->u.adt.ether;
+		return data->adt.ether;
 	case IPSET_OPT_NAME:
-		return data->u.adt.name;
+		return data->adt.name;
 	case IPSET_OPT_NAMEREF:
-		return data->u.adt.nameref;
+		return data->adt.nameref;
 	case IPSET_OPT_IP2:
-		return &data->u.adt.ip2;
+		return &data->adt.ip2;
 	case IPSET_OPT_CIDR2:
-		return &data->u.adt.cidr2;
+		return &data->adt.cidr2;
 	case IPSET_OPT_PROTO:
-		return &data->u.adt.proto;
+		return &data->adt.proto;
 	/* Swap/rename */
 	case IPSET_OPT_SETNAME2:
-		return data->u.setname2;
+		return data->setname2;
 	/* flags */
 	case IPSET_OPT_FLAGS:
 	case IPSET_OPT_EXIST:
-- 
1.7.1

