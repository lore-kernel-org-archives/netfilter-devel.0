Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCB7C25B47
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 17:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjJWReD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 13:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbjJWRdx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 13:33:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F313C94
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 10:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698082391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3dzxKQ5mnOM3P9EGuL92ja1HRn79vJ1JUhLdUk3kVIc=;
        b=aN/519yPHtEAujIOOEmRurg4EnXpcfnPKbTJdJAMFKznxCAMHM8ftwYjA/yIKmmMPh6VOe
        z/4QDMO2PnN/lUVYiv7NxSnaK9OrGj21vT6X9r8ErJ0dCNiq93ytLl3eOGgSC8fUqqzpsc
        xSGiVDm0VmamYEV6BClboTJuZ6wr2FM=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-Vv4YzkOzNiCdNKbAU4LUQw-1; Mon, 23 Oct 2023 13:33:09 -0400
X-MC-Unique: Vv4YzkOzNiCdNKbAU4LUQw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-507e110795aso809826e87.0
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 10:33:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698082387; x=1698687187;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3dzxKQ5mnOM3P9EGuL92ja1HRn79vJ1JUhLdUk3kVIc=;
        b=QaJ9EuMAI2mNZMetn0OZT5mhBbKw50IOLLI7ne0UM9noPJGni8CxuLXfWd+kyvLKiv
         KH9odcIfjFf4ARrvh84SOQPgmTNsfZev0ZleCanK0g8Uog3f90XDTWAhrrjvMOcv5QRr
         qvCUMJKH/iNpUTRTSA0Y/OZlI3PceD8PPOTkCZErbGYia311AppWHy0n95mFPUO/ORzL
         4Rj41bmCqOpf139F8/0Yia8Qt+n0cNidGYGOZYBc4IPbFrchDorE3mbQjd9YMABiIh54
         L8bX1NbUIF2P1IKWUTGgGAT8z+hK+hnKlMRdAC46A8csX+rmjnpTMWz3n9aIG0l8ro62
         mK6A==
X-Gm-Message-State: AOJu0Yyn857gj8lspq3mV8WRTdr6LdYwlHLazeNk/1Q0tM/8XoDqRPMv
        3Qw87Ku5R8A7GQcUMnZucmaZ2ISX/QO/32Wk2WIW721PQXgnaDzwFqrSKNwfClkp/kdY1W/4JCk
        DcgSYo4M48x8sJx8nwkrqsdmQsG0b0iZvoIKL
X-Received: by 2002:a05:6512:1594:b0:503:404:b44c with SMTP id bp20-20020a056512159400b005030404b44cmr6818697lfb.1.1698082387396;
        Mon, 23 Oct 2023 10:33:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9DTK4lyPibir6iJsVbo6x6X/y70lSoKTpp45mRzMkKydFhu2c5W19cCFFnaeYhtETCCbJDg==
X-Received: by 2002:a05:6512:1594:b0:503:404:b44c with SMTP id bp20-20020a056512159400b005030404b44cmr6818685lfb.1.1698082387018;
        Mon, 23 Oct 2023 10:33:07 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id qq21-20020a17090720d500b00988f168811bsm7006877ejb.135.2023.10.23.10.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 10:33:06 -0700 (PDT)
Message-ID: <84b4439a830c7898376a054edacaf0a3cb0f00b5.camel@redhat.com>
Subject: Re: [PATCH nft 3/3] parser_bison: fix length check for ifname in
 ifname_expr_alloc()
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Mon, 23 Oct 2023 19:33:05 +0200
In-Reply-To: <ZTaqeZ3kgMNj/WZK@calendula>
References: <20231023170058.919275-1-thaller@redhat.com>
         <20231023170058.919275-3-thaller@redhat.com> <ZTaqG+UTE/3JHdyW@calendula>
         <ZTaqeZ3kgMNj/WZK@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 2023-10-23 at 19:16 +0200, Pablo Neira Ayuso wrote:
> On Mon, Oct 23, 2023 at 07:15:10PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Oct 23, 2023 at 07:00:47PM +0200, Thomas Haller wrote:
> > > IFNAMSIZ is 16, and the allowed byte length of the name is one
> > > less than
> > > that. Fix the length check and adjust a test for covering the
> > > longest
> > > allowed interface name.
> > >=20
> > > This is obviously a change in behavior, because previously
> > > interface
> > > names with length 16 were accepted and were silently truncated
> > > along the
> > > way. Now they are rejected as invalid.
> > >=20
> > > Fixes: fa52bc225806 ('parser: reject zero-length interface
> > > names')
> > > Signed-off-by: Thomas Haller <thaller@redhat.com>
> > > ---
> > > =C2=A0src/parser_bison.y=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 3 ++-
> > > =C2=A0tests/shell/testcases/chains/0042chain_variable_0 | 7 +------
> > > =C2=A02 files changed, 3 insertions(+), 7 deletions(-)
> > >=20
> > > diff --git a/src/parser_bison.y b/src/parser_bison.y
> > > index f0652ba651c6..9bfc3cdb2d12 100644
> > > --- a/src/parser_bison.y
> > > +++ b/src/parser_bison.y
> > > @@ -16,6 +16,7 @@
> > > =C2=A0#include <stdio.h>
> > > =C2=A0#include <inttypes.h>
> > > =C2=A0#include <syslog.h>
> > > +#include <net/if.h>
> > > =C2=A0#include <netinet/ip.h>
> > > =C2=A0#include <netinet/tcp.h>
> > > =C2=A0#include <netinet/if_ether.h>
> > > @@ -158,7 +159,7 @@ static struct expr *ifname_expr_alloc(const
> > > struct location *location,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return NULL;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > =C2=A0
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (length > 16) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (length >=3D IFNAMSIZ) =
{
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0xfree(name);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0erec_queue(error(location, "interface name too
> > > long"), queue);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return NULL;
> > > diff --git a/tests/shell/testcases/chains/0042chain_variable_0
> > > b/tests/shell/testcases/chains/0042chain_variable_0
> > > index 739dc05a1777..a4b929f7344c 100755
> > > --- a/tests/shell/testcases/chains/0042chain_variable_0
> > > +++ b/tests/shell/testcases/chains/0042chain_variable_0
> > > @@ -26,18 +26,13 @@ table netdev filter2 {
> > > =C2=A0
> > > =C2=A0rc=3D0
> > > =C2=A0$NFT -f - <<< $EXPECTED || rc=3D$?
> > > -test "$rc" =3D 0
> > > +test "$rc" =3D 1
> > > =C2=A0cat <<EOF | $DIFF -u <($NFT list ruleset) -
> > > =C2=A0table netdev filter1 {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain Main_Ingress1 {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0type filter hook ingress device "lo" priority -
> > > 500; policy accept;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > =C2=A0}
> > > -table netdev filter2 {
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain Main_Ingress2 {
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0type filter hook ingress devices =3D {
> > > d23456789012345, lo } priority -500; policy accept;
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > -}
> >=20
> > Please, do not remove it, fix this test.
>=20
> Or maybe I am missing the reason for this change? It seems this
> d23456789012345 was added to your previous patch in this series.
>=20
>=20

The point is to add a test for the bug first.

Followed by the fix. And the change to the test shows how the fix
fixes.


Thomas

