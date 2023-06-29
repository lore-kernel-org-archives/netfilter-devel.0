Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD923EB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jun 2023 14:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjF2OEb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Jun 2023 10:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbjF2OEa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jun 2023 10:04:30 -0400
Received: from smtp-bc09.mail.infomaniak.ch (smtp-bc09.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc09])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDDB26B6
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2023 07:04:29 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QsKvD35f0zMv9Sj;
        Thu, 29 Jun 2023 14:04:24 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QsKvC4gyYzMq943;
        Thu, 29 Jun 2023 16:04:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1688047464;
        bh=zISBIrJvCaHLRpaYZPXAza1RbGmkHK5jlpXQyEL+/wQ=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=G2IKbxTJjSTE0YizDdZocUBqMS5TGvHnP9teKeK6e5vwKRUm7vo+LJ1rdcQebD901
         qR9J7+6nFp7i+256OKDUJSDcPWOqov00QGjywo4UflTjIWmP2+Yep9oMHPU4y+D48z
         c8G7ySgOMc66YXaURaFnU8g7PvlLl/M1fmnydrN0=
Message-ID: <62715f92-96ec-ca8b-afc7-a1ae85f4141d@digikod.net>
Date:   Thu, 29 Jun 2023 16:04:23 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v11 08/12] landlock: Add network rules and TCP hooks
 support
Content-Language: en-US
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-9-konstantin.meskhidze@huawei.com>
 <167413e7-c69a-3030-cd72-4c198158622e@digikod.net>
In-Reply-To: <167413e7-c69a-3030-cd72-4c198158622e@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 27/06/2023 18:14, Mickaël Salaün wrote:
> 
> On 15/05/2023 18:13, Konstantin Meskhidze wrote:
>> This commit adds network rules support in the ruleset management
>> helpers and the landlock_create_ruleset syscall.
>> Refactor user space API to support network actions. Add new network
>> access flags, network rule and network attributes. Increment Landlock
>> ABI version. Expand access_masks_t to u32 to be sure network access
>> rights can be stored. Implement socket_bind() and socket_connect()
>> LSM hooks, which enables to restrict TCP socket binding and connection
>> to specific ports.

It is important to explain the decision rationales. Please explain new 
types, something like this:

The new landlock_net_port_attr structure has two fields. The 
allowed_access field contains the LANDLOCK_ACCESS_NET_* rights. The port 
field contains the port value according to the the allowed protocol. 
This field can take up to a 64-bit value [1] but the maximum value 
depends on the related protocol (e.g. 16-bit for TCP).

[1] 
https://lore.kernel.org/r/278ab07f-7583-a4e0-3d37-1bacd091531d@digikod.net
