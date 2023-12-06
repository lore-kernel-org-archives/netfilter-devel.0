Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZKl7QnYm"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111B1D44
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 07:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701875528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S9ysiW3pPT62FjwNwGIaDo+f5G+1MxNgmrzDUVJU+KE=;
	b=ZKl7QnYmcNArkuYNPQy8tNs3cR/cMpu+ehmS29M3cq9zvYrRyhlpW787HFcMqLzaHUqLku
	PRzYYS45ZQJ0BQlHyP3geptGWyRMPuoSP7iinnEjhl5+93O/Lvehxq/K568mTfEqgtHA4T
	5SQ5LMOeId2XD2CKRDHnU5zHZGqhszw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-UsRZcz82NrOiWVKnsoJs-w-1; Wed, 06 Dec 2023 10:12:06 -0500
X-MC-Unique: UsRZcz82NrOiWVKnsoJs-w-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a1cf7d2af71so15742666b.0
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Dec 2023 07:12:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701875525; x=1702480325;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S9ysiW3pPT62FjwNwGIaDo+f5G+1MxNgmrzDUVJU+KE=;
        b=YmFp1WTTPAin0UqxKtds545CDOlGVCBgPGrJy7J/NhCYATSpZFj38Z/4ufSZ3Zv2lp
         LXfPZrPKob38sU+lVVs5GUQyB3vDJxQWfGgBl8WKSc3ytMfum5FglHxaSCgvlDOsTps9
         /h6pqiSncfqacGZ2IP+HnnlVjGLZgRwOI3WAXy+14RQ2dprhWwfQaTuNoSJg30X4N2D3
         UAksrTMvgovjzVvyqRioVuOQ1tEEkvepRc1xUYHvQhIL1b7fbYCMnSpl7w8hJKRFZPkn
         OK0XLNiI96azQRIiJSRmRXvERlNFiLvW+IClHbp9OULOSO4UrlYEN5CuLSv4NyLDzy2f
         SCSA==
X-Gm-Message-State: AOJu0YyfBBZn7Pql4xN2IiPl7iIz1s1W3oYXlsVmkDZzzqSpDe8+kC9T
	wNyvDYpTpBGTT6RTkTyyjcRkxkjOF3Da1xqH/gwuJkGQjC6k1N0jfPZ4wWm2cAZLzkLHKYSvrJw
	RhUrJxneHbCT6EbP597OHwV3fPePK03Nk6KmW
X-Received: by 2002:a17:906:57c8:b0:a1a:541c:561b with SMTP id u8-20020a17090657c800b00a1a541c561bmr1525917ejr.6.1701875525320;
        Wed, 06 Dec 2023 07:12:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQzNJaEE7kLoZjf6lVxpnNOVAJYr5VDxVCOhHnLOrFrs7kos8qPTFd4uRcXJnlj+CWgpdvDQ==
X-Received: by 2002:a17:906:57c8:b0:a1a:541c:561b with SMTP id u8-20020a17090657c800b00a1a541c561bmr1525893ejr.6.1701875524801;
        Wed, 06 Dec 2023 07:12:04 -0800 (PST)
Received: from [10.0.0.196] ([37.186.166.196])
        by smtp.gmail.com with ESMTPSA id bi18-20020a170906a25200b00a0c3b122a1esm43449ejb.63.2023.12.06.07.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 07:12:04 -0800 (PST)
Message-ID: <e9e2e586be0f6ff08532526b801b8b1df768e7c5.camel@redhat.com>
Subject: Re: [PATCH v2 nft] parser: tcpopt: fix tcp option parsing with NUM
 + length field
From: Thomas Haller <thaller@redhat.com>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Maciej =?UTF-8?Q?=C5=BBenczykowski?=
	 <zenczykowski@gmail.com>
