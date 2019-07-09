Return-Path: <SRS0=D85U=VG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB41C73C41
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 13:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B58F20861
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 13:02:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iiLTon2C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfGINCb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 09:02:31 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:54674 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfGINCb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 09:02:31 -0400
Received: by mail-wm1-f54.google.com with SMTP id p74so3002631wme.4
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jul 2019 06:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cjopRhLM5wrapOqSoRRu9rJnYhaNg3/Q6yO35ntd1vw=;
        b=iiLTon2CFw1mJMoc2V5eJwJ/ZjuGtfis5b0ezVWXskKvfI4z37oWFc4n4RotqVsU5g
         oNMwW1Q12rF7he7Y0aTiDd1Ruw5zJfHEXENqPjsz3dQFWfl6oCHX1L0QaZ6q2TSlinNV
         AL2iuW3ScnD0DYWZuI8pxeQ3nZo3J4FNyLvi189j9n7Mf8ss/2P88v2EHlIQgm3kDZjD
         DBzqAkrFf/Jp5hFbyGpHF+hN9T6LYt2dvxmtNMd1ffmEhoINF6dfC1lra3nj9wy3KJJ8
         YSkRY9ZPB9wU9It8yg9HzYZE6FVK2Nk58u+k7Ggwhp141gM//+4+4Tjy1LGqS0uWEhAf
         LQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cjopRhLM5wrapOqSoRRu9rJnYhaNg3/Q6yO35ntd1vw=;
        b=FjcsMfI9a1wSuH21xmbklXh9JtQl2298Le6ABZV7TeVEP2kPmIyhMI3PD+XTxeDO2+
         NHe9IeejkPTkqUmSHbOQsFkgJYnl6RNdiWBvGwL/h9l57PKh4mDVkCD603pvuNEwKHeN
         NEYVqBuvY6Clv7pNyzgT6YyKMbrjCu3vOMz4ASeMMZv5kMNIFevMEz9oqdTTDInpgJB7
         MRpVDX0kNMgaA7nwyN8LLLDtUo7kWuPRlkb69llV6ruvo49/MJK6pbLWj8HQd/4by0UU
         QXeZYh2TLUxWlV9UqNgm2BARDlm//TjI5XyLfTMGtJTAAg3E2TomQuREBVhRNn7A3i3j
         G44Q==
X-Gm-Message-State: APjAAAWTmIW0plsMb+FC+sgv0semlpBP1lrhZ0GmbVN63JHvPrmZ0uR/
        badUxRj4NfdKJgEDTh9cYf5T7hSc
X-Google-Smtp-Source: APXvYqyV4B3kjE8HsoztWEzS/6E5cPi4m0+FVmba+cytjex6w2CUaSaeHV1+P9OBR+bX7c7wtqOUOg==
X-Received: by 2002:a1c:44d7:: with SMTP id r206mr23268860wma.164.1562677349458;
        Tue, 09 Jul 2019 06:02:29 -0700 (PDT)
Received: from VGer.neptura.lan ([2a01:e35:8aed:1991::ab91:6451])
        by smtp.gmail.com with ESMTPSA id x6sm20756866wrt.63.2019.07.09.06.02.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 06:02:28 -0700 (PDT)
From:   =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
Subject: [PATCH nftables v5 0/1] add ct expectations support
Date:   Tue,  9 Jul 2019 15:02:08 +0200
Message-Id: <20190709130209.24639-1-sveyret@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Here is the new version containing the correction with JSON. It seems to work,
even if I can't be 100% sure because the Python tests are showing a lot of
errors not related to my modifications.

Stéphane Veyret (1):
  add ct expectations support

 doc/libnftables-json.adoc                     | 55 +++++++++++++++-
 doc/stateful-objects.txt                      | 49 +++++++++++++++
 include/linux/netfilter/nf_tables.h           | 14 ++++-
 include/rule.h                                | 10 +++
 src/evaluate.c                                |  4 ++
 src/json.c                                    | 11 ++++
 src/mnl.c                                     | 13 ++++
 src/netlink.c                                 | 12 ++++
 src/parser_bison.y                            | 62 ++++++++++++++++++-
 src/parser_json.c                             | 45 ++++++++++++++
 src/rule.c                                    | 35 +++++++++++
 src/scanner.l                                 |  1 +
 src/statement.c                               |  4 ++
 tests/py/ip/objects.t                         |  9 +++
 tests/py/ip/objects.t.payload                 |  4 ++
 tests/py/nft-test.py                          |  4 ++
 tests/shell/testcases/listing/0013objects_0   | 10 ++-
 .../testcases/nft-f/0018ct_expectation_obj_0  | 18 ++++++
 18 files changed, 354 insertions(+), 6 deletions(-)
 create mode 100755 tests/shell/testcases/nft-f/0018ct_expectation_obj_0

-- 
2.21.0

