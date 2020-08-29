Return-Path: <SRS0=fjj5=CH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED85C433E7
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 07:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD6F320936
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 07:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lxCeoHeQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgH2HEV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Aug 2020 03:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgH2HET (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Aug 2020 03:04:19 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C821EC061236
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 00:04:18 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id x7so1125596wro.3
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 00:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z9WkUbOD2f/VNPLxnlmXqW0XeHPhR94N71Unjm3cJ/c=;
        b=lxCeoHeQs9PDLlSSJTE40YlKj+hKMNa1ZxZ0cjZaPvVMSZ8IrhbvqTxqRhCS6PYx/+
         8QgW6ASfYsLqHC51HXkrUTbNXbr/dN0IUa3onAv7Kh3oe1bzJXz3jbisOAn/A/L8P+Qy
         Zf+2FewEEO/50LVb62BrY5lwPMyFVIJ7Jr2hsyJlQfyjhoeP+0SQRw9mxMm+e+WKmcLj
         CVJ+jLuP7JAKiSvBWssN3AOPJt4/zKgmr8yh4EhlAwpqXOFDXptyBA8kNWmq8G2upjYi
         /kjYvWzjLSUU1QNXu7Y1tOi4vId2ocPLKopad4sPBxC1GNRv7MNXSMRbVMcCGXjV7JCO
         x7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z9WkUbOD2f/VNPLxnlmXqW0XeHPhR94N71Unjm3cJ/c=;
        b=jne7Z5GQZgVhL5guEYoXtLWNBTm7gbf/DxTSh82wUgvETm/XXyBqxO7YZ+phoSnsyE
         knsyD+6CEaspyTZAj3/VhP2lFmN1geb+w+IHBfDjFLufHya9a1MVGLHPJJ5S8dLizwOO
         7cI3dp1Yn2HX4GvHKm1qzfryuRUs+FxNUVAWFiUadhGYqRiH8QX/rHz6h3KHKfTrYO/a
         lFjxvkqsvjQE6AYQjNo8ZBBLBhcfS/gcsNf+jxrfXAGlvD//X7F5rNZs68oL7jDe9sTJ
         09ZoNU3noFprAG90ep8ud/xohicdv1bDHokgHSH0bxeP6DGtqbgPDV/lyB3c9FkYWpII
         HSRw==
X-Gm-Message-State: AOAM532yK9KIQ93ROddxlM3X/ByC3ASl2tXh2mxnerxZwwKdIeMIy3Uk
        WzZVgyIowx92ONna02r/Kgzrc6zEK1EM6g==
X-Google-Smtp-Source: ABdhPJwFpjK07Z5KUi6BiZCCrp9+UmSUQoZBQ+vSfzxFA6LH2Vayu2E+ZOIFah19VBAbtEdNJiB1YA==
X-Received: by 2002:a5d:4f09:: with SMTP id c9mr2180123wru.427.1598684657264;
        Sat, 29 Aug 2020 00:04:17 -0700 (PDT)
Received: from localhost.localdomain (94-21-174-118.pool.digikabel.hu. [94.21.174.118])
        by smtp.gmail.com with ESMTPSA id f2sm2489756wrj.54.2020.08.29.00.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2020 00:04:16 -0700 (PDT)
From:   Balazs Scheidler <bazsi77@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Balazs Scheidler <bazsi77@gmail.com>
Subject: [PATCH nftables v2 3/5] doc: added documentation on "socket wildcard"
Date:   Sat, 29 Aug 2020 09:04:03 +0200
Message-Id: <20200829070405.23636-4-bazsi77@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200829070405.23636-1-bazsi77@gmail.com>
References: <20200829070405.23636-1-bazsi77@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Balazs Scheidler <bazsi77@gmail.com>
---
 doc/primary-expression.txt | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index a9c39cbb..e87e8cc2 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -195,7 +195,7 @@ raw prerouting meta ipsec exists accept
 SOCKET EXPRESSION
 ~~~~~~~~~~~~~~~~~
 [verse]
-*socket* {*transparent* | *mark*}
+*socket* {*transparent* | *mark* | *wildcard*}
 
 Socket expression can be used to search for an existing open TCP/UDP socket and
 its attributes that can be associated with a packet. It looks for an established
@@ -209,15 +209,20 @@ or non-zero bound listening socket (possibly with a non-local address).
 Value of the IP_TRANSPARENT socket option in the found socket. It can be 0 or 1.|
 boolean (1 bit)
 |mark| Value of the socket mark (SOL_SOCKET, SO_MARK). | mark
+|wildcard|
+Indicates whether the socket is wildcard-bound (e.g. 0.0.0.0 or ::0). |
+boolean (1 bit)
 |==================
 
 .Using socket expression
 ------------------------
-# Mark packets that correspond to a transparent socket
+# Mark packets that correspond to a transparent socket. "socket wildcard 0"
+# means that zero-bound listener sockets are NOT matched (which is usually
+# exactly what you want).
 table inet x {
     chain y {
 	type filter hook prerouting priority -150; policy accept;
-        socket transparent 1 mark set 0x00000001 accept
+        socket transparent 1 socket wildcard 0 mark set 0x00000001 accept
     }
 }
 
-- 
2.17.1