Date: Wed, 06 Dec 2023 16:12:03 +0100
In-Reply-To: <ZXCDDgEhAV3KOCwt@orbyte.nwl.cc>
References: <20231205115610.19791-1-fw@strlen.de>
	 <fcb3ef457002c89246c24a79290d25498ef7b0b0.camel@redhat.com>
	 <20231206113836.GE8352@breakpoint.cc>
	 <5aece71107a2716d9e6742cbc4e159c8c65a5ba0.camel@redhat.com>
	 <20231206115906.GF8352@breakpoint.cc> <20231206120447.GG8352@breakpoint.cc>
	 <ZXCDDgEhAV3KOCwt@orbyte.nwl.cc>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 (3.50.1-1.fc39) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2023-12-06 at 15:19 +0100, Phil Sutter wrote:
> On Wed, Dec 06, 2023 at 01:04:47PM +0100, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > Thomas Haller <thaller@redhat.com> wrote:
> > > > On Wed, 2023-12-06 at 12:38 +0100, Florian Westphal wrote:
> > > > > Thomas Haller <thaller@redhat.com> wrote:
> > > > > > Hi Florian,
> > > > > >=20
> > > > > > On Tue, 2023-12-05 at 12:56 +0100, Florian Westphal wrote:
> > > > > > > =C2=A0.../packetpath/dumps/tcp_options.nft=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 14
> > > > > > > +++++++
> > > > > >=20
> > > > > > is there a reason not to also generate a .json-nft file?
> > > > >=20
> > > > > Yes, I am not adding more one-line monsters.
> > > > >=20
> > > > > I'll add one once there is a solution in place that has human
> > > > > readable
> > > > > json dumps that don't fail validation because of identical
> > > > > but
> > > > > differently formatted output.
> > > > >=20
> > > >=20
> > > > What about the "[PATCH nft 0/2] pretty print .json-nft files"
> > > > patches?
> > >=20
> > > I'm fine with that. Phil? Pablo? This is re:
> > >=20
> > > https://patchwork.ozlabs.org/project/netfilter-devel/patch/2023112412=
4759.3269219-3-thaller@redhat.com/
>=20
> What I don't like is that we'll still get these huge patches/mails if
> the dumps are converted. Those that remain are still hard to handle
> in
> case of errors.

We can of course do a one-time commit to convert all .json-nft to
multi-line. The patch makes an effort to not require re-generating the
existing files unless necessary.

The only question is which one is preferable.

Regenerating all .json-nft files once, also makes the second patch
slightly simpler (but not so much, that it would be an argument for
doing that).

>=20
> > What about making it so we NEVER compare json-nft at all?
> >=20
> > Instead, feed the json-nft file to nft, then do a normal list-
> > ruleset,
> > then compare that vs. normal .nft file.
> >=20
> > This avoids any and all formatting issues and also avoids breakage
> > when
> > the json-nft file is formatted differently.
>=20
> We may hide problems because nft might inadvertently sanitize the
> input.
> Also, conversion from standard syntax to JSON may be symmetrically
> broken, so standard->JSON->standard won't detect the problem.
>=20
> > Eg. postprocessing via json_pp won't match what this patch above
> > expects.
>=20
> Python natively supports JSON. Converting stuff into comparable
> strings
> (which also look pretty when printed) is a simple matter of:
>=20
> > import json
> >=20
> > json.dumps(json.loads(<dump as string>), \
> > 	=C2=A0=C2=A0 sort_keys =3D True, indent =3D 4, \
> > 	=C2=A0=C2=A0 separators =3D (',', ': '))
>=20
> We rely upon Python for the testsuite already, so I don't see why
> there's all the fuss. JSON dump create, load and compare have not
> been a
> problem in the 5 years tests/py does it.

The current patches intentionally don't try to sort keys. I claim, it's
also not necessary to sort them. I can easily be convinced otherwise,
by showing a counter-example/reproducer.

There is no fuzz, aside you and Florian bringing this topic up.


Thomas

