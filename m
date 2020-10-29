Return-Path: <SRS0=f/Zg=EE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6A8C55178
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19E8A20732
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:52:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="V71S1AoR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgJ2Lwd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgJ2Lwb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:52:31 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28203C0613D3
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:52:30 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p5so3432315ejj.2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jWlfYByzghbHE6nPcLpVNi2cBqC/iPZgjdI+QoItV6s=;
        b=V71S1AoRSBl3sCC/azw0tYMSL70RAvd3QKlRse02aN0Ee/GfZ0IbTRdFSdNcf8J9hK
         fM11Mg5lOFRilrhHfcLHgcZD79yP/hvncPs3U8XAHP1cFEFb8T/FOJ4YzaQnx3hD9Xxp
         n+WdhDHIH5yib0GfoZ8FqDIdYUnPkecAEyd1MM4OJ3XCEtXHMlDhqyPCYMMI6+Bu5So5
         y1eTga8G+gLbkjPJWlDosjl4HYnlvGatW73+GZiaus99d1sMbLhhdGjkddU/6Q2Ccf3z
         cR++O+EN9m/vhtESw40LGgDGiGrbTgAU132fUerEhic9OODrs6g5/vws119OadVEWG4h
         Y7Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jWlfYByzghbHE6nPcLpVNi2cBqC/iPZgjdI+QoItV6s=;
        b=hSRMwlAF2AJ7Gph3y2udMEtvurEMWAkdJO9lvBjTLS3nwJYsjLd+9z0g8VG0b1vwnh
         5hl28/yCU+qsgm3a09b39dzgLOARYudkubpgvCAcG2RsCvL9RQoinU1s235ucN9/a14w
         iibnYolYPLiMxNC1PGJDCa8ih51Hg7Ei1oRCg0DjOOS66KyT8llzo80HZxwCiq8k/7Ey
         j7sfjWamJYJFA4Td9+49DWMquDxSQx3gF4NKH0hV6iIQU48osR37NiP7B7DCt0YuQVH4
         dprQnuCgxADyuaL3265Cej9zzQg+o1GSzLpha1LBmBHQ1BU16B4B5N9Q+Qc9FWzCO+hS
         ODSg==
X-Gm-Message-State: AOAM530WeYxmMvvmET6ud6k8Q+FXq8ZvY7pXpehtOy1+wXosUSeYYcHi
        TW0VZF+egwqnhat3P4VFO6cJj1e3sZW4Og==
X-Google-Smtp-Source: ABdhPJx7VDdaoyhuxuOWGu1Sse/RN/n3tx//g9XgNMw6jJHuRtD/E4zlunIWZh+eKhznkGC02PXOig==
X-Received: by 2002:a17:907:43c0:: with SMTP id ok24mr3607853ejb.385.1603972348611;
        Thu, 29 Oct 2020 04:52:28 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5af104.dynamic.kabel-deutschland.de. [95.90.241.4])
        by smtp.gmail.com with ESMTPSA id q19sm1391188ejz.90.2020.10.29.04.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:52:28 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v2 2/2] conntrack.8: man update for opts format support
Date:   Thu, 29 Oct 2020 12:51:56 +0100
Message-Id: <20201029115156.69784-3-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201029115156.69784-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20201029115156.69784-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 conntrack.8 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/conntrack.8 b/conntrack.8
index 1174c6c..e48d74e 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -109,7 +109,7 @@ Show the in-kernel connection tracking system statistics.
 Atomically zero counters after reading them.  This option is only valid in
 combination with the "\-L, \-\-dump" command options.
 .TP
-.BI "-o, --output [extended,xml,timestamp,id,ktimestamp,labels,userspace] "
+.BI "-o, --output [extended,xml,save,timestamp,id,ktimestamp,labels,userspace] "
 Display output in a certain format. With the extended output option, this tool
 displays the layer 3 information. With ktimestamp, it displays the in-kernel
 timestamp available since 2.6.38 (you can enable it via the \fBsysctl(8)\fP
@@ -376,6 +376,9 @@ additional information.
 .B conntrack \-L \-o xml
 Show the connection tracking table in XML
 .TP
+.B conntrack \-L \-o save
+Show the connection tracking table in conntrack tool options format
+.TP
 .B conntrack \-L -f ipv6 -o extended
 Only dump IPv6 connections in /proc/net/nf_conntrack format, with
 additional information.
-- 
2.25.1

