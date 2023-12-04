Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2Qzc8At"
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B17135
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 04:38:59 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9e1021dbd28so605646566b.3
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Dec 2023 04:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701693538; x=1702298338; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5HR5ItveFsOlst1PsaFf9EDqMjujW3/7oZ9MGgeCBCQ=;
        b=H2Qzc8AtEXsofBoSANGIAO7UX9F0AFI1ZOiJDjnclUzDIC4Hbfnpj2438I524etPvC
         VZEL0nWGcVUMTH9xeux8c5zKDeDgEVq38biH+yyPIBeSSpVsAhKx/PHEKeA1AD0BTzT8
         PkW8dmIOrnWWRc/C/DoeCjTvzrFsKjf9dQyysr3vpYZ4lGw7VWcm0RQTqPE5ZDJQR2HT
         PHkpNwWU8FeMXRdsLR1ewjvZQ+NnBy8h1/yM9AP2wAXTJjSw+ebMKzxCGKj7CQRoNCgW
         KbNS5II7dlLJVFY+CBOm95CuPAXPJ0FBGgwssNw18NOUe8NuMs4U4p1oiPffjfBKJTAn
         2R2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701693538; x=1702298338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5HR5ItveFsOlst1PsaFf9EDqMjujW3/7oZ9MGgeCBCQ=;
        b=FQkMG6Bu4Yy8dqrqRO2SQFfM8qMtPO3bFmslV1x7DrrWN1rw16oiZDttAuGglvHOcV
         EfySjrqbhuKyEGt3b+1hLFU62F10cR9CsJ1UPVe2VJ+szvh03njSWaAF7XJzuuqZeZXT
         cdeOIdHYoYHbdsaEhy5S2fB541rwl176tcvXESM1XHK5gwacyU4dV48UOnnVc7GBnT0N
         U92XVBbWGh20UZH3zFIiA9ZwuYVmuNbo9qksrUgedDmAsFVmDnvHUof9V++O36lWFyxp
         tlyWdZjNgphhDtbG/rqzdaY+IFztnj6d7tEAv0DU1vbxVjJrXdTSayfr/sEM5HjyEKzp
         wxvg==
X-Gm-Message-State: AOJu0YzR5uBbxNrUp196sR4ybte+6GFe7lmT0/AouD3dSWSknpnh/EsM
	RASYFUFIeGFApto2/seuOBuVu4XGmOGOyzm+Y9k=
X-Google-Smtp-Source: AGHT+IG9wsgSygxu5iaIXOC0UWceG+ct+OW+A/30F6jE4rWWpych4vFk4FD7fsLFj7xVEl1zbV6J0WiSF3ne+uz7V5Q=
X-Received: by 2002:a17:907:918c:b0:9fc:3aeb:d2b9 with SMTP id
 bp12-20020a170907918c00b009fc3aebd2b9mr2589149ejb.71.1701693538052; Mon, 04
 Dec 2023 04:38:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHo-OozyEqHUjL2-ntATzeZOiuftLWZ_HU6TOM_js4qLfDEAJg@mail.gmail.com>
 <CAHo-Oow4CJGe-xfhweZWzWZ0kaJiwg7HOjKCU-r7HLV_TYGNLQ@mail.gmail.com>
 <20231203131344.GB5972@breakpoint.cc> <20231204094351.GC5972@breakpoint.cc> <ZW2ufym+r10rESua@calendula>
In-Reply-To: <ZW2ufym+r10rESua@calendula>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Mon, 4 Dec 2023 13:38:45 +0100
Message-ID: <CAHo-OoyOh_6AOjCUrF8qZR-vuf=uhy_8WwzyFURwP_7=3jsWeA@mail.gmail.com>
Subject: Re: does nft 'tcp option ... exists' work?
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, 
	Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 4, 2023 at 11:48=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
> On Mon, Dec 04, 2023 at 10:43:51AM +0100, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > Maciej =C5=BBenczykowski <zenczykowski@gmail.com> wrote:
> > > > FYI, I upgraded the router to OpenWrt 23.05.2 with 5.15.137 and it
> > > > doesn't appear to have changed anything, ie. 'tcp option fastopen
> > > > exists' still does not appear to match.
> > > >
> > > > Also note that I'm putting this in table inet filter postrouting li=
ke
> > > > below... but that shouldn't matter should it?
> > >
> > > No, this is an endianess bug, on BE the compared byte is always 0.
> >
> > We could fix this from userspace too:
> >
> > ... exists  -> reg32 !=3D 0
> > ... missing -> reg32 =3D=3D 0
> >
> > currently nftables uses &boolean_type, so the
> > compare is for 1 byte.  We could switch this to
> > 32 bit integer type, this way it will no longer
> > matter if the kernel stores the number at offset 0 or 3.
>
> This simplifies things.
>
> > Phil, Pablo, what do you think?
>
> Just make sure this does not break backward compatibility. When used
> from set declarations with typeof, for example.

I can confirm the box in question is Big Endian:
root@mf286a:~# uname -a; cat /proc/net/tcp | egrep '0100007F|7F000001'
Linux mf286a 5.15.137 #0 Tue Nov 14 13:38:11 2023 mips GNU/Linux
   3: 7F000001:0035 00000000:0000 0A 00000000:00000000 00:00000000
00000000     0        0 3519 1 2ca55a24 100 0 0
^ 7F000001 - big endian
^ 0100007F - little endian

(I'm guessing 'mips' is always BE, vs mipsel being LE or something,
but not actually 100% sure of that)

wrt. the fix, perhaps this should be fixed both in the kernel and in usersp=
ace?
it seems wrong to have unpredictable endian-ness dependent kernel logic,
but a userspace fix/workaround would be easier to deploy...

Is there some way I could feed raw nf bytecode in via nft syntax (if
no... should support for this be added?) ?
(ie. I'm not too sure how to rebuild/flash the kernel, changing
userspace nft binary would be easier, but doing something without
rebuilding either, to confirm this will indeed fix it would be even
better...)
