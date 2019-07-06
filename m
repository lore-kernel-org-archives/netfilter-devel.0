Return-Path: <SRS0=/Ma8=VD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD76C0650E
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jul 2019 22:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABFCE20838
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jul 2019 22:28:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cK7GXLop"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfGFW2o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Jul 2019 18:28:44 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40988 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbfGFW2o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jul 2019 18:28:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so13212188wrm.8
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Jul 2019 15:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=basp1FeaqXoN6zDMaS9+fSyDA4/C8rnqkCqbdsbuxj4=;
        b=cK7GXLopGhv/BSg8aBDt0PmY8oivp6OtGd4zsm3hX27ta4X3o+xAnu1z45EFa1fv3L
         meUxPRSo74MTs2J7XX3ps5L95cB/8UocyEkyiAKmFplc5d/diOOGYCIVxpSPtx9SaBFn
         wxIsMhgoWjYz6M7GRJ7rV6txD7hR1P2YICVUdSp99TVzZP3z/zW/oswH6gwaepdFNYVc
         DJVU6FW5ISNT5GFGC7f7omSkbo9oK8TWJmf0zGl1ekgjja2V/wyq+sqsfw+DZxierCtK
         It4udgFDSx/ofd2MbEAVh3nKlhg9Dx9s6HzVkQZAnyrNP9iHEncEk6dCHTNayQeX6jMf
         HjJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=basp1FeaqXoN6zDMaS9+fSyDA4/C8rnqkCqbdsbuxj4=;
        b=ZGUHPK3mjWY68jz86KcQ+UwpPad/781bJuRhciTkfQxowW5RNuMubU+J84hCYozic9
         iKLb2PBMlRKADcy/1CdE5mycP63hhI6vnAB5A8OBaxSDQxm5JgvwJfSm7/0gF+Q6HI1b
         NWscX5b557vs7pVOjxQ12hC+cS7PKp+uitASl8V4MqcHPAqoajvmgA8gwLiNooqAtgEh
         yjuh0UXQH0ageD5uH0KYMOK8EDWoHbLjReue2/x4JMKMgHrkD7x+Jbjeks3ZjCe/sSc3
         fjvqYno28QUEuXL3Xhu/rH+KX1jBt7bkuUTFlr0DLuZC6SJeoALB5t1+5t99jrinavM5
         mL0w==
X-Gm-Message-State: APjAAAUej1iIgMnL8Kegvt0TiHSshb4UMZQQ1AFbgT3uuiwkmQsteVGW
        6Yn5qaH31NI1JfHfYvhD2qc=
X-Google-Smtp-Source: APXvYqwIfLM+2y/dAFMIeDmLkkGqlTgi0eVmzvqFwFh6HbQ+ZRbbI+TThsRX4gYl0zublCRPym2waQ==
X-Received: by 2002:adf:f104:: with SMTP id r4mr5904694wro.140.1562452121221;
        Sat, 06 Jul 2019 15:28:41 -0700 (PDT)
Received: from jong.localdomain ([141.226.217.127])
        by smtp.gmail.com with ESMTPSA id g25sm8704076wmk.39.2019.07.06.15.28.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 06 Jul 2019 15:28:40 -0700 (PDT)
From:   Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
Subject: [PATCH] netfilter: Update obsolete comments referring to ip_conntrack
Date:   Sun,  7 Jul 2019 01:28:24 +0300
Message-Id: <20190706222824.29550-1-yon.goldschmidt@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190705085156.GA14117@jong.localdomain>
References: <20190705085156.GA14117@jong.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
- * 			      conntrack/NAT module.
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
 
-	/* ip_conntrack_icmp guarantees us that we only have ICMP_ECHO,
-	 * TIMESTAMP, INFO_REQUEST or ADDRESS type icmp packets from here
+	/* nf_conntrack_proto_icmp guarantees us that we only have ICMP_ECHO,
+	 * TIMESTAMP, INFO_REQUEST or ICMP_ADDRESS type icmp packets from here
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
- * 			      	     conntrack/NAT module.
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
 
-	/* See ip_conntrack_proto_tcp.c */
+	/* See nf_conntrack_proto_tcp.c */
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
-- 
2.21.0

