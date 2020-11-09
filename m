Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61383C2D0A3
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1345C2068D
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="SwrMdUy0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbgKISSB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729570AbgKISR7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Nov 2020 13:17:59 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04064C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2020 10:17:59 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id ay21so9795484edb.2
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Nov 2020 10:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ewDI2bPhC8l/NzNd+cHUa87r7Wm+v4Gqi5Ee77OPxCQ=;
        b=SwrMdUy0WZYtry8FpsKDCjaRVVeacWkzbSxvMGywDiZBRukUYf4rM2u1A3CbltbI5Y
         elQLqFviq9esQ0ZTFMBM6uIURuknfYG4I3lrn9jGbMt7IGWmZjs3j7PGQoQ+4vuVezLq
         5Yl54w/VtUNWEcPPX6I5iUJtRAb67CaEilZvGbC0aLBogjx2w1cd6R0sANUpMAffeQID
         zKalksh4OfADpAkSJZF8/Gt/h7Dm9dkIk/heKSGqLsegWFOYrCC8BWOhHr8v8L8Ut/Mc
         ZUUdln775qvAkP7C3pAjn+55ejlGxtWgdb5d6Geb0PaX+b3pll9yx0ZRTPFB9rn+dcQz
         tTKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ewDI2bPhC8l/NzNd+cHUa87r7Wm+v4Gqi5Ee77OPxCQ=;
        b=RrJM89PY3OPNjnF/UwwdWVpjIeQDho7M++FVVoopg9ctf4lzsqUvNFQGv33P7cqDfk
         GX43FaIaeq7r6N5mMZq/tmeyHnOtU3+6/YC96p/fowrttWkIIXmGFAcb2eNBij0cTJ++
         O1W+/wfoboMB9Mx8/YoW0d5s16x0F03FecMIW5PCmRSP+bEy6I53+ifRkp+UPMVw6HLn
         nuWJEWn9uE5kSoLoFRBbADEcHiHKr7tYc/qoW8G1y+C73QBtjIfZ5U28typ4DW+TWDIy
         gxLlOvD1TN4zR+poHxWb8LPsPuJokEFqkkQAzbZaw6uzheVivIFphr1JulN/HGJWz4Xt
         +Ivg==
X-Gm-Message-State: AOAM533esARbMg+3QrWwEYWVTTGpETRObbg+oOiLACngbD31VOC9uQO1
        /lUI2P8e5t139173ZhgiE4U5kNonk6kgdg==
X-Google-Smtp-Source: ABdhPJwU2ji05TNfa1PXWhiof38iLDuKxsOoyeY0KkFz2xuSIP3+SDvqla7BLMIQOmW18HevVuA1Zg==
X-Received: by 2002:a05:6402:17ac:: with SMTP id j12mr16441203edy.31.1604945877466;
        Mon, 09 Nov 2020 10:17:57 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5af104.dynamic.kabel-deutschland.de. [95.90.241.4])
        by smtp.gmail.com with ESMTPSA id g25sm9056273ejh.61.2020.11.09.10.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 10:17:56 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v2 0/4] conntrack: accept commands from file + tests
Date:   Mon,  9 Nov 2020 19:17:37 +0100
Message-Id: <20201109181741.52325-1-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo & all,

Here is the adjusted version of patches for conntrack
to support loading ct entries from file in the "save"
aka "options" format.

It uses the approach proposed by Pablo to first create
a list of command objects and then go through the list 
and apply it. 
At least the way I understood it ;)
Pablo, please let me know whether this is what you meant.
The approach definitely seems cleaner, but is more invasive
on the other hand.

Thanks,
Mikhail

Mikhail Sennikovsky (4):
  conntrack: accept commands from file
  conntrack.8: man update for --load-file support
  tests: saving and loading ct entries, save format
  tests: conntrack -L/-D ip family filtering

 conntrack.8                         |    8 +
 extensions/libct_proto_dccp.c       |   60 +-
 extensions/libct_proto_gre.c        |   52 +-
 extensions/libct_proto_icmp.c       |   38 +-
 extensions/libct_proto_icmpv6.c     |   38 +-
 extensions/libct_proto_sctp.c       |   56 +-
 extensions/libct_proto_tcp.c        |   68 +-
 extensions/libct_proto_udp.c        |   52 +-
 extensions/libct_proto_udplite.c    |   50 +-
 include/conntrack.h                 |   63 +-
 src/conntrack.c                     | 1214 ++++++++++++++++-----------
 tests/conntrack/test-conntrack.c    |   84 +-
 tests/conntrack/testsuite/08stdin   |   80 ++
 tests/conntrack/testsuite/09dumpopt |  147 ++++
 14 files changed, 1295 insertions(+), 715 deletions(-)
 create mode 100644 tests/conntrack/testsuite/08stdin
 create mode 100644 tests/conntrack/testsuite/09dumpopt

-- 
2.25.1

