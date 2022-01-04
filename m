Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7251FC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jan 2022 23:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbiADXWq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jan 2022 18:22:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234152AbiADXWq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jan 2022 18:22:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641338556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=APTNjtc/NVeYk8GhPpMv5eoWks1kKQ6Uvjyyq82/v/0=;
        b=L/rpCF9B2XdxphFcSqpyxzTnRQeRsT0LpADTswx+ns4Pg+H92/4yyZZr8UsQwFEnLnHyNX
        CrylSwfM3ReFp7wSMviSJw5Dtu018bMOKAqBRO+RH2gNFfq+X3STE5cjB9USWKf6vSiF1X
        yXfMyYOX+LLPRBj4LDjN0NzijDc9nuI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-3SAfBwgANTKBAVvPy3-d4w-1; Tue, 04 Jan 2022 18:22:35 -0500
X-MC-Unique: 3SAfBwgANTKBAVvPy3-d4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DDE51023F4D;
        Tue,  4 Jan 2022 23:22:34 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACAB710246F4;
        Tue,  4 Jan 2022 23:22:33 +0000 (UTC)
Date:   Wed, 5 Jan 2022 00:22:22 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     etkaar <lists.netfilter.org@prvy.eu>, netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nftables >= 0.9.8: atomic update (nft -f ...) of a set not
 possible any more
Message-ID: <20220105002222.6695b8f7@elisabeth>
In-Reply-To: <20220104195728.GB938@breakpoint.cc>
References: <5tg3b13w5.PCaY2G@prvy.eu>
        <20220104195728.GB938@breakpoint.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Tue, 4 Jan 2022 20:57:28 +0100
Florian Westphal <fw@strlen.de> wrote:

> etkaar <lists.netfilter.org@prvy.eu> wrote:
>=20
> [ CC Stefano ]
>=20
> > Dear colleagues,
> >=20
> > given is following perfectly working ruleset (nft list ruleset), which =
drops almost all of the IPv4 traffic, but grants access to port 22 (SSH) fo=
r two IPv4 addresses provided by the set named 'whitelist_ipv4_tcp': =20
>=20
> Thanks for reporting, I can reproduce this.
>=20
> > +++
> > table inet filter {
> > 	set whitelist_ipv4_tcp {
> > 		type inet_service . ipv4_addr
> > 		flags interval
> > 		elements =3D { 22 . 111.222.333.444,
> > 			=C2=A0 =C2=A0 =C2=A022 . 555.666.777.888 }
> > 	} =20
>=20
> I can repro this, looks like missing scratchpad cloning in the set
> backend.
>=20
> I can see that after second 'nft -f', avx2_lookup takes the 'if (unlikely=
(!scratch)) {' branch.
>=20
> Can you try this (kernel) patch below?
>=20
> As a workaround, you could try removing the 'interval' flag so that
> kernel uses a hash table as set backend instead.
>=20
> Stefano, does that patch make sense to you?
> Thanks!

Thanks for checking and fixing this!

Yes, it makes sense, a clone without a subsequent new insertion
wouldn't have a scratchpad otherwise -- I wonder how I missed this.
Just perhaps:

> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipap=
o.c
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -1271,7 +1271,7 @@ static struct nft_pipapo_match *pipapo_clone(struct=
 nft_pipapo_match *old)
>  {
>  	struct nft_pipapo_field *dst, *src;
>  	struct nft_pipapo_match *new;
> -	int i;
> +	int i, err;
> =20
>  	new =3D kmalloc(sizeof(*new) + sizeof(*dst) * old->field_count,
>  		      GFP_KERNEL);
> @@ -1291,6 +1291,14 @@ static struct nft_pipapo_match *pipapo_clone(struc=
t nft_pipapo_match *old)
>  		goto out_scratch;
>  #endif
> =20
> +	err =3D pipapo_realloc_scratch(new, old->bsize_max);
> +	if (err) {
> +#ifdef NFT_PIPAPO_ALIGN
> +		free_percpu(new->scratch_aligned);
> +#endif

I would use another label for this, "out_scratch_aligned", for
consistency with the rest of the error handling, but it's not a strong
preference.

> +		goto out_scratch;
> +	}
> +
>  	rcu_head_init(&new->rcu);
> =20
>  	src =3D old->f;
>=20

--=20
Stefano

