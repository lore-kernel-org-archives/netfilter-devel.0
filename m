Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3069CDB483
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 16:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjJRQeq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 12:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjJRQep (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 12:34:45 -0400
Received: from smtp-42ac.mail.infomaniak.ch (smtp-42ac.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EA8AB
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Oct 2023 09:34:43 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4S9bzN6GprzMpnhB;
        Wed, 18 Oct 2023 16:34:40 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4S9bzN2h3VzMpp9v;
        Wed, 18 Oct 2023 18:34:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1697646880;
        bh=CQUmmHiSErLby2lNEYPNY/t43aBfTRQam0pIROhUnrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HAyEtaWARBhPTyUtyfN33vMCk9hST5LcmB8oBQu4G997Gl8hUQsPsuvk66cGBUkKS
         g2CDYUE8PAHS6U9iEsQk2VxJl4SGjJ8eJqNgRAofXIySb0ZHYrdCUFgWJZXU6jWKLA
         hpatlFElhV05pDDOKPwUsSsfZO8U1XSIh9/8ADEM=
Date:   Wed, 18 Oct 2023 18:34:38 +0200
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Subject: Re: [PATCH v13 07/12] landlock: Refactor landlock_add_rule() syscall
Message-ID: <20231018.quie0uuphieB@digikod.net>
References: <20231016015030.1684504-1-konstantin.meskhidze@huawei.com>
 <20231016015030.1684504-8-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231016015030.1684504-8-konstantin.meskhidze@huawei.com>
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 16, 2023 at 09:50:25AM +0800, Konstantin Meskhidze wrote:
> Change the landlock_add_rule() syscall to support new rule types
> in future Landlock versions. Add the add_rule_path_beneath() helper
> to support current filesystem rules.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> Link: https://lore.kernel.org/r/20230920092641.832134-8-konstantin.meskhidze@huawei.com
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> ---
> 
> Changes since v12:
> * None.
> 
> Changes since v11:
> * None.
> 
> Changes since v10:
> * None.
> 
> Changes since v9:
> * Minor fixes:
> 	- deletes unnecessary curly braces.
> 	- deletes unnecessary empty line.
> 
> Changes since v8:
> * Refactors commit message.
> * Minor fixes.
> 
> Changes since v7:
> * None
> 
> Changes since v6:
> * None
> 
> Changes since v5:
> * Refactors syscall landlock_add_rule() and add_rule_path_beneath() helper
> to make argument check ordering consistent and get rid of partial revertings
> in following patches.
> * Rolls back refactoring base_test.c seltest.
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Refactors add_rule_path_beneath() and landlock_add_rule() functions
> to optimize code usage.
> * Refactors base_test.c seltest: adds LANDLOCK_RULE_PATH_BENEATH
> rule type in landlock_add_rule() call.
> 
> Changes since v3:
> * Split commit.
> * Refactors landlock_add_rule syscall.
> 
> ---
>  security/landlock/syscalls.c | 92 +++++++++++++++++++-----------------
>  1 file changed, 48 insertions(+), 44 deletions(-)
> 
> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index d35cd5d304db..8a54e87dbb17 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -274,6 +274,47 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
>  	return err;
>  }
> 
> +static int add_rule_path_beneath(struct landlock_ruleset *const ruleset,
> +				 const void __user *const rule_attr)
> +{
> +	struct landlock_path_beneath_attr path_beneath_attr;
> +	struct path path;
> +	int res, err;
> +	access_mask_t mask;
> +
> +	/* Copies raw user space buffer, only one type for now. */
> +	res = copy_from_user(&path_beneath_attr, rule_attr,
> +			     sizeof(path_beneath_attr));
> +	if (res)
> +		return -EFAULT;
> +
> +	/*
> +	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
> +	 * are ignored in path walks.
> +	 */
> +	if (!path_beneath_attr.allowed_access)
> +		return -ENOMSG;
> +
> +	/*
> +	 * Checks that allowed_access matches the @ruleset constraints
> +	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
> +	 */

You now can replace this comment block with that:
+	/* Checks that allowed_access matches the @ruleset constraints. */

> +	mask = landlock_get_raw_fs_access_mask(ruleset, 0);
> +	if ((path_beneath_attr.allowed_access | mask) != mask)
> +		return -EINVAL;
> +
> +	/* Gets and checks the new rule. */
> +	err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
> +	if (err)
> +		return err;
> +
> +	/* Imports the new rule. */
> +	err = landlock_append_fs_rule(ruleset, &path,
> +				      path_beneath_attr.allowed_access);
> +	path_put(&path);
> +	return err;
> +}
