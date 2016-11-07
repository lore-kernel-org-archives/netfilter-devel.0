From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix oops when inserting an
 element into a verdict map
Date: Mon, 7 Nov 2016 20:52:43 +0800
Message-ID: <CAML_gOfCp4nkGOo-qcYm+AQrkLADLP4YNqSXadSRO3KgoUjjcg@mail.gmail.com>
References: <1478414401-21488-1-git-send-email-zlpnobody@163.com> <CAOkSjBgfQTVMPJxiiNEL+J15EWT_3u+0HP_7KHTYHu8KhS8Sug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, dalegaard@gmail.com
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:35631 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752431AbcKGMwo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Nov 2016 07:52:44 -0500
Received: by mail-ua0-f195.google.com with SMTP id 50so5966665uae.2
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Nov 2016 04:52:43 -0800 (PST)
In-Reply-To: <CAOkSjBgfQTVMPJxiiNEL+J15EWT_3u+0HP_7KHTYHu8KhS8Sug@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-11-07 18:58 GMT+08:00 Arturo Borrero Gonzalez <arturo@debian.org>:
> On 6 November 2016 at 07:40, Liping Zhang <zlpnobody@163.com> wrote:
>> From: Liping Zhang <zlpnobody@gmail.com>
>>
>> Dalegaard says:
>>  The following ruleset, when loaded with 'nft -f bad.txt'
>>  ----snip----
>>  flush ruleset
>>  table ip inlinenat {
>>    map sourcemap {
>>      type ipv4_addr : verdict;
>>    }
>>
>>    chain postrouting {
>>      ip saddr vmap @sourcemap accept
>>    }
>>  }
>>  add chain inlinenat test
>>  add element inlinenat sourcemap { 100.123.10.2 : jump test }
>>  ----snip----
>
> Perhaps it would be good to have this simple testcase in the nft shell
> testsuite so we avoid future regressions.

Good, I will send the related patch later.
