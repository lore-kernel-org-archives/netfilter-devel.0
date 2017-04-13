From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: make it safer when updating ct->status
Date: Thu, 13 Apr 2017 11:55:07 +0800
Message-ID: <CAML_gOez2Tow+4rdSPHqsnmR9YSHuwyQVEiL75GW8+v83LUgjw@mail.gmail.com>
References: <1492012596-60889-1-git-send-email-zlpnobody@163.com>
 <000001d2b3ff$9777d110$c6677330$@foxmail.com> <CAML_gOeLBvnCYrYH7JzaJKg+UJ-hm+ctKGvJRnJkfsN8EEswhg@mail.gmail.com>
 <000201d2b405$3c071920$b4154b60$@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, cernekee@chromium.org
To: Gao Feng <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:36762 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751750AbdDMDzI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2017 23:55:08 -0400
Received: by mail-ua0-f181.google.com with SMTP id a1so27068503uaf.3
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Apr 2017 20:55:08 -0700 (PDT)
In-Reply-To: <000201d2b405$3c071920$b4154b60$@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Feng,

2017-04-13 11:22 GMT+08:00 Gao Feng <gfree.wind@foxmail.com>:
[...]
>> No, it's better to do this together, there are two invocations, it's not good to
>> copy these codes twice.
>
> You mean " on &= ~ IPS_UNCHANGEABLE_MASK " and " off &= ~ IPS_UNCHANGEABLE_MASK " seems duplicated?

I see. I misunderstood your initial meaning. So I will send V2 :)
