From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: make it safer when updating ct->status
Date: Thu, 13 Apr 2017 11:15:26 +0800
Message-ID: <CAML_gOeLBvnCYrYH7JzaJKg+UJ-hm+ctKGvJRnJkfsN8EEswhg@mail.gmail.com>
References: <1492012596-60889-1-git-send-email-zlpnobody@163.com> <000001d2b3ff$9777d110$c6677330$@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, cernekee@chromium.org
To: Gao Feng <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:34373 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751121AbdDMDP1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2017 23:15:27 -0400
Received: by mail-ua0-f169.google.com with SMTP id u103so26829537uau.1
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Apr 2017 20:15:27 -0700 (PDT)
In-Reply-To: <000001d2b3ff$9777d110$c6677330$@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Feng,

2017-04-13 10:42 GMT+08:00 Gao Feng <gfree.wind@foxmail.com>:
[...]
>> +static void
>> +__ctnetlink_change_status(struct nf_conn *ct, unsigned long on,
>> +                       unsigned long off)
>> +{
>> +     unsigned long mask;
>> +     unsigned int bit;
>> +
>> +     for (bit = 0; bit < __IPS_MAX_BIT; bit++) {
>> +             mask = 1 << bit;
>> +             /* Ignore these unchangable bits */
>> +             if (mask & IPS_UNCHANGEABLE_MASK)
>> +                     continue;
>
> How about clear the bits of on and off with IPS_UNCHANGEABLE_MASK before
> loop.
> Like "on &= ~ IPS_UNCHANGEABLE_MASK";
> Then the "if (mask & IPS_UNCHANGEABLE_MASK)" could be removed.

No, it's better to do this together, there are two invocations, it's not good to
copy these codes twice.

>
> BTW, when some bits are set both of on and off, the "on" would be effective,
> but "off" not.

This won't happen, see the invocation:
1. __ctnetlink_change_status(ct, status, 0);
2. __ctnetlink_change_status(ct, status, ~status);

> So I think we could use BUILD_BUG_ON to avoid it during building.
> BUILD_BUG_ON(on&mask);

Btw, this won't help, BUILD_BUG_ON is only effective on compile time,
but "on" and "off" will be modified at the running time.
