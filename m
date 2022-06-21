Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC78C43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jun 2022 08:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiFUIXV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jun 2022 04:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiFUIXV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jun 2022 04:23:21 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C266065DF;
        Tue, 21 Jun 2022 01:23:19 -0700 (PDT)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LRzvL5WcZz683Pb;
        Tue, 21 Jun 2022 16:19:26 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 10:23:17 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 09:23:16 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v6 00/17] Network support for Landlock
Date:   Tue, 21 Jun 2022 16:22:56 +0800
Message-ID: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 lhreml745-chm.china.huawei.com (10.201.108.195)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,
This is a new V6 patch related to Landlock LSM network confinement.
It is based on the latest landlock-wip branch on top of v5.19-rc2:
https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=landlock-wip

It brings refactoring of previous patch version V5:
    - Fixes some logic errors and typos.
    - Adds additional FIXTURE_VARIANT and FIXTURE_VARIANT_ADD helpers
    to support both ip4 and ip6 families and shorten seltests' code.
    - Makes TCP sockets confinement support optional in sandboxer demo.
    - Formats the code with clang-format-14

All test were run in QEMU evironment and compiled with
 -static flag.
 1. network_test: 18/18 tests passed.
 2. base_test: 7/7 tests passed.
 3. fs_test: 59/59 tests passed.
 4. ptrace_test: 8/8 tests passed.

Still have issue with base_test were compiled without -static flag
(landlock-wip branch without network support)
1. base_test: 6/7 tests passed.
 Error:
 #  RUN           global.inconsistent_attr ...
 # base_test.c:54:inconsistent_attr:Expected ENOMSG (42) == errno (22)
 # inconsistent_attr: Test terminated by assertion
 #          FAIL  global.inconsistent_attr
not ok 1 global.inconsistent_attr

LCOV - code coverage report:
            Hit  Total  Coverage
Lines:      952  1010    94.3 %
Functions:  79   82      96.3 %

Previous versions:
v5: https://lore.kernel.org/linux-security-module/20220516152038.39594-1-konstantin.meskhidze@huawei.com
v4: https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/

Konstantin Meskhidze (17):
  landlock: renames access mask
  landlock: refactors landlock_find/insert_rule
  landlock: refactors merge and inherit functions
  landlock: moves helper functions
  landlock: refactors helper functions
  landlock: refactors landlock_add_rule syscall
  landlock: user space API network support
  landlock: adds support network rules
  landlock: implements TCP network hooks
  seltests/landlock: moves helper function
  seltests/landlock: adds tests for bind() hooks
  seltests/landlock: adds tests for connect() hooks
  seltests/landlock: adds AF_UNSPEC family test
  seltests/landlock: adds rules overlapping test
  seltests/landlock: adds ruleset expanding test
  seltests/landlock: adds invalid input data test
  samples/landlock: adds network demo

 include/uapi/linux/landlock.h               |  49 ++
 samples/landlock/sandboxer.c                | 118 ++-
 security/landlock/Kconfig                   |   1 +
 security/landlock/Makefile                  |   2 +
 security/landlock/fs.c                      | 162 +---
 security/landlock/limits.h                  |   8 +-
 security/landlock/net.c                     | 155 ++++
 security/landlock/net.h                     |  26 +
 security/landlock/ruleset.c                 | 448 +++++++++--
 security/landlock/ruleset.h                 |  91 ++-
 security/landlock/setup.c                   |   2 +
 security/landlock/syscalls.c                | 168 +++--
 tools/testing/selftests/landlock/common.h   |  10 +
 tools/testing/selftests/landlock/config     |   4 +
 tools/testing/selftests/landlock/fs_test.c  |  10 -
 tools/testing/selftests/landlock/net_test.c | 774 ++++++++++++++++++++
 16 files changed, 1737 insertions(+), 291 deletions(-)
 create mode 100644 security/landlock/net.c
 create mode 100644 security/landlock/net.h
 create mode 100644 tools/testing/selftests/landlock/net_test.c

--
2.25.1

