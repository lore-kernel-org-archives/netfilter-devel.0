From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCHv3] tests: py: Add test for ambiguity while setting the value
Date: Wed, 21 Jun 2017 14:20:59 +0530
Message-ID: <CAOfkYf6pn6jTUjVpwcYok3QuXTp_v8SX17hNeNHAPfiUQhALYw@mail.gmail.com>
References: <1497641742-25272-1-git-send-email-mayhs11saini@gmail.com>
 <20170618092913.GA8026@salvia> <20170618094830.GA3183@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34533 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752566AbdFUIvB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2017 04:51:01 -0400
Received: by mail-oi0-f48.google.com with SMTP id b6so86598742oia.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2017 01:51:00 -0700 (PDT)
In-Reply-To: <20170618094830.GA3183@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 18, 2017 at 3:18 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Jun 18, 2017 at 11:29:13AM +0200, Pablo Neira Ayuso wrote:
>> On Sat, Jun 17, 2017 at 01:05:42AM +0530, Shyam Saini wrote:
>> > This test checks bug identified and fixed in the commit mentioned below
>> > In a statement if there are  multiple src data then it  would be
>> > totally ambiguous to decide which value to set.
>> >
>> > Before the commit was made it returned 134(BUG), but now it returns 1
>> > i.e, an error message.
>>
>> Applied, thanks.
>>
>> One change though before applying, see below.
>
> BTW, shouldn't we check for explicit exit code 1 in rule_add() in
> tests/py/?
>
>> > Test: 986dea8 ("evaluate: avoid reference to multiple src data in
>> > statements which set values")
>
> It would be good to run this test with and without 986dea8.
>
> If we hit exit code 134, the py test should complain even if we say
> "fail".
>
> Basically, test py with 'fail' is fine if we fail gracefully, not if
> we hit BUG.
>
> Probably just a matter of making a oneline patch for nft-tests.py to
> enforce this?
Patch sent,

Thanks
