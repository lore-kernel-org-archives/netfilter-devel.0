From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 2/2] [NETFILTER]: xt_owner: allow matching UID/GID ranges
Date: Sun, 20 Jan 2008 13:19:03 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801201318500.14598@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801201318040.14598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49381 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYATMTE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 07:19:04 -0500
In-Reply-To: <Pine.LNX.4.64.0801201318040.14598@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 1ab123486c698860966193d254db54f8a4d428b4
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sun Jan 20 13:15:08 2008 +0100

    [NETFILTER]: xt_owner: allow matching UID/GID ranges
   =20
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

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
