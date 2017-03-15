From: Gao Feng <fgao@ikuai8.com>
Subject: Re: [PATCH nf 1/1] netfilter: helper: Fix possible panic caused by
 invoking expectfn unloaded
Date: Thu, 16 Mar 2017 06:57:58 +0800
Message-ID: <CA+6hz4q8FEoadzJoZO7ymqJuNZdJZzn3Dka0ztqfE+vJur6oag@mail.gmail.com>
References: <1489472766-89568-1-git-send-email-fgao@ikuai8.com> <20170315130726.GA6318@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg202.qq.com ([184.105.206.29]:37120 "EHLO smtpbg202.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753063AbdCOW6F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 18:58:05 -0400
Received: from mail-pg0-f49.google.com (unknown [74.125.83.49])
        by esmtp4.qq.com (ESMTP) with SMTP id 0
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Mar 2017 06:57:59 +0800 (CST)
Received: by mail-pg0-f49.google.com with SMTP id b129so15552396pgc.2
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 15:57:59 -0700 (PDT)
In-Reply-To: <20170315130726.GA6318@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Wed, Mar 15, 2017 at 9:07 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Mar 14, 2017 at 02:26:06PM +0800, fgao@ikuai8.com wrote:
>> From: Gao Feng <fgao@ikuai8.com>
>>
>> The helper module permits the helper modules register expectfn, and
>> it could be hold by external caller. But when the module is unloaded,
>> there may be some pending expect nodes which still hold the function
>> reference. It may cause unexpected behavior, even panic.
>>
>> Now it would delete the expect nodes which uses the expectfn when
>> unregister expectfn. And it must use the rcu_read_lock to protect
>> the expectfn until insert it or doesn't access it ever.
>
> Expectations should be removed by when the helper module is gone, so
> what is the problem here?

Let me explain it as following:
1. The expectations would be removed by when the helper module is
gone, but expectfn is not. For example, the file nf_nat_sip.c. It
registers the expectfn at init, and unregister expectfn at exit. But
it doesn't remove the expect node when unload;
The nf_nat_sip.c uses nf_ct_helper_expectfn_register register expectfn
and nf_ct_helper_expectfn_unregister unregister the expectfn.

2. ctlink could create one expect by CTA_EXPECT_FN and without
CTA_EXPECT_HELP_NAME. It invokes nf_ct_helper_expectfn_find_by_name to
get expectfn and helper is NULL.
There is one race condition
              cpu1
                                      cpu2
ctlink creates the expect node with expectfn

                               the expectfn is unregistered
insert the expect node

Now the bug comes on. The module which expectfn is in is unloaded.

Best Regards
Feng


