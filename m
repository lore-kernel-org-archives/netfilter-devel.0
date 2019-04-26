Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE65C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7172C20679
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:52:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMaXexNo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfDZQwK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:52:10 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:40789 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfDZQwJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 12:52:09 -0400
Received: by mail-pl1-f179.google.com with SMTP id b3so1843373plr.7
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 09:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mPm8sR/bq1AwReKrW8oOITBdtL8qDFs+SGyyWuNowBE=;
        b=YMaXexNoG1O45dnoDmsCXPwVV1n0ek/FQje7u3vCxD1nzG/OqLGMYjaHQ2A1eoCba2
         kKtKO5NLeTnqnlpkAVQvCvZI7cliyYeh5jENIX5uPPfFA46Vk3HVExJNDfuKXuIcc3vv
         +wk+RBLZCvijAie9XiikdhEj6z2zdjYeScC/nAz+F1mfaCo3fgqnOwY8jIp8Imyt9GJs
         ssIeat1Mxpjgv5KEyx4B0IMetMQdYRBw8RDkxBwUQsxE+eTAXQc/d1HUnhMFfyobnvFS
         uPT4J5CIKh3jfHEeCLNecpz02pheZjIHQ7uIyADCmhaYxFDFYI33oyVx2OiZgUoiChtt
         gBxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mPm8sR/bq1AwReKrW8oOITBdtL8qDFs+SGyyWuNowBE=;
        b=nft1EfehC9u2VjAqYFtjEokdYiqE7Ho+S88M48iLIwaC++hoQVpexN8zqST14KOt2C
         X7ur+7oEYg/Loi8kDy514GPeuNx/eN5t8lPfNt0lNikzm9T2qiglDRJAykLadwqT8oGD
         W38wm9NgysDKBMSokpvckfYZAklf9ShfkKRLUFghlYKCqa5WKafA/3vYmU9kdcalAwsY
         CU2eYxfl0e7yJzszcsvogXBu8tto9aZSwPh0I7SYoud5lJMYsb3q89SXHu5NQEQ+1qK3
         ri+5giVA/6VSpr2YUqGyEZhlklvKzVH/vtGikrw/L356BB3BqLxYVewKmuNtSK4nRveH
         vxPQ==
X-Gm-Message-State: APjAAAWduK1KxUUPwScV3vMGDYAXapHCeqZFVhRfqBiWI9XWVE6XZcj7
        3w45SyRhZZ4SkswaDTbsgRk=
X-Google-Smtp-Source: APXvYqwcEbPWIs3RTy8XBV7GrUCnikEJPObR2hUgqVBWWrF1f9b73XWd7InaYrroIysWas8Q4KQXGA==
X-Received: by 2002:a17:902:4481:: with SMTP id l1mr28306401pld.75.1556297528438;
        Fri, 26 Apr 2019 09:52:08 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id m16sm59202350pfi.29.2019.04.26.09.52.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Apr 2019 09:52:07 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH nf 0/4] netfilter: nf_flow_table: fix several flowtable bugs
Date:   Sat, 27 Apr 2019 01:51:43 +0900
Message-Id: <20190426165143.2651-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch set fixes several bugs in the flowtable modules.

First patch fixes netdev refcnt leak bug.
The flow offload routine allocates a dst_entry and that has 1 refcnt.
So the dst_release() should be called.
This patch just adds missing dst_release() in the end of
nft_flow_offload_eval().

Second patch adds TCP status check routine.
Only ESTABLISHED TCP session should have flow offload.
But flow offload routine do not check TCP status. So all of TCP status
can be flow offloaded session.
After this patch, only ESTABLISHED TCP session can be flow offloaded
session.

Third patch adds ttl value check routine.
Flow offload data-path routine decreases ttl value. but it doesn't check
ttl value.
This patch just adds ttl value check routine.
If ttl value is under 1, the packet will be passed up to the L3.

Fourth patch adds CT condition check routine into flow offload routines.
a flow offloaded CT can be deleted by masquerade notifier. if so,
the flow offload shouldn't be used in flow offload data-path and
the GC should delete that.
If the CT is flow offloaded and ct_general.use is 1, it means the CT is
removed  from the list and flow offload should be deleted GC.

Taehee Yoo (4):
  netfilter: nf_flow_table: fix netdev refcnt leak
  netfilter: nft_flow_offload: do not make un-established tcp
    flow_offload session.
  netfilter: nf_flow_table: check ttl value in flow offload data path
  netfilter: nf_flow_table: do not use deleted CT's flow offload

 net/netfilter/nf_flow_table_core.c | 10 +++++++++-
 net/netfilter/nf_flow_table_ip.c   |  6 ++++++
 net/netfilter/nft_flow_offload.c   |  4 ++++
 3 files changed, 19 insertions(+), 1 deletion(-)

-- 
2.17.1

