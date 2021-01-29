Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A8D5C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D170564E00
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhA2V0B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbhA2VZ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jan 2021 16:25:56 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF180C061573
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:15 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id s11so12223662edd.5
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UAdoWOf77mnW3Iq874RnfyiJVSUPTZpUF/gBGPdNGpg=;
        b=DQspw62ui6PcU733DERAA5C8nHnAyXPAEn2E9yYm21pZ8zxzxBM1ruDXHllVXY7ae8
         SdelhnBpWGhpHPGUDzsxq7MhX/aTF6JXU//VfX46XCvMtYpx68Vs1qoHJpD1zj0ZOtbT
         MjPWBYO6zrmRhXu02ZwIQA1uQ5kH/Q1Qj+u5/WPyoQT6k60/Ab7m8e6DXI9eB4Fb/cnG
         K4CxQtdD0RpK/rRkxO3LmQn8NTTZqG2TixgQ1TMbhZOabEiW+YaeJPMXJB3Er6a8NUxT
         xFbD5bvDCPBRjGczuyfauXbD1l5MHMsI/9MXs6tK4YPCdSa1dikOOGUJh5vMvfeuFoqp
         XsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UAdoWOf77mnW3Iq874RnfyiJVSUPTZpUF/gBGPdNGpg=;
        b=ay5TvsBNeyvOKtcxbJLzIUoi3lkilh6zrIBGzwQYw0sAhHwTHK7mdtUHxMzUqRHEzV
         4vGaMV9NNMPwbiNIK9MlCT0V6dUXySWvlB+7LUrVLksXw0lKZrdx9zqfseBtIEB2vPoq
         62oWkCah8nUTuqRnv3OTW75JhDrobeGp9TBNAQzdsbpSyv3mb7y9OohcgrBpNpd87eYK
         JCyxBR6NdisB4DBVV8Sr0YZnPk2xwiADIOztoXfSld29Xxegcg8V57eK55+spPzifawZ
         ka1tW6CfNwf5vBz1fod32492PCms51rve6t4XcmjS2JqgMZ/OWWQBozs5kUFCyTYl6Et
         MDFg==
X-Gm-Message-State: AOAM531OtsHnQE/+j1CoHZzXeNMGfuaECv0oFlphljH5utJd8GwCU1V9
        /7XHzY+URXfTcgQkq0Im8kDN0SfEVYqrYg==
X-Google-Smtp-Source: ABdhPJxfMRaoRJAHthIx01+4c7LUtTQGohvRTx3e6r1ysD1E3jjsvrpmYIIT/o1qnuulxDAHvKxaQw==
X-Received: by 2002:a05:6402:34d2:: with SMTP id w18mr7733762edc.102.1611955514340;
        Fri, 29 Jan 2021 13:25:14 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bd4ff.dynamic.kabel-deutschland.de. [95.91.212.255])
        by smtp.gmail.com with ESMTPSA id q2sm5143218edv.93.2021.01.29.13.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:25:13 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v3 0/8] conntrack: save output format
Date:   Fri, 29 Jan 2021 22:24:44 +0100
Message-Id: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo & all,

As discussed, here is the updated version of the "save output format"
patches.
The main changes since the last series:
1. Adopting upon the latest master changes from Pablo
2. Line parsing logic is taken from the xtables as Pablo suggested
3. The changes made more granular.

Thanks & regards,
Mikhail

Mikhail Sennikovsky (8):
  conntrack: reset optind in do_parse
  conntrack: move global options to struct ct_cmd
  conntrack: per-command entries counters
  conntrack: introduce ct_cmd_list
  conntrack: accept commands from file
  conntrack.8: man update for --load-file support
  tests: saving and loading ct entries, save format
  tests: conntrack -L/-D ip family filtering

 conntrack.8                         |   8 +
 src/conntrack.c                     | 546 +++++++++++++++++++++-------
 tests/conntrack/test-conntrack.c    |  84 ++++-
 tests/conntrack/testsuite/08stdin   |  80 ++++
 tests/conntrack/testsuite/09dumpopt | 147 ++++++++
 5 files changed, 726 insertions(+), 139 deletions(-)
 create mode 100644 tests/conntrack/testsuite/08stdin
 create mode 100644 tests/conntrack/testsuite/09dumpopt

-- 
2.25.1

