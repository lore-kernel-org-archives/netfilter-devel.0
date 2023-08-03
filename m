Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF28BC04A6A
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 14:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbjHCOMy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 10:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbjHCOMc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 10:12:32 -0400
Received: from smtp-1908.mail.infomaniak.ch (smtp-1908.mail.infomaniak.ch [IPv6:2001:1600:4:17::1908])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3DF3ABC
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 07:11:54 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4RGrPj3w4wzMpvQs;
        Thu,  3 Aug 2023 14:11:53 +0000 (UTC)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4RGrPj12PRzMppDL;
        Thu,  3 Aug 2023 16:11:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1691071913;
        bh=0Lr/X9xvu90gp+BVwk3QWde3xY2K+G94l41qvIHjpR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U9hX0+XBnMFlwqnHzE6bK6QhYlZoIGDAScNSJ5LR+fuz5PNwrRo8/wl+TlRXzKt7T
         rQ1H5R3l0FGgslfPQFvNyT+8XBTD1QY3Vz1w2iO4tvK+C3/NCDJV5zSY3KyxNEz19I
         mEwJAujcIbDw3QqSLKltWiJFhErY6ksW6ZwBKqvA=
Date:   Thu, 3 Aug 2023 16:12:02 +0200
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Subject: Re: [PATCH v11 08/12] landlock: Add network rules and TCP hooks
 support
Message-ID: <20230803.EiD9Ea1Iel0f@digikod.net>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-9-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230515161339.631577-9-konstantin.meskhidze@huawei.com>
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 16, 2023 at 12:13:35AM +0800, Konstantin Meskhidze wrote:
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

[...]

> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index 8a54e87dbb17..5cb0a1bc6ec0 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c

[...]

> +static int add_rule_net_service(struct landlock_ruleset *ruleset,
> +				const void __user *const rule_attr)
> +{
> +#if IS_ENABLED(CONFIG_INET)

We should define two add_rule_net_service() functions according to
IS_ENABLED(CONFIG_INET) instead of changing the body of the only
function.  The second function would only return -EAFNOSUPPORT.  This
cosmetic change would make the code cleaner.


> +	struct landlock_net_service_attr net_service_attr;
> +	int res;
> +	access_mask_t mask;
> +
> +	/* Copies raw user space buffer, only one type for now. */
> +	res = copy_from_user(&net_service_attr, rule_attr,
> +			     sizeof(net_service_attr));
> +	if (res)
> +		return -EFAULT;
> +
> +	/*
> +	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
> +	 * are ignored by network actions.
> +	 */
> +	if (!net_service_attr.allowed_access)
> +		return -ENOMSG;
> +
> +	/*
> +	 * Checks that allowed_access matches the @ruleset constraints
> +	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
> +	 */
> +	mask = landlock_get_net_access_mask(ruleset, 0);
> +	if ((net_service_attr.allowed_access | mask) != mask)
> +		return -EINVAL;
> +
> +	/* Denies inserting a rule with port 0 or higher than 65535. */
> +	if ((net_service_attr.port == 0) || (net_service_attr.port > U16_MAX))
> +		return -EINVAL;
> +
> +	/* Imports the new rule. */
> +	return landlock_append_net_rule(ruleset, net_service_attr.port,
> +					net_service_attr.allowed_access);
> +#else /* IS_ENABLED(CONFIG_INET) */
> +	return -EAFNOSUPPORT;
> +#endif /* IS_ENABLED(CONFIG_INET) */
> +}
