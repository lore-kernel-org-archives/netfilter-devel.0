Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D328EC432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 19:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A72BA20659
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 19:55:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UMGgQHdS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKUTzZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 14:55:25 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52436 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726293AbfKUTzZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 14:55:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574366123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gVy33bhCCstMrr8skoxkjdRHDOmycD+JhN4tfGMqAz8=;
        b=UMGgQHdSAcFXHYRL3K+XrH4ajJus51FRKsz56uoNmhc+9unj26F6k84qhNu3F+1NsSeCF1
        eqeViERVs2axeelK/pgBiTSbUg1E5vKe0eUfJAwgSctx8fg0YU/gVHKMbSXcO0UYf9wwmX
        x2/gKbqVO4/HHeqeZdo//w4GZ4/iemU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-FfITCV46Ojm8yF_t_orgCA-1; Thu, 21 Nov 2019 14:55:20 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F266803F42;
        Thu, 21 Nov 2019 19:55:18 +0000 (UTC)
Received: from localhost (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2627F67580;
        Thu, 21 Nov 2019 19:55:13 +0000 (UTC)
Date:   Thu, 21 Nov 2019 20:55:10 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Jay Ligatti <ligatti@usf.edu>,
        Ori Rottenstreich <or@cs.technion.ac.il>,
        Kirill Kogan <kirill.kogan@gmail.com>
Subject: Re: [PATCH nf-next 8/8] nft_set_pipapo: Introduce AVX2-based lookup
 implementation
Message-ID: <20191121205510.0068551b@redhat.com>
In-Reply-To: <20191120160800.GN8016@orbyte.nwl.cc>
References: <cover.1574119038.git.sbrivio@redhat.com>
        <367e77e2a0097a0c1b715919b8d21f7a51a10429.1574119038.git.sbrivio@redhat.com>
        <20191120151653.GD20235@breakpoint.cc>
        <20191120160800.GN8016@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: FfITCV46Ojm8yF_t_orgCA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 20 Nov 2019 17:08:00 +0100
Phil Sutter <phil@nwl.cc> wrote:

> On Wed, Nov 20, 2019 at 04:16:53PM +0100, Florian Westphal wrote:
> > Stefano Brivio <sbrivio@redhat.com> wrote: =20
> > > If the AVX2 set is available, we can exploit the repetitive
> > > characteristic of this algorithm to provide a fast, vectorised
> > > version by using 256-bit wide AVX2 operands for bucket loads and
> > > bitwise intersections.
> > >=20
> > > In most cases, this implementation consistently outperforms rbtree
> > > set instances despite the fact they are configured to use a given,
> > > single, ranged data type out of the ones used for performance
> > > measurements by the nft_concat_range.sh kselftest. =20
> >=20
> > I think in that case it makes sense to remove rbtree once this new
> > set type has had some upstream exposure and let pipapo handle the
> > range sets.
> >=20
> > Stefano, if I understand this right then we could figure out which
> > implementation (C or AVX) is used via "grep avx2 /proc/cpuinfo".

In practice, that's correct.

Strictly speaking, this is not portable, because other architectures
might decide to have an 'avx2' flag that means something different,
so...

> > If not, I think we might want to expose some additional debug info
> > on set dumps. =20
>=20
> I once submitted a patch introducing NFTA_SET_OPS, an attribute holding
> set type's name in dumps. Maybe we can reuse that? It is message ID
> 20180403211540.23700-3-phil@nwl.cc (Subject: [PATCH v2 2/2] net:
> nftables: Export set backend name via netlink).

...I would rather try to introduce this at a later time. I just
wonder: what was the problem with that series? :)

--=20
Stefano

