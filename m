Return-Path: <SRS0=ip/f=VB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A67C1C0651F
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 18:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7808C2189E
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 18:49:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SYRcLNyJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfGDStD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 14:49:03 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:34031 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfGDStC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 14:49:02 -0400
Received: by mail-ua1-f66.google.com with SMTP id c4so1399909uad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jul 2019 11:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/Hn0aaGGgje7tIhCuyUc74308rvrhoCZpczG3RG+e6g=;
        b=SYRcLNyJ6x34p4ly5yTSnKqoOsCAoGtnmZ0ptS9rN1ltZP2WOMRkWCQTL5UCJVH9iu
         ekj9UrpL30YvJmjsc5teXmbfJxT+FUtotC8i0NzhlY8zS6E7e4noMMNkUH6DY664aZSd
         gQeGc2HdLtsshu4G9B+qzGNQ0UrJDenIBawBEcybF68VMMF5341Z3SuJ+ASZk5w1addo
         EBbg4BhjxYaY9z7BpFNHeT31qzStN2oc8GrNyH70vIQnth74bqwD1/fkMHFDjVeLkh8D
         2va5iR3XvxMiaEdYK2iAhcJnl9NpP8W+BOiVYMeybVcEkGWO8x8hxAk5iBtjRxAJ3mnZ
         aJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/Hn0aaGGgje7tIhCuyUc74308rvrhoCZpczG3RG+e6g=;
        b=KusJ4+grRSDoOwC0o1YwNSCeIdDr1PYgXK0GuRJpH4CK4CgQm+78Piikx9eGosVlY6
         /gE77otZ0sLPvz7NRjDZ5tToO9Nuf0dZxIdUG9oc5tWv4vn3TRkCLHp+/aeQQPRuXoPa
         iEzmI+3MmwqjSo8uSrDy0lwpcDb+Gympgbr6i86SAdKjPWJNCQQUTzekUWr648XHiLzj
         ydKcHWDazMRsB10S0E5TnGBANrU1Qw91Nhqcau/nYWt1pP2eHe7/d/qoExiY1gFNLSnd
         gwSswde0B4y/vlhwfAgwVBuIDOER3ilazRWDE9eq2gzElzaR8z55a1e9d4tdLzz6CyEu
         PnHQ==
X-Gm-Message-State: APjAAAW9lNI2leFKKnmROZGO0lKbPHpY0+pb3lx8INbS/0rKjdt5I7EB
        VOFD1RCpB6/r/GieCHpMhZ3bdk5IaicMu50aLstv0Ww7
X-Google-Smtp-Source: APXvYqxMMvnvx1JJYxxaUnpEexQa6g2selTm6M5fjE950jbY+uTG1NOd73jeq2sZ1878Aqg/gU0OJ9UuDd4kLbjJvG0=
X-Received: by 2002:ab0:3159:: with SMTP id e25mr13458019uam.81.1562266141856;
 Thu, 04 Jul 2019 11:49:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190605092818.13844-1-sveyret@gmail.com> <20190605092818.13844-2-sveyret@gmail.com>
 <20190702231247.qoqcq5lynsb4xs5h@salvia>
In-Reply-To: <20190702231247.qoqcq5lynsb4xs5h@salvia>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Thu, 4 Jul 2019 20:48:50 +0200
Message-ID: <CAFs+hh6TcVM1HbK=iZF5vfSnnGYdtpSTTy=DR3LizSgkuYQghA@mail.gmail.com>
Subject: Re: [PATCH nftables v4 1/1] add ct expectations support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le mer. 3 juil. 2019 =C3=A0 01:12, Pablo Neira Ayuso <pablo@netfilter.org> =
a =C3=A9crit :
> Please, make sure you run ./configure with --with-json.

I'm sorry, but I don't manage to compile it anymore.

I took latest versions of kernel/lib/nft and merged my modifications
to nft. But when I try to compile nft, even if the configure goes
well, the make fails. The message is that it needs libnftnl > 1.1.3
whereas configure only requires version 1.1.1, and the lib creates a
package with version 1.1.2. If I cheat (and update the libnftnl.pc
file by hand), then make fails later, when compiling libnftables.c
with the following messages :
libnftables.c:112:14: warning: data definition has no type or storage class
 EXPORT_SYMBOL(nft_ctx_add_include_path);
              ^
libnftables.c:112:15: warning: type defaults to =E2=80=98int=E2=80=99 in de=
claration
of =C2=AB nft_ctx_add_include_path =C2=BB [-Wimplicit-int]
 EXPORT_SYMBOL(nft_ctx_add_include_path);
               ^~~~~~~~~~~~~~~~~~~~~~~~
libnftables.c:112:15: error: =C2=AB nft_ctx_add_include_path =C2=BB redecla=
red
as different kind of symbol
In file included from libnftables.c:9:
../include/nftables/libnftables.h:76:5: note: previous definition of =C2=AB
nft_ctx_add_include_path =C2=BB was here
 int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path);
     ^~~~~~~~~~~~~~~~~~~~~~~~
libnftables.c:113:5: warning: no previous prototype for function =C2=AB
nft_ctx_add_include_path =C2=BB [-Wmissing-prototypes]
 int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
     ^~~~~~~~~~~~~~~~~~~~~~~~

Does someone have a clue ?

--=20
Bien cordialement, / Plej kore,

St=C3=A9phane Veyret
