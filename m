Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA82CE79AD
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 09:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbjITJ1G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 05:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbjITJ1E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 05:27:04 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F71BAB;
        Wed, 20 Sep 2023 02:26:54 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RrCmK4DbPz6HJc3;
        Wed, 20 Sep 2023 17:24:49 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 20 Sep 2023 10:26:47 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
Subject: [PATCH v12 00/12] Network support for Landlock
Date:   Wed, 20 Sep 2023 17:26:28 +0800
Message-ID: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500002.china.huawei.com (7.188.26.138) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,
This is a new V12 patch related to Landlock LSM network confinement.
It is based on the landlock's -next branch on top of v6.5-rc6 kernel version:
https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=next

It brings refactoring of previous patch version V11.
Mostly there are fixes of logic and typos, refactoring some selftests.

All test were run in QEMU evironment and compiled with
 -static flag.
 1. network_test: 77/77 tests passed.
 2. base_test: 7/7 tests passed.
 3. fs_test: 108/108 tests passed.
 4. ptrace_test: 8/8 tests passed.

Previous versions:
v11: https://lore.kernel.org/linux-security-module/20230515161339.631577-1-konstantin.meskhidze@huawei.com/
v10: https://lore.kernel.org/linux-security-module/20230323085226.1432550-1-konstantin.meskhidze@huawei.com/
v9: https://lore.kernel.org/linux-security-module/20230116085818.165539-1-konstantin.meskhidze@huawei.com/
v8: https://lore.kernel.org/linux-security-module/20221021152644.155136-1-konstantin.meskhidze@huawei.com/
v7: https://lore.kernel.org/linux-security-module/20220829170401.834298-1-konstantin.meskhidze@huawei.com/
v6: https://lore.kernel.org/linux-security-module/20220621082313.3330667-1-konstantin.meskhidze@huawei.com/
v5: https://lore.kernel.org/linux-security-module/20220516152038.39594-1-konstantin.meskhidze@huawei.com
v4: https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/

Konstantin Meskhidze (11):
  landlock: Make ruleset's access masks more generic
  landlock: Refactor landlock_find_rule/insert_rule
  landlock: Refactor merge/inherit_ruleset functions
  landlock: Move and rename layer helpers
  landlock: Refactor layer helpers
  landlock: Refactor landlock_add_rule() syscall
  landlock: Add network rules and TCP hooks support
  selftests/landlock: Share enforce_ruleset()
  selftests/landlock: Add 7 new test variants dedicated to network
  samples/landlock: Add network demo
  landlock: Document Landlock's network support

Mickaël Salaün (1):
  landlock: Allow filesystem layout changes for domains without such
    rule type

 Documentation/userspace-api/landlock.rst     |   93 +-
 include/uapi/linux/landlock.h                |   47 +
 samples/landlock/sandboxer.c                 |  114 +-
 security/landlock/Kconfig                    |    3 +-
 security/landlock/Makefile                   |    2 +
 security/landlock/fs.c                       |  232 +--
 security/landlock/limits.h                   |    6 +
 security/landlock/net.c                      |  241 +++
 security/landlock/net.h                      |   35 +
 security/landlock/ruleset.c                  |  405 ++++-
 security/landlock/ruleset.h                  |  181 +-
 security/landlock/setup.c                    |    2 +
 security/landlock/syscalls.c                 |  122 +-
 tools/testing/selftests/landlock/base_test.c |    2 +-
 tools/testing/selftests/landlock/common.h    |   10 +
 tools/testing/selftests/landlock/config      |    4 +
 tools/testing/selftests/landlock/fs_test.c   |   75 +-
 tools/testing/selftests/landlock/net_test.c  | 1592 ++++++++++++++++++
 18 files changed, 2815 insertions(+), 351 deletions(-)
 create mode 100644 security/landlock/net.c
 create mode 100644 security/landlock/net.h
 create mode 100644 tools/testing/selftests/landlock/net_test.c

--
2.25.1

