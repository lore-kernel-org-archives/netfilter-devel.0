From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf 1/5] netfilter: nfnl_cthelper: don't report error if
 NFCTH_PRIV_DATA_LEN is empty
Date: Tue, 21 Mar 2017 22:26:35 +0800
Message-ID: <CAML_gOde+SUbv1zLMxVhixBo7Ji8PCayNiWi7nL8biLCrEdAAg@mail.gmail.com>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
 <1489934162-7415-2-git-send-email-zlpnobody@163.com> <20170321101828.GA1940@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:34911 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757284AbdCUO0z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 10:26:55 -0400
Received: by mail-vk0-f68.google.com with SMTP id z204so5341813vkd.2
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 07:26:36 -0700 (PDT)
In-Reply-To: <20170321101828.GA1940@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-03-21 18:18 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Sun, Mar 19, 2017 at 10:35:58PM +0800, Liping Zhang wrote:
>> From: Liping Zhang <zlpnobody@gmail.com>
>>
>> Currently, when we create cthelper via nfnetlink, -EINVAL will be
>> returned if the NFCTH_PRIV_DATA_LEN attribute is empty.
>>
>> But enforcing the user to specify the NFCTH_PRIV_DATA_LEN attr seems
>> unnecessary, so it's better to set the helper->data_len to zero if
>> the NFCTH_PRIV_DATA_LEN attribute is empty.
>>
>> Found by running example program from libnetfilter_cthelper:
>>   # ./libnetfilter_cthelper/examples/nfct-helper-add test 1
>>   error: Invalid argument
>
> I suggest you fix this userspace example instead, we should always
> send NFCTH_PRIV_DATA_LEN. This is integral part of the helper
> description.
>
> NFCTH_ATTR_PRIV_DATA_LEN has been always set from the conntrack-tools,
> so most likely this example just got outdated at some point of the
> development and nobody noticed so far.

OK, get it. I will send a patch to fix the example codes.

>
> Thanks.
