Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E48DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 11:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85D2160F5A
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 11:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239782AbhJ0LGY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 07:06:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233865AbhJ0LGY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 07:06:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635332638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vMgU4gLia5wjMZaTH8KVHDMojxGN1eGBidy0GPnbwZ0=;
        b=Vz4KyZdWSEoj4kQBIv9nOHpe3a19shHz1VnRZ1mICxT7qXn/wSYB79F3sGRbp3FCDeVo3w
        0ADnIMToVrUo4HcnXtLveVdZtYM07wtYBSJFplImPW6M0zURrvK95wS0UH4Y8PWsgS5z4d
        o3F/pjkPaO6LKue5zKN22YoHHvbHgWM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-cRlAgUF8OYGJgouEDgBmOg-1; Wed, 27 Oct 2021 07:03:57 -0400
X-MC-Unique: cRlAgUF8OYGJgouEDgBmOg-1
Received: by mail-ed1-f70.google.com with SMTP id i9-20020a508709000000b003dd4b55a3caso1917898edb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Oct 2021 04:03:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:date:message-id:mime-version:content-transfer-encoding;
        bh=vMgU4gLia5wjMZaTH8KVHDMojxGN1eGBidy0GPnbwZ0=;
        b=IxSqfADWt9jCpFFJSfhI7z90JZVEfh3Jkqa215b8M9dUPYA0tXEuWwEBSKQN5itOZ1
         xnl40iMrL58wBytyhVoPiU5pXzmZDXiBtfFUj6vDp/Sjoc5zXrV1quDXCeW71um9LVt8
         /Q6SPdAoF3kS7SnSbZQ9OvagPjbhp9+SAqTaLXgTMiz1QvgID2bmLWhmewqAylnUwgv8
         7VgbyN/twb0ZzTd8C4HjzDtMsep+fSJ7sEvbO8uMaXS1vF5uyAuM/+axWOyOE8OXKrcA
         b3wNRrSzOlNVubmNneLQ2WXWOMnA+ZoYcdBqAzq4NmH1djqUL3xrd0d0qFH3E/8XNGKQ
         kTzQ==
X-Gm-Message-State: AOAM530KHHWBPAjQsYXLpW1Adz6dlxlHd3ANmKZVC3McuwJX6F/xLIh+
        tm0FyxlH6JMCTkMfYA7jw4nFbsKo5/1eeBmOegQorMBcbYu9IjZchxYYGceVcfcValH99UnLcmy
        zSFrYwSbvC3bD0dqWhmNgyT2G7cLz
X-Received: by 2002:a17:906:3784:: with SMTP id n4mr37880086ejc.129.1635332635574;
        Wed, 27 Oct 2021 04:03:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqdKuaD9mjVDkmUvTPlJZhgPBLTt+iC0wxpBfG7V/8pjJ363lXhnrkRgccxgLbvKmj18AKmA==
X-Received: by 2002:a17:906:3784:: with SMTP id n4mr37880050ejc.129.1635332635315;
        Wed, 27 Oct 2021 04:03:55 -0700 (PDT)
Received: from localhost ([185.112.167.53])
        by smtp.gmail.com with ESMTPSA id bi23sm10698086ejb.122.2021.10.27.04.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 04:03:54 -0700 (PDT)
From:   =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] tests: shell: README: copy edit
In-Reply-To: <YXkmZaJit3R8XpzL@salvia>
References: <20211020124512.490288-1-snemec@redhat.com>
 <20211020150402.GJ1668@orbyte.nwl.cc>
 <20211021103025+0200.945334-snemec@redhat.com>
 <20211021102644.GM1668@orbyte.nwl.cc>
 <20211021130323+0200.342006-snemec@redhat.com> <YXkWeFPM3ixQ2cTb@salvia>
 <20211027115112+0200.686229-snemec@redhat.com> <YXkmZaJit3R8XpzL@salvia>
User-Agent: Notmuch/0.33.2 (https://notmuchmail.org) Emacs/29.0.50
 (x86_64-pc-linux-gnu)
Date:   Wed, 27 Oct 2021 13:04:38 +0200
Message-ID: <20211027130438+0200.462117-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 27 Oct 2021 12:13:57 +0200
Pablo Neira Ayuso wrote:

> On Wed, Oct 27, 2021 at 11:51:12AM +0200, =C5=A0t=C4=9Bp=C3=A1n N=C4=9Bme=
c wrote:
>> > * patch 2/3, what is the intention there? a path to the nft executable
>> >   is most generic way to refer how you use $NFT, right?
>>=20
>> No, not since 7c8a44b25c22. I've always thought that 'Fixes:' is mostly
>> or at least also meant for humans, i.e., that the person reading the
>> commit message and wanting to better understand the change would look at
>> the referenced commit, but if that is a wrong assumption to make, I
>> propose to add the following description:
>
>>   Since commit 7c8a44b25c22, $NFT can contain an arbitrary command, e.g.
>>   'valgrind nft'.
>
> OK, but why the reader need to know about former behaviour? The git
> repository already provides the historical information if this is of
> his interest. To me, the README file should contain the most up to
> date information that is relevant to run the test infrastructure.

I agree, and that's what the patch does: 'a path to the nft executable'
is the former behaviour, arbitrary command is the most up to date
information. (The "Since..." text above is my proposal for the commit
description, not for the README file.)

>> > * patch 3/3, I'd add a terse sentence so I do not need to scroll down
>> >   and read the update to README to understand what this patch updates.
>> >   I'd suggest: "Test files are located with find, so they can be placed
>> >   in any location."
>>=20
>> That text was just split to a separate paragraph, it has nothing to do
>> with the actual change.
>
> OK, then please document every update in your patch.

>> > Regarding reference to 4d26b6dd3c4c, not sure it is worth to add this
>> > to the README file. The test infrastructure is only used for internal
>> > development use, this is included in tarballs but distributors do not
>> > package this.
>>=20
>> IMO this argument should speak _for_ including the commit reference
>> rather than omitting it, as the developer is more likely to be
>> interested in the commit than the consumer.
>>
>> I thought about making the wording simply describe the current state
>> without any historical explanations, but saying "Test files are
>> executable files matching the pattern <<name_N>>, where N doesn't mean
>> anything." seemed weird.
>
> For historical explanations, you can dig into git.

Would the following README text work for you?

  Test files are executable files matching the pattern <<name_N>>,
  where N has no meaning. All tests should return 0 on success.

  Since they are located with `find', test files can be put in any
  subdirectory.

Maybe saying "where N should be 0 in all new tests" would be less
strange?

I think both are significantly less helpful than my original version,
but at least they aren't wrong like the current text.

Proposed commit description, based on your comments:

  Since commit 4d26b6dd3c4c, test file name suffix no longer reflects
  expected exit code in all cases.

  Move the sentence "Since they are located with `find', test files can
  be put in any subdirectory." to a separate paragraph.

--=20
=C5=A0t=C4=9Bp=C3=A1n

