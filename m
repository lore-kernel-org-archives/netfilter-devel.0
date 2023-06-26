Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F72EB64DC
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jun 2023 18:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjFZSmK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 14:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbjFZSmG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 14:42:06 -0400
Received: from smtp-8fac.mail.infomaniak.ch (smtp-8fac.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F01F188
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2023 11:42:02 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QqcBx05zczMq4rw;
        Mon, 26 Jun 2023 18:42:01 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QqcBw118LzMpvV8;
        Mon, 26 Jun 2023 20:42:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1687804920;
        bh=O6Z//Jht1V+2grmqyyJ2OcZwGX8ozABe9JfLjyR0A2Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qMlBlkWqEqn7ixbT9M7Bk8dxXYiUjMVYopEgTAxSanhFwsMPFlu3zQxlAFbqw+ag5
         Bkwzkz5IJ/KGK8eCBatjZK6q5c/sPE2+fX63fNaT+Q+ff4+TvNWlXGjekZFQmdGvSj
         jRs29alhFhabKLhrM5Bed5eWgUwRSn4E8bpAvL2M=
Message-ID: <fc490ec3-12ff-bca1-1c5e-44d09c54b8a4@digikod.net>
Date:   Mon, 26 Jun 2023 20:41:59 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v11 08/12] landlock: Add network rules and TCP hooks
 support
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-9-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230515161339.631577-9-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 15/05/2023 18:13, Konstantin Meskhidze wrote:
> This commit adds network rules support in the ruleset management
> helpers and the landlock_create_ruleset syscall.
> Refactor user space API to support network actions. Add new network
> access flags, network rule and network attributes. Increment Landlock
> ABI version. Expand access_masks_t to u32 to be sure network access
> rights can be stored. Implement socket_bind() and socket_connect()
> LSM hooks, which enables to restrict TCP socket binding and connection
> to specific ports.
> 
> Co-developed-by: Mickaël Salaün <mic@digikod.net>

Signed-off-by: Mickaël Salaün <mic@digikod.net>


> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v10:
> * Removes "packed" attribute.
> * Applies Mickaёl's patch with some refactoring.
> * Deletes get_port() and check_addrlen() helpers.
> * Refactors check_socket_access() by squashing get_port() and
> check_addrlen() helpers into it.
> * Fixes commit message.
> 
> Changes since v9:
> * Changes UAPI port field to __u64.
> * Moves shared code into check_socket_access().
> * Adds get_raw_handled_net_accesses() and
> get_current_net_domain() helpers.
> * Minor fixes.
> 
> Changes since v8:
> * Squashes commits.
> * Refactors commit message.
> * Changes UAPI port field to __be16.
> * Changes logic of bind/connect hooks with AF_UNSPEC families.
> * Adds address length checking.
> * Minor fixes.
> 
> Changes since v7:
> * Squashes commits.
> * Increments ABI version to 4.
> * Refactors commit message.
> * Minor fixes.
> 
> Changes since v6:
> * Renames landlock_set_net_access_mask() to landlock_add_net_access_mask()
>    because it OR values.
> * Makes landlock_add_net_access_mask() more resilient incorrect values.
> * Refactors landlock_get_net_access_mask().
> * Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>    LANDLOCK_NUM_ACCESS_FS as value.
> * Updates access_masks_t to u32 to support network access actions.
> * Refactors landlock internal functions to support network actions with
>    landlock_key/key_type/id types.
> 
> Changes since v5:
> * Gets rid of partial revert from landlock_add_rule
> syscall.
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Refactors landlock_create_ruleset() - splits ruleset and
> masks checks.
> * Refactors landlock_create_ruleset() and landlock mask
> setters/getters to support two rule types.
> * Refactors landlock_add_rule syscall add_rule_path_beneath
> function by factoring out get_ruleset_from_fd() and
> landlock_put_ruleset().
> 
> Changes since v3:
> * Splits commit.
> * Adds network rule support for internal landlock functions.
> * Adds set_mask and get_mask for network.
> * Adds rb_root root_net_port.
> 
> ---
>   include/uapi/linux/landlock.h                |  48 +++++
>   security/landlock/Kconfig                    |   1 +
>   security/landlock/Makefile                   |   2 +
>   security/landlock/limits.h                   |   6 +-
>   security/landlock/net.c                      | 174 +++++++++++++++++++
>   security/landlock/net.h                      |  26 +++
>   security/landlock/ruleset.c                  |  52 +++++-
>   security/landlock/ruleset.h                  |  63 +++++--
>   security/landlock/setup.c                    |   2 +
>   security/landlock/syscalls.c                 |  72 +++++++-
>   tools/testing/selftests/landlock/base_test.c |   2 +-
>   11 files changed, 425 insertions(+), 23 deletions(-)
>   create mode 100644 security/landlock/net.c
>   create mode 100644 security/landlock/net.h
> 

[...]

> diff --git a/security/landlock/net.c b/security/landlock/net.c
> new file mode 100644
> index 000000000000..f8d2be53ac0d
> --- /dev/null
> +++ b/security/landlock/net.c
> @@ -0,0 +1,174 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Landlock LSM - Network management and hooks
> + *
> + * Copyright © 2022 Huawei Tech. Co., Ltd.
> + * Copyright © 2022 Microsoft Corporation

You can replace these dates with "2022-2023", and same for all your 
other "2022" I guess.
