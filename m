From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: build failure if --with-xtables [WAS: nftables 0.7 release]
Date: Wed, 4 Jan 2017 08:35:33 +0100
Message-ID: <CAOkSjBi922Q4rGLt5Tg34TvBi7swfCuAPNKQwxTiRkJyTCGd0Q@mail.gmail.com>
References: <20161220204636.GA11674@salvia> <20170103155614.40273a5e.robby@rlworkman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Robby Workman <robby@rlworkman.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35917 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753604AbdADHfz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Jan 2017 02:35:55 -0500
Received: by mail-io0-f173.google.com with SMTP id p127so2818359iop.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jan 2017 23:35:55 -0800 (PST)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com. [209.85.223.182])
        by smtp.gmail.com with ESMTPSA id i62sm33745861itb.12.2017.01.03.23.35.54
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Jan 2017 23:35:54 -0800 (PST)
Received: by mail-io0-f182.google.com with SMTP id d9so448308755ioe.0
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jan 2017 23:35:54 -0800 (PST)
In-Reply-To: <20170103155614.40273a5e.robby@rlworkman.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 3 January 2017 at 22:56, Robby Workman <robby@rlworkman.net> wrote:
> On Tue, 20 Dec 2016 21:46:36 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
>> Hi!
>>
>> The Netfilter project proudly presents:
>>
>>         nftables 0.7
>>
>> This release contains many accumulated bug fixes and new features
>> available up to the (upcoming) Linux 4.10-rc1 kernel release.
>>
>> * Facilitate migration from iptables to nftables:
>>
>>   At compilation time, you have to pass this option.
>>
>>   # ./configure --with-xtables
>
>
> I get a build failure with this option - bug filed with some details:
> https://bugzilla.netfilter.org/show_bug.cgi?id=1110

the required xlate methods of iptables have not been released so far.
They are not present in iptables 1.6.0.
