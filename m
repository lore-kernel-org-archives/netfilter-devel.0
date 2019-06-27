Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8004C48BD6
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0F4120656
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:41:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qKOARyJE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfF0Plp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 11:41:45 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36951 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfF0Plp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 11:41:45 -0400
Received: by mail-ot1-f65.google.com with SMTP id s20so2753790otp.4
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 08:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=49ksRos0QYTanaw4z20X0CS9lgTf86PjnQ4MvDFyhyA=;
        b=qKOARyJEC776CORW2mNiUIs/on7n/SWiId6qyxSL8XXIUHMS9OePTMH/5WrTVgoBUZ
         +u7PZAZaZPOaBF8E/W2EVJbsiqXCHTOrYrW1ygnEhBqmwFHjjD3b5KO1Zj6qYMv5Ei5I
         nKuY8XftmXWJKVVxXAWFgzbgmOgiBV3BbLaQMFt8U4QfR7KDjE/wAxiTC1DUyhLiytf3
         jDIty/AEeV1p5Ttzmwfzv6s9o6d1HA0Gco9vmZKXWLug+K/RtZ0gEbBPLoIPLMS9909C
         CW6jpyFpfcX/D2wpzKodtB/QurC2PIleO3y/f3y9rUtPxdTAbcI8r+u3te/8e2j8NHPu
         RABA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=49ksRos0QYTanaw4z20X0CS9lgTf86PjnQ4MvDFyhyA=;
        b=QoiCZQcXGR1tZ9IKyaITwauHlUy+qp/J9ONi1PnoC573E8wDNNU+vx7sEfk23Xx9eG
         k4rQOrpx3WUynpv8ipVpd0oFJ0ZWqSE8HDBvo89FZk7gjyPvHuhL73oBKJbnBW8O62NC
         Chno5ek6nzRMZiVsH2NHpFTU1iao6o3LjkIlFUqVlargh4U3s2babfahB+jbgmU7Wx1j
         UQdMo6jSN6Pl5kII6NEk/uoGLzJLKb09ntLV570tILJz1v833BJvwGmXDv0igzsTDi3d
         6j673owl7AarCzzkUlofw14IHdrKLe6yykaMgyb6S8N4ryLL3jg3vcboqTD874g4BdFp
         W11A==
X-Gm-Message-State: APjAAAVf7DyFrs5Kj6T3c4kVBgJBZn+mZzIlVCUrMH6otlvXbYj0bCSL
        0y5ArV0G/9QXP644wprPhfi2ybYvLeHHtxenIUWujCmY
X-Google-Smtp-Source: APXvYqz9JTHzjv6V/PzY5r1tObyGMBi/yssKT12eVfwvPDZGo0hZ6qF7H8kAMs1pTlhmS0KnbzIOhqTbulTtl1oSxgw=
X-Received: by 2002:a9d:5911:: with SMTP id t17mr3807111oth.159.1561650104783;
 Thu, 27 Jun 2019 08:41:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190619175741.22411-1-shekhar250198@gmail.com>
 <20190620143731.jfnty672zi7rcxgs@salvia> <CAN9XX2r6FK6gn7X7i6krWOwaFTiad5OVQybT+qMYbuW1iFY1qQ@mail.gmail.com>
 <20190627123223.viv3p7kn3lq7nxfi@egarver.localdomain>
In-Reply-To: <20190627123223.viv3p7kn3lq7nxfi@egarver.localdomain>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Thu, 27 Jun 2019 21:11:33 +0530
Message-ID: <CAN9XX2o7qfV3G=h-K0rXC8nsm4fufy_SGGRe02V0eEYtOHTK6w@mail.gmail.com>
Subject: Re: [PATCH nft v9]tests: py: fix pyhton3
To:     Eric Garver <eric@garver.life>,
        shekhar sharma <shekhar250198@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 27, 2019 at 6:02 PM Eric Garver <eric@garver.life> wrote:
>
> On Thu, Jun 20, 2019 at 11:08:18PM +0530, shekhar sharma wrote:
> > On Thu, Jun 20, 2019 at 8:07 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > On Wed, Jun 19, 2019 at 11:27:41PM +0530, Shekhar Sharma wrote:
> > > > This patch changes the file to run on both python2 and python3.
> > > >
> > > > The tempfile module has been imported and used.
> > > > Although the previous replacement of cmp() by eric works,
> > > > I have replaced cmp(a,b) by ((a>b)-(a<b)) which works correctly.
> > >
> > > Any reason not to use Eric's approach? This ((a>b)-(a<b)) is
> > > confusing.
> >
> > No, Eric's approach is also working nicely. I read on a website
> > that cmp(a,b) of python2 can be replaced by ((a>b)-(a<b)) in python3.
>
> This is true, but as Pablo stated it can be confusing. For this function
> we only care if the sets are equivalent so I simplified it.
>
True.
> If you agree, the please drop this change from your next revision and
> Pablo can take my patch.

OK , I will not include this change in v10.
