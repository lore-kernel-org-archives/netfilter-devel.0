Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE55C5B57D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02A77218BC
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GGKnDr0+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfGEIwD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 04:52:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50560 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfGEIwD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 04:52:03 -0400
Received: by mail-wm1-f65.google.com with SMTP id n9so8034648wmi.0
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2019 01:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=1cFAlOd8pXYJnLMKrXnO0PHVWH7++dVWADcyTF1CMws=;
        b=GGKnDr0+4UTIAtrVzJ/jHiqHs50VC9rHFSABqrqi4InVFxW674Huu4c6KmwTdvbeTe
         po3h4HUoWDaU6mCxRIct4Mu+HTSSAWCbNN5iDY9b10J6M32DWPZK27Nvt3oHdl+gkc1g
         HBBOi0/9QSopAAASSUuquyjyLuuCIpIXY0ytps+Sq336eTkHsiiJZQBDOyalcRiqhCex
         wUXGALTM4KPLRwFrr5CTR07LwNe+2uneh4BNpIANXpYOrWE3P49y3DUce3Hwd1pjpT/a
         odKL4fr2E9kC1rzuVWbV97bRadLGtIHKaJfcJZMH3v9LefoPO0SZB2oByw+4IfdhvH9A
         P3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=1cFAlOd8pXYJnLMKrXnO0PHVWH7++dVWADcyTF1CMws=;
        b=fg/7941tWjvSSNjh32vMHZBDJ0XB4JJLdrm5rBGJRs+2W79Rd17dsI494fcROadpFY
         kuUu3RNJVgjM0taVcjatLRW3mjoszbKcBvseGR9kzVrgaPa+aqMoUeZAoxzrpFkU0Kj4
         4w92ShvGw57Y3IaWEyNHnOhb4PUv/yMJVv5mB37tChdwXvsyrtTbGKbPuQPvT4lempsY
         dWofFJzNKRLdC9Z/PJi4PonFGl4PVh3ssIljE6xlr6NlsrLiEEZl9zLb9buXMWLgP2B4
         GjfJo3EMQtqepjdoFhx0KomVYK6QJsll9dcN3Upjyb+HC28rOncOKxJ1HH5yOreKKLKv
         2CpA==
X-Gm-Message-State: APjAAAXa4KdDtPD7NiEa7NRFObqHrMpwh07giEvzKetTkjWlUfnEBMTb
        wBIyKSPAzv/JUbAWu4eMTWt5rb6L
X-Google-Smtp-Source: APXvYqzQHH3qySGLhwV6/cvTht14qSKR3gklAtLxeSq3tCgKEq5EtTvnM4aS9XWL9303CxU6mpPtfQ==
X-Received: by 2002:a7b:c3d5:: with SMTP id t21mr2200537wmj.87.1562316720346;
        Fri, 05 Jul 2019 01:52:00 -0700 (PDT)
Received: from jong.localdomain ([141.226.217.127])
        by smtp.gmail.com with ESMTPSA id r4sm7989578wrv.34.2019.07.05.01.51.59
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 01:51:59 -0700 (PDT)
Date:   Fri, 5 Jul 2019 11:51:57 +0300
From:   Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: Update obsolete comments referring to ip_conntrack
Message-ID: <20190705085156.GA14117@jong.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.") the new
generic nf_conntrack was introduced, and it came to supersede the
old ip_conntrack.
This change updates (some) of the obsolete comments referring to old
file/function names of the ip_conntrack mechanism, as well as removes
a few self-referencing comments that we shouldn't maintain anymore.

I did not update any comments referring to historical actions (e.g,
comments like "this file was derived from ..." were left untouched,
even if the referenced file is no longer here).

Signed-off-by: Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
---
 include/linux/netfilter/nf_conntrack_h323_asn1.h | 3 +--
 net/ipv4/netfilter/ipt_CLUSTERIP.c               | 4 ++--
 net/netfilter/nf_conntrack_core.c                | 4 +---
 net/netfilter/nf_conntrack_h323_asn1.c           | 5 ++---
 net/netfilter/nf_conntrack_proto_gre.c           | 2 --
 net/netfilter/nf_conntrack_proto_icmp.c          | 2 +-
 net/netfilter/nf_nat_core.c                      | 2 +-
 7 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_h323_asn1.h b/include/linux/netfilter/nf_conntrack_h323_asn1.h
