From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 23/69]: xt_owner: allow matching UID/GID ranges
Date: Wed, 30 Jan 2008 21:17:30 +0100 (MET)
Message-ID: <20080130201727.29874.76735.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60701 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbYA3URb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:31 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_owner: allow matching UID/GID ranges

Add support for ranges to the new revision. This doesn't affect
compatibility since the new revision was not released yet.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
commit c1e9e8f11d30d54eb79e53ca02f0fd17a60407ef
tree 8ad98d01d79a033fd2014a2de8fbc03a00a4f2cd
parent 09a855c601cbbf240e7f127705dea74317658c45
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 29 Jan 2008 16:22:=
03 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:18 +=
0100

 include/linux/netfilter/xt_owner.h |    4 ++--
 net/netfilter/xt_owner.c           |   14 ++++++++------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/xt_owner.h b/include/linux/netfilt=
er/xt_owner.h
index eacd34e..c84e52c 100644
--- a/include/linux/netfilter/xt_owner.h
+++ b/include/linux/netfilter/xt_owner.h
@@ -8,8 +8,8 @@ enum {
 };
=20
 struct xt_owner_match_info {
-	u_int32_t uid;
-	u_int32_t gid;
+	u_int32_t uid_min, uid_max;
+	u_int32_t gid_min, gid_max;
 	u_int8_t match, invert;
 };
=20
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index d382f9c..9059c16 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -4,8 +4,8 @@
  *
  * (C) 2000 Marc Boucher <marc@mbsi.ca>
  *
- * Copyright =C2=A9 CC Computer Consultants GmbH, 2007
- * Contact: <jengelh@computergmbh.de>
+ * Copyright =C2=A9 CC Computer Consultants GmbH, 2007 - 2008
+ * <jengelh@computergmbh.de>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License version 2 as
@@ -102,13 +102,15 @@ owner_mt(const struct sk_buff *skb, const struct =
net_device *in,
 		       (XT_OWNER_UID | XT_OWNER_GID)) =3D=3D 0;
=20
 	if (info->match & XT_OWNER_UID)
-		if ((filp->f_uid !=3D info->uid) ^
-		    !!(info->invert & XT_OWNER_UID))
+		if ((filp->f_uid >=3D info->uid_min &&
+		    filp->f_uid <=3D info->uid_max) ^
+		    !(info->invert & XT_OWNER_UID))
 			return false;
=20
 	if (info->match & XT_OWNER_GID)
-		if ((filp->f_gid !=3D info->gid) ^
-		    !!(info->invert & XT_OWNER_GID))
+		if ((filp->f_gid >=3D info->gid_min &&
+		    filp->f_gid <=3D info->gid_max) ^
+		    !(info->invert & XT_OWNER_GID))
 			return false;
=20
 	return true;
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
