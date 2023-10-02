Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB18E7491B
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 20:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjJBUce (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 16:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjJBUce (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 16:32:34 -0400
X-Greylist: delayed 349 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 02 Oct 2023 13:32:29 PDT
Received: from smtp-bc0a.mail.infomaniak.ch (smtp-bc0a.mail.infomaniak.ch [45.157.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F09EB8
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 13:32:29 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4RzstN0Wx1zMq947;
        Mon,  2 Oct 2023 20:26:36 +0000 (UTC)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4RzstM3c1SzMpnPl;
        Mon,  2 Oct 2023 22:26:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1696278395;
        bh=TPozluJ8MS36RfAnGTdcFrCTIv4pyyC9ynO0JK5yBwo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U5uQBfpG3t8/hAoQpIrJS6R0taMsVhyIpMIXPKVUwpdLf1vw/sPEQWEHSTBeQSJ3X
         58IaM+pKkKX0p+RiJbK7iAqNq4jWi9gRJBQHo8j0wW/PGuADSviJMDDwW8jYPLm7PS
         0ICkgurbfKQart240Q+7H3eu3on/6dXMnsoSN4yc=
Date:   Mon, 2 Oct 2023 22:26:34 +0200
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v12 08/12] landlock: Add network rules and TCP hooks
 support
Message-ID: <20231001.oobeez8AeYae@digikod.net>
References: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
 <20230920092641.832134-9-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230920092641.832134-9-konstantin.meskhidze@huawei.com>
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks for this new version Konstantin. I pushed this series, with minor
changes, to -next. So far, no warning. But it needs some changes, mostly
kernel-only, but also one with the handling of port 0 with bind (see my
review below).

On Wed, Sep 20, 2023 at 05:26:36PM +0800, Konstantin Meskhidze wrote:
> This commit adds network rules support in the ruleset management
> helpers and the landlock_create_ruleset syscall.
> Refactor user space API to support network actions. Add new network
> access flags, network rule and network attributes. Increment Landlock
> ABI version. Expand access_masks_t to u32 to be sure network access
> rights can be stored. Implement socket_bind() and socket_connect()
> LSM hooks, which enables to restrict TCP socket binding and connection
> to specific ports.
> The new landlock_net_port_attr structure has two fields. The allowed_access
> field contains the LANDLOCK_ACCESS_NET_* rights. The port field contains
> the port value according to the allowed protocol. This field can
> take up to a 64-bit value [1] but the maximum value depends on the related
> protocol (e.g. 16-bit for TCP).
> 
> [1]
> https://lore.kernel.org/r/278ab07f-7583-a4e0-3d37-1bacd091531d@digikod.net
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v11:
> * Replace dates with "2022-2023" in net.c/h files headers.
> * Removes WARN_ON_ONCE(!domain) in check_socket_access().
> * Using "typeof(*address)" instead of offsetofend(struct sockaddr, sa_family).
> * Renames LANDLOCK_RULE_NET_SERVICE to LANDLOCK_RULE_NET_PORT.
> * Renames landlock_net_service_attr to landlock_net_port_attr.
> * Defines two add_rule_net_service() functions according to
>   IS_ENABLED(CONFIG_INET) instead of changing the body of the only
>   function.
> * Adds af_family consistency check while handling AF_UNSPEC specifically.
> * Adds bind_access_mask in add_rule_net_service() to deny all rules with bind
>   action on port zero.
> * Minor fixes.
> * Refactors commit message.
> 
> Changes since v10:
> * Removes "packed" attribute.
> * Applies Mickaёl's patch with some refactoring.
> * Deletes get_port() and check_addrlen() helpers.
> * Refactors check_socket_access() by squashing get_port() and
>   check_addrlen() helpers into it.
> * Fixes commit message.
> 
> Changes since v9:
> * Changes UAPI port field to __u64.
> * Moves shared code into check_socket_access().
> * Adds get_raw_handled_net_accesses() and
>   get_current_net_domain() helpers.
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
>   because it OR values.
> * Makes landlock_add_net_access_mask() more resilient incorrect values.
> * Refactors landlock_get_net_access_mask().
> * Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>   LANDLOCK_NUM_ACCESS_FS as value.
> * Updates access_masks_t to u32 to support network access actions.
> * Refactors landlock internal functions to support network actions with
>   landlock_key/key_type/id types.
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
>  include/uapi/linux/landlock.h                |  47 ++++
>  security/landlock/Kconfig                    |   3 +-
>  security/landlock/Makefile                   |   2 +
>  security/landlock/limits.h                   |   5 +
>  security/landlock/net.c                      | 241 +++++++++++++++++++
>  security/landlock/net.h                      |  35 +++
>  security/landlock/ruleset.c                  |  62 ++++-
>  security/landlock/ruleset.h                  |  59 ++++-
>  security/landlock/setup.c                    |   2 +
>  security/landlock/syscalls.c                 |  33 ++-
>  tools/testing/selftests/landlock/base_test.c |   2 +-
>  11 files changed, 467 insertions(+), 24 deletions(-)
>  create mode 100644 security/landlock/net.c
>  create mode 100644 security/landlock/net.h
> 
> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
> index 81d09ef9aa50..3b8400e8a4d9 100644
> --- a/include/uapi/linux/landlock.h
> +++ b/include/uapi/linux/landlock.h
> @@ -31,6 +31,12 @@ struct landlock_ruleset_attr {
>  	 * this access right.
>  	 */
>  	__u64 handled_access_fs;
> +	/**
> +	 * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
> +	 * that is handled by this ruleset and should then be forbidden if no
> +	 * rule explicitly allow them.
> +	 */
> +	__u64 handled_access_net;
>  };
> 
>  /*
> @@ -54,6 +60,11 @@ enum landlock_rule_type {
>  	 * landlock_path_beneath_attr .
>  	 */
>  	LANDLOCK_RULE_PATH_BENEATH = 1,
> +	/**
> +	 * @LANDLOCK_RULE_NET_PORT: Type of a &struct
> +	 * landlock_net_port_attr .
> +	 */
> +	LANDLOCK_RULE_NET_PORT = 2,
>  };
> 
>  /**
> @@ -79,6 +90,23 @@ struct landlock_path_beneath_attr {
>  	 */
>  } __attribute__((packed));
> 
> +/**
> + * struct landlock_net_port_attr - Network service definition

"Network port definition"


> diff --git a/security/landlock/Kconfig b/security/landlock/Kconfig
> index c1e862a38410..10c099097533 100644
> --- a/security/landlock/Kconfig
> +++ b/security/landlock/Kconfig
> @@ -2,7 +2,8 @@
> 
>  config SECURITY_LANDLOCK
>  	bool "Landlock support"
> -	depends on SECURITY
> +	depends on SECURITY && !ARCH_EPHEMERAL_INODES

!ARCH_EPHEMERAL_INODES is definitely gone now.

> +	select SECURITY_NETWORK
>  	select SECURITY_PATH
>  	help
>  	  Landlock is a sandboxing mechanism that enables processes to restrict
> diff --git a/security/landlock/Makefile b/security/landlock/Makefile
> index 7bbd2f413b3e..53d3c92ae22e 100644
> --- a/security/landlock/Makefile
> +++ b/security/landlock/Makefile
> @@ -2,3 +2,5 @@ obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
> 
>  landlock-y := setup.o syscalls.o object.o ruleset.o \
>  	cred.o ptrace.o fs.o
> +
> +landlock-$(CONFIG_INET) += net.o
> \ No newline at end of file
> diff --git a/security/landlock/limits.h b/security/landlock/limits.h
> index bafb3b8dc677..93c9c6f91556 100644
> --- a/security/landlock/limits.h
> +++ b/security/landlock/limits.h
> @@ -23,6 +23,11 @@
>  #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
>  #define LANDLOCK_SHIFT_ACCESS_FS	0
> 
> +#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
> +#define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
> +#define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
> +#define LANDLOCK_SHIFT_ACCESS_NET	LANDLOCK_NUM_ACCESS_FS
> +
>  /* clang-format on */
> 
>  #endif /* _SECURITY_LANDLOCK_LIMITS_H */
> diff --git a/security/landlock/net.c b/security/landlock/net.c
> new file mode 100644
> index 000000000000..62b830653e25
> --- /dev/null
> +++ b/security/landlock/net.c
> @@ -0,0 +1,241 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Landlock LSM - Network management and hooks
> + *
> + * Copyright © 2022-2023 Huawei Tech. Co., Ltd.
> + * Copyright © 2022-2023 Microsoft Corporation
> + */
> +
> +#include <linux/in.h>
> +#include <linux/net.h>
> +#include <linux/socket.h>
> +#include <net/ipv6.h>
> +
> +#include "common.h"
> +#include "cred.h"
> +#include "limits.h"
> +#include "net.h"
> +#include "ruleset.h"
> +
> +int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
> +			     const u16 port, access_mask_t access_rights)

