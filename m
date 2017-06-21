From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCHv3] tests: py: Add test for ambiguity while setting the value
Date: Wed, 21 Jun 2017 14:16:35 +0530
Message-ID: <CAOfkYf7th9qh81iUD-c_AFYHy05t=ccjTj0=UZ6XYfeU7u41hQ@mail.gmail.com>
References: <1497641742-25272-1-git-send-email-mayhs11saini@gmail.com>
 <20170618092913.GA8026@salvia> <20170618093137.GA12806@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35565 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdFUIqh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2017 04:46:37 -0400
Received: by mail-oi0-f54.google.com with SMTP id c189so63560158oia.2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2017 01:46:37 -0700 (PDT)
In-Reply-To: <20170618093137.GA12806@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 18, 2017 at 3:01 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
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
>>
>> > Test: 986dea8 ("evaluate: avoid reference to multiple src data in
>> > statements which set values")
>
> BTW, please update .gitconfig in your home to add:
>
> [core]
>         abbrev = 12
>
> So we get commit abbrev of 12 chars at least.
>
> 7 may lead to ambiguities in the future, as a hash with the same
> prefix may show up later on.
Done

Thanks a lot :)

> Thanks!
