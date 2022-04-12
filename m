Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBF2C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 13:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354684AbiDLNvB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 09:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243898AbiDLNvA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 09:51:00 -0400
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [IPv6:2001:1600:4:17::8faa])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73D9554BB
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 06:48:41 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Kd6WX1hwtzMpylj;
        Tue, 12 Apr 2022 15:48:40 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Kd6WW57D5zlhMCJ;
        Tue, 12 Apr 2022 15:48:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1649771320;
        bh=TrA2DvyRvfndWMb9xYUPO0MrsUmcO/bFj1ED6seMXF0=;
        h=Date:From:To:Cc:References:Subject:In-Reply-To:From;
        b=iEm5zSK7txjoHyn4XM7N0oBHwUx71LhWTBOrZlemhexaIXc4o+1awU3TWtN2ElzuM
         p3QHoTxkHtsz8oAlHo/mSFDtwET/J38hWtgJtI50LlDKKQDnma6VYJ1UT2F978fqKs
         qS3MjxqJM/BQwD0i9iIZ4aEYPb4kgcZTKDV26gPM=
Message-ID: <1b1c5aaa-9d9a-e38e-42b4-bb0509eba4b5@digikod.net>
Date:   Tue, 12 Apr 2022 15:48:57 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-8-konstantin.meskhidze@huawei.com>
 <d4724117-167d-00b0-1f10-749b35bffc2f@digikod.net>
Subject: Re: [RFC PATCH v4 07/15] landlock: user space API network support
In-Reply-To: <d4724117-167d-00b0-1f10-749b35bffc2f@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 12/04/2022 13:21, Mickaël Salaün wrote:
> 
> On 09/03/2022 14:44, Konstantin Meskhidze wrote:

[...]

>> @@ -184,7 +185,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>>
>>       /* Checks content (and 32-bits cast). */
>>       if ((ruleset_attr.handled_access_fs | LANDLOCK_MASK_ACCESS_FS) !=
>> -            LANDLOCK_MASK_ACCESS_FS)
>> +             LANDLOCK_MASK_ACCESS_FS)
> 
> Don't add cosmetic changes. FYI, I'm relying on the way Vim does line 
> cuts, which is mostly tabs. Please try to do the same.

Well, let's make it simple and avoid tacit rules. I'll update most of 
the existing Landlock code and tests to be formatted with clang-format 
(-i *.[ch]), and I'll update the landlock-wip branch so that you can 
base your next patch series on it. There should be some exceptions that 
need customization but we'll see that in the next series. Anyway, don't 
worry too much, just make sure you don't have style-only changes in your 
patches.
