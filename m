Return-Path: <SRS0=uBXc=ZO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA0CC432C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 420C520707
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eoF9GI5l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfKVNkL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Nov 2019 08:40:11 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56936 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726633AbfKVNkK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Nov 2019 08:40:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574430009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G0gsvrSimGl65OThYNeNuaDhnNi8JcK4xpI5gvMomfw=;
        b=eoF9GI5ltRDWyp1RS+HXNwBRrQuQKEJJFZ4NYQR1AeaxLwzMb59S1W3Zexod8QRhaOTeCc
        QtXtIAafJalP22Tmqnswo1usvOUIzAtRIS5TaV54oFB9iIl6JzuP82oaqx1JUjLWHKm/df
        d7ft4m174VEF/vbrqERvdhCBAGsovnU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-uxZ6plbzPiSsvlwYoQh0XQ-1; Fri, 22 Nov 2019 08:40:06 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B99201083E96;
        Fri, 22 Nov 2019 13:40:03 +0000 (UTC)
Received: from localhost (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 48BCC6E722;
        Fri, 22 Nov 2019 13:39:58 +0000 (UTC)
Date:   Fri, 22 Nov 2019 14:39:54 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Jay Ligatti <ligatti@usf.edu>,
        Ori Rottenstreich <or@cs.technion.ac.il>,
        Kirill Kogan <kirill.kogan@gmail.com>
Subject: Re: [PATCH nf-next 3/8] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20191122143954.183ac140@redhat.com>
In-Reply-To: <20191121220046.0517c87d@redhat.com>
References: <cover.1574119038.git.sbrivio@redhat.com>
        <6da551247fd90666b0eca00fb4467151389bf1dc.1574119038.git.sbrivio@redhat.com>
        <20191120150609.GB20235@breakpoint.cc>
        <20191121205442.5eb3d113@redhat.com>
        <20191121204113.GL20235@breakpoint.cc>
        <20191121220046.0517c87d@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: uxZ6plbzPiSsvlwYoQh0XQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 21 Nov 2019 22:00:46 +0100
Stefano Brivio <sbrivio@redhat.com> wrote:

> On Thu, 21 Nov 2019 21:41:13 +0100
> Florian Westphal <fw@strlen.de> wrote:
>=20
> > Yes, exactly, we should only reject what either
> > 1. would crash kernel
> > 2. makes obviously no sense (missing or contradiction attributes).
> >=20
> > anything more than that isn't needed.
> >  =20
> > > We could opt to be stricter indeed, by checking that a single netlink
> > > batch contains a corresponding number of start and end elements. This
> > > can't be done by the insert function though, we don't have enough
> > > context there.   =20
> >=20
> > Yes.  If such 'single element with no end interval' can't happen or
> > won't cause any problems then no action is needed. =20
>=20
> Yeah, I don't expect that to cause any problem. I don't have a
> kselftest or nft test for it, because that would require nft to send
> invalid elements, so I only tested those two cases manually. The
> nastiest thing I could come up with was start > end, and it's now
> covered by:
>=20
> =09=09if (memcmp(start, end,
> =09=09=09   f->groups / NFT_PIPAPO_GROUPS_PER_BYTE) > 0)
> =09=09=09return -EINVAL;
>=20
> while:
> - start =3D=3D end is allowed, explicitly handled below
> - end without any previous start (somewhat) correctly maps to < 0 > to
>   end

On the contrary, good that you mentioned this, I haven't been creative
enough. If we allow a < 0 > start element and keep the start pointer
set to NULL, this ends up being used as it is in ->walk(). Another
problem I found is that on the sequence:

- start element only passed to ->insert()
- API frees the start element
- end element is then passed to ->insert()

we would end up with a dangling ->start pointer, which is again
problematic on a number of operations including walk(). Fixed in v2 by
adding explicit checks (and comments).

--=20
Stefano

