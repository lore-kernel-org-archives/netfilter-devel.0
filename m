Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671BFC7EE32
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 15:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbjFEPNY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbjFEPNN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 11:13:13 -0400
X-Greylist: delayed 605 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Jun 2023 08:12:28 PDT
Received: from smtp-42ae.mail.infomaniak.ch (smtp-42ae.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ae])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4F31BF
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 08:12:28 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QZcK92Hf0zMqYTR;
        Mon,  5 Jun 2023 17:02:21 +0200 (CEST)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QZcK80Jb5zMrK3h;
        Mon,  5 Jun 2023 17:02:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1685977341;
        bh=8LypuOr5m5yp1T2kVIMo8zx5AGopO/50AfLfFNI9IN4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=GV+QlfYKG5GPSIziXgCRfwpuQRwlP414bzmpoP1sl0tm9vwznegS1NFMnLY5mTKZa
         9DlM2goDlktzM/q/GFQEOxk8hZE5racUBGyTzDAvWWNHW1BKBSHmkBdL7+XeO2oiDh
         +FvNXv88/gA1ptQeoSBeCXaZ1uQoC2epRpqEmLc0=
Message-ID: <8f3d242a-c0ee-217e-8094-84093ce4e134@digikod.net>
Date:   Mon, 5 Jun 2023 17:02:19 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v11 00/12] Network support for Landlock
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com,
        =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack3000@gmail.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Konstantin,

The kernel code looks good. I found some issues in tests and 
documentation, and I'm still reviewing the whole patches. In the 
meantime, I've pushed it in -next, we'll see how it goes.

We need to have this new code covered by syzkaller. I'll work on that 
unless you want to.

Regards,
  Mickaël


On 15/05/2023 18:13, Konstantin Meskhidze wrote:
> Hi,
> This is a new V11 patch related to Landlock LSM network confinement.
> It is based on the landlock's -next branch on top of v6.2-rc3+ kernel version:
> https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=next
> 
> It brings refactoring of previous patch version V10.
> Mostly there are fixes of logic and typos, refactoring some selftests.
> 
> All test were run in QEMU evironment and compiled with
>   -static flag.
>   1. network_test: 36/36 tests passed.
>   2. base_test: 7/7 tests passed.
>   3. fs_test: 78/78 tests passed.
>   4. ptrace_test: 8/8 tests passed.
> 
> Previous versions:
> v10: https://lore.kernel.org/linux-security-module/20230323085226.1432550-1-konstantin.meskhidze@huawei.com/
> v9: https://lore.kernel.org/linux-security-module/20230116085818.165539-1-konstantin.meskhidze@huawei.com/
> v8: https://lore.kernel.org/linux-security-module/20221021152644.155136-1-konstantin.meskhidze@huawei.com/
> v7: https://lore.kernel.org/linux-security-module/20220829170401.834298-1-konstantin.meskhidze@huawei.com/
> v6: https://lore.kernel.org/linux-security-module/20220621082313.3330667-1-konstantin.meskhidze@huawei.com/
> v5: https://lore.kernel.org/linux-security-module/20220516152038.39594-1-konstantin.meskhidze@huawei.com
> v4: https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
> v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
> v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
> v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/
> 
> Konstantin Meskhidze (11):
>    landlock: Make ruleset's access masks more generic
>    landlock: Refactor landlock_find_rule/insert_rule
>    landlock: Refactor merge/inherit_ruleset functions
>    landlock: Move and rename layer helpers
>    landlock: Refactor layer helpers
>    landlock: Refactor landlock_add_rule() syscall
>    landlock: Add network rules and TCP hooks support
>    selftests/landlock: Share enforce_ruleset()
>    selftests/landlock: Add 11 new test suites dedicated to network
>    samples/landlock: Add network demo
>    landlock: Document Landlock's network support
> 
> Mickaël Salaün (1):
>    landlock: Allow filesystem layout changes for domains without such
>      rule type
> 
>   Documentation/userspace-api/landlock.rst     |   89 +-
>   include/uapi/linux/landlock.h                |   48 +
>   samples/landlock/sandboxer.c                 |  128 +-
>   security/landlock/Kconfig                    |    1 +
>   security/landlock/Makefile                   |    2 +
>   security/landlock/fs.c                       |  232 +--
>   security/landlock/limits.h                   |    7 +-
>   security/landlock/net.c                      |  174 +++
>   security/landlock/net.h                      |   26 +
>   security/landlock/ruleset.c                  |  405 +++++-
>   security/landlock/ruleset.h                  |  185 ++-
>   security/landlock/setup.c                    |    2 +
>   security/landlock/syscalls.c                 |  163 ++-
>   tools/testing/selftests/landlock/base_test.c |    2 +-
>   tools/testing/selftests/landlock/common.h    |   10 +
>   tools/testing/selftests/landlock/config      |    4 +
>   tools/testing/selftests/landlock/fs_test.c   |   74 +-
>   tools/testing/selftests/landlock/net_test.c  | 1317 ++++++++++++++++++
>   18 files changed, 2520 insertions(+), 349 deletions(-)
>   create mode 100644 security/landlock/net.c
>   create mode 100644 security/landlock/net.h
>   create mode 100644 tools/testing/selftests/landlock/net_test.c
> 
> --
> 2.25.1
> 
