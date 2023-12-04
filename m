Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O7XJjcIx"
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC98A0
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 15:01:42 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-a00f67f120aso666750966b.2
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Dec 2023 15:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701730901; x=1702335701; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rlZg6gP/315jivpcBjyZHPKJN+X3wBlvMtkA/MY6Dpk=;
        b=O7XJjcIxmrTx71420Tn7Uat5iOtks4gLKP9ucO8VR4qs2/nDaPfMpl+ng4OtjhcxSF
         rMfOIwhU+mgvmysab13/AknO9q3Q1/MY51lB7jzru+lQ08LzJFwTKPiGM/CSvQ68voO1
         vTnGVMpWIv4jswB/6/8X+UveIBO2/ffXLulzct+wkgOqqdsAymEW5A4Cfz7+nubsRxIh
         a0BiZCP72yXEB2+sTehLQlXIRB84gLYY5aRZEdMYzZmW8+j2sywrgjRKqWFaCLRMtN9C
         DuRk/YWi18iVIizttl1/llDf4tnGYvnYeykSecqQmiyRjOBNgWTqW6pSLMr5q6K+iW00
         Imuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701730901; x=1702335701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rlZg6gP/315jivpcBjyZHPKJN+X3wBlvMtkA/MY6Dpk=;
        b=UkG7/1Z8zvN9PPblYx+G8RqjYo5w+yaSUT4ZG+iVaAmUHVcsGoJukEYWu07lJwBYZd
         1ve2mUiaVaKzlA21SrDgUPRalfZLWbwyBuGQ/MLjbaQ2jwUmsiPyqQnph2NmYo/4ARKk
         PUp+NvHvtQo4RxIZ66tjKGI2UGDV1kPmsDZ6eDfbozUM7xGLB1IZ3VHwq93ZGnzO3pQ5
         k4ox72FpIQ1GlXPi2gJQw+qHIUNpMTS9zYaF93EJj7LqNvJLk4FN2SPs1N9a0nA8bHdY
         qyay/cIeRzlzVScgbr7uy1aSv02Z/ah2mCxoY5coujsn1vnrp9UXpaoQTIz77iNjd/nP
         oqFQ==
X-Gm-Message-State: AOJu0YzGB/pNOchvEOJYYhiwj8LpnodHl9CrMJ9fRZkglaabq3QGl8wb
	Lrvd7tIp+WWnqA3sMWBBOSjoIZ81s5q7nWtYs3r/WYheTvV9NQ==
X-Google-Smtp-Source: AGHT+IGxQ7LB2BjMazzTm2yraM2Q7Dj8TbcqqmpupySeRdPOKxx1/g3J0v/qOXXAY6aPToYf6QUHEr2bPI7GwK1MeDQ=
X-Received: by 2002:a17:906:2258:b0:a19:a19b:55e8 with SMTP id
 24-20020a170906225800b00a19a19b55e8mr4176890ejr.120.1701730900934; Mon, 04
 Dec 2023 15:01:40 -0800 (PST)
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
 <20231204130115.GA29636@breakpoint.cc> <CAHo-OowYxrMcsmhSk17FUFt-5LUwfkOhM+t=v3Yz6_2vbXcnkQ@mail.gmail.com>
 <20231204133345.GB29636@breakpoint.cc>
In-Reply-To: <20231204133345.GB29636@breakpoint.cc>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Mon, 4 Dec 2023 15:01:29 -0800
Message-ID: <CAHo-Oox+54BTFAXewt-9AyDdk_2nZTx+tm488efXpa+7_7wQ5g@mail.gmail.com>
Subject: Re: does nft 'tcp option ... exists' work?
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
	Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 4, 2023 at 5:33=E2=80=AFAM Florian Westphal <fw@strlen.de> wrot=
e:
> Maciej =C5=BBenczykowski <zenczykowski@gmail.com> wrote:
> > > You could try this:
> > >
> > > tcp option @34,8,8 =3D=3D 34
> >
> > So this seems to mean @number(34),offset(8),length(8) =3D=3D 34
> > And I understand the idea, but don't understand where the two 8's are
> > coming from.
>
> Yes, its wrong, it should be 0,8 as you found out.
>
> > Is this counting bits? bytes?
>
> Bits.
>
> > Furthermore, I realized that really mangle postrouting 'reset tcp
> > option fastopen' is a better solution to my particular problem.
>
> Ah, yes, that will nop it out.

So... new problem - turns out there's an experimental and an official
tcp fastopen option.

And it looks like numeric options segfault:

root@mf286a:~# cat
/usr/share/nftables.d/chain-pre/mangle_postrouting/nop-out-tcp-fastopen.nft
#meta nfproto ipv4 oifname "464-xlat" tcp flags syn / fin,syn,rst,ack
tcp option 254      length ge 4 counter drop comment "drop outbound
IPv4 TCP Exp FastOpen";
#meta nfproto ipv6 oifname "wwan0"    tcp flags syn / fin,syn,rst,ack
tcp option 254      length ge 4 counter drop comment "drop outbound
IPv6 TCP Exp FastOpen";
meta nfproto ipv4 oifname "464-xlat" tcp flags syn / fin,syn,rst,ack
tcp option fastopen length ge 2 reset tcp option fastopen counter
comment "NOP out outbound IPv4 TCP FastOpen";
meta nfproto ipv6 oifname "wwan0"    tcp flags syn / fin,syn,rst,ack
tcp option fastopen length ge 2 reset tcp option fastopen counter
comment "NOP out outbound IPv6 TCP FastOpen"

works, but if I uncomment things then 'fw4 check' hits a 'Segmentation
fault' in nft:
[122865.227686] do_page_fault(): sending SIGSEGV to nft for invalid
read access from 0000003d
[122865.236361] epc =3D 77d0aa0d in libnftables.so.1.1.0[77cf0000+a4000]
[122865.242935] ra  =3D 77d0c7b5 in libnftables.so.1.1.0[77cf0000+a4000]

root@mf286a:~# opkg search /usr/sbin/nft
nftables-json - 1.0.8-1
root@mf286a:~# opkg search /usr/lib/libnftables.so.1.1.0
nftables-json - 1.0.8-1

the issue is (total guess) related to 254 failing to convert back into
a string, since using '34' works...

(I can make things work if I use 'tcp option @254,0,32 =3D=3D 0xFE0CF989'
instead, which is better anyway... but still)
