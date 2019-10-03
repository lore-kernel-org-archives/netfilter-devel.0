Return-Path: <SRS0=hHnn=X4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D5DC10F14
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 20:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4925C20862
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 20:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="He4q4BaV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732804AbfJCU33 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 16:29:29 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40652 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfJCU33 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 16:29:29 -0400
Received: by mail-ed1-f66.google.com with SMTP id v38so3826403edm.7;
        Thu, 03 Oct 2019 13:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=u7ZYonuNP9SAqKQUA4lb0Fri1p8aW+ORUTZ38/PqnQA=;
        b=He4q4BaVzz3ysrDjqZmQhSBfWZlpceOetRwr/NpYef80KX0Qruy9e8fdi4wXzf2kDX
         R3WhG4toYhzzvFCma3V937xC5vMzpVdN/q9rWM5LSF8OUwWWGdtvd/lEOpxqdpG+TEFg
         PbXOUYo6dA4m1VKnSNbnu/2uWRffLzPSn3PN8qbyybBiGga65wjPuIYtf/oj2a5z1+MV
         8E7k8owGm3tUFkiqTrKkwNolcmIgl5RT951yANA7krwczT45eYgfDr3TtXvApssqvKME
         uRN+KgaPIcGdw0qyCqjRAMUUSpCmZ80s2r3VewekJS8DkLNSR6/LpiJ5DKUiunF4lcCW
         jl9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=u7ZYonuNP9SAqKQUA4lb0Fri1p8aW+ORUTZ38/PqnQA=;
        b=O+IiJjWBrOLH/buOKnqJsR0EieTD69o68pwY9+g0GkiGqVEHXPw3eJ2fyXzTrVunJA
         94hmGGK7YrU9unLUrnmV6EJkRueKldhYtu4yigC079w27tFnK6+ELmDzxd651j2LnEPt
         PRNmx1lifGBU04xNETg9ZK4nYimKmYFijg8VQuNaQR7XMhJOwJ6g6/iy63bCDAN15tSz
         7EaCjNMxNrMe7GS/Fm4Zq2b6qtPkzK4v9f5G0v9FdWvEtrNxL06Zb0DPB/fPyDmK0Uh3
         5/eJZG/uaEtDSZsBDPJULGi5GC6jyiOPUImVysJYBbI6izv3UyLMzSb202xf9TSZVK8b
         3+XA==
X-Gm-Message-State: APjAAAW/w3aTlWuxwTn1LFig6+fViJHsbLsvUh9KS3X+J+nP/9by/xgF
        4GmVj/mcsMvkWV+0fMyNJQ==
X-Google-Smtp-Source: APXvYqxm4qn6mXmhwnprpw33vR7yG2Zefk8mywl9KAbSBAJFJ6LB7yDYFggcdc6aA1kL894UxSoqRA==
X-Received: by 2002:a17:907:20a2:: with SMTP id pw2mr9203607ejb.163.1570134566810;
        Thu, 03 Oct 2019 13:29:26 -0700 (PDT)
Received: from avx2 ([46.53.250.203])
        by smtp.gmail.com with ESMTPSA id c26sm664660edb.2.2019.10.03.13.29.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 13:29:26 -0700 (PDT)
Date:   Thu, 3 Oct 2019 23:29:24 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, netdev@vger.kernel.org, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org
Subject: [PATCH net-next] net, uapi: fix -Wpointer-arith warnings
Message-ID: <20191003202924.GA21016@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add casts to fix these warnings:

./usr/include/linux/netfilter_arp/arp_tables.h:200:19: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]
./usr/include/linux/netfilter_bridge/ebtables.h:197:19: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]
./usr/include/linux/netfilter_ipv4/ip_tables.h:223:19: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]
./usr/include/linux/netfilter_ipv6/ip6_tables.h:263:19: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]
./usr/include/linux/tipc_config.h:310:28: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]
./usr/include/linux/tipc_config.h:410:24: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]
./usr/include/linux/virtio_ring.h:170:16: error: pointer of type 'void *' used in arithmetic [-Werror=pointer-arith]

