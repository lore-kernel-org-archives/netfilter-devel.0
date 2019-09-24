Return-Path: <SRS0=Dg9R=XT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A30C432C2
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 15:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95E4D214DA
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 15:03:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pOD5BrpX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388028AbfIXPDs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Sep 2019 11:03:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40628 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfIXPDs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Sep 2019 11:03:48 -0400
Received: by mail-wm1-f68.google.com with SMTP id b24so415003wmj.5
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2019 08:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KoiaBOBiskAhXxFRASgVM8zbijOp00MHNehGF+WnAss=;
        b=pOD5BrpX6dRi8LPwx4E/+zUrJnUzYrFufQ8+07LgNwijzZQsFNC/G72DyA8aBqG5i/
         jxUFORXUyM/NZAtCvxUR604snzjJAbYvvIL704Fn9wU8+QndWjtBvC/SKtngBI6hc8cn
         jgNV8lheU4yNDxSvzdIYerkeETu7t185a1cHxWrX9ilnKEFMeP3BW/oKfBSu7YcBqQs+
         v+++OgTdY6O8V1+AyEbUTQ/CFcN7YTUOn3Wh8Lb3vA900thdmqxEGmVRKlp5/sZKUrU3
         flnVm8LBkwSUfq0TqrpCeKsvtwI4YRYfgze7v/OYwtld3TJX4rG8yKwYbGLiCAzSmnCU
         xfRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KoiaBOBiskAhXxFRASgVM8zbijOp00MHNehGF+WnAss=;
        b=BLl1uRosQj/LqrihNQLhR2VL5GOhOHVDkoo8TZdRdJFi208A9SaCID+bs0c5+tGIzi
         7xsofBKYCqaobdxj+EILyCtvaTvxec4l8lTWDdtrp/np7lxqLFdhqaW40s2CFPLnHGke
         gS0/CBFDdaBIaMW57ms3nUM8s+qRHzBTWj9Z/CFeVgH3G1Yw/gB22Zh6oyOv2biEB5K8
         HObxsGuBfnLTeXy9s7jqt67aP7ldqaDKVjgqJBJA97wbhC7JTTaFS2nkCn7tXBuo97Ef
         X/BOmG3V61s4qR+gJhvi+jWIe4RfLA+LZ7cb+sa0MjWeka91el2adbFvcfI2qIt3iF8n
         akSQ==
X-Gm-Message-State: APjAAAUHB85n5lXIxK/sunUxzz8PEqgLvZmzsg9bjl9g4LGBRDc4ypfe
        eX5yRepi73Mys5zIzWZdV7xIF8J/
X-Google-Smtp-Source: APXvYqzHyAwWH9+VNAH4FZstIaqMawu06wNLO2R8XzIFA/DrDM51eAb++mSKBmGtkSosm8c0o0Hayw==
X-Received: by 2002:a1c:7c08:: with SMTP id x8mr542702wmc.140.1569337424513;
        Tue, 24 Sep 2019 08:03:44 -0700 (PDT)
Received: from kristrev-XPS-15-9570.lan ([193.213.155.210])
        by smtp.gmail.com with ESMTPSA id o188sm499495wma.14.2019.09.24.08.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 08:03:43 -0700 (PDT)
From:   Kristian Evensen <kristian.evensen@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Kristian Evensen <kristian.evensen@gmail.com>
Subject: [RFC] ipset: Add wildcard support to net,iface
Date:   Tue, 24 Sep 2019 17:03:42 +0200
Message-Id: <20190924150342.16536-1-kristian.evensen@gmail.com>
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

Wildcard matching is enabled by setting the
IPSET_FLAG_IFACE_WILDCARD-flag when adding an element.  When this flag
is set, only the initial part of the interface name of the set element
is used for comparison.

I am submitting this change as an RFC, as I am not sure if my approach
with using a flag (or wildcard matching at all) is OK. Please note that
this patch is against kernel 4.14, as that is what my current devices
are running. A final submission will be against net-next.

I will send my changes to the ipset-user space utility/library in a
follow-up email.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/uapi/linux/netfilter/ipset/ip_set.h |  2 ++
 net/netfilter/ipset/ip_set_hash_netiface.c  | 23 ++++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/linux/netfilter/ipset/ip_set.h
index 60236f694..71d6de524 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -201,6 +201,8 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_WITH_FORCEADD = (1 << IPSET_FLAG_BIT_WITH_FORCEADD),
 	IPSET_FLAG_BIT_WITH_SKBINFO = 6,
 	IPSET_FLAG_WITH_SKBINFO = (1 << IPSET_FLAG_BIT_WITH_SKBINFO),
+	IPSET_FLAG_BIT_IFACE_WILDCARD = 7,
+	IPSET_FLAG_IFACE_WILDCARD = (1 << IPSET_FLAG_BIT_IFACE_WILDCARD),
 	IPSET_FLAG_CADT_MAX	= 15,
 };
 
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index f5164c1ef..8ac0757c2 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -29,7 +29,8 @@
 /*				3    Counters support added */
 /*				4    Comments support added */
 /*				5    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	6 /* skbinfo support added */
+/*				6    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	7 /* interface wildcard support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
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
-- 
2.20.1

