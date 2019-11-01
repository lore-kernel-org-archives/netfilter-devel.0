Return-Path: <SRS0=Gx1r=YZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA633C47E49
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 16:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2FD8217D9
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 16:36:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="TFQGS7Xq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbfKAQgb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:36:31 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:58107 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728990AbfKAQgb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 12:36:31 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 3D78ECC0131;
        Fri,  1 Nov 2019 17:36:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1572626187; x=1574440588; bh=9hCGYBJsy9
        W8V3GgJO947ZTiD0ZxzWbd7Q1HoYEm24c=; b=TFQGS7XqQln1GuVPTptT+FXEZw
        iGFy6ZOzPqFeYyR/7YRS/HjuT9HmSvwadJu9U2XTEU8HGx1eW8PYi24Jusb86QPT
        ArYe62+C9bwcw4kV7F48LFhy1dA7/swp3a9/l3s265tQqwnXVM6j/7YCwpdM5D6J
        te6FFIC1VtOT9BEDY=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri,  1 Nov 2019 17:36:27 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 2AECFCC0126;
        Fri,  1 Nov 2019 17:36:27 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 1132720810; Fri,  1 Nov 2019 17:36:27 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/1] netfilter: ipset: Add wildcard support to net,iface
Date:   Fri,  1 Nov 2019 17:36:26 +0100
Message-Id: <20191101163626.10649-2-kadlec@blackhole.kfki.hu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101163626.10649-1-kadlec@blackhole.kfki.hu>
References: <20191101163626.10649-1-kadlec@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Kristian Evensen <kristian.evensen@gmail.com>

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
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/uapi/linux/netfilter/ipset/ip_set.h |  2 ++
 net/netfilter/ipset/ip_set_hash_netiface.c  | 23 ++++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/l=
inux/netfilter/ipset/ip_set.h
index eea166c52c36..11a72a938eb1 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -205,6 +205,8 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_WITH_FORCEADD =3D (1 << IPSET_FLAG_BIT_WITH_FORCEADD),
 	IPSET_FLAG_BIT_WITH_SKBINFO =3D 6,
 	IPSET_FLAG_WITH_SKBINFO =3D (1 << IPSET_FLAG_BIT_WITH_SKBINFO),
+	IPSET_FLAG_BIT_IFACE_WILDCARD =3D 7,
+	IPSET_FLAG_IFACE_WILDCARD =3D (1 << IPSET_FLAG_BIT_IFACE_WILDCARD),
 	IPSET_FLAG_CADT_MAX	=3D 15,
 };
=20
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/i=
pset/ip_set_hash_netiface.c
index 1a04e0929738..be5e95a0d876 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -25,7 +25,8 @@
 /*				3    Counters support added */
 /*				4    Comments support added */
 /*				5    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	6 /* skbinfo support added */
+/*				6    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	7 /* interface wildcard support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -57,6 +58,7 @@ struct hash_netiface4_elem {
 	u8 cidr;
 	u8 nomatch;
 	u8 elem;
+	u8 wildcard;
 	char iface[IFNAMSIZ];
 };
=20
@@ -71,7 +73,9 @@ hash_netiface4_data_equal(const struct hash_netiface4_e=
lem *ip1,
 	       ip1->cidr =3D=3D ip2->cidr &&
 	       (++*multi) &&
 	       ip1->physdev =3D=3D ip2->physdev &&
-	       strcmp(ip1->iface, ip2->iface) =3D=3D 0;
+	       (ip1->wildcard ?
+		strncmp(ip1->iface, ip2->iface, strlen(ip1->iface)) =3D=3D 0 :
+		strcmp(ip1->iface, ip2->iface) =3D=3D 0);
 }
=20
 static int
@@ -103,7 +107,8 @@ static bool
 hash_netiface4_data_list(struct sk_buff *skb,
 			 const struct hash_netiface4_elem *data)
 {
-	u32 flags =3D data->physdev ? IPSET_FLAG_PHYSDEV : 0;
+	u32 flags =3D (data->physdev ? IPSET_FLAG_PHYSDEV : 0) |
+		    (data->wildcard ? IPSET_FLAG_IFACE_WILDCARD : 0);
=20
 	if (data->nomatch)
 		flags |=3D IPSET_FLAG_NOMATCH;
@@ -229,6 +234,8 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr=
 *tb[],
 			e.physdev =3D 1;
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |=3D (IPSET_FLAG_NOMATCH << 16);
+		if (cadt_flags & IPSET_FLAG_IFACE_WILDCARD)
+			e.wildcard =3D 1;
 	}
 	if (adt =3D=3D IPSET_TEST || !tb[IPSET_ATTR_IP_TO]) {
 		e.ip =3D htonl(ip & ip_set_hostmask(e.cidr));
@@ -280,6 +287,7 @@ struct hash_netiface6_elem {
 	u8 cidr;
 	u8 nomatch;
 	u8 elem;
+	u8 wildcard;
 	char iface[IFNAMSIZ];
 };
=20
@@ -294,7 +302,9 @@ hash_netiface6_data_equal(const struct hash_netiface6=
_elem *ip1,
 	       ip1->cidr =3D=3D ip2->cidr &&
 	       (++*multi) &&
 	       ip1->physdev =3D=3D ip2->physdev &&
-	       strcmp(ip1->iface, ip2->iface) =3D=3D 0;
+	       (ip1->wildcard ?
+		strncmp(ip1->iface, ip2->iface, strlen(ip1->iface)) =3D=3D 0 :
+		strcmp(ip1->iface, ip2->iface) =3D=3D 0);
 }
=20
 static int
@@ -326,7 +336,8 @@ static bool
 hash_netiface6_data_list(struct sk_buff *skb,
 			 const struct hash_netiface6_elem *data)
 {
-	u32 flags =3D data->physdev ? IPSET_FLAG_PHYSDEV : 0;
+	u32 flags =3D (data->physdev ? IPSET_FLAG_PHYSDEV : 0) |
+		    (data->wildcard ? IPSET_FLAG_IFACE_WILDCARD : 0);
=20
 	if (data->nomatch)
 		flags |=3D IPSET_FLAG_NOMATCH;
@@ -440,6 +451,8 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr=
 *tb[],
 			e.physdev =3D 1;
 		if (cadt_flags & IPSET_FLAG_NOMATCH)
 			flags |=3D (IPSET_FLAG_NOMATCH << 16);
+		if (cadt_flags & IPSET_FLAG_IFACE_WILDCARD)
+			e.wildcard =3D 1;
 	}
=20
 	ret =3D adtfn(set, &e, &ext, &ext, flags);
--=20
2.20.1