This function is only used in add_rule_net_service(), so it should not
be exported, and we can merge it (into landlock_add_rule_net_port).

> +{
> +	int err;
> +	const struct landlock_id id = {
> +		.key.data = (__force uintptr_t)htons(port),
> +		.type = LANDLOCK_KEY_NET_PORT,
> +	};
> +
> +	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
> +
> +	/* Transforms relative access rights to absolute ones. */
> +	access_rights |= LANDLOCK_MASK_ACCESS_NET &
> +			 ~landlock_get_net_access_mask(ruleset, 0);
> +
> +	mutex_lock(&ruleset->lock);
> +	err = landlock_insert_rule(ruleset, id, access_rights);
> +	mutex_unlock(&ruleset->lock);
> +
> +	return err;
> +}
> +
> +int add_rule_net_service(struct landlock_ruleset *ruleset,

We should only export functions with a "landlock_" prefix, and "service"
is now replaced with "port", which gives landlock_add_rule_net_port().

For consistency, we should also rename add_rule_path_beneath() into
landlock_add_rule_path_beneath(), move it into fs.c, and merge
landlock_append_fs_rule() into it (being careful to not move the related
code to ease review). This change should be part of the "landlock:
Refactor landlock_add_rule() syscall" patch. Please be careful to keep
the other changes happening in other patches.


> +			 const void __user *const rule_attr)
> +{
> +	struct landlock_net_port_attr net_port_attr;
> +	int res;
> +	access_mask_t mask, bind_access_mask;
> +
> +	/* Copies raw user space buffer. */
> +	res = copy_from_user(&net_port_attr, rule_attr, sizeof(net_port_attr));

We should include <linux/uaccess.h> because of copy_from_user().

Same for landlock_add_rule_path_beneath().

> +	if (res)
> +		return -EFAULT;
> +
> +	/*
> +	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
> +	 * are ignored by network actions.
> +	 */
> +	if (!net_port_attr.allowed_access)
> +		return -ENOMSG;
> +
> +	/*
> +	 * Checks that allowed_access matches the @ruleset constraints
> +	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
> +	 */
> +	mask = landlock_get_net_access_mask(ruleset, 0);
> +	if ((net_port_attr.allowed_access | mask) != mask)
> +		return -EINVAL;
> +
> +	/*
> +	 * Denies inserting a rule with port 0 (for bind action) or
> +	 * higher than 65535.
> +	 */
> +	bind_access_mask = net_port_attr.allowed_access &
> +			   LANDLOCK_ACCESS_NET_BIND_TCP;
> +	if (((net_port_attr.port == 0) &&
> +	     (bind_access_mask == LANDLOCK_ACCESS_NET_BIND_TCP)) ||

For context about "port 0 binding" see
https://lore.kernel.org/all/7cb458f1-7aff-ccf3-abfd-b563bfc65b84@huawei.com/

I previously said:
>> > To say it another way, we should not allow to add a rule with port
>> > 0 for
>> > LANDLOCK_ACCESS_NET_BIND_TCP, but return -EINVAL in this case. This
>> > limitation should be explained, documented and tested.

Thinking more about this port 0 for bind (and after an interesting
discussion with Eric), it would be a mistake to forbid a rule to bind on
port 0 because this is very useful for some network services, and
because it would not be reasonable to have an LSM hook to control such
"random ports". Instead we should document what using this value means
(i.e. pick a dynamic available port in a range defined by the sysadmin)
and highlight the fact that it is controlled with the
/proc/sys/net/ipv4/ip_local_port_range sysctl, which is also used by
IPv6.

We then need to test binding on port zero by getting the binded port
(cf. getsockopt/getsockname) and checking that we can indeed connect to
it.

> +	    (net_port_attr.port > U16_MAX))
> +		return -EINVAL;
> +
> +	/* Imports the new rule. */
> +	return landlock_append_net_rule(ruleset, net_port_attr.port,
> +					net_port_attr.allowed_access);
> +}

> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index 1ede2b9a79b7..9bd0483c64d4 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -33,13 +33,16 @@
>  typedef u16 access_mask_t;
>  /* Makes sure all filesystem access rights can be stored. */
>  static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
> +/* Makes sure all network access rights can be stored. */
> +static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_NET);
>  /* Makes sure for_each_set_bit() and for_each_clear_bit() calls are OK. */
>  static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));
> 
>  /* Ruleset access masks. */
> -typedef u16 access_masks_t;
> +typedef u32 access_masks_t;
>  /* Makes sure all ruleset access rights can be stored. */
> -static_assert(BITS_PER_TYPE(access_masks_t) >= LANDLOCK_NUM_ACCESS_FS);
> +static_assert(BITS_PER_TYPE(access_masks_t) >=
> +	      LANDLOCK_NUM_ACCESS_FS + LANDLOCK_NUM_ACCESS_NET);
> 
>  typedef u16 layer_mask_t;
>  /* Makes sure all layers can be checked. */
> @@ -84,6 +87,11 @@ enum landlock_key_type {
>  	 * keys.
>  	 */
>  	LANDLOCK_KEY_INODE = 1,
> +	/**
> +	 * @LANDLOCK_KEY_NET_PORT: Type of &landlock_ruleset.root_net_port's
> +	 * node keys.
> +	 */
> +	LANDLOCK_KEY_NET_PORT = 2,

You don't need to specify "2".


> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index 8a54e87dbb17..da6cbd0032ca 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -29,6 +29,7 @@
>  #include "cred.h"
>  #include "fs.h"
>  #include "limits.h"
> +#include "net.h"
>  #include "ruleset.h"
>  #include "setup.h"
> 
> @@ -74,7 +75,8 @@ static void build_check_abi(void)
>  {
>  	struct landlock_ruleset_attr ruleset_attr;
>  	struct landlock_path_beneath_attr path_beneath_attr;
> -	size_t ruleset_size, path_beneath_size;
> +	struct landlock_net_port_attr net_port_attr;
> +	size_t ruleset_size, path_beneath_size, net_service_size;

net_port_size
