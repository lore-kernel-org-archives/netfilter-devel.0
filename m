From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCH nft] parser_bison: restore nft {import,export} ruleset
Date: Thu, 15 Feb 2018 01:25:04 +0530
Message-ID: <CAOfkYf5dGcKkW4ErvHS0F_px8V96OLp-NAKv7KSJ2jPysyNA1A@mail.gmail.com>
References: <20180214183244.16184-1-pablo@netfilter.org> <CAOfkYf4aYq8bkzC5i+mrxrxO0EgzxzL46yphGKfUZettW4LspA@mail.gmail.com>
 <20180214191652.ao7ethqbt3qwvvqz@salvia> <20180214192712.2veqolrbrgq3n255@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, anthonyryan1@gmail.com,
        Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:35602 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030255AbeBNTzF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 14:55:05 -0500
Received: by mail-ot0-f195.google.com with SMTP id a2so21454995otf.2
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 11:55:05 -0800 (PST)
In-Reply-To: <20180214192712.2veqolrbrgq3n255@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> On Wed, Feb 14, 2018 at 08:16:52PM +0100, Pablo Neira Ayuso wrote:
>> On Thu, Feb 15, 2018 at 12:34:31AM +0530, Shyam Saini wrote:
>> > Hi Pablo,
>> >
>> > On Thu, Feb 15, 2018 at 12:02 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > > Restore original syntax for the yet experimental VM low-level json
>> > > representation.
>> > >
>> > > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1224
>> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> > > ---
>> > > I asked for this change to make room for the high-level json
>> > > representation, but we can use -j options for this instead.  Given there
>> > > are more users for the json representation that I expected, I'm fixing
>> > > it myself by restoring the former behaviour.
>> >
>> > Why would one use "nft export"  without "nft import".
>> > if someone exports rules in json then they can't use those rules
>> > given the fact that "nft import" was not available earlier.
>> >
>> > Am i missing something?
>>
>> With this patch nft import and nft export works as expected, ie.
>>
>>         nft export ruleset json > file.json
>>         nft import ruleset json < file.json
>>
>> I'm just restoring 'nft export ruleset json' with this patch, it seems
>> there are more users of this than I expected, so let's restore this
>> before 0.8.3 is released, that's my proposal.
>
> Oh, probably you got confused because the patch title refers to nft
> import when it should only refer to nft export ruleset json?

No, I mean in some previous mail Phil mentioned that it could break user's
script.
 I was thinking why one would use "nft export json" alone.
Earlier we didn't have nft import command.

So lets say if some user do "nft export json >file.json" then the
rules in file.json
are of no use without "nft import json" because we had no way to
import or use them again.

Sorry, I missed previous mail and couldn't follow up.


Thanks!
