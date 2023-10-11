Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49C7CD6E57
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 16:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbjJKQCU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 12:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjJKQCT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 12:02:19 -0400
Received: from smtp-42ab.mail.infomaniak.ch (smtp-42ab.mail.infomaniak.ch [IPv6:2001:1600:3:17::42ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BE891
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 09:02:16 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4S5Hb95CC8zMpnw3;
        Wed, 11 Oct 2023 16:02:13 +0000 (UTC)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4S5Hb923C1zMpnPf;
        Wed, 11 Oct 2023 18:02:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1697040133;
        bh=PXdZZri2UgVudcCp6iGj1khwqrx7yccQv3dd/KtwPtI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rgdwf8PiZ1j6yIbwLjrdoWQbgB3H/aF428G3Q2MwAH3L8xhxPQaxwSZHIUkVTtcv5
         mA0jYlw9ujDvxQncxvg5HToGuhWCOOWm5imfimxfEaO4O+Ld6Ih4cNZ3oQcoMPEk7i
         J8Nr6PPX+qMCU4MrfkEgXLzhYo7cxVkZ0VK0vh+8=
Date:   Wed, 11 Oct 2023 18:02:13 +0200
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v12 08/12] landlock: Add network rules and TCP hooks
 support
Message-ID: <20231011.shuu8oomi4Mo@digikod.net>
References: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
 <20230920092641.832134-9-konstantin.meskhidze@huawei.com>
 <20231001.oobeez8AeYae@digikod.net>
 <ad7d294e-267c-d233-e8d6-c92108f229d8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad7d294e-267c-d233-e8d6-c92108f229d8@huawei.com>
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 11, 2023 at 04:53:57AM +0300, Konstantin Meskhidze (A) wrote:
> 
> 
> 10/2/2023 11:26 PM, Mickaël Salaün пишет:
> > Thanks for this new version Konstantin. I pushed this series, with minor
> > changes, to -next. So far, no warning. But it needs some changes, mostly
> > kernel-only, but also one with the handling of port 0 with bind (see my
> > review below).
> > 
> > On Wed, Sep 20, 2023 at 05:26:36PM +0800, Konstantin Meskhidze wrote:
> > > This commit adds network rules support in the ruleset management
> > > helpers and the landlock_create_ruleset syscall.
> > > Refactor user space API to support network actions. Add new network
> > > access flags, network rule and network attributes. Increment Landlock
> > > ABI version. Expand access_masks_t to u32 to be sure network access
> > > rights can be stored. Implement socket_bind() and socket_connect()
> > > LSM hooks, which enables to restrict TCP socket binding and connection
> > > to specific ports.
> > > The new landlock_net_port_attr structure has two fields. The allowed_access
> > > field contains the LANDLOCK_ACCESS_NET_* rights. The port field contains
> > > the port value according to the allowed protocol. This field can
> > > take up to a 64-bit value [1] but the maximum value depends on the related
> > > protocol (e.g. 16-bit for TCP).
> > > 
> > > [1]
> > > https://lore.kernel.org/r/278ab07f-7583-a4e0-3d37-1bacd091531d@digikod.net
> > > 
> > > Signed-off-by: Mickaël Salaün <mic@digikod.net>
> > > Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> > > ---
> > > 

> > > +int add_rule_net_service(struct landlock_ruleset *ruleset,
> > 
> > We should only export functions with a "landlock_" prefix, and "service"
> > is now replaced with "port", which gives landlock_add_rule_net_port().
> > 
> > For consistency, we should also rename add_rule_path_beneath() into
> > landlock_add_rule_path_beneath(), move it into fs.c, and merge
> > landlock_append_fs_rule() into it (being careful to not move the related
> > code to ease review). This change should be part of the "landlock:
> > Refactor landlock_add_rule() syscall" patch. Please be careful to keep
> > the other changes happening in other patches.
> > 
> > 
> > > +			 const void __user *const rule_attr)
> > > +{
> > > +	struct landlock_net_port_attr net_port_attr;
> > > +	int res;
> > > +	access_mask_t mask, bind_access_mask;
> > > +
> > > +	/* Copies raw user space buffer. */
> > > +	res = copy_from_user(&net_port_attr, rule_attr, sizeof(net_port_attr));
> > 
> > We should include <linux/uaccess.h> because of copy_from_user().
> > 
> > Same for landlock_add_rule_path_beneath().
> > 
> > > +	if (res)
> > > +		return -EFAULT;
> > > +
> > > +	/*
> > > +	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
> > > +	 * are ignored by network actions.
> > > +	 */
> > > +	if (!net_port_attr.allowed_access)
> > > +		return -ENOMSG;
> > > +
> > > +	/*
> > > +	 * Checks that allowed_access matches the @ruleset constraints
> > > +	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
> > > +	 */
> > > +	mask = landlock_get_net_access_mask(ruleset, 0);
> > > +	if ((net_port_attr.allowed_access | mask) != mask)
> > > +		return -EINVAL;
> > > +
> > > +	/*
> > > +	 * Denies inserting a rule with port 0 (for bind action) or
> > > +	 * higher than 65535.
> > > +	 */
> > > +	bind_access_mask = net_port_attr.allowed_access &
> > > +			   LANDLOCK_ACCESS_NET_BIND_TCP;
> > > +	if (((net_port_attr.port == 0) &&
> > > +	     (bind_access_mask == LANDLOCK_ACCESS_NET_BIND_TCP)) ||
> > 
> > For context about "port 0 binding" see
> > https://lore.kernel.org/all/7cb458f1-7aff-ccf3-abfd-b563bfc65b84@huawei.com/
> > 
> > I previously said:
> > > > > To say it another way, we should not allow to add a rule with port
> > > > > 0 for
> > > > > LANDLOCK_ACCESS_NET_BIND_TCP, but return -EINVAL in this case. This
> > > > > limitation should be explained, documented and tested.
> > 
> > Thinking more about this port 0 for bind (and after an interesting
> > discussion with Eric), it would be a mistake to forbid a rule to bind on
> > port 0 because this is very useful for some network services, and
> > because it would not be reasonable to have an LSM hook to control such
> > "random ports". Instead we should document what using this value means
> > (i.e. pick a dynamic available port in a range defined by the sysadmin)
> > and highlight the fact that it is controlled with the
> > /proc/sys/net/ipv4/ip_local_port_range sysctl, which is also used by
> > IPv6.
> 
>   Hi Mickaёl.
>   I also wonder which part of documentation (landlock.rst) we should include
> zero port description in?

This documentation should be in the struct landlock_net_port_attr's @port
description, which will then be part of the generated documentation.


> > 
> > We then need to test binding on port zero by getting the binded port
> > (cf. getsockopt/getsockname) and checking that we can indeed connect to
> > it.
> > 
> > > +	    (net_port_attr.port > U16_MAX))
> > > +		return -EINVAL;
> > > +
> > > +	/* Imports the new rule. */
> > > +	return landlock_append_net_rule(ruleset, net_port_attr.port,
> > > +					net_port_attr.allowed_access);
> > > +}
