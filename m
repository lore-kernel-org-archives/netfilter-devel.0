Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FF7C606CF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 22:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69E73216FD
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 22:57:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aY6RshOB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbfGHW5N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 18:57:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46198 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbfGHW5M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 18:57:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so14224727wru.13
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jul 2019 15:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NncLuP0X6miauwJTnwNC/Fn6BZdwDyBEJpx8rqY+tgQ=;
        b=aY6RshOB9zIN4KeDmGCZVJNAy+pXHju0xyf2IcEWsc88wbhSpbWOHeZhJJSftZtWn+
         pRZwF3FzZ/kBVipgp94VHdeaZFQHnIaQQyeM+Zuz+cfK+ZLO948xMdM6+7AIR4QmrCaA
         287vFoIa07be3JGatYgHiy/PA+pxTq3Tc5pjNIUJeNtQcCKUQclUfsGZbz31GiUjW/6I
         6le9lQ+J2H95RUhZHiN0R+kUt2E4vYn/cvzlb/VBsdiBfsc4K+GUht1sjFLsB5B28xSY
         8Q7rhXnmtHc+zGu7P4o0ZS6oxhLYZ7M1iZOzReVqDrGdoHxD7aCMPapLPj6h24vQFomH
         DKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NncLuP0X6miauwJTnwNC/Fn6BZdwDyBEJpx8rqY+tgQ=;
        b=UtNAy+gs0s3eQRpy3bc8boa0v9T4BtZZo2Rlj4cVZ2yLFNacJjhlzp7IpOh53Sd6cW
         XGcYiUUCrnZKRquYdYDJ5L8hk0OocGhTV/3eHJ9GKOLdZZjSU0ryqE8PxQTVcGe/i706
         QyrHta+DhEryM+g0THgYGrHRsRO4KTBtYZ+tpl93wxKr79eXna3Ivg98JKxnjCZEC3B7
         R2b6yQcZwsrXQoy5HfcshOjdFBr26/uSYapAbIZtnUMTy6FIKcdX9GcpVjaYikAiJ2Zc
         jcdVzsdCQJjl2pb0qwakSi1f55n6IeoJ5bQL5X7DAE/KB9QWuT3T36F73YfrzBqUtIMp
         vxaQ==
X-Gm-Message-State: APjAAAUwEEtpIMrZTeYc+jDEtZZAWLkWTbE+zR9C4zOgFqdZ3pDoH57p
        GTFJ0Q7sqSJfGcGWXI3eyHgEjFmO
X-Google-Smtp-Source: APXvYqwD157E8khxwFwspKo5MFu5+f0hdGv7sbCipP+byUrwzVh55a8oGDvKX6rh9z4VJplj5shSVg==
X-Received: by 2002:a5d:4087:: with SMTP id o7mr20813931wrp.277.1562626630283;
        Mon, 08 Jul 2019 15:57:10 -0700 (PDT)
Received: from jong.localdomain ([141.226.217.127])
        by smtp.gmail.com with ESMTPSA id r14sm782430wrx.57.2019.07.08.15.57.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 15:57:09 -0700 (PDT)
From:   Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
Subject: [PATCH v2] netfilter: Update obsolete comments referring to ip_conntrack
Date:   Tue,  9 Jul 2019 01:56:32 +0300
Message-Id: <20190708225632.12366-1-yon.goldschmidt@gmail.com>
X-Mailer: git-send-email 2.21.0
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
Interdiff:
  diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
  index 21025c2c605b..bd35daad5168 100644
  --- a/net/netfilter/Kconfig
  +++ b/net/netfilter/Kconfig
  @@ -223,8 +223,6 @@ config NF_CONNTRACK_FTP
   	  of Network Address Translation on them.
   
   	  This is FTP support on Layer 3 independent connection tracking.
  -	  Layer 3 independent connection tracking is experimental scheme
  -	  which generalize ip_conntrack to support other layer 3 protocols.
   
   	  To compile it as a module, choose M here.  If unsure, say N.
   
  @@ -338,7 +336,7 @@ config NF_CONNTRACK_SIP
   	help
   	  SIP is an application-layer control protocol that can establish,
   	  modify, and terminate multimedia sessions (conferences) such as
  -	  Internet telephony calls. With the ip_conntrack_sip and
  +	  Internet telephony calls. With the nf_conntrack_sip and
   	  the nf_nat_sip modules you can support the protocol on a connection
   	  tracking/NATing firewall.
   
  @@ -1302,7 +1300,7 @@ config NETFILTER_XT_MATCH_HELPER
   	depends on NETFILTER_ADVANCED
   	help
   	  Helper matching allows you to match packets in dynamic connections
  -	  tracked by a conntrack-helper, ie. ip_conntrack_ftp
  +	  tracked by a conntrack-helper, ie. nf_conntrack_ftp
   
   	  To compile it as a module, choose M here.  If unsure, say Y.
   

 include/linux/netfilter/nf_conntrack_h323_asn1.h | 3 +--
 net/ipv4/netfilter/ipt_CLUSTERIP.c               | 4 ++--
 net/netfilter/Kconfig                            | 6 ++----
 net/netfilter/nf_conntrack_core.c                | 4 +---
 net/netfilter/nf_conntrack_h323_asn1.c           | 5 ++---
 net/netfilter/nf_conntrack_proto_gre.c           | 2 --
 net/netfilter/nf_conntrack_proto_icmp.c          | 2 +-
 net/netfilter/nf_nat_core.c                      | 2 +-
 8 files changed, 10 insertions(+), 18 deletions(-)

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
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 21025c2c605b..bd35daad5168 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -223,8 +223,6 @@ config NF_CONNTRACK_FTP
 	  of Network Address Translation on them.
 
 	  This is FTP support on Layer 3 independent connection tracking.
-	  Layer 3 independent connection tracking is experimental scheme
-	  which generalize ip_conntrack to support other layer 3 protocols.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
@@ -338,7 +336,7 @@ config NF_CONNTRACK_SIP
 	help
 	  SIP is an application-layer control protocol that can establish,
 	  modify, and terminate multimedia sessions (conferences) such as
-	  Internet telephony calls. With the ip_conntrack_sip and
+	  Internet telephony calls. With the nf_conntrack_sip and
 	  the nf_nat_sip modules you can support the protocol on a connection
 	  tracking/NATing firewall.
 
@@ -1302,7 +1300,7 @@ config NETFILTER_XT_MATCH_HELPER
 	depends on NETFILTER_ADVANCED
 	help
 	  Helper matching allows you to match packets in dynamic connections
-	  tracked by a conntrack-helper, ie. ip_conntrack_ftp
+	  tracked by a conntrack-helper, ie. nf_conntrack_ftp
 
 	  To compile it as a module, choose M here.  If unsure, say Y.
 
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

