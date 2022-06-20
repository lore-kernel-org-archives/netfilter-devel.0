Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A34C43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 10:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240372AbiFTKBo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 06:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236288AbiFTKBn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 06:01:43 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09E5219F
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 03:01:42 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id s20-20020a056830439400b0060c3e43b548so7976055otv.7
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 03:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=fu4YN2YHVD8MJpZ6CZg8enAAO6AbalEs2jkOA6wKqeU=;
        b=HYO3ZkSOdRkNbY/pyKkgbq1PBhL7Gjp4jGb/NEQ9mpruRYZ5Ga7JjtmAh2uM9CPlAa
         bwO68jexkJnqRj+QtnlDxN2D2FclzfvbmOP3SlTl42gnDyX0vdMV/qmO1mnhSKRI8+uo
         90xu5F9no17az/pxt4ZGHM2Eygg/R1RQeoNM/m8KzhqXlTL1jIDJoSlycoCz1mf8O0Iu
         7QyxrIjtPaNXNwTVNPyze/3dvzpb7MiBGXExnKigUyJLGhbEaJC9GjwYh34I6IqEVI3O
         1w5vClrtlI/B4ubhH2FXBHrMFKhouunMJEXVzoZQgaVALYi3X1lc3CJjEKbhuh9ap3ZN
         g6PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=fu4YN2YHVD8MJpZ6CZg8enAAO6AbalEs2jkOA6wKqeU=;
        b=bsOj1xLZjsgkIVBt3Ws5QoC9AmKd6CTtoR8LUBQ+G9lOJ6qloTr3W4FTh7l9TG5yL7
         aAiwduiwaMD9w0PlrgFHVVFoZuB/OjFGHmHUc1uQqoDCguFb4ZC7H2kbVt0biPIQxIvf
         m64J+SSrrPzNNa0zJg/NZ1jlx7nsVZkajiyd9spAFB5CKVuJrYsyuHtDvw3ya/8HXtn4
         3Y3V0pgRwzFCG79t+HZZd6BjsITl0UAqMd7TJFH8MAxfF9ec/oCY+74kU6FdCIqT5gr4
         qemLKAiz6Sg1grfi80okk62zG8NaQRmQXx6mevgxaiCSZW9iN8gLRMaLArNl9KPjJ4TS
         Ec1Q==
X-Gm-Message-State: AJIora+R06D4viLjgC8vZyAWHeeaAolTSxAbdwClYhIJ0tXkBJx/Xufa
        GgiqCo91sQb+5ZJjjtKqOoVPPL+9dV/DiqCWqHk=
X-Google-Smtp-Source: AGRyM1vrF5sMpZQYl/EN7tcB1DnbQknGBbIL1ddsT0sX4oy2QE1SrTCnwM2lvSr60Gq/MW1IeijIgoeQJAWgGDkiavE=
X-Received: by 2002:a9d:7857:0:b0:60c:4f4d:465b with SMTP id
 c23-20020a9d7857000000b0060c4f4d465bmr9117832otm.272.1655719302329; Mon, 20
 Jun 2022 03:01:42 -0700 (PDT)
MIME-Version: 1.0
References: <CANKwiJVSW3RjhHDnziGjWenApAcvdSAqBTi7MfHqyiyHd4_F=A@mail.gmail.com>
 <20220616202014.e7ebc6df8f8f0f1fdce27e12@plushkava.net> <CANKwiJX5_67uPPqdwoH3-gbY11Dmj29Hjse+8m3-bsJD0hHVEg@mail.gmail.com>
 <Yq0mDdXioEEC10KN@slk15.local.net>
In-Reply-To: <Yq0mDdXioEEC10KN@slk15.local.net>
From:   Gmail Support <testingforadept@gmail.com>
Date:   Mon, 20 Jun 2022 11:01:31 +0100
Message-ID: <CANKwiJV8R=J1CN0PyYhnjXT8+bwfvoYj3VH=KOGA5Kocfzwwmw@mail.gmail.com>
Subject: Re: Support for String Match Blocking in NFTables
To:     duncan_roe@optusnet.com.au,
        Gmail Support <testingforadept@gmail.com>,
        Kerin Millar <kfm@plushkava.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello - Thank you for your email, fixed offset is not an option right
now as we have different flavours of log shipping services so I will
check the two suggestion provided in the link.

Thanks.

Respectfully.

On Sat, Jun 18, 2022 at 2:10 AM Duncan Roe <duncan_roe@optusnet.com.au> wrote:
>
> On Fri, Jun 17, 2022 at 05:14:53PM +0100, Gmail Support wrote:
> > Okay thank you, is there any plans to support this extension in the future?
> >
> > On Thu, Jun 16, 2022 at 8:20 PM Kerin Millar <kfm@plushkava.net> wrote:
> > >
> > > On Thu, 16 Jun 2022 10:15:55 +0100
> > > Gmail Support <testingforadept@gmail.com> wrote:
> > >
> > > > Hello,
> > > >
> > > > We recently migrated our servers from RedHat to Ubuntu based systems.
> > > > We used to have an IPtables rule that was blocking packets matching a
> > > > specific application file and below was the rule we had deployed.
> > > >
> > > > -A INPUT -p udp -m udp --dport 514 -m string --string
> > > > "someapplication.exe" --algo bm -j DROP
> > > >
> > > > In NFtables, I read in the blogs that string based blocking is not
> > > > possible. In the man page of Ubuntu, I see a note "The  string  type
> > > > is  used  to  for character strings. A string begins with an
> > > > alphabetic character (a-zA-Z) followed by zero or more alphanumeric
> > > > characters or the  characters  /, -, _ and .. In addition anything
> > > > enclosed in double quotes (") is recognized as a string."
> > > >
> > > > Can you please confirm if string based blocking is supported in Nftables.
> > >
> > > There is no equivalent to the string extension in nftables. While it
> > > is possible to match against a portion of the packet's payload using a
> > > raw payload expression, doing so requires that the offset and length
> > > of the data be specified. That is, it cannot search for a pattern and,
> > > thus, match at any potential offset.
> > >
> > > --
> > > Kerin Millar
>
> You can do string matching by writing a libnetfilter_queue program.
>
> Follow the documentation at
> https://netfilter.org/projects/libnetfilter_queue/doxygen/html/
>
> There are 2 sets of functions: the "deprecated" functions will run faster with
> your requirements. They're not deprecated at all, only the underlying library
> used by the current implementation is deprecated.
>
> Cheers ... Duncan.
