From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCH 1/2] tests: shell: Add test for incomplete set add set command
Date: Mon, 26 Jun 2017 23:02:34 +0530
Message-ID: <CAOfkYf7jSLBq65ALTjdi0JK=ajPkg_db0sSYPkv7tFrLA2u1gg@mail.gmail.com>
References: <1498219556-25179-1-git-send-email-mayhs11saini@gmail.com> <20170626165942.GA8489@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:33684 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdFZRcg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 13:32:36 -0400
Received: by mail-ot0-f196.google.com with SMTP id q16so769548otb.0
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 10:32:35 -0700 (PDT)
In-Reply-To: <20170626165942.GA8489@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 26, 2017 at 10:29 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Jun 23, 2017 at 05:35:55PM +0530, Shyam Saini wrote:
>> Before the [Test] commit if we run nft with incomplete "add set"
>> command it caused segmentation fault and exit with error code 139 and
>> further it didn't throw any error message.
>>
>>   For example:
>>     $ sudo nft add set t s
>>
>> But after the [Test] commit it throws syntax error message and exits with
>> return value 1.
>>
>>   For example:
>>     $ sudo nft add set t s
>>     <cmdline>:1:12-12: Error: syntax error, unexpected newline, expecting '{'
>>     add set t s
>>                ^
>>
>> This commit tests changes made in the [Test] commit.
>
> Applied, thanks.
>
> I have reworked a bit your commit message, it looks a bit convoluted.

Thanks a lot :)

> No worries, have a look at what I pushed out for reference.

Shouldn't we follow conventions mentioned in "scripts/checkpatch.pl" ?

Thanks,
shyam
