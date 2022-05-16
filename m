Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209DBC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 16:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbiEPQQx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 12:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbiEPQQw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 12:16:52 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a11:7980:3::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664BD39145
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 09:16:50 -0700 (PDT)
From:   vincent@systemli.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1652717806;
        bh=K373TLpRJ15jMCTCmZuWnps+dcUVX0MM40rTkJVLsMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4vVYxoam79xHK5Zdq+HdYCLNFDQH6rrIGLxACvt8fZ+J7/8psyHSXPfezb1h1xfs
         Ptk/LpvzcZSQ6hbl5u+hL0+LWIQ2mj010y/e3iqT1n7rcBiIxUVkraW+VE2lx1Wc3/
         pNF1mYcUV3gpYfF71yC3fh/ve5uhKHMNX3MwF+f8fypKMOdNfPMBN4HuLziRjl4qDJ
         XMO0Xy42l/4vBKAJ+mcjGsmdZ/a2IvtyrGkdJGIYRlZiQxdqdptb0cZUsAHOSR2U0Q
         1bYjDr1j5WJ23tRgCWTTN4cSs2np7dwG5KEXlLMG/pn/RirORVKZqDhWra/qhataNo
         krtTdwVQODFkg==
To:     netfilter-devel@vger.kernel.org
Cc:     Nick Hainke <vincent@systemli.org>
Subject: [PATCH] treewide: use uint* instead of u_int*
Date:   Mon, 16 May 2022 18:16:41 +0200
Message-Id: <20220516161641.15321-1-vincent@systemli.org>
In-Reply-To: <9n33705n-4s4r-q4s1-q97-76n73p18s99r@vanv.qr>
References: <9n33705n-4s4r-q4s1-q97-76n73p18s99r@vanv.qr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Nick Hainke <vincent@systemli.org>

Gcc complains about missing types. Some commits introduced u_int* instead
of uint*. Use uint treewide.

Fixes errors in the form of:
In file included from xtables-legacy-multi.c:5:
xshared.h:83:56: error: unknown type name 'u_int16_t'; did you mean 'uint16_t'?
    83 | set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
        |                                                        ^~~~~~~~~
        |                                                        uint16_t
make[6]: *** [Makefile:712: xtables_legacy_multi-xtables-legacy-multi.o] Error 1

