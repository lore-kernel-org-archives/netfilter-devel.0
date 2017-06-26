From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCH 1/2] tests: shell: Add test for incomplete set add set command
Date: Mon, 26 Jun 2017 23:46:50 +0530
Message-ID: <CAOfkYf4+b4yM7YVBozdJ9OyQsULZ=8juNGcz8SVdpT=skJRUHQ@mail.gmail.com>
References: <1498219556-25179-1-git-send-email-mayhs11saini@gmail.com>
 <20170626165942.GA8489@salvia> <CAOfkYf7jSLBq65ALTjdi0JK=ajPkg_db0sSYPkv7tFrLA2u1gg@mail.gmail.com>
 <20170626173725.GA12032@salvia> <CAOfkYf6Ap6__=6kTodK9m5jhvq6yU4cLM1E8WK_NwE8dEwBKjw@mail.gmail.com>
 <20170626180834.GA12436@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35915 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbdFZSQw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 14:16:52 -0400
Received: by mail-oi0-f45.google.com with SMTP id p187so5324759oif.3
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 11:16:52 -0700 (PDT)
In-Reply-To: <20170626180834.GA12436@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 26, 2017 at 11:38 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jun 26, 2017 at 11:24:23PM +0530, Shyam Saini wrote:
>> On Mon, Jun 26, 2017 at 11:07 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Mon, Jun 26, 2017 at 11:02:34PM +0530, Shyam Saini wrote:
>> >> On Mon, Jun 26, 2017 at 10:29 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> >> > On Fri, Jun 23, 2017 at 05:35:55PM +0530, Shyam Saini wrote:
>> >> >> Before the [Test] commit if we run nft with incomplete "add set"
>> >> >> command it caused segmentation fault and exit with error code 139 and
>> >> >> further it didn't throw any error message.
>> >> >>
>> >> >>   For example:
>> >> >>     $ sudo nft add set t s
>> >> >>
>> >> >> But after the [Test] commit it throws syntax error message and exits with
>> >> >> return value 1.
>> >> >>
>> >> >>   For example:
>> >> >>     $ sudo nft add set t s
>> >> >>     <cmdline>:1:12-12: Error: syntax error, unexpected newline, expecting '{'
>> >> >>     add set t s
>> >> >>                ^
>> >> >>
>> >> >> This commit tests changes made in the [Test] commit.
>> >> >
>> >> > Applied, thanks.
>> >> >
>> >> > I have reworked a bit your commit message, it looks a bit convoluted.
>> >>
>> >> Thanks a lot :)
>> >>
>> >> > No worries, have a look at what I pushed out for reference.
>> >>
>> >> Shouldn't we follow conventions mentioned in "scripts/checkpatch.pl" ?
>> >
>> > Interesting.
>> >
>> > So the [test] thing is something that checkpatch.pl suggests, right?
>> yes something like that.
>>
>> > I would like to know more about that new thing, do you have
>> > documentation about this?
>>
>> No documentation but yeah it throws following error when convention is
>> not followed.
>>
>> "ERROR: Please use git commit description style 'commit <12+ chars of
>> sha1> ("<title line>")' - ie: 'commit c6cd7c22548a ("src: fix crash
>> when inputting an incomplete set add command")'"
>
> Ah, that's different thing.
>
> so no need for the [Test] tag you are adding.

Sure
> This means that:
>
> commit c6cd7c22548a ("src: fix crash when inputting an incomplete set add command")
>
> is the right way to refer to commits. That's a valid thing indeed, we
> should stick to that.

After adding  "commit" keyword in the same commit message the error gone .
Sorry, my bad.

> Let's stick to this in follow up patches, OK?
Sure

Thanks a lot
