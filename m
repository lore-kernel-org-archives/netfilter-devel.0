Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F13C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 18:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiFWS4d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 14:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237389AbiFWSqs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 14:46:48 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE77EF4D1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:50:22 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id o10so73754edi.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=El2zY+AGRKNqanFs/RqCIauGn5w2+Cy5YscyKIjvhgc=;
        b=LIvrDBUKmaiP23tC8iK+/aL5lWfCRUgVNwhWMbUpN0gmKUMOwsPl80xDtLKGBQA4Kw
         PWblklDwhz5rs/cHATj3TIJZrHDRaLsZaDueBdpGCHosWc7IOeq1PtzzCzfYeneqWiIA
         t64ap3mrUhNDN0wTj+Gw0ehByQPIH3dQnkk0zpSxKaARoFepBMpKt6VeC1Y+9FgjcZb5
         7M8kwaZEqlw3LTYv4GWf0g25vJrgo2n8+hQCHJM0H1ef8qCQFIAlOuF7YKLtdih6Vkb2
         m4KoXvtrwnaEQHSoWdGOspuvhQQUOM7Z9406NSITK99ol7yPcIjttrmJsDjVISd+te5X
         ZMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=El2zY+AGRKNqanFs/RqCIauGn5w2+Cy5YscyKIjvhgc=;
        b=uLpJ8XEj2tYw2rUmuefNM7vmtrozCieI3/iYD+KOxR8+P55VlIvHI7PcTv+qC3u1PI
         fNidIOSuFd60s5u5WjjdHC35AWzCNieX79otLRR4rkBs/kT/19rh7/oOnF27u5O53+aN
         jE9WJfZlUEGj9WY6x6yeCvR2kqHmdzSfun7MNKxN+t5QmIqsAO+/ZwNz2ccYYmuVkApo
         4BfUQ+FawRES5ocnXMdDJQtLgVnT3uesUL2q10pr06HwpUY3mTbukM4+4BUJcloVRf1/
         p8XrxFh7NTsiTYSriwgr03O6gLyv7jkvczwdsh6CJLtTWpSr3HzySmnmkuzG3n8gy74Q
         2pOQ==
X-Gm-Message-State: AJIora+xJg6daovuzV02eXeQTnLZk2zmL6W0CxYpUvMztv7S8ZGRskpX
        7FYoWl3SzKtYVbf9O/U2IznH8LmVBgnx3A==
X-Google-Smtp-Source: AGRyM1tqMaURlL53LeS3UhXvzULSEsUgmALJO/xz1ic1h22lh4pfkEMSMpCyH50EneGyzLcYFTF3Kw==
X-Received: by 2002:aa7:c846:0:b0:431:6c7b:26af with SMTP id g6-20020aa7c846000000b004316c7b26afmr12131666edt.123.1656006619652;
        Thu, 23 Jun 2022 10:50:19 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id o9-20020aa7c7c9000000b004356e90d13esm119891eds.83.2022.06.23.10.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 10:50:18 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 0/6] conntrack: fixes for handling unknown protocols
Date:   Thu, 23 Jun 2022 19:49:54 +0200
Message-Id: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo & all,

Here is a set of fixes and test cases for handling ct entries of
protocols unknown to the conntrack tool.
The six commits are organized in a way: a commit with a testcase
showing an issue, followed by a commit fixing the issue.

Comments/suggestions are very welcome as always.

Regards,
Mikhail

Mikhail Sennikovsky (6):
  tests/conntrack: ct create for unknown protocols
  conntrack: set reply l4 proto for unknown protocol
  tests/conntrack: invalid protocol values
  conntrack: fix protocol number parsing
  tests/conntrack: ct -o save for unknown protocols
  conntrack: fix -o save dump for unknown protocols

 extensions/libct_proto_unknown.c    | 11 ++++++++++
 src/conntrack.c                     | 33 ++++++++++++++++++++++++++---
 tests/conntrack/testsuite/00create  | 32 ++++++++++++++++++++++++++++
 tests/conntrack/testsuite/09dumpopt | 26 +++++++++++++++++++++++
 4 files changed, 99 insertions(+), 3 deletions(-)

-- 
2.25.1

