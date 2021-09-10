Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D324C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Sep 2021 09:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A44C61186
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Sep 2021 09:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhIJKAO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 06:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbhIJKAN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 06:00:13 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A996C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Sep 2021 02:59:02 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id t19so2855281lfe.13
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Sep 2021 02:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=onCdKIUgCfs58VRskLMAyu7dqEYeOt/0Yl28FmOtUSY=;
        b=jTLJA5sGf04EL2qenECQy9hGrAEPgIdZt+XTeFNmnCFBXWM7tcSsqzDsyEYFJEmSkc
         n9l74UNz3mGmQvUFDzPlSnelkau0snmYcOu8r25VXAi/ZBBRf+amV7enigPZaV4Ddxvu
         C1FRailLu+p1jUtL9mjrr/dyRdBLqM67O/WbHvq8uywyfBpLMhoRUwtR1qaAEdHXZKc1
         9mhZ32w1u6MsBbWKIVF+lpe3qUExes059MRSahtFJ8nqWrbLvxsytUvfa7roI59hMMR1
         kOFHlA0L2w3QaHBmaM+z6lsCQhvEUL6AmPyCnNxxmIC+BrgYej3UScdbbu/loaVsv4XF
         IpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=onCdKIUgCfs58VRskLMAyu7dqEYeOt/0Yl28FmOtUSY=;
        b=RWPqmnHEQ+ci/zYNOeM9aQytrCPjiimzeU87MX5p6kXcbUoGRP+hVcpScGRbXtaqEc
         mFxirCzcSecxEMRJeStNJu8ydI+Y4LNF2IC7ePhis1uDilQKoNHUy6a3YOn0SvJxf3Xn
         XfIdmboqr68bNHt/CFn0QpVlngxJB/uUFe6+YoBIMk8uOfBj6Awo21vRkakXfClHL1Ck
         16gpCz+TkbkhOuqCOrML/Q7aibUKR7n+NazXUDNcXWZ8F14/ESgi9l2Upov1hGBpUPzE
         tUNkoRGgZ/DsnJ6L8q++nsKxBWBYTmnteUtMD8d05GRKTD75jr0+93OzoGnOfL+Y5rh+
         XExA==
X-Gm-Message-State: AOAM533lAU3f6caQ6l7HjJdcAO5WT1w85qwYalMh8SsyQ69t2fZlWViH
        IKJHs23gstKC0aJC87jAEobSvapggmg=
X-Google-Smtp-Source: ABdhPJyV3PeizJxsyhRo8O5JTOKKqvLn722sa+QuWdQ97/G8v41tCJ5VCWtgazmGCItSWFYHi2pNog==
X-Received: by 2002:ac2:5f0a:: with SMTP id 10mr3239832lfq.14.1631267940642;
        Fri, 10 Sep 2021 02:59:00 -0700 (PDT)
Received: from localhost.localdomain (85-156-66-84.elisa-laajakaista.fi. [85.156.66.84])
        by smtp.gmail.com with ESMTPSA id x17sm486510lfe.204.2021.09.10.02.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 02:59:00 -0700 (PDT)
From:   Topi Miettinen <toiwoton@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Topi Miettinen <toiwoton@gmail.com>
Subject: [PATCH] libnetfilter_queue: src/nlmsg.c: SECCTX can be of any length
Date:   Fri, 10 Sep 2021 12:58:45 +0300
Message-Id: <20210910095845.54611-1-toiwoton@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Typically security contexts are not 'u32' sized but strings, for example
'system_u:object_r:my_http_client_packet_t:s0'.

Fix length validation check to allow any context sizes.

Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
---
 src/nlmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index b1154fc..5400dd7 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -253,7 +253,6 @@ static int nfq_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFQA_IFINDEX_PHYSOUTDEV:
 	case NFQA_CAP_LEN:
 	case NFQA_SKB_INFO:
-	case NFQA_SECCTX:
 	case NFQA_UID:
 	case NFQA_GID:
 	case NFQA_CT_INFO:
@@ -281,6 +280,7 @@ static int nfq_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFQA_PAYLOAD:
 	case NFQA_CT:
 	case NFQA_EXP:
+	case NFQA_SECCTX:
 		break;
 	}
 	tb[type] = attr;
-- 
2.30.2

