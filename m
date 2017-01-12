From: Gao Feng <fgao@ikuai8.com>
Subject: Re: [PATCH nf-next 1/1] netfilter: nf_tables: Remove the rcu lock for
 dump functions
Date: Thu, 12 Jan 2017 23:24:56 +0800
Message-ID: <CA+6hz4oFuh1ecVfSOS7tp2KNesMwq4F_5dnKssAAzJa+g_SN=g@mail.gmail.com>
References: <1484217474-122356-1-git-send-email-fgao@ikuai8.com> <20170112111100.GB1048@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbguseast2.qq.com ([54.204.34.130]:50328 "EHLO
        smtpbguseast2.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbdALPZL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2017 10:25:11 -0500
Received: from mail-vk0-f43.google.com (unknown [209.85.213.43])
        by esmtp4.qq.com (ESMTP) with SMTP id 0
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 23:24:58 +0800 (CST)
Received: by mail-vk0-f43.google.com with SMTP id x75so14505497vke.2
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 07:24:59 -0800 (PST)
In-Reply-To: <20170112111100.GB1048@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Thu, Jan 12, 2017 at 7:11 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jan 12, 2017 at 06:37:54PM +0800, fgao@ikuai8.com wrote:
>> From: Feng <fgao@ikuai8.com>
>>
>> The rcu lock protect is added 3 years ago with the commit
>> e688a7f8c6cb7a18aae7e55ccdd175f0ad9e69c0. But I find the dump
>> operation is protected by the nfnl_lock in the current codes. The
>> dump is a synchronization opertion in the netlink callback function
>> which is protected by the nfnl_lock.
>
> nfnl_lock() only protects the first call, follow up recvmsg() calls in
> rely on rcu. Please, see netlink_dump().

Thanks your detail explanation.
Actually I read the netlink_dump before, but fail to find any valuable info.

Now I get the reason with your info "recvmsg" and "first call".
The netlink_recvmsg would try to invoke the dump callback again sometimes.

Thank you very much.

Regards
Feng