Signed-off-by: Nick Hainke <vincent@systemli.org>
---
 extensions/libxt_conntrack.c              | 2 +-
 include/libipq/libipq.h                   | 6 +++---
 include/libiptc/libxtc.h                  | 2 +-
 include/linux/netfilter_arp/arpt_mangle.h | 2 +-
 iptables/xshared.c                        | 2 +-
 iptables/xshared.h                        | 2 +-
 libipq/ipq_create_handle.3                | 2 +-
 libipq/ipq_set_mode.3                     | 2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 64018ce1..234085c5 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -778,7 +778,7 @@ matchinfo_print(const void *ip, const struct xt_entry_match *match, int numeric,
 
 static void
 conntrack_dump_ports(const char *prefix, const char *opt,
-		     u_int16_t port_low, u_int16_t port_high)
+		     uint16_t port_low, uint16_t port_high)
 {
 	if (port_high == 0 || port_low == port_high)
 		printf(" %s%s %u", prefix, opt, port_low);
diff --git a/include/libipq/libipq.h b/include/libipq/libipq.h
index 3cd13292..48c368f5 100644
--- a/include/libipq/libipq.h
+++ b/include/libipq/libipq.h
@@ -48,19 +48,19 @@ typedef unsigned long ipq_id_t;
 struct ipq_handle
 {
 	int fd;
-	u_int8_t blocking;
+	uint8_t blocking;
 	struct sockaddr_nl local;
 	struct sockaddr_nl peer;
 };
 
-struct ipq_handle *ipq_create_handle(u_int32_t flags, u_int32_t protocol);
+struct ipq_handle *ipq_create_handle(uint32_t flags, uint32_t protocol);
 
 int ipq_destroy_handle(struct ipq_handle *h);
 
 ssize_t ipq_read(const struct ipq_handle *h,
                 unsigned char *buf, size_t len, int timeout);
 
-int ipq_set_mode(const struct ipq_handle *h, u_int8_t mode, size_t len);
+int ipq_set_mode(const struct ipq_handle *h, uint8_t mode, size_t len);
 
 ipq_packet_msg_t *ipq_get_packet(const unsigned char *buf);
 
diff --git a/include/libiptc/libxtc.h b/include/libiptc/libxtc.h
index 37010188..a1d16ef9 100644
--- a/include/libiptc/libxtc.h
+++ b/include/libiptc/libxtc.h
@@ -10,7 +10,7 @@ extern "C" {
 #endif
 
 #ifndef XT_MIN_ALIGN
-/* xt_entry has pointers and u_int64_t's in it, so if you align to
+/* xt_entry has pointers and uint64_t's in it, so if you align to
    it, you'll also align to any crazy matches and targets someone
    might write */
 #define XT_MIN_ALIGN (__alignof__(struct xt_entry))
diff --git a/include/linux/netfilter_arp/arpt_mangle.h b/include/linux/netfilter_arp/arpt_mangle.h
index 250f5029..f83ad10a 100644
--- a/include/linux/netfilter_arp/arpt_mangle.h
+++ b/include/linux/netfilter_arp/arpt_mangle.h
@@ -13,7 +13,7 @@ struct arpt_mangle
 	union {
 		struct in_addr tgt_ip;
 	} u_t;
-	u_int8_t flags;
+	uint8_t flags;
 	int target;
 };
 
diff --git a/iptables/xshared.c b/iptables/xshared.c
index a8512d38..9b5e5b5b 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1025,7 +1025,7 @@ static const int inverse_for_options[NUMBER_OF_OPT] =
 };
 
 void
-set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
+set_option(unsigned int *options, unsigned int option, uint16_t *invflg,
 	   bool invert)
 {
 	if (*options & option)
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 14568bb0..f8212988 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -80,7 +80,7 @@ struct xtables_target;
 #define IPT_INV_ARPHRD		0x0800
 
 void
-set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
+set_option(unsigned int *options, unsigned int option, uint16_t *invflg,
 	   bool invert);
 
 /**
diff --git a/libipq/ipq_create_handle.3 b/libipq/ipq_create_handle.3
index 11ef95c4..ebe46daa 100644
--- a/libipq/ipq_create_handle.3
+++ b/libipq/ipq_create_handle.3
@@ -24,7 +24,7 @@ ipq_create_handle, ipq_destroy_handle \(em create and destroy libipq handles.
 .br
 .B #include <libipq.h>
 .sp
-.BI "struct ipq_handle *ipq_create_handle(u_int32_t " flags ", u_int32_t " protocol ");"
+.BI "struct ipq_handle *ipq_create_handle(uint32_t " flags ", uint32_t " protocol ");"
 .br
 .BI "int ipq_destroy_handle(struct ipq_handle *" h );
 .SH DESCRIPTION
diff --git a/libipq/ipq_set_mode.3 b/libipq/ipq_set_mode.3
index 0edd3c00..e206886c 100644
--- a/libipq/ipq_set_mode.3
+++ b/libipq/ipq_set_mode.3
@@ -24,7 +24,7 @@ ipq_set_mode \(em set the ip_queue queuing mode
 .br
 .B #include <libipq.h>
 .sp
-.BI "int ipq_set_mode(const struct ipq_handle *" h ", u_int8_t " mode ", size_t " range );
+.BI "int ipq_set_mode(const struct ipq_handle *" h ", uint8_t " mode ", size_t " range );
 .SH DESCRIPTION
 The
 .B ipq_set_mode
-- 
2.36.1

