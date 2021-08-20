Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 588B9C4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Aug 2021 16:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AD396113B
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Aug 2021 16:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhHTQNf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 12:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbhHTQNd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 12:13:33 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B20C061760
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Aug 2021 09:12:52 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x16so9013134pfh.2
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Aug 2021 09:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RO0qJPyVxn7zktNcuKL/DVkxSs1R8k1CLBPh2DLYoBA=;
        b=MBwMdhcNDsNbnf1iagFPCq4zhK7nFPV/S0KTUrylO0RXMapDdclfx95SnEtlSVUsTL
         lGKcb2nCpU+oYOzKxCvUIigZbXC6h/eDFGQ3vSnEYBztoiHT7CSlNbgiDuS4V1W82S0i
         mYxMU9lQ8h4w4Ja+3/MvkkseZF1G5j0cqRDqKH76Chb+QLCzTZyWTiMowDRP89PkbUXq
         7yk5dzJ2U1NA5uU60x4g9SA0f60F/4Tf3D0J3comifdvkCMXZVWEsxjKBKp04XopfPM8
         mmw97pc2CTDiBKjaAgp4ckyDL5lR9sujyhg0ONi5coTpOpn7ZapQKToNIgT3n71ctkR0
         AwlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RO0qJPyVxn7zktNcuKL/DVkxSs1R8k1CLBPh2DLYoBA=;
        b=m9uUdy20Stfud/cw/b7GcTdFeLZBhhdCHyET+pdFIX/5UvyrlqS94sIJd/PlmcFHA7
         fTaQogl02Bkn8R1jJXL5qV3hRiMM19eW729rsq3MPX81WHNvckxiJfj1PwJKe5Tahrgd
         NfeVjAnZCUl66CMjB75ALzgzZhM9zp6W5e9/V9jvPVdmSOP5zmEZC63LNAoFmhIWh04/
         Q0sGM+lYNS8AfnJrEI/aM/Oo+kqeKdjVLaOFicvopHKzSbfSgymRsOXIFJuK2UdTVwTe
         VM0rr1JjnhihavLgY5UG7C/BbY5MNJp83/KwyIQaDbjDV4ZsN+8PyCfVxeYJgxBKdPbH
         dpQA==
X-Gm-Message-State: AOAM533kOYMokvsXcxhWHnqB06KmsYQ6SLGyt2n+kDr3S606xUiMO8oN
        B2VpmZrLu+g6kl7MIy8UM68fDuYUM6w=
X-Google-Smtp-Source: ABdhPJwf1leM1o/YzHXrzWWw45Q7GATK5Rtx30rKcfoI7yWpgMzFN/QQoMcuSuGx1hBG5Lrz72bBNQ==
X-Received: by 2002:a05:6a00:2405:b0:3e1:9f65:9703 with SMTP id z5-20020a056a00240500b003e19f659703mr20539737pfh.6.1629475971716;
        Fri, 20 Aug 2021 09:12:51 -0700 (PDT)
Received: from nova-ws.. ([103.29.142.250])
        by smtp.gmail.com with ESMTPSA id 138sm1534782pfz.187.2021.08.20.09.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 09:12:51 -0700 (PDT)
From:   Xiao Liang <shaw.leon@gmail.com>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Xiao Liang <shaw.leon@gmail.com>
Subject: [PATCH nftables] src: Optimize prefix match only if is big-endian
Date:   Sat, 21 Aug 2021 00:12:37 +0800
Message-Id: <20210820161237.18821-1-shaw.leon@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A prefix of integer type is big-endian in nature. Prefix match can be
optimized to truncated 'cmp' only if it is big-endian.

Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
---
 src/netlink_linearize.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index eb53ccec..454b9ba3 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -548,7 +548,8 @@ static void netlink_gen_relational(struct netlink_linearize_ctx *ctx,
 	case EXPR_PREFIX:
 		sreg = get_register(ctx, expr->left);
 		if (expr_basetype(expr->left)->type != TYPE_STRING &&
-		    (!expr->right->prefix_len ||
+		    (expr->right->byteorder != BYTEORDER_BIG_ENDIAN ||
+		     !expr->right->prefix_len ||
 		     expr->right->prefix_len % BITS_PER_BYTE)) {
 			len = div_round_up(expr->right->len, BITS_PER_BYTE);
 			netlink_gen_expr(ctx, expr->left, sreg);
-- 
2.33.0

