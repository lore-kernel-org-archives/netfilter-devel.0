From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf 2/5] netfilter: nfnl_cthelper: fix incorrect helper->expect_class_max
Date: Tue, 21 Mar 2017 22:35:43 +0800
Message-ID: <CAML_gOcFGgeT3SwWgi8g=apH8hxcW3ytvE98=15qupES3bXG6g@mail.gmail.com>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
 <1489934162-7415-3-git-send-email-zlpnobody@163.com> <20170321102752.GB1940@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:34584 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932652AbdCUOfp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 10:35:45 -0400
Received: by mail-vk0-f47.google.com with SMTP id z204so38983173vkd.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 07:35:44 -0700 (PDT)
In-Reply-To: <20170321102752.GB1940@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-03-21 18:27 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
>> +     class_max = ntohl(nla_get_be32(tb[NFCTH_POLICY_SET_NUM]));
>> +     if (class_max == 0)
>> +             return -EINVAL;
>
> I think this patch is just fixing up this case. We should always
> provide a policy for the expectation.

No, see comments below.

>
>> +     if (class_max > NF_CT_MAX_EXPECT_CLASSES)
>>               return -EOVERFLOW;
>>
>>       expect_policy = kzalloc(sizeof(struct nf_conntrack_expect_policy) *
>> -                             helper->expect_class_max, GFP_KERNEL);
>> +                             class_max, GFP_KERNEL);
>>       if (expect_policy == NULL)
>>               return -ENOMEM;
>>
>> -     for (i=0; i<helper->expect_class_max; i++) {
>> +     for (i = 0; i < class_max; i++) {
>>               if (!tb[NFCTH_POLICY_SET+i])
>>                       goto err;
>>
>> @@ -191,6 +191,8 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
>>               if (ret < 0)
>>                       goto err;
>>       }
>> +
>> +     helper->expect_class_max = class_max - 1;
>
> Why - 1 ?
>
> class_max represents the array size, you can just keep this code the
> way it is.

Actually, expect_class_max represents the array size minus 1.

For sip, expect_class_max is set to SIP_EXPECT_MAX(3). For ftp,
expect_class_max is set to 0.

Also there's a "BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);"
in nf_conntrack_helper_register, so if we supply 4 expect_policys,
i.e. expect_class_max is 4, BUG_ON will happen.
