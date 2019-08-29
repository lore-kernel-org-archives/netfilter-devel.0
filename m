Return-Path: <SRS0=245l=WZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1CAC3A59F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Aug 2019 14:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F99920644
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Aug 2019 14:54:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hGgVO+Bi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfH2OyB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 10:54:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41044 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbfH2OyB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 10:54:01 -0400
Received: by mail-wr1-f68.google.com with SMTP id j16so3736499wrr.8
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2019 07:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=/C/pwF4A233BAy53H3nfCN19qA9sykYgKnvif2aPCoI=;
        b=hGgVO+BiP0A0JENqeLFMLJYOlXPneXYwZuf4578pqZ+oNJdqelXU7sDJVkWYY11Uqv
         7Ii7aESmikGGRsn6kELkat0ny6+Oap1qqmgGpVMQZFZD2j4slqFfw8bjv9Nvg6NYsLk3
         F9sd6mzsNtSFInZw5805cmojaC2kvr7m3+pDXcyevu9bsHSxK7+84do8rzuyWcqvpe9Q
         hikT1pxrAUNvfToL0CMelrOCsfcC9tuNSBDM3J8hq2TpyFR582r5dpDNk3GSbNbrVKBF
         EubS6BTA2XWDf9lSG8R6F8Zd3azUkHI4hSRUYzM8veQTyeYBMDJjkRfQXQoqQYPCwiBO
         s03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=/C/pwF4A233BAy53H3nfCN19qA9sykYgKnvif2aPCoI=;
        b=H8326swvT1IXCWFmpPguGefUrzfiuXNv0JJjSGx7wIVX/yKPCe4zMt61vS58548rIK
         cXt/hBShQav4/1Ob8FkCF/3CvJUQLkls5VcEdZhS4DhAGnQ7gUuQ9YmbyQv3uT2Hw4nS
         eQ92UbAM6AVz1ajs743gK6E8XWqQ7Fy1iEq0gvPK6Si22hmDlXEuLlSYOiBnuSV4kbDe
         7Z6DziKdtpiFnRPPFUe/GjfWtI9wRdfYSxSjNLZsQ+bFx0ltDEq3g8G3g8deBAvZW8h6
         ctLhw+o7kDYqx9IpuGWwUgXufkHKrSHVLab1YZw5ttqKVxhD1/IO/nCGBVm1xqyE4zAp
         R5GA==
X-Gm-Message-State: APjAAAUs/BmpJTfspeuRhc0tSuclOQvSTCAwykjAjbFz/giqAlABzlae
        xyl7Qedk4wVBEr4iCAhipeeDGn33ImM=
X-Google-Smtp-Source: APXvYqx3Oxhl5izxfGZODzGreQG0bV6o4/6uGZKWBE6MzZ9gK13nhajUg/WjD5ocdv7YLyd++jF6JQ==
X-Received: by 2002:adf:8043:: with SMTP id 61mr5244026wrk.115.1567090439408;
        Thu, 29 Aug 2019 07:53:59 -0700 (PDT)
Received: from cplx1037.edegem.eu.thmulti.com ([2001:4158:f012:500:2a10:7bff:fec5:6f08])
        by smtp.gmail.com with ESMTPSA id b136sm5598639wme.18.2019.08.29.07.53.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 29 Aug 2019 07:53:57 -0700 (PDT)
From:   Alin Nastac <alin.nastac@gmail.com>
X-Google-Original-From: Alin Nastac <alin.nastac@technicolor.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: reject: fix ICMP csum verification
Date:   Thu, 29 Aug 2019 16:53:51 +0200
Message-Id: <1567090431-4538-1-git-send-email-alin.nastac@technicolor.com>
X-Mailer: git-send-email 2.7.4
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Alin Nastac <alin.nastac@gmail.com>

Typically transport protocols such as TCP and UDP use an IP
pseudo-header for their checksum computation, but ICMP does not
use it.

Fixes: 7fc38225363dd ("netfilter: reject: skip csum verification for protocols that don't support it")
Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 2361fda..4d2e956 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -180,6 +180,10 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 		return;
 	}
 
+	/* ICMP checksum computation does not use an IP pseudo-header */
+	if (proto == IPPROTO_ICMP)
+	  proto = 0;
+
 	if (nf_ip_checksum(skb_in, hook, ip_hdrlen(skb_in), proto) == 0)
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
 }
-- 
2.7.4

