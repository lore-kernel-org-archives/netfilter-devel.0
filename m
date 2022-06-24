Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88AFFCCA480
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jun 2022 15:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbiFXPB4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Jun 2022 11:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbiFXPBs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Jun 2022 11:01:48 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECCE10FE1
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2022 08:01:47 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id h23so5211171ejj.12
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2022 08:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MpGuYub81dWqQvj8Y8RrNNkuRjtdN16XYy/CJnnmHs0=;
        b=hke5AzM4/sdAZyOE9GQc08/SyrPm+wleSCSbz/oKay/7wV7JIhP8hXBGWQZ/jR+bSd
         Gjz54TXMzj7w+6W3IWug0kuprFNOLU+53u6+x1Ulebgv7LI8uPjmak/WR8WNuvlnhaxW
         4xgwlt61Jl32tdBjKxvfr1NLMcUVy948nmSYmM/8FHGIa6AgP+CL2Cld/F944bU8LiVQ
         9l8BtoGQLio0CXeK05WwKEtsQOgyUv9K69w92ptJ25NxI7EnYXtM2cvXXVHvXdHM/H97
         xOV7a0jslgUAdJsPLrhD/1KXK/h63O+jrmaujfhdktC+lWoEr8HuoqRr0sVYv+KsqtA+
         6Q6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MpGuYub81dWqQvj8Y8RrNNkuRjtdN16XYy/CJnnmHs0=;
        b=F0WvltJwraIuQXV/mOQsViiYURE2L4bdQq820k2MNF8vavo91W5O6T1D3ADMaLVGqr
         GXlU5pHLVjXTs9b/bATo6t5MTp6MnMoTWaaoOoA7PlsolSVIYi7ZctOrxhJznSHf6XAa
         8EK+mKarNd5iJMqWBcp85YlABR3AKYEQnWCO8ulmbAn/Z36V/8eZMYIKFW4dr7H1S4aX
         65PXAcFQKXobzRkwNei99FVPkT+fWPmNwMZGvpQ80boOBtR2zpkt3ZBPrOIHu61nwjLR
         UVJAC8iEb/WNyAzJINGppHlAES1YvjsdDgV4PZ3O4JIz88gE6nmTaXFKZiPT1hawZ+c2
         fNyA==
X-Gm-Message-State: AJIora/iPOfSwF0vGoCILzFpK+Ek0La4ZzOSWRj/gAKbkuo86x6kYXJE
        vVucaZyn4PJi8RRrZHvIe/vshVgKsJJ3Jw==
X-Google-Smtp-Source: AGRyM1twIWrkFNQzbrfa7gfgFhIOpoDMmo6kvBZCRxSE5VSxRYahfj6Ek8epANdU4HpoiPublHOPSg==
X-Received: by 2002:a17:907:6eab:b0:722:dbb8:8e2 with SMTP id sh43-20020a1709076eab00b00722dbb808e2mr13935964ejc.746.1656082905301;
        Fri, 24 Jun 2022 08:01:45 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id r13-20020a170906a20d00b006fec9cf9237sm1246842ejy.130.2022.06.24.08.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 08:01:44 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 3/3] conntrack: fix -o save dump for unknown protocols
Date:   Fri, 24 Jun 2022 17:01:26 +0200
Message-Id: <20220624150126.24916-4-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220624150126.24916-1-mikhail.sennikovskii@ionos.com>
References: <20220624150126.24916-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make sure the protocol (-p) option is included in the -o save
ct entry dumps for L4 protocols unknown to the conntrack tool.

Do not use getprotobynumber for unknown protocols to ensure
"-o save" data incompatibility between hosts having different
/etc/protocols contents.

Include testcases covering the issue.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c                     |  9 +++++++++
 tests/conntrack/testsuite/09dumpopt | 26 ++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/src/conntrack.c b/src/conntrack.c
index e381543..d49ac1a 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -800,6 +800,7 @@ static int ct_save_snprintf(char *buf, size_t len,
 	struct ctproto_handler *cur;
 	uint8_t l3proto, l4proto;
 	int tuple_attrs[4] = {};
+	bool l4proto_set;
 	unsigned i;
 	int ret;
 
@@ -860,6 +861,7 @@ static int ct_save_snprintf(char *buf, size_t len,
 
 	l4proto = nfct_get_attr_u8(ct, ATTR_L4PROTO);
 
+	l4proto_set = false;
 	/* is it in the list of supported protocol? */
 	list_for_each_entry(cur, &proto_list, head) {
 		if (cur->protonum != l4proto)
@@ -870,9 +872,16 @@ static int ct_save_snprintf(char *buf, size_t len,
 
 		ret = ct_snprintf_opts(buf + offset, len, ct, cur->print_opts);
 		BUFFER_SIZE(ret, size, len, offset);
+
+		l4proto_set = true;
 		break;
 	}
 
+	if (!l4proto_set) {
+		ret = snprintf(buf + offset, len, "-p %d ", l4proto);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	/* skip trailing space, if any */
 	for (; size && buf[size-1] == ' '; --size)
 		buf[size-1] = '\0';
diff --git a/tests/conntrack/testsuite/09dumpopt b/tests/conntrack/testsuite/09dumpopt
index 447590b..c1e0e6e 100644
--- a/tests/conntrack/testsuite/09dumpopt
+++ b/tests/conntrack/testsuite/09dumpopt
@@ -145,3 +145,29 @@
 -D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
 # clean up after yourself
 -D -w 10 ; OK
+# Cover protocols unknown to the conntrack tool
+# Create a conntrack entries
+# IGMP
+-I -w 10 -t 59 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ;
+# Some fency protocol
+-I -w 10 -t 59 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ;
+# Some fency protocol with IPv6
+-I -w 10 -t 59 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p 200 ;
+-R - ; OK
+# copy to zone 11
+-L -w 10 -o save ; |s/-w 10/-w 11/g
+-R - ; OK
+# Delete stuff in zone 10, should succeed
+# IGMP
+-D -w 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
+# Some fency protocol
+-D -w 10  -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
+# Some fency protocol with IPv6
+-D -w 10 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p 200 ; OK
+# Delete stuff in zone 11, should succeed
+# IGMP
+-D -w 11 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
+# Some fency protocol
+-D -w 11  -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
+# Some fency protocol with IPv6
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p 200 ; OK
-- 
2.25.1

