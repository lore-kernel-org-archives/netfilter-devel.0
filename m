From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix missmatch in big-endian system
Date: Thu, 9 Mar 2017 16:29:02 +0100
Message-ID: <CAOkSjBg2rzgbyn54RjzQP6bKFPrDOcZ5EAh-nMqXB4UJ=Q64uA@mail.gmail.com>
References: <1488984858-29290-1-git-send-email-zlpnobody@163.com>
 <CAOkSjBhyOiSw1ucabBrsrjdpmBLgbej6=_9NUuKsfri5YmZUqw@mail.gmail.com> <CAML_gOddzk4GV0DDaqEM+egkmXv-pm+X9GQDV6vcxW83MCpfQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33812 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754243AbdCIPaM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2017 10:30:12 -0500
Received: by mail-io0-f170.google.com with SMTP id g6so30420822ioj.1
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Mar 2017 07:29:24 -0800 (PST)
Received: from mail-io0-f178.google.com (mail-io0-f178.google.com. [209.85.223.178])
        by smtp.gmail.com with ESMTPSA id 141sm3078966ioe.58.2017.03.09.07.29.23
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Mar 2017 07:29:23 -0800 (PST)
Received: by mail-io0-f178.google.com with SMTP id f84so29247107ioj.0
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Mar 2017 07:29:23 -0800 (PST)
In-Reply-To: <CAML_gOddzk4GV0DDaqEM+egkmXv-pm+X9GQDV6vcxW83MCpfQQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 March 2017 at 13:46, Liping Zhang <zlpnobody@gmail.com> wrote:
>>
>> Any chance the compiler detects the double assignment and removes the first one?
>
> This will never happen, since these two assignment statements are not identical.

But perhaps the compiler can look beyond the high level statement? a
present or future compiler may detect (at low level) that you are
indeed writing the very same piece of memory twice in a row.

The kernel sources has 'memzero_explicit' [0] but it seems to use
'volatile' which perhaps isn't useful either [1].

Anyway, I was simply curious.

[0] http://lxr.free-electrons.com/source/lib/string.c#L679
[1] http://www.daemonology.net/blog/2014-09-04-how-to-zero-a-buffer.html
