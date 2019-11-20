Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AAB3C432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 12:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 736AD224E6
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 12:13:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TPLl88ic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbfKTMNH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 07:13:07 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59486 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729273AbfKTMNG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 07:13:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574251986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L2YyuaUT3WssEaZiORZc0AIs1qFmdux3/MfSGozQquI=;
        b=TPLl88ic4tHdpbLD9lL2WE4QKfDetuj+oRRBBIcvrb9hW/XrpcC/gyBstyjeCD6mAotMNl
        5VwAeh+gSmbOMMgIeiILwYWlzNL7Vnc/4NqnqRgZbwGTjjrrVNlSuZcLRraluCjRIyPkjD
        /XkXg/6WgqMCZ9ylT1QzSTUXrB+xLro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-d1Ga3O39NiGrrYPsHsD_zw-1; Wed, 20 Nov 2019 07:13:04 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8489E1005512;
        Wed, 20 Nov 2019 12:13:02 +0000 (UTC)
Received: from localhost (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FC4961081;
        Wed, 20 Nov 2019 12:13:00 +0000 (UTC)
Date:   Wed, 20 Nov 2019 13:12:56 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH libnftnl] set: Add support for NFTA_SET_SUBKEY
 attributes
Message-ID: <20191120131256.4f17cdf1@redhat.com>
In-Reply-To: <20191120130152.7d4d3ca8@redhat.com>
References: <20191119010723.39368-1-sbrivio@redhat.com>
        <20191120112448.GI8016@orbyte.nwl.cc>
        <20191120130152.7d4d3ca8@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: d1Ga3O39NiGrrYPsHsD_zw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 20 Nov 2019 13:01:52 +0100
Stefano Brivio <sbrivio@redhat.com> wrote:

> On Wed, 20 Nov 2019 12:24:48 +0100
> Phil Sutter <phil@nwl.cc> wrote:
>
> [...]
>
> > > +=09=09if (!*l)
> > > +=09=09=09break;
> > > +=09=09v =3D *l;
> > > +=09=09mnl_attr_put_u32(nlh, NFTA_SET_SUBKEY_LEN, htonl(v));   =20
> >=20
> > I guess you're copying the value here because how htonl() is declared,
> > but may it change the input value non-temporarily? I mean, libnftnl is
> > in control over the array so from my point of view it should be OK to
> > directly pass it to htonl(). =20
>=20
> It won't change the input value at all, but that's not the point: I'm
> reading from an array of 8-bit values and attributes are 32 bits. If I
> htonl() directly on the input array, it's going to use 24 bits around
> those 8 bits.

Err, wait, never mind :) I'm just passing the value, not the reference
there -- no need to copy anything of course. I'll drop this copy in v2.

--=20
Stefano

