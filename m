From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: reject statement - "crazy" parse error?
Date: Fri, 28 Oct 2016 11:07:24 +0200
Message-ID: <CAOkSjBgd0UJzg3Xp-ub4twebDmHdVJ25e5GkWEw5h2XUmQxKxQ@mail.gmail.com>
References: <aea0c58c-dd68-bffb-859c-81f77ebe8dfd@nurealm.net>
 <CAOkSjBjd6CwTcMv_G1p1KmWnQukHUn6f4oCoaeZHmXEyJDiW4g@mail.gmail.com> <5a8da546-8694-40b8-b514-1f80bff71a44@nurealm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: James Feeney <james@nurealm.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:36098 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752022AbcJ1JHr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 05:07:47 -0400
Received: by mail-lf0-f42.google.com with SMTP id b75so51638041lfg.3
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 02:07:46 -0700 (PDT)
Received: from mail-lf0-f50.google.com (mail-lf0-f50.google.com. [209.85.215.50])
        by smtp.gmail.com with ESMTPSA id s10sm1903879lja.26.2016.10.28.02.07.44
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Oct 2016 02:07:44 -0700 (PDT)
Received: by mail-lf0-f50.google.com with SMTP id f134so46788840lfg.2
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 02:07:44 -0700 (PDT)
In-Reply-To: <5a8da546-8694-40b8-b514-1f80bff71a44@nurealm.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26 October 2016 at 20:50, James Feeney <james@nurealm.net> wrote:
>> I can't reproduce the issue here.
>
> Thanks Arturo.  What distribution are you using?  Hmm - any suggestions about
> how to "poke" at this issue on my end?
>

I'm using Debian, of course :-)

You could check the config of your kernel. That error message seems to
come from the kernel.

Perhaps, the reject modules were not configured.
Please, check NF_TABLES* and NFT_* symbols (also NF_*)

For the record, the debian kernel 4.7.0 contains:

% egrep NF_TABLES\|NFT_\|NF_ /boot/config-$(uname -r) | grep -i reject
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_NFT_BRIDGE_REJECT=m


> BTW, I can load this file without problem when replacing "reject" with "drop".
> Whatever the problem, it is "triggered" by the "reject" statement.
>
> I was concerned that perhaps my system was in some inconsistent upgrade state,
> because I noticed I was actually still running kernel 4.8.1-1, not 4.8.4-1.
>

Using a newer kernel is always a good idea. Newer ones will contain
up-to-date code, fixes.
So yes, some behaviour may have changed between 4.8.1 and 4.8.4.

>
> /etc/test.nft:4:1-2: Error: Could not process rule: Operation not supported
> table ip private {
> ^^
>
> Well, that's not good, because something changed, from "No such file or
> directory" to "Operation not supported", but it is still not right.  Of course,
> in both cases, the error messages are "useless", not saying *what* file, and not
> saying *what* operation.
>

Yes, the error reporting in the 'nft -f' situation is something to improve,
specially with kernel reported errors.
This is even worse in the case of nested includes.
