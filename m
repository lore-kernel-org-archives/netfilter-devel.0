Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C528CEB64DD
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jun 2023 16:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjF0QOQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jun 2023 12:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjF0QOP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2023 12:14:15 -0400
Received: from smtp-190d.mail.infomaniak.ch (smtp-190d.mail.infomaniak.ch [185.125.25.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224C230DF;
        Tue, 27 Jun 2023 09:14:09 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Qr8sq04jszMqN1J;
        Tue, 27 Jun 2023 16:14:07 +0000 (UTC)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Qr8sn63VPz3Y;
        Tue, 27 Jun 2023 18:14:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1687882446;
        bh=Yg0KfM1iR2/QRwbQzzpHFvLUdwy1soimluoZk9JrzsM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=zyxurIKP4rMveeqXsq1BdFQ5dtryxGpiG79aSrqs9dG2uh8XIP8ebTDnZBF2YnTxP
         3G2FsO4V3uInOtvmm8YRp7xIt5TGizCLmxwUuxKDSh/Y2nyKEFXGCdKYdAhW7C7ee1
         hIVvu7grhhnHH8QbU2kK8hn58iRyBMmgBbpWaTfc=
Message-ID: <167413e7-c69a-3030-cd72-4c198158622e@digikod.net>
Date:   Tue, 27 Jun 2023 18:14:04 +0200
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
> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
> index 81d09ef9aa50..93794759dad4 100644
> --- a/include/uapi/linux/landlock.h
> +++ b/include/uapi/linux/landlock.h
> @@ -31,6 +31,13 @@ struct landlock_ruleset_attr {
>   	 * this access right.
>   	 */
>   	__u64 handled_access_fs;
> +
> +	/**
> +	 * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
> +	 * that is handled by this ruleset and should then be forbidden if no
> +	 * rule explicitly allow them.
> +	 */
> +	__u64 handled_access_net;
>   };
> 
>   /*
> @@ -54,6 +61,11 @@ enum landlock_rule_type {
>   	 * landlock_path_beneath_attr .
>   	 */
>   	LANDLOCK_RULE_PATH_BENEATH = 1,
> +	/**
> +	 * @LANDLOCK_RULE_NET_SERVICE: Type of a &struct
> +	 * landlock_net_service_attr .
> +	 */
> +	LANDLOCK_RULE_NET_SERVICE = 2,
>   };
> 
>   /**
> @@ -79,6 +91,23 @@ struct landlock_path_beneath_attr {
>   	 */
>   } __attribute__((packed));
> 
> +/**
> + * struct landlock_net_service_attr - TCP subnet definition
> + *
> + * Argument of sys_landlock_add_rule().
> + */
> +struct landlock_net_service_attr {
> +	/**
> +	 * @allowed_access: Bitmask of allowed access network for services
> +	 * (cf. `Network flags`_).
> +	 */
> +	__u64 allowed_access;
> +	/**
> +	 * @port: Network port.
> +	 */
> +	__u64 port;
> +};

The "net service" name reflects the semantic but it doesn't fit well 
with the data type. It works with TCP, UDP and other protocols such as 
VSOCK, but not unix sockets. I think it makes more sense to rename 
LANDLOCK_RULE_NET_SERVICE to LANDLOCK_RULE_NET_PORT and 
landlock_net_service_attr to landlock_net_port_attr. Please be careful 
with the documentation, non-kernel code, and comments as well.

In the future, we could add a landlock_net_path_attr to identify a unix 
abstract path, which would also be a network service, but it would not 
accept the TCP access rights.

The access right names (LANDLOCK_ACCESS_NET_{BIND,CONNECT}_TCP) are 
still good.


I'm still improving tests, so you might wait a bit before renaming the 
related files.
