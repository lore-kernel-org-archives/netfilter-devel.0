Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23309C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jun 2022 01:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbiFRBKp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jun 2022 21:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiFRBKo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jun 2022 21:10:44 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B306AA60
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2022 18:10:42 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id d14so2079128pjs.3
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2022 18:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=nQudMtFlx8pRbwNTA0WxAt/gguZbNmqcRx5kLIU4k9g=;
        b=M9SHq2s5rdAi6Yv/oOM1j0wcR/V6Le+iwNuHdknPH6baB/ygZ5uefgssSCrHlO/6uF
         YWR1Lj9bqajZEs0iP02xiHf/mig3qFCvh7N7CoNZ2mISRv48fdeosnI+hAFz8XqkyAgF
         GDJhq9VIpavBB02k42mCstH6HqzoazyANERVIJnT4K1//ScRTtaQ9xdXaWYuPf45xIpw
         8DNe/A0I/khGLrWtUpJXJT7FUoSMy21YXoWPzl6Ika+utIzB7yebcVoZolFslhSzKNNX
         wgHGcyPdFWR6G8LwGlyCP6LF3je9EV0t1HaG9HHSI2UO/Xi4Xa5UWoimcb5x0uq8Ftx0
         uT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :reply-to:mail-followup-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=nQudMtFlx8pRbwNTA0WxAt/gguZbNmqcRx5kLIU4k9g=;
        b=CzBwPHKZDlTqPHsBniGftjiXRyBlLSRCpd6IsEX+nuoow4b0rSjnDZFePi5VuBgNho
         JH2o0vuk6YzcwKxKUFkqJtCtPO+kpyxlEmTBWkSMbMnvioh7KcAyiZ0oSP7Fb2mMYS98
         m2BV1TSCJJna7Mc0V/C3Rq4/HL6G3JbIZso4iyqNd9d2d++8REYqqKju/rbH7vd7xU/s
         asmZMTBC7a9SeHUbE91dY00HkVshLDjmMvmIPAHKvqR0E0kytLBFQvn5Hcq6ykB+RZ1F
         YbL19yVZK/MGoxfJXAKzwHjm4a/xLzy91oZfLinocIk9sxNsRv0l3MWkBP6w17y6Lr+z
         vtIQ==
X-Gm-Message-State: AJIora90DUEM4zz6e4HIR+OgqIzV/89MGbPOhxDlZu98+dVvyczjZog5
        BMsBsCiLufg/Q3KwGrU7gC7bCtLyz/8=
X-Google-Smtp-Source: AGRyM1s9HHTyTGK24/PphQw6LcpsbxNPUD2VgMMV5CY0Iabj2rFaq4gJsxBf1ptwpVOQLfN00WniQw==
X-Received: by 2002:a17:903:2585:b0:163:dc33:6b7e with SMTP id jb5-20020a170903258500b00163dc336b7emr11974159plb.172.1655514642083;
        Fri, 17 Jun 2022 18:10:42 -0700 (PDT)
Received: from slk15.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id q3-20020a170902f78300b0016788487357sm4149000pln.132.2022.06.17.18.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 18:10:41 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Sat, 18 Jun 2022 11:10:37 +1000
To:     Gmail Support <testingforadept@gmail.com>
Cc:     Kerin Millar <kfm@plushkava.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Support for String Match Blocking in NFTables
Message-ID: <Yq0mDdXioEEC10KN@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Gmail Support <testingforadept@gmail.com>,
        Kerin Millar <kfm@plushkava.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <CANKwiJVSW3RjhHDnziGjWenApAcvdSAqBTi7MfHqyiyHd4_F=A@mail.gmail.com>
 <20220616202014.e7ebc6df8f8f0f1fdce27e12@plushkava.net>
 <CANKwiJX5_67uPPqdwoH3-gbY11Dmj29Hjse+8m3-bsJD0hHVEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKwiJX5_67uPPqdwoH3-gbY11Dmj29Hjse+8m3-bsJD0hHVEg@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 17, 2022 at 05:14:53PM +0100, Gmail Support wrote:
> Okay thank you, is there any plans to support this extension in the future?
>
> On Thu, Jun 16, 2022 at 8:20 PM Kerin Millar <kfm@plushkava.net> wrote:
> >
> > On Thu, 16 Jun 2022 10:15:55 +0100
> > Gmail Support <testingforadept@gmail.com> wrote:
> >
> > > Hello,
> > >
> > > We recently migrated our servers from RedHat to Ubuntu based systems.
> > > We used to have an IPtables rule that was blocking packets matching a
> > > specific application file and below was the rule we had deployed.
> > >
> > > -A INPUT -p udp -m udp --dport 514 -m string --string
> > > "someapplication.exe" --algo bm -j DROP
> > >
> > > In NFtables, I read in the blogs that string based blocking is not
> > > possible. In the man page of Ubuntu, I see a note "The  string  type
> > > is  used  to  for character strings. A string begins with an
> > > alphabetic character (a-zA-Z) followed by zero or more alphanumeric
> > > characters or the  characters  /, -, _ and .. In addition anything
> > > enclosed in double quotes (") is recognized as a string."
> > >
> > > Can you please confirm if string based blocking is supported in Nftables.
> >
> > There is no equivalent to the string extension in nftables. While it
> > is possible to match against a portion of the packet's payload using a
> > raw payload expression, doing so requires that the offset and length
> > of the data be specified. That is, it cannot search for a pattern and,
> > thus, match at any potential offset.
> >
> > --
> > Kerin Millar

You can do string matching by writing a libnetfilter_queue program.

Follow the documentation at
https://netfilter.org/projects/libnetfilter_queue/doxygen/html/

There are 2 sets of functions: the "deprecated" functions will run faster with
your requirements. They're not deprecated at all, only the underlying library
used by the current implementation is deprecated.

Cheers ... Duncan.
