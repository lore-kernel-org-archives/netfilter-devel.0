Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D404EC761A6
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Apr 2023 02:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbjDACbC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Mar 2023 22:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbjDACbB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Mar 2023 22:31:01 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D3BDBC6
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2023 19:31:01 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso27449573pjb.0
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2023 19:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680316260;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ljxRC8l1Ts0AchrC/O9Mqcf8QOja4nreH3VdPE+ia3o=;
        b=QCsi/pozo2IJ7UM1v1OV51LjzzHGlNukMyJJq9Y3VaB3sqF/Gn1fz0u8J2/CVAJXGE
         bNiMuVV4N8aET+DwOOAJSneVF7z8yQi3Wt2pa8EFhCXz81a99S4kNnapkmY06H8YwB8E
         Wsh7koAfO/WEF/GwFREZozjByJ15gg4fqs39I9VBL4HFQ7KMX6uSvvuRzNqHD+Wywk6q
         OrbvExejtlbVs+udcLVSbauCWOd6288YBPTgBb5oEynRsVEiK3Q7pGkEu4D3PSc8pz0p
         1j/uYJGO3J6qik5VwVTzrhaj3kDrCEd1PjNwmdrwIITh3G6n0m4klhiismHJl9vS+3IB
         OJmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680316260;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ljxRC8l1Ts0AchrC/O9Mqcf8QOja4nreH3VdPE+ia3o=;
        b=KLPAALAwJeyKqWgsfIHb88Y/D5pjHFp8BZf0oJ6Xx6Nx4MZ24GnlNufSxRpABB1at2
         8XrXxfJJWUmX+t5v3QkMx75dZ0+Xz/KZtoUPxlLpFn5bYejx5ib9If/YRUKGG/AfHN6j
         b2qdW1UQZ8iOSLY+2zVLZNptryaNodQiC52qQmlgQT3YmTWIgJDNtovX70EPYK5hZeuh
         wJY4yw1vWSWTmedLbpLwqI6K0L9DJJ5cewy0bJWo+SfSrh8uysaqhQ2ThPU6TMldJAm1
         sWr17wBecc7qz8AfvrPdqR2ols1WuFy761bLwftuUBdWVCS4WymTRE82zE7aTC2Ql0uN
         buLA==
X-Gm-Message-State: AAQBX9fCsp5iD01TJxnf9dbgjqhm8YShcEEOasutZOPlonIytE0OPqLU
        8kY4J4U9x1yD8mTK8zMV03BnZMqvs8LutL8FGsM=
X-Google-Smtp-Source: AKy350YzanvnjXESu27/7MPm6zgzBtF4TLP7Q18jO2DBALX3+N6ZTy4b7Vk5aT6bzt03Wj8kzfSMLA==
X-Received: by 2002:a17:902:e5cd:b0:1a1:a146:f6d7 with SMTP id u13-20020a170902e5cd00b001a1a146f6d7mr36416741plf.4.1680316260592;
        Fri, 31 Mar 2023 19:31:00 -0700 (PDT)
Received: from n157-068-149.byted.org ([240e:b1:e401:3::68])
        by smtp.gmail.com with ESMTPSA id u5-20020a656705000000b00502e6bfedc0sm2326644pgf.0.2023.03.31.19.30.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Mar 2023 19:31:00 -0700 (PDT)
From:   Fei Cheng <chenwei.0515@bytedance.com>
X-Google-Original-From: Fei Cheng <chenwei.0515@bytedance>
To:     willemdebruijn.kernel@gmail.com, dsahern@kernel.org,
        davem@davemloft.net, netfilter-devel@vger.kernel.org
Cc:     chenwei.0515@bytedance.com
Subject: [PATCH]     udp:nat:vxlan tx after nat should recsum if vxlan tx offload on
Date:   Sat,  1 Apr 2023 10:30:29 +0800
Message-Id: <20230401023029.967357-1-chenwei.0515@bytedance.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: "chenwei.0515" <chenwei.0515@bytedance.com>

    If vxlan-dev enable tx csum offload, there are two case of CHECKSUM_PARTIAL,
    but udp->check donot have the both meanings.

    1. vxlan-dev disable tx csum offload, udp->check is just pseudo hdr.
    2. vxlan-dev enable tx csum offload, udp->check is pseudo hdr and
       csum from outter l4 to innner l4.

    Unfortunately if there is a nat process after vxlan tx，udp_manip_pkt just use
    CSUM_PARTIAL to re csum PKT, which is just right on vxlan tx csum disable offload.

    This patch use skb->csum_local flag to identify two case, which will csum lco_csum if valid.

Signed-off-by: chenwei.0515 <chenwei.0515@bytedance.com>
---
 include/linux/skbuff.h       | 1 +
 net/ipv4/udp.c               | 1 +
 net/netfilter/nf_nat_proto.c | 9 +++++++++
 3 files changed, 11 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ff7ad331fb82..62996d8d0b4d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -990,6 +990,7 @@ struct sk_buff {
 	__u8			slow_gro:1;
 	__u8			csum_not_inet:1;
 	__u8			scm_io_uring:1;
+	__u8			csum_local:1;
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c605d171eb2d..86bad0bbb76e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -889,6 +889,7 @@ void udp_set_csum(bool nocheck, struct sk_buff *skb,
 		uh->check = udp_v4_check(len, saddr, daddr, lco_csum(skb));
 		if (uh->check == 0)
 			uh->check = CSUM_MANGLED_0;
+		skb->csum_local = 1;
 	} else {
 		skb->ip_summed = CHECKSUM_PARTIAL;
 		skb->csum_start = skb_transport_header(skb) - skb->head;
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 48cc60084d28..a0261fe2d932 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -25,6 +25,7 @@
 #include <net/ip6_route.h>
 #include <net/xfrm.h>
 #include <net/ipv6.h>
+#include <net/udp.h>
 
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack.h>
@@ -75,6 +76,14 @@ static bool udp_manip_pkt(struct sk_buff *skb,
 	hdr = (struct udphdr *)(skb->data + hdroff);
 	__udp_manip_pkt(skb, iphdroff, hdr, tuple, maniptype, !!hdr->check);
 
+	if (skb->csum_local) {
+		hdr->check = 0;
+		hdr->check = udp_v4_check(htons(hdr->len), tuple->src.u3.ip, tuple->dst.u3.ip,
+					  lco_csum(skb));
+		if (hdr->check == 0)
+			hdr->check = CSUM_MANGLED_0;
+	}
+
 	return true;
 }
 
-- 
2.11.0

