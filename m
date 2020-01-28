Return-Path: <SRS0=fFh5=3R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9343CC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 20:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65D4C2087F
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 20:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FyPCvtTD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgA1USN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jan 2020 15:18:13 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42889 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726141AbgA1USN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jan 2020 15:18:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580242691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eFXeWEV3SsDV0ry8Z3r4IL/oQHO2CPJvbvBVVxvO3qM=;
        b=FyPCvtTDjxKWdrOTvgffYXlutKiGYFd3O9gi3CBJFvDcjJ2uk7ogIhlQ60qg/7fQ1owVl5
        woIB15DvDh6lrBo0dk2eBE9kf1ImnGEmCV7UtODxCSGMPDsT8XtANV0OBsEj68tX4zqeYV
        ZNtUQnvqjy2RhNm7brYPLdTgJtYEnBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105--hA44tpmM4G98TXYGG7hIw-1; Tue, 28 Jan 2020 15:18:07 -0500
X-MC-Unique: -hA44tpmM4G98TXYGG7hIw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 049798010DD;
        Tue, 28 Jan 2020 20:18:06 +0000 (UTC)
Received: from localhost (ovpn-112-49.ams2.redhat.com [10.36.112.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A575F8ECE2;
        Tue, 28 Jan 2020 20:18:02 +0000 (UTC)
Date:   Tue, 28 Jan 2020 21:17:52 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH libnftnl v3 1/2] set: Add support for
 NFTA_SET_DESC_CONCAT attributes
Message-ID: <20200128211752.00312b6a@redhat.com>
In-Reply-To: <20200128193016.42lnsncnvmypf62p@salvia>
References: <cover.1579432712.git.sbrivio@redhat.com>
        <1c8f7f6ceca5a37c5115c75ed2ebcc337e78a3d1.1579432712.git.sbrivio@redhat.com>
        <20200128193016.42lnsncnvmypf62p@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 28 Jan 2020 20:30:16 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Sun, Jan 19, 2020 at 02:35:25PM +0100, Stefano Brivio wrote:
> > If NFTNL_SET_DESC_CONCAT data is passed, pass that to the kernel
> > as NFTA_SET_DESC_CONCAT attributes: it describes the length of
> > single concatenated fields, in bytes.
> >=20
> > Similarly, parse NFTA_SET_DESC_CONCAT attributes if received
> > from the kernel.
> >=20
> > This is the libnftnl counterpart for nftables patch:
> >   src: Add support for NFTNL_SET_DESC_CONCAT
> >=20
> > v3:
> >  - use NFTNL_SET_DESC_CONCAT and NFTA_SET_DESC_CONCAT instead of a
> >    stand-alone NFTA_SET_SUBKEY attribute (Pablo Neira Ayuso)
> >  - pass field length in bytes instead of bits, fields would get
> >    unnecessarily big otherwise
> > v2:
> >  - fixed grammar in commit message
> >  - removed copy of array bytes in nftnl_set_nlmsg_build_subkey_payload(=
),
> >    we're simply passing values to htonl() (Phil Sutter)
> >=20
> > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > ---
> >  include/libnftnl/set.h |   1 +
> >  include/set.h          |   2 +
> >  src/set.c              | 111 ++++++++++++++++++++++++++++++++++-------
> >  3 files changed, 95 insertions(+), 19 deletions(-)
> >=20
> > diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
> > index db3fa686d60a..dcae354b76c4 100644
> > --- a/include/libnftnl/set.h
> > +++ b/include/libnftnl/set.h
> > @@ -24,6 +24,7 @@ enum nftnl_set_attr {
> >  	NFTNL_SET_ID,
> >  	NFTNL_SET_POLICY,
> >  	NFTNL_SET_DESC_SIZE,
> > +	NFTNL_SET_DESC_CONCAT, =20
>=20
> This one needs to be defined at the end to not break binary interface.

Hah, right, I just focused on not breaking kernel UAPI and didn't check
this. I'll move it.

> Compilation breaks for some reason:
>=20
> In file included from ../include/internal.h:10,
>                  from gen.c:9:
> ../include/set.h:28:22: error: =E2=80=98NFT_REG32_COUNT=E2=80=99 undeclar=
ed here (not
> in a function); did you mean =E2=80=98NFT_REG32_15=E2=80=99?
>    28 |   uint8_t  field_len[NFT_REG32_COUNT];
>       |                      ^~~~~~~~~~~~~~~
>       |                      NFT_REG32_15

That's something that comes from kernel headers changes, now
commit f3a2181e16f1 ("netfilter: nf_tables: Support for sets with
multiple ranged fields"), this hunk:

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/=
netfilter/nf_tables.h
index c13106496bd2..065218a20bb7 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -48,6 +48,7 @@ enum nft_registers {
=20
 #define NFT_REG_SIZE   16
 #define NFT_REG32_SIZE 4
+#define NFT_REG32_COUNT        (NFT_REG32_15 - NFT_REG32_00 + 1)
=20
 /**
  * enum nft_verdicts - nf_tables internal verdicts

I didn't include those in userspace patches, following e.g. current
iproute2 practice. Let me know if I should actually submit that as
separate change -- I thought it would be more practical for you to sync
headers as needed.

--=20
Stefano

