Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D19BCD98EA
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 16:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjJKQEn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 12:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbjJKQEm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 12:04:42 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6869D;
        Wed, 11 Oct 2023 09:04:39 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S5Hbc4SGWz6K6B6;
        Thu, 12 Oct 2023 00:02:36 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 11 Oct 2023 17:04:36 +0100
Message-ID: <f5cbe500-851f-0928-171b-3275f95471ff@huawei.com>
Date:   Wed, 11 Oct 2023 19:04:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v12 08/12] landlock: Add network rules and TCP hooks
 support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, Eric Dumazet <edumazet@google.com>
References: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
 <20230920092641.832134-9-konstantin.meskhidze@huawei.com>
 <20231001.oobeez8AeYae@digikod.net>
 <ad7d294e-267c-d233-e8d6-c92108f229d8@huawei.com>
 <20231011.shuu8oomi4Mo@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <20231011.shuu8oomi4Mo@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



10/11/2023 7:02 PM, Mickaël Salaün пишет:
> On Wed, Oct 11, 2023 at 04:53:57AM +0300, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 10/2/2023 11:26 PM, Mickaël Salaün пишет:
>> > Thanks for this new version Konstantin. I pushed this series, with minor
>> > changes, to -next. So far, no warning. But it needs some changes, mostly
>> > kernel-only, but also one with the handling of port 0 with bind (see my
>> > review below).
>> > 
>> > On Wed, Sep 20, 2023 at 05:26:36PM +0800, Konstantin Meskhidze wrote:
>> > > This commit adds network rules support in the ruleset management
>> > > helpers and the landlock_create_ruleset syscall.
>> > > Refactor user space API to support network actions. Add new network
>> > > access flags, network rule and network attributes. Increment Landlock
>> > > ABI version. Expand access_masks_t to u32 to be sure network access
>> > > rights can be stored. Implement socket_bind() and socket_connect()
>> > > LSM hooks, which enables to restrict TCP socket binding and connection
>> > > to specific ports.
>> > > The new landlock_net_port_attr structure has two fields. The allowed_access
>> > > field contains the LANDLOCK_ACCESS_NET_* rights. The port field contains
>> > > the port value according to the allowed protocol. This field can
>> > > take up to a 64-bit value [1] but the maximum value depends on the related
>> > > protocol (e.g. 16-bit for TCP).
>> > > 
>> > > [1]
>> > > https://lore.kernel.org/r/278ab07f-7583-a4e0-3d37-1bacd091531d@digikod.net
>> > > 
>> > > Signed-off-by: Mickaël Salaün <mic@digikod.net>
>> > > Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> > > ---
>> > > 
> 
>> > > +int add_rule_net_service(struct landlock_ruleset *ruleset,
>> > 
>> > We should only export functions with a "landlock_" prefix, and "service"
>> > is now replaced with "port", which gives landlock_add_rule_net_port().
>> > 
>> > For consistency, we should also rename add_rule_path_beneath() into
>> > landlock_add_rule_path_beneath(), move it into fs.c, and merge
>> > landlock_append_fs_rule() into it (being careful to not move the related
>> > code to ease review). This change should be part of the "landlock:
>> > Refactor landlock_add_rule() syscall" patch. Please be careful to keep
>> > the other changes happening in other patches.
>> > 
>> > 
>> > > +			 const void __user *const rule_attr)
>> > > +{
>> > > +	struct landlock_net_port_attr net_port_attr;
>> > > +	int res;
>> > > +	access_mask_t mask, bind_access_mask;
>> > > +
>> > > +	/* Copies raw user space buffer. */
>> > > +	res = copy_from_user(&net_port_attr, rule_attr, sizeof(net_port_attr));
>> > 
>> > We should include <linux/uaccess.h> because of copy_from_user().
>> > 
>> > Same for landlock_add_rule_path_beneath().
>> > 
>> > > +	if (res)
>> > > +		return -EFAULT;
>> > > +
>> > > +	/*
>> > > +	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
>> > > +	 * are ignored by network actions.
>> > > +	 */
>> > > +	if (!net_port_attr.allowed_access)
>> > > +		return -ENOMSG;
>> > > +
>> > > +	/*
>> > > +	 * Checks that allowed_access matches the @ruleset constraints
>> > > +	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
>> > > +	 */
>> > > +	mask = landlock_get_net_access_mask(ruleset, 0);
>> > > +	if ((net_port_attr.allowed_access | mask) != mask)
>> > > +		return -EINVAL;
>> > > +
>> > > +	/*
>> > > +	 * Denies inserting a rule with port 0 (for bind action) or
>> > > +	 * higher than 65535.
>> > > +	 */
>> > > +	bind_access_mask = net_port_attr.allowed_access &
>> > > +			   LANDLOCK_ACCESS_NET_BIND_TCP;
>> > > +	if (((net_port_attr.port == 0) &&
>> > > +	     (bind_access_mask == LANDLOCK_ACCESS_NET_BIND_TCP)) ||
>> > 
>> > For context about "port 0 binding" see
>> > https://lore.kernel.org/all/7cb458f1-7aff-ccf3-abfd-b563bfc65b84@huawei.com/
>> > 
>> > I previously said:
>> > > > > To say it another way, we should not allow to add a rule with port
>> > > > > 0 for
>> > > > > LANDLOCK_ACCESS_NET_BIND_TCP, but return -EINVAL in this case. This
>> > > > > limitation should be explained, documented and tested.
>> > 
>> > Thinking more about this port 0 for bind (and after an interesting
>> > discussion with Eric), it would be a mistake to forbid a rule to bind on
>> > port 0 because this is very useful for some network services, and
>> > because it would not be reasonable to have an LSM hook to control such
>> > "random ports". Instead we should document what using this value means
>> > (i.e. pick a dynamic available port in a range defined by the sysadmin)
>> > and highlight the fact that it is controlled with the
>> > /proc/sys/net/ipv4/ip_local_port_range sysctl, which is also used by
>> > IPv6.
>> 
>>   Hi Mickaёl.
>>   I also wonder which part of documentation (landlock.rst) we should include
>> zero port description in?
> 
> This documentation should be in the struct landlock_net_port_attr's @port
> description, which will then be part of the generated documentation.
> 
   Got it.
   Thanks.
> 
>> > 
>> > We then need to test binding on port zero by getting the binded port
>> > (cf. getsockopt/getsockname) and checking that we can indeed connect to
>> > it.
>> > 
>> > > +	    (net_port_attr.port > U16_MAX))
>> > > +		return -EINVAL;
>> > > +
>> > > +	/* Imports the new rule. */
>> > > +	return landlock_append_net_rule(ruleset, net_port_attr.port,
>> > > +					net_port_attr.allowed_access);
>> > > +}
> .
