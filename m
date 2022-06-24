Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49ECCCA482
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jun 2022 15:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiFXPB4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Jun 2022 11:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiFXPBp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Jun 2022 11:01:45 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA4EE091
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2022 08:01:44 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z7so3822351edm.13
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2022 08:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BwQRjfDRsCYLy7osBFvDr0/Z5lQKvo1EJE3UOFAA6hk=;
        b=aH6HDE26EmXF2D/QSNVf//vaqaSr5d5+cDufKuoEGwX2HYqnGnKjhSaMaFLCNaeN6i
         N1OHIYgWaCeVgQACORfjgxEev32ywVNKuXejl0t5lH5fqVegGEN6fwYPMmaw+6AGJ/jA
         MNP2hSeE9K5RN1TzH7l9Gd/oRsGtJwg0hih2SieIxjkTmt2vL8NA+X4nlv2AI6PLoLew
         4kssx3jtCYjUoiuCYkzh1+SCxCZCXLq+YoU5uI73p0rM4QOucUFb/bddUetR4fbOCruz
         nSbwHgaFxW56+R0CI4/nA0Ob2GOjx9WPvdu61AgS+VaIvTvUxlkdGvlXYdPBK2QA/gZT
         soNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BwQRjfDRsCYLy7osBFvDr0/Z5lQKvo1EJE3UOFAA6hk=;
        b=TEUaj3K/Gc+AD1jgvxFWZS7Tw4K4/HMv3yUf1DUelt+BRAxtbH/3Sea0yqEplgi77y
         61uCYid9Dp1t3IIiBXDGAK7Ke/bwNZCil999tXAuqYjD82uHVCM3F5fwy83UkWKsnHx7
         fxIY0mK5duCwF8O3Fez5epgjNrsloATJ8NmjuTB3lvpXynG9kdQvy8pp3urGtbwzQ0ae
         V+KpftGjZj4hVcePiY8Lu216M9S1diQT+D0e0OT2omUs9abdzhQEKfei2vNnGNy/O9oa
         f2IFCeQ4H0WWciFAgrbI1j7w2ZRrOUGs5MrUg/0tBaTF8VGBfDdXiroH5wG4gU2uwhFo
         tfZw==
X-Gm-Message-State: AJIora+o2G1BgmFpRgbXM1N1D914HW4bJrKCrGUvB24N/LVih0x2uSZr
        YfQzQqQQCEyondXhrQ91ZOUATmFVMIxtaw==
X-Google-Smtp-Source: AGRyM1tI3rWg40Kgf3YnL4atFkdpW9Mx3Y7oU7naI1HzfoAGcRyAWm5b+IQ4pq7CsWci70Pldi1sHA==
X-Received: by 2002:aa7:cf0f:0:b0:435:80ab:2e7e with SMTP id a15-20020aa7cf0f000000b0043580ab2e7emr18401521edy.207.1656082902170;
        Fri, 24 Jun 2022 08:01:42 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id r13-20020a170906a20d00b006fec9cf9237sm1246842ejy.130.2022.06.24.08.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 08:01:41 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 1/3] conntrack: set reply l4 proto for unknown protocol
Date:   Fri, 24 Jun 2022 17:01:24 +0200
Message-Id: <20220624150126.24916-2-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220624150126.24916-1-mikhail.sennikovskii@ionos.com>
References: <20220624150126.24916-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Withouth reply l4 protocol being set consistently the mnl_cb_run
(in fact the kernel) would return EINVAL.

Make sure the reply l4 protocol is set properly for unknown
protocols.
Include testcases covering the issue.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 extensions/libct_proto_unknown.c   | 11 +++++++++++
 tests/conntrack/testsuite/00create | 27 +++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/extensions/libct_proto_unknown.c b/extensions/libct_proto_unknown.c
index 2a47704..b877c56 100644
--- a/extensions/libct_proto_unknown.c
+++ b/extensions/libct_proto_unknown.c
@@ -21,10 +21,21 @@ static void help(void)
 	fprintf(stdout, "  no options (unsupported)\n");
 }
 
+static void final_check(unsigned int flags,
+		        unsigned int cmd,
+		        struct nf_conntrack *ct)
+{
+	if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO) &&
+	    nfct_attr_is_set(ct, ATTR_L4PROTO) &&
+	    !nfct_attr_is_set(ct, ATTR_REPL_L4PROTO))
+		nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, nfct_get_attr_u8(ct, ATTR_L4PROTO));
+}
+
 struct ctproto_handler ct_proto_unknown = {
 	.name 		= "unknown",
 	.help		= help,
 	.opts		= opts,
+	.final_check	= final_check,
 	.version	= VERSION,
 };
 
diff --git a/tests/conntrack/testsuite/00create b/tests/conntrack/testsuite/00create
index 911e711..9962e23 100644
--- a/tests/conntrack/testsuite/00create
+++ b/tests/conntrack/testsuite/00create
@@ -34,3 +34,30 @@
 -I -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
 # delete icmp ping request entry
 -D -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# Test protocols unknown by the conntrack tool
+# IGMP
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
+# Create again - should fail
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; BAD
+# repeat using protocol name instead of the value, should fail as well
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p igmp ; BAD
+# delete
+-D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
+# delete again should fail
+-D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; BAD
+# create using protocol name instead of the value
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p igmp ; OK
+# update
+-U -t 11 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
+# delete
+-D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
+# delete again should fail
+-D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p igmp ; BAD
+# take some protocol that is not normally not in /etc/protocols
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
+# update
+-U -t 11 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
+# delete
+-D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
+# delete again
+-D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; BAD
-- 
2.25.1