Those are theoretical probably but kernel doesn't control compiler flags
in userspace.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/uapi/linux/netfilter_arp/arp_tables.h  |    2 +-
 include/uapi/linux/netfilter_bridge/ebtables.h |    2 +-
 include/uapi/linux/netfilter_ipv4/ip_tables.h  |    2 +-
 include/uapi/linux/netfilter_ipv6/ip6_tables.h |    2 +-
 include/uapi/linux/tipc_config.h               |    4 ++--
 include/uapi/linux/virtio_ring.h               |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/uapi/linux/netfilter_arp/arp_tables.h
+++ b/include/uapi/linux/netfilter_arp/arp_tables.h
@@ -199,7 +199,7 @@ struct arpt_get_entries {
 /* Helper functions */
 static __inline__ struct xt_entry_target *arpt_get_target(struct arpt_entry *e)
 {
-	return (void *)e + e->target_offset;
+	return (struct xt_entry_target *)((char *)e + e->target_offset);
 }
 
 /*
--- a/include/uapi/linux/netfilter_bridge/ebtables.h
+++ b/include/uapi/linux/netfilter_bridge/ebtables.h
@@ -194,7 +194,7 @@ struct ebt_entry {
 static __inline__ struct ebt_entry_target *
 ebt_get_target(struct ebt_entry *e)
 {
-	return (void *)e + e->target_offset;
+	return (struct ebt_entry_target *)((char *)e + e->target_offset);
 }
 
 /* {g,s}etsockopt numbers */
--- a/include/uapi/linux/netfilter_ipv4/ip_tables.h
+++ b/include/uapi/linux/netfilter_ipv4/ip_tables.h
@@ -222,7 +222,7 @@ struct ipt_get_entries {
 static __inline__ struct xt_entry_target *
 ipt_get_target(struct ipt_entry *e)
 {
-	return (void *)e + e->target_offset;
+	return (struct xt_entry_target *)((char *)e + e->target_offset);
 }
 
 /*
--- a/include/uapi/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6_tables.h
@@ -262,7 +262,7 @@ struct ip6t_get_entries {
 static __inline__ struct xt_entry_target *
 ip6t_get_target(struct ip6t_entry *e)
 {
-	return (void *)e + e->target_offset;
+	return (struct xt_entry_target *)((char *)e + e->target_offset);
 }
 
 /*
--- a/include/uapi/linux/tipc_config.h
+++ b/include/uapi/linux/tipc_config.h
@@ -309,7 +309,7 @@ static inline int TLV_SET(void *tlv, __u16 type, void *data, __u16 len)
 	tlv_ptr->tlv_len  = htons(tlv_len);
 	if (len && data) {
 		memcpy(TLV_DATA(tlv_ptr), data, len);
-		memset(TLV_DATA(tlv_ptr) + len, 0, TLV_SPACE(len) - tlv_len);
+		memset((char *)TLV_DATA(tlv_ptr) + len, 0, TLV_SPACE(len) - tlv_len);
 	}
 	return TLV_SPACE(len);
 }
@@ -409,7 +409,7 @@ static inline int TCM_SET(void *msg, __u16 cmd, __u16 flags,
 	tcm_hdr->tcm_flags = htons(flags);
 	if (data_len && data) {
 		memcpy(TCM_DATA(msg), data, data_len);
-		memset(TCM_DATA(msg) + data_len, 0, TCM_SPACE(data_len) - msg_len);
+		memset((char *)TCM_DATA(msg) + data_len, 0, TCM_SPACE(data_len) - msg_len);
 	}
 	return TCM_SPACE(data_len);
 }
--- a/include/uapi/linux/virtio_ring.h
+++ b/include/uapi/linux/virtio_ring.h
@@ -169,7 +169,7 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p,
 {
 	vr->num = num;
 	vr->desc = p;
-	vr->avail = p + num*sizeof(struct vring_desc);
+	vr->avail = (struct vring_avail *)((char *)p + num * sizeof(struct vring_desc));
 	vr->used = (void *)(((uintptr_t)&vr->avail->ring[num] + sizeof(__virtio16)
 		+ align-1) & ~(align - 1));
 }
