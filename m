Return-Path: <SRS0=avf6=DC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B27C4C4741F
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69D0721741
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="ZlyMaLHf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgIYMtn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Sep 2020 08:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728922AbgIYMtn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:43 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEC7C0613CE
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:42 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p9so3454179ejf.6
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=25EypFwRmNMp9Hox8d9gC5bYBkAYP3JedLzexbhsvBc=;
        b=ZlyMaLHflXT4ttQdg2NinPamRFXNy9T0+//0cvFwmhhxNCNBqBY5E7e1RtkMYYQXOQ
         n05WBDSwD4AHLNVAq1BhnMt2hiNY2Hl0ilsw6J1NFrTw4iVQQ3ndJ6E8CuSwkrd+DDCo
         NxErzVr3a/XwdQWpHXayK4ZRYDblbUkWMrD8uXkCJncn//fTKA0prrdabtxpj/nc+ZsN
         CepppFhxIwqX50kxye+BbjaRlb4rZhGhL9749cHfW+ILN+8KAs/8e9c8Q1/AbFP2ZHXA
         FcAXwrsjNe+g60s1ntdo/8N9Ge8cLERc7X2NizdbTU4FXbyyawYc1WziKeBzf5f9qowD
         /lBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=25EypFwRmNMp9Hox8d9gC5bYBkAYP3JedLzexbhsvBc=;
        b=FdvhUmtwOHYHd2CI6+LRxosh2YPXDKYeeAB5eckqlt8WBtb6QlwBA0AVcmeUsDV5OD
         oQ2Q6J+ONmJTbOS9+S85LSJUn4jdZoeQWPENZDyO1eGANp1QPI6hM1z/krgAnoqpr3+j
         NSyTNepgYbQPluRHGmVCdZwd1q1DaESQU5qR+oornF2VIseDBRwHA0pf2itiSBO9+r+7
         Rt3ivGEgMEO/exTDZ8xrUbiW6OzYSJqTC1IGHNJTMxKuRIqg195tay2qNhaRcu28qRpo
         p7U13PsqStRiwsbO/2q30dQ32aI7A+J+fvEIeVRLrk8KwOJSUutSENvAGeyJ0j2SQ7tW
         0RIg==
X-Gm-Message-State: AOAM532agNbavBTObqbMVy9C06GNGq25aeRJ9NobJZ/DGKPTJwzOYiUQ
        fmFLe8fJK6c91/sj4xEuTwrfUTviDYfFRQ==
X-Google-Smtp-Source: ABdhPJxd1I3gzbkwWXzlNs8CuER7R3wBqd4WOVLhW2padp5nfYSvrb83mnqTc4eu6ltMa+17ffFjaQ==
X-Received: by 2002:a17:906:85a:: with SMTP id f26mr2570093ejd.389.1601038181048;
        Fri, 25 Sep 2020 05:49:41 -0700 (PDT)
Received: from localhost.localdomain (dynamic-046-114-037-141.46.114.pool.telefonica.de. [46.114.37.141])
        by smtp.gmail.com with ESMTPSA id t3sm1761642edv.59.2020.09.25.05.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 05:49:40 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH 0/8] Fast bulk transfers of large sets of ct entries
Date:   Fri, 25 Sep 2020 14:49:11 +0200
Message-Id: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Fellows,

This is a set of patches to the conntrack tool that I think 
might be interesting to the community.

The PATCH 1 and PATCH 2 represent a fix to the icmp ct entry creation 
(a test case and a fix respectively).

The remaining patches represent an extension to the conntrack tool
functionality that enables fast bulk transfers of large sets of ct 
entries, which includes creating a large set of ct entries with
a single conntrack tool invocation by passing ct entry parameters
on stdin and making conntrack be able to dump ct entries in a new
"opts" format that could be later fed back to the conntrack.

To demonstrate the overall idea, this functionality makes it possible 
to e.g. copy all ct entries from one ct zone (15) to another (9915) 
with the following command:

  conntrack -L -w 15 -o opts | sed 's/-w 15/-w 9915/g' | conntrack -I -


In addition to this I have a question about the behavioural change
of the "conntrack -L" done after conntrack v1.4.5.
With the conntrack v1.4.5 used on Debian Buster the "conntrack -L"
dumps both ipv4 and ipv6 ct entries, while with the current master, 
presumably starting with the commit 2bcbae4c14b253176d7570e6f6acc56e521ceb5e 
"conntrack -L"  only dumps ipv4 entries.

So is this really the desired behavior? 
(I see the manual page was always saying it should be like that,
but since it behaved differently there might be multiple appliances 
out there relying on the "old" behavior).

And if the "new" behavior is desired, would it make sense to add a new 
-f option value, e.g. "any", that would actually explicitly allow the 
"old" behaviour, i.e. dump both ipv4 and ipv6 entries with one go?
If yes - I could create a small patch for that as well.

Thanks & Regards,
Mikhail

Mikhail Sennikovsky (8):
  tests: icmp entry create/delete
  conntrack: fix icmp entry creation
  conntrack: accept parameters from stdin
  conntrack.8: man update for stdin params support
  tests: conntrack parameters from stdin
  conntrack: implement options output format
  conntrack.8: man update for opts format support
  tests: dumping ct entries in opts format

 conntrack.8                         |  13 +-
 extensions/libct_proto_dccp.c       |  24 ++
 extensions/libct_proto_gre.c        |  16 +
 extensions/libct_proto_icmp.c       |  33 ++
 extensions/libct_proto_icmpv6.c     |  33 ++
 extensions/libct_proto_sctp.c       |  19 ++
 extensions/libct_proto_tcp.c        |  17 ++
 extensions/libct_proto_udp.c        |  16 +
 extensions/libct_proto_udplite.c    |  16 +
 include/conntrack.h                 |  38 +++
 src/conntrack.c                     | 457 +++++++++++++++++++++++++---
 tests/conntrack/test-conntrack.c    |  84 ++++-
 tests/conntrack/testsuite/00create  |   4 +
 tests/conntrack/testsuite/08stdin   |  62 ++++
 tests/conntrack/testsuite/09dumpopt |  77 +++++
 15 files changed, 857 insertions(+), 52 deletions(-)
 create mode 100644 tests/conntrack/testsuite/08stdin
 create mode 100644 tests/conntrack/testsuite/09dumpopt

-- 
2.25.1

