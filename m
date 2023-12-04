Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a6jXeTDD"
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939FEAC
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 05:20:19 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-a1975fe7befso463668266b.2
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Dec 2023 05:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701696018; x=1702300818; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=voB0ugIf296FDFCL3yc7INg4wijRhAVKk9GB12ZGbdk=;
        b=a6jXeTDDA6jatC6Z2lPpUMZ8b8F3MAKhE4T2erFN57Lv67dEjnuvh9+y+XZrJOLKqH
         TS6kUNvS+rH3Yhl6dHPBdx7uksJw4aMmBbyraeI9uUNdAl6H7FNr0DhVJNewamp9loqc
         FiaXkDPPQ2FUNZjHwxypHcctSMA7yA0lbR842hA41x5jfV98F2JNFX9KE9aSNRMT5Qo2
         tCi2LRjB0Ev2i+MCdovTTFU/UjZ0Afy3mBdobRVszH14csAvcpWH7GAqYUD+JpTgnRxo
         Fiu0yByqY0idCqxyrdU4Uzn5gxHo3lgBm/CjfR1Y2+TqSEarno2oj1imahhW5YTCk61J
         kFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701696018; x=1702300818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=voB0ugIf296FDFCL3yc7INg4wijRhAVKk9GB12ZGbdk=;
        b=WkjcNTQtXADxemvCWUnKiAdpmpv1GchyQ1q5py65tu+3vLjL5Q5vmEUr0jRaKP0sTy
         4TfA1/HoXJCQb2Vsy90U8XAVPGG9njmHfhYerMpH2C9Ufft/CzWcddP9GGGwP6da44JY
         JGoHHc+a/fbvTmR5+GJ3n8HQ5spRif+VqkNrX9Z9TcmcQxkHB4nsDckFdapr7Ug92ZCJ
         LxKPYq/qk0YLjaHzIb5vJgWY3LUWLarSSlC/8MvejTlnDsti93XsFSyXNkmY+EPA8uUq
         WyAKGK/Q8fbGb3wWeh7YRZqUPWx69Yo0lko9lYDRvSC+dcu1aSuCsciC1xk6B/0tnZz5
         GxZg==
X-Gm-Message-State: AOJu0Yw/3o4Cpm6vc/GtsPS2BVo/o6NbOXl5y0BiGi45HfIxaMmw0WcG
	Nj0PqqAWQqcW49MzXhS5n9vc9VMc4+CP8Id/KI4=
X-Google-Smtp-Source: AGHT+IEeofR3OheyuY0c8U1485nbJ0mxSlWgrRt/8pZ5csRsKdrR27zFz1UA3KqJmdvcEAYUx9kTe6mUBBBjGRtwbeg=
X-Received: by 2002:a17:906:ac8:b0:a19:a19a:eab6 with SMTP id
 z8-20020a1709060ac800b00a19a19aeab6mr3313826ejf.111.1701696017812; Mon, 04
 Dec 2023 05:20:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHo-OozyEqHUjL2-ntATzeZOiuftLWZ_HU6TOM_js4qLfDEAJg@mail.gmail.com>
 <CAHo-Oow4CJGe-xfhweZWzWZ0kaJiwg7HOjKCU-r7HLV_TYGNLQ@mail.gmail.com>
 <20231203131344.GB5972@breakpoint.cc> <20231204094351.GC5972@breakpoint.cc>
 <ZW2ufym+r10rESua@calendula> <CAHo-OoyOh_6AOjCUrF8qZR-vuf=uhy_8WwzyFURwP_7=3jsWeA@mail.gmail.com>
 <20231204130115.GA29636@breakpoint.cc>
In-Reply-To: <20231204130115.GA29636@breakpoint.cc>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Mon, 4 Dec 2023 05:20:06 -0800
Message-ID: <CAHo-OowYxrMcsmhSk17FUFt-5LUwfkOhM+t=v3Yz6_2vbXcnkQ@mail.gmail.com>
Subject: Re: does nft 'tcp option ... exists' work?
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
	Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 4, 2023 at 5:01=E2=80=AFAM Florian Westphal <fw@strlen.de> wrot=
e:
> Maciej =C5=BBenczykowski <zenczykowski@gmail.com> wrote:
> > wrt. the fix, perhaps this should be fixed both in the kernel and in us=
erspace?
> > it seems wrong to have unpredictable endian-ness dependent kernel logic=
,
> > but a userspace fix/workaround would be easier to deploy...
>
> Right.
>
> > Is there some way I could feed raw nf bytecode in via nft syntax (if
> > no... should support for this be added?) ?
>
> You could try this:
>
> tcp option @34,8,8 =3D=3D 34

So this seems to mean @number(34),offset(8),length(8) =3D=3D 34
And I understand the idea, but don't understand where the two 8's are
coming from.
Is this counting bits? bytes?
( http://netfilter.org/projects/nftables/manpage.html "RAW PAYLOAD
EXPRESSION" seems to suggest it counts bits)
If it's counting bits, shouldn't it be @34,0,8 =3D=3D 34
My understanding is that tcp options (except for eol[0] and nop[1])
are (u8 kind >=3D2, u8 length >=3D2, length-2 data bytes...),
so kind is at offset 0...

> (where 34 is the kind/option you are looking for).

I tried replacing 'tcp option fastopen exists' with 'tcp option
fastopen length ge 0' and that seems to work.
(I also tried 'tcp option fastopen kind eq 34' but I guess the nft
binary is too new and no longer supports 'kind')

Furthermore, I realized that really mangle postrouting 'reset tcp
option fastopen' is a better solution to my particular problem.
(I think stripping out the tcp fastopen option from the syn disables
fastopen without causing a blackhole and thus an extra RTT roundtrip)

I'll give your suggestion a try too.