index 91d6275292a5..19df78341fb3 100644
--- a/include/linux/netfilter/nf_conntrack_h323_asn1.h
+++ b/include/linux/netfilter/nf_conntrack_h323_asn1.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /****************************************************************************
- * ip_conntrack_h323_asn1.h - BER and PER decoding library for H.323
- *                   conntrack/NAT module.
+ * BER and PER decoding library for H.323 conntrack/NAT module.
  *
  * Copyright (c) 2006 by Jing Min Zhao <zhaojingmin@users.sourceforge.net>
  *
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 4d6bf7ac0792..6bdb1ab8af61 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -416,8 +416,8 @@ clusterip_tg(struct sk_buff *skb, const struct xt_action_param *par)
         ctinfo == IP_CT_RELATED_REPLY))
        return XT_CONTINUE;
 
-   /* ip_conntrack_icmp guarantees us that we only have ICMP_ECHO,
-    * TIMESTAMP, INFO_REQUEST or ADDRESS type icmp packets from here
+   /* nf_conntrack_proto_icmp guarantees us that we only have ICMP_ECHO,
+    * TIMESTAMP, INFO_REQUEST or ICMP_ADDRESS type icmp packets from here
     * on, which all have an ID field [relevant for hashing]. */
 
    hash = clusterip_hashfn(skb, cipinfo->config);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f4f9b8344a32..74a61127edf0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1816,9 +1816,7 @@ EXPORT_SYMBOL_GPL(nf_ct_kill_acct);
 #include <linux/netfilter/nfnetlink_conntrack.h>
 #include <linux/mutex.h>
 
-/* Generic function for tcp/udp/sctp/dccp and alike. This needs to be
- * in ip_conntrack_core, since we don't want the protocols to autoload
- * or depend on ctnetlink */
+/* Generic function for tcp/udp/sctp/dccp and alike. */
 int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
                   const struct nf_conntrack_tuple *tuple)
 {
diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 8f6ba8162f0b..573cb4481481 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -1,11 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * ip_conntrack_helper_h323_asn1.c - BER and PER decoding library for H.323
- *                          conntrack/NAT module.
+ * BER and PER decoding library for H.323 conntrack/NAT module.
  *
  * Copyright (c) 2006 by Jing Min Zhao <zhaojingmin@users.sourceforge.net>
  *
- * See ip_conntrack_helper_h323_asn1.h for details.
+ * See nf_conntrack_helper_h323_asn1.h for details.
  */
 
 #ifdef __KERNEL__
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index c2eb365f1723..5b05487a60d2 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * ip_conntrack_proto_gre.c - Version 3.0
- *
  * Connection tracking protocol helper module for GRE.
  *
  * GRE is a generic encapsulation protocol, which is generally not very
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index a824367ed518..5f37aff3b2a9 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -215,7 +215,7 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
        return -NF_ACCEPT;
    }
 
-   /* See ip_conntrack_proto_tcp.c */
+   /* See nf_conntrack_proto_tcp.c */
    if (state->net->ct.sysctl_checksum &&
        state->hook == NF_INET_PRE_ROUTING &&
        nf_ip_checksum(skb, state->hook, dataoff, 0)) {
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 9ab410455992..3f6023ed4966 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -519,7 +519,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
  * and NF_INET_LOCAL_OUT, we change the destination to map into the
  * range. It might not be possible to get a unique tuple, but we try.
  * At worst (or if we race), we will end up with a final duplicate in
- * __ip_conntrack_confirm and drop the packet. */
+ * __nf_conntrack_confirm and drop the packet. */
 static void
 get_unique_tuple(struct nf_conntrack_tuple *tuple,
         const struct nf_conntrack_tuple *orig_tuple,
