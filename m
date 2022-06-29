Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADFBEC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 17:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiF2RJ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 13:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiF2RJ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 13:09:56 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2A01A818
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 10:09:55 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id c13so23086589eds.10
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 10:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rcFC+TBrKDwU+jKG/u5kuCyIz/Vq+7OcOxx4MBDW7SQ=;
        b=Yn9Nd6Al+7srWPbngwvgiQaSzFzA6sKGOWcNdJsqyeIBUq0CGFwVEVO4rI9ZIlaetP
         jLLeCfy8/QmYGYmcwpUn/TGAk7wy2Ty2oG6hC0SI5p7qFCQDXPWFviuwzsTdVjbhVIrw
         lPsmI6WqlVBKxLc5lQDb6j5qnKO5zRuIw4L8cHxEBEiALiP2yzcP6RxTOWF8/L3IzkJT
         4+k6ItJaJHSapYM8rbwy/N/QgYxYrLj9rfNv9cDuLV6IZOFLeQFB9EIOMAOL2J6N/YQL
         BKGvFVVLRqn7j8G2PB7DDec4CRKCu3opmerolteS3g236nXdQs1xNaYSD2HIsoaAFqmG
         NFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rcFC+TBrKDwU+jKG/u5kuCyIz/Vq+7OcOxx4MBDW7SQ=;
        b=Z7vY7jOZsQptSRiWGXgPdteJCYNoC1WC/VvDeWWIsc2FVugdHG8jlkG8SEeMfrGWxV
         H09AtVQyPzf+US5dHFOdTyasj5tl9TVOYmJc0H9eE9K/iWQcvVD+KbzwvtNZbBVMJg65
         UHZKss7SatMtm07ws1r6djPOIP2ik88Pz9fYa/MYQcyGkKhfn53Yq5tMEK2FbdgFlc55
         TTojYXboYop42BN5xCdto8BNE9zm+/qZYTfX6sYS9Wy7UxFboiENgVgxNriIwoK3ne+D
         wqZXecOwMd6nmYGgdS22WQwxK6W8BfrTiB7H5jtdyXNcYfl4mvQXTy7lRr6FCXeJUNsR
         lwHg==
X-Gm-Message-State: AJIora+QdVNk6IWyz9m2nB5Ek1m/X7vJAG5s0rwFedeOlTvllekTBcPT
        Gi2raCa97nd27Hn55EAa65HkZ4tvARGcwA==
X-Google-Smtp-Source: AGRyM1vN9uQZuUAiM+IRxZGiKQMd47zy6Q2KSRF0cHB6as/xOuYJPhOKMRkRrp04dzmAETE4rMyzSQ==
X-Received: by 2002:a05:6402:1597:b0:435:88fb:5b1d with SMTP id c23-20020a056402159700b0043588fb5b1dmr5549267edv.316.1656522593522;
        Wed, 29 Jun 2022 10:09:53 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net ([85.214.13.132])
        by smtp.gmail.com with ESMTPSA id s6-20020a1709062ec600b00711d88ae162sm8008829eji.24.2022.06.29.10.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 10:09:52 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 0/3] conntrack: -A command implementation
Date:   Wed, 29 Jun 2022 19:09:38 +0200
Message-Id: <20220629170941.46219-1-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo & all,

As discussed, here is an updated patch set for the -A command
support.
As you requested it introduces a separate CT_ADD command now.
In order to do that cleanly and error-safe I had to do two
preparation steps, which are included as two separate commits
with detailed description on each.

Comments/suggestions are very welcome.

Regards,
Mikhail

Mikhail Sennikovsky (3):
  conntrack: generalize command parsing
  conntrack: use C99 initializer syntax for opts map
  conntrack: introduce new -A command

 extensions/libct_proto_dccp.c     |  33 +++----
 extensions/libct_proto_gre.c      |  33 +++----
 extensions/libct_proto_icmp.c     |  33 +++----
 extensions/libct_proto_icmpv6.c   |  33 +++----
 extensions/libct_proto_sctp.c     |  33 +++----
 extensions/libct_proto_tcp.c      |  33 +++----
 extensions/libct_proto_udp.c      |  33 +++----
 extensions/libct_proto_udplite.c  |  33 +++----
 include/conntrack.h               |  68 +++++++++++++-
 src/conntrack.c                   | 150 ++++++++++--------------------
 tests/conntrack/testsuite/08stdin |  47 +++++++++-
 tests/conntrack/testsuite/10add   |  42 +++++++++
 12 files changed, 338 insertions(+), 233 deletions(-)
 create mode 100644 tests/conntrack/testsuite/10add

-- 
2.25.1

