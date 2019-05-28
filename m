Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA767C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 14:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FF252133F
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 14:03:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QIbz736x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfE1ODv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 10:03:51 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42826 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfE1ODu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 10:03:50 -0400
Received: by mail-oi1-f196.google.com with SMTP id w9so14319232oic.9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2019 07:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=yQCOBjRN7zRCY+loJLeWTvy725oBwAtzBOKeMiKSKrc=;
        b=QIbz736xm6hsma3J32Lc2XesN7AVH197Gpazd3eDi/qa17iMqx/P1UQ8SCtnBnVFMG
         1Laohrhr2hnVm6N2NP51TVUtZKMuHgohsymr+fnIzGsxxMk+LS/UIyh3Ip4/Q/O8TLiS
         v700OlWJhg2BNesBI8c9J6RV/sy+PhNbwa+OnKlOnbQhF+45MPuLxsHDsT9x3WRTc0KJ
         7S/6eDp0C6U+EeN+g8+LT0ydkIijT/vVlxn+VO7ycn5bboheh1gYa8TDFisG3k7ydQIA
         yXl0VtWeuz5O8EzY+41WVa+S3raFMD078wbjLRu8sGeNA0ZEZPQ3my3yn3LNuBth60HS
         avzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=yQCOBjRN7zRCY+loJLeWTvy725oBwAtzBOKeMiKSKrc=;
        b=MQShGJYJeDMw6QkfKpWZ4L5fp0zBQ4/+ub7P4M3vOMD7WULO2WY8H5FsFGE4PWUtgf
         S4OmDaZ+ganvr+8Ycz+UAkOerbDgeZnaBS4mc4X7DN5QK+ri249/xv1idn4M5peHIhUk
         K5SBJSQOBrMzERail+Q5f1u84we+7RjeWhGLbw/r3COU0nkspCKs0/gYsTPuTKWzMdNx
         8lzrv96hJLc8IZWs4eVi5H9zA3jkQwkbCFDc/xyUfPI4OZ7Ery3bPEofE+D8W0I2s8VP
         nnjCQEU7qRRcW9chnH/8igIkeZLNBlqOGWQqv/PtgtQoaADs9iDGEFzJQfGQPU2uN2Gh
         Cr5Q==
X-Gm-Message-State: APjAAAV6gX+zvPGEQwXGW4uTk9Fv9vp07tyf/gJ5DUcudOljm46Z/iZ6
        0gqEnw/54fIfUw93ml03/TzvCCiANYl5MAmm+as=
X-Google-Smtp-Source: APXvYqxlo900Dqp6mSHsTFIo+cZDhJ0UuTB38nJR/W2XWCLSfohHZR2/V70yzj+YnS903YVBMIBfh44BRFF1+zvPTnE=
X-Received: by 2002:aca:f20a:: with SMTP id q10mr2618934oih.94.1559052230057;
 Tue, 28 May 2019 07:03:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190523182622.386876-1-shekhar250198@gmail.com>
 <20190524193600.mx434k2r6if4dzqd@salvia> <20190524194605.y4gtny534yffs4hj@salvia>
 <20190528133206.swz6y52fc7c2pp2c@egarver.localdomain> <20190528133904.3hryyj4g55ewl5sw@egarver.localdomain>
In-Reply-To: <20190528133904.3hryyj4g55ewl5sw@egarver.localdomain>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Tue, 28 May 2019 19:33:36 +0530
Message-ID: <CAN9XX2ojK_z3Gc64r_XupFWNfTpAgf1wPO10Sxr-p3bahhqOqw@mail.gmail.com>
Subject: Re: [PATCH nft v4] tests: py: fix python3
To:     Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 28, 2019, 7:09 PM Eric Garver <eric@garver.life> wrote:
>
> On Tue, May 28, 2019 at 09:32:06AM -0400, Eric Garver wrote:
> > On Fri, May 24, 2019 at 09:46:05PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, May 24, 2019 at 09:36:00PM +0200, Pablo Neira Ayuso wrote:
> > > > On Thu, May 23, 2019 at 11:56:22PM +0530, Shekhar Sharma wrote:
> > > > > This version of the patch converts the file into python3 and also uses
> > > > > .format() method to make the print statments cleaner.
> > > >
> > > > Applied, thanks.
> > >
> > > Hm.
> > >
> > > I'm hitting this here after applying this:
> > >
> > > # python nft-test.py
> > > Traceback (most recent call last):
> > >   File "nft-test.py", line 17, in <module>
> > >     from nftables import Nftables
> > > ImportError: No module named nftables
> >
> > Did you build nftables --with-python-bin ? The error can occur if you
> > built nftables against a different python version. e.g. built for
> > python3, but the "python" executable is python2.
>
> Actually, it's probably caused by this hunk:
>
>     @@ -13,6 +13,8 @@
>      # Thanks to the Outreach Program for Women (OPW) for sponsoring this test
>      # infrastructure.
>
>     +from __future__ import print_function
>     +from nftables import Nftables
>      import sys
>      import os
>      import argparse
>     @@ -22,7 +24,6 @@ import json
>      TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
>      sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
>
>     -from nftables import Nftables
>
>      TESTS_DIRECTORY = ["any", "arp", "bridge", "inet", "ip", "ip6"]
>      LOGFILE = "/tmp/nftables-test.log"
>
> I don't know why the import of nftables was moved. But it was moved to
> _before_ the modification of the import search path (sys.path.insert()).
> Moving it back should fix the issue. Sorry I missed it.



Yes, I think the problem is resolved now.
I shouldn't have moved it to the top.

Thanks!
Shekhar
