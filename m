Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9B2C25B6B
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 02:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjJZCCY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 22:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjJZCCY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 22:02:24 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3135128;
        Wed, 25 Oct 2023 19:02:20 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4SG8DH2gyyz6K8yL;
        Thu, 26 Oct 2023 10:01:35 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 26 Oct 2023 03:02:16 +0100
Message-ID: <9e59d159-1184-ac68-9e10-cc9fcb0666f3@huawei.com>
Date:   Thu, 26 Oct 2023 05:02:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v13 08/12] landlock: Add network rules and TCP hooks
 support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20231016015030.1684504-1-konstantin.meskhidze@huawei.com>
 <20231016015030.1684504-9-konstantin.meskhidze@huawei.com>
 <20231017.xahKoo9Koo8v@digikod.net>
 <57f150b2-0920-8567-8351-1bdb74684cfa@huawei.com>
 <20231020.ido6Aih0eiGh@digikod.net>
 <ea02392e-4460-9695-050f-7519aecebec2@huawei.com>
 <20231024.Ahdeepoh7wos@digikod.net>
 <bc4699d7-ab54-a3b8-06a0-1724a63c6076@huawei.com>
 <20231025.ooG0Uach9aes@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <20231025.ooG0Uach9aes@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



10/25/2023 2:29 PM, Mickaël Salaün пишет:
> On Tue, Oct 24, 2023 at 12:12:01PM +0300, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 10/24/2023 12:03 PM, Mickaël Salaün пишет:
>> > On Tue, Oct 24, 2023 at 06:18:54AM +0300, Konstantin Meskhidze (A) wrote:
>> > > 
>> > > 
>> > > 10/20/2023 12:49 PM, Mickaël Salaün пишет:
>> > > > On Fri, Oct 20, 2023 at 07:08:33AM +0300, Konstantin Meskhidze (A) wrote:
>> > > > > > > > > 10/18/2023 3:29 PM, Mickaël Salaün пишет:
>> > > > > > On Mon, Oct 16, 2023 at 09:50:26AM +0800, Konstantin Meskhidze wrote:
>> > 
>> > > > > > > diff --git a/security/landlock/net.h b/security/landlock/net.h
>> > > > > > > new file mode 100644
>> > > > > > > index 000000000000..588a49fd6907
>> > > > > > > --- /dev/null
>> > > > > > > +++ b/security/landlock/net.h
>> > > > > > > @@ -0,0 +1,33 @@
>> > > > > > > +/* SPDX-License-Identifier: GPL-2.0-only */
>> > > > > > > +/*
>> > > > > > > + * Landlock LSM - Network management and hooks
>> > > > > > > + *
>> > > > > > > + * Copyright © 2022-2023 Huawei Tech. Co., Ltd.
>> > > > > > > + */
>> > > > > > > +
>> > > > > > > +#ifndef _SECURITY_LANDLOCK_NET_H
>> > > > > > > +#define _SECURITY_LANDLOCK_NET_H
>> > > > > > > +
>> > > > > > > +#include "common.h"
>> > > > > > > +#include "ruleset.h"
>> > > > > > > +#include "setup.h"
>> > > > > > > +
>> > > > > > > +#if IS_ENABLED(CONFIG_INET)
>> > > > > > > +__init void landlock_add_net_hooks(void);
>> > > > > > > +
>> > > > > > > +int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
>> > > > > > > +			     const u16 port, access_mask_t access_rights);
>> > > > > > > +#else /* IS_ENABLED(CONFIG_INET) */
>> > > > > > > +static inline void landlock_add_net_hooks(void)
>> > > > > > > +{
>> > > > > > > +}
>> > > > > > > +
>> > > > > > > +static inline int
>> > > > > > > +landlock_append_net_rule(struct landlock_ruleset *const ruleset, const u16 port,
>> > > > > > > +			 access_mask_t access_rights);
>> > > > > > > +{
>> > > > > > > +	return -EAFNOSUPPORT;
>> > > > > > > +}
>> > > > > > > +#endif /* IS_ENABLED(CONFIG_INET) */
>> > > > > > > +
>> > > > > > > +#endif /* _SECURITY_LANDLOCK_NET_H */
>> > > > > > > diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>> > > > > > > index 4c209acee01e..1fe4298ff4a7 100644
>> > > > > > > --- a/security/landlock/ruleset.c
>> > > > > > > +++ b/security/landlock/ruleset.c
>> > > > > > > @@ -36,6 +36,11 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>> > > > > > >  	refcount_set(&new_ruleset->usage, 1);
>> > > > > > >  	mutex_init(&new_ruleset->lock);
>> > > > > > >  	new_ruleset->root_inode = RB_ROOT;
>> > > > > > > +
>> > > > > > > +#if IS_ENABLED(CONFIG_INET)
>> > > > > > > +	new_ruleset->root_net_port = RB_ROOT;
>> > > > > > > +#endif /* IS_ENABLED(CONFIG_INET) */
>> > > > > > > +
>> > > > > > >  	new_ruleset->num_layers = num_layers;
>> > > > > > >  	/*
>> > > > > > >  	 * hierarchy = NULL
>> > > > > > > @@ -46,16 +51,21 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>> > > > > > >  }
>> > > > > > > > >  struct landlock_ruleset *
>> > > > > > > -landlock_create_ruleset(const access_mask_t fs_access_mask)
>> > > > > > > +landlock_create_ruleset(const access_mask_t fs_access_mask,
>> > > > > > > +			const access_mask_t net_access_mask)
>> > > > > > >  {
>> > > > > > >  	struct landlock_ruleset *new_ruleset;
>> > > > > > > > >  	/* Informs about useless ruleset. */
>> > > > > > > -	if (!fs_access_mask)
>> > > > > > > +	if (!fs_access_mask && !net_access_mask)
>> > > > > > >  		return ERR_PTR(-ENOMSG);
>> > > > > > >  	new_ruleset = create_ruleset(1);
>> > > > > > > -	if (!IS_ERR(new_ruleset))
>> > > > > > > +	if (IS_ERR(new_ruleset))
>> > > > > > > +		return new_ruleset;
>> > > > > > > +	if (fs_access_mask)
>> > > > > > >  		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
>> > > > > > > +	if (net_access_mask)
>> > > > > > > +		landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
>> > > > > > > This is good, but it is not tested: we need to add a test that
>> > > > > both
>> > > > > > handle FS and net restrictions. You can add one in net.c, just handling
>> > > > > > LANDLOCK_ACCESS_FS_READ_DIR and LANDLOCK_ACCESS_NET_BIND_TCP, add one
>> > > > > > rule with path_beneath (e.g. /dev) and another with net_port, and check
>> > > > > > that open("/") is denied, open("/dev") is allowed, and and only the
>> > > > > > allowed port is allowed with bind(). This test should be simple and can
>> > > > > > only check against an IPv4 socket, i.e. using ipv4_tcp fixture, just
>> > > > > > after port_endianness. fcntl.h should then be included by net.c
>> > > > > > >   Ok.
>> > > > > > > I guess that was the purpose of layout1.with_net (in fs_test.c)
>> > > > > but it
>> > > > > > >   Yep. I added this kind of nest in fs_test.c to test both
>> > > fs and network
>> > > > > rules together.
>> > > > > > is not complete. You can revamp this test and move it to net.c
>> > > > > > following the above suggestions, keeping it consistent with other tests
>> > > > > > in net.c . You don't need the test_open() nor create_ruleset() helpers.
>> > > > > > > This test must failed if we change
>> > > > > "ruleset->access_masks[layer_level] |="
>> > > > > > to "ruleset->access_masks[layer_level] =" in
>> > > > > > landlock_add_fs_access_mask() or landlock_add_net_access_mask().
>> > > > > > >   Do you want to change it? Why?
>> > > > > The kernel code is correct and must not be changed. However, if
>> > > by
>> > > > mistake we change it and remove the OR, a test should catch that. We
>> > > > need a test to assert this assumption.
>> > > > > >   Fs and network masks are ORed to not intersect with each
>> > > other.
>> > > > > Yes, they are ORed, and we need a test to check that. Noting is
>> > > > currently testing this OR (and the different rule type consistency).
>> > > > I'm suggesting to revamp the layout1.with_net test into
>> > > > ipv4_tcp.with_fs and make it check ruleset->access_masks[] and rule
>> > > > addition of different types.
>> > 
>> > > From the other email:
>> > > Thinking about this test. We don't need to add any additional ASSERT here.
>> > > Anyway if we accidentally change "ruleset->access_masks[layer_level] |=" to
>> > > "ruleset->access_masks[layer_level] =" we will fail either in opening
>> > > directory or in port binding, cause adding a second rule (fs or net) will
>> > > overwrite a first one's mask. it does not matter which one goes first. I
>> > > will check it and send you a message.
>> > > What do you think?
>> > 
>> > > 
>> > >   About my previous comment.
>> > > 
>> > >   Checking the code we can  notice that adding fs mask goes first:
>> > > 
>> > > ...
>> > > if (fs_access_mask)
>> > > 		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
>> > > if (net_access_mask)
>> > > 		landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
>> > > ....
>> > > 
>> > > So with we change "ruleset->access_masks[layer_level] |="
>> > > >> > to "ruleset->access_masks[layer_level] =" in
>> > > landlock_add_fs_access_mask() nothing bad will happen.
>> > > But if we do that in landlock_add_net_access_mask()
>> > > fs mask will be overwritten and adding fs rule will fail
>> > > (as unhandled allowed_accesss).
>> > 
>> > Right. What is the conclusion here? Are you OK with my test proposal?
>> 
>>   So we just check if landlock_add_net_access_mask() would be changed by
>> mistake?
> 
> With the current kernel code, yes.
> 
>> Changing landlock_add_fs_access_mask() does not break the logic. Am
>> I correct here?
> 
> Yes, only landlock_add_net_access_mask() changes would be detected with
> the current kernel code, but the test checks the whole semantic, so even
> the following code with a buggy landlock_add_fs_access_mask() would be
> detected:
> 
> if (net_access_mask)
> 	landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
> if (fs_access_mask)
> 	landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);

  I agree. Thanks for the explanation.
> .
