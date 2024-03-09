Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FABE627;
	Sat,  9 Mar 2024 00:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709944720; cv=none; b=C4rAAbYrxOQ3E996sRms11D8DcNgXRlzQK3CgPzT4u4km940MetbGI+ATlHaGSfGFOGJT+ru/vwKJaBXkDDk8muii+m9ETTN/0e/+O5Ua4y1QKNjqlgah+CQn95ZpYJzq5QCqMf759NAnZElOxvF2pGy4HRhrqSFIXBGmjl5Oc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709944720; c=relaxed/simple;
	bh=7lbVqSoXTt3ZWFzGFPIOjaRutUv/QCs6THdS8lLjyNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BDDAi+x2Ah199kus9j89euacz6YmFvzLskCX7u7e4lLxlSbNPPE068Sj5JLaJ1Ocfokcy9aBbKGzHuSzvdLohWNEBs5kIPVK5x0Il+PQ4pvntwV5G6Y+5A1tSEOCDEYBAO2kXBSWdna414KjJHsOO5KWg0EkWQr0wwAUrFHVw90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iX3euKuv; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iX3euKuv"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a44e3176120so360043866b.1;
        Fri, 08 Mar 2024 16:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709944717; x=1710549517; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72DcCZF4zzX57IzWh27ui3Nzppo1bro7gcZPjXVNA+s=;
        b=iX3euKuvBFsuQTJcl3L91GVeXi3QsAMcpy+dPII5FbzUv9Dt/FQR5yKgsSGmTI4/W2
         0QDBgcgqT6SHktVbVvQnJy8Wkrr9umnNidbas9+kkRDdLKstPA4TKaBcaf3aYnIx9vII
         6beTTvJ6eD8fUQzcQHVC9tt/XajN3fCoMf/vLOPkErN4a4+1M+4TTsOrpTnWIkg9WWSj
         E3gARDXGqEND+XmNXw3CXkscJDv1WU9p3HouaCodIBEVkF/kE/s4B9q5Cs7I2YVbT1a1
         hxl3HVBG85XMuqrmxaXaL8taKTSLhaYUWJJUs1sxJG1sZGE/X+OrhGLvl3R/d1ztWv+Y
         naDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709944717; x=1710549517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72DcCZF4zzX57IzWh27ui3Nzppo1bro7gcZPjXVNA+s=;
        b=shzfuHxNjYBdb3xdieBw5/YNtKQDhAkT3Es8k6UlGsTDGiovCzYwCxTuedB5KukaUz
         aSmfuWwIU+HwY7A7yovnTlVhjFKPcFZCzKFCeKwzT1LigQ5nI2lHUgcW+9Fd7FiWEF+T
         ktUblacVNUpG5w6d8BoHLajNi0ia7bPWOUvx2Uua5ZdhkzCgjFGQB6sbj/RFGzYj2WeH
         VJfRZzVwbsNmPu8nOybRGu94jbSsLZOJjQ+8LRcGioS/fa5DtUST6DRwkjnnvptHnxwj
         rm5zwvV5edgu2HsUW5MZt5NJ0JyMtgsdx7j3uS/Eb+DquhD0kWHiV3TK29zg15fJNEvJ
         2tvQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4ZJ0X0VGRfztiN+xDHi1cRSlPAc4FSYTdF+0uxic2vCM9hRrGyWJpxPpWcVJ/JKUXNmZrWJL2JgGmCfv4y+Cb+USJnCWMhEflArFlvMWDaLL6SmNZe+2mtrfTffSxAQ6J6Px4YPIo
X-Gm-Message-State: AOJu0YycnoliYTksHUd8w36qm9/nYOePeSOQnyXeBt0HAb7unP9Fz20P
	vaoOuI4Vq89rzStVQbH6yEkSIxZtpyFXEaA/GZVlKX0lfEJZW6LjVHYCR1cr5UCmShs9JJonBCM
	N++zxLpiqCrPvKNjIbdZlQy2RHr9i37jy22Hgkg==
X-Google-Smtp-Source: AGHT+IEv68BJOUuaGhqxVRkKxn+KfDlSUbKgIqshiPy4e7wU2I/4jkYErNIyGNgTBmrJ96YLJI5qj0LCOHE4JBxVLEQ=
X-Received: by 2002:a17:906:d1db:b0:a43:fd9d:a64 with SMTP id
 bs27-20020a170906d1db00b00a43fd9d0a64mr125290ejb.31.1709944716757; Fri, 08
 Mar 2024 16:38:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307090732.56708-1-kerneljasonxing@gmail.com>
 <20240307093310.GI4420@breakpoint.cc> <CAL+tcoAPi+greENaD8X6Scc97Fnhiqa62eUSn+JS98kqY+VA6A@mail.gmail.com>
 <20240307120054.GK4420@breakpoint.cc> <CAL+tcoBqBaHxSU9NQqVxhRzzsaJr4=0=imtyCo4p8+DuXPL5AA@mail.gmail.com>
 <20240307141025.GL4420@breakpoint.cc> <CAL+tcoDUyFU9wT8gzOcDqW7hWfR-7Sg8Tky9QsY_b05gP4uZ1Q@mail.gmail.com>
 <20240308224657.GO4420@breakpoint.cc>
In-Reply-To: <20240308224657.GO4420@breakpoint.cc>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Sat, 9 Mar 2024 08:37:59 +0800
Message-ID: <CAL+tcoDv_tOAdjwpCCuBkgSCAn4rj4wnTWTB17DY0RpXnQ=p5w@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: avoid sending RST to reply
 out-of-window skb
To: Florian Westphal <fw@strlen.de>
Cc: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org, 
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 9, 2024 at 6:47=E2=80=AFAM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > connection.  Feel free to send patches that replace drop with -accept
> > > where possible/where it makes sense, but I don't think the
> > > TCP_CONNTRACK_SYN_SENT one can reasonably be avoided.
> >
> > Oh, are you suggesting replacing NF_DROP with -NF_ACCEPT in
> > nf_conntrack_dccp_packet()?
>
> It would be more consistent with what tcp and sctp trackers are
> doing, but this should not matter in practice (the packet is malformed).

Okay, I will take some time to check the sctp part. BTW, just like one
of previous emails said, I noticed there are two points in DCCP part
which is not consistent with TCP part, so I submitted one simple patch
[1] to do it.

[1]: https://lore.kernel.org/all/20240308092915.9751-1-kerneljasonxing@gmai=
l.com/

>
> > > +       case NFCT_TCP_INVALID: {
> > > +               verdict =3D -NF_ACCEPT;
> > > +               if (ct->status & IPS_NAT_MASK)
> > > +                       res =3D NF_DROP; /* skb would miss nat transf=
ormation */
> >
> > Above line, I guess, should be 'verdict =3D NF_DROP'?
>
> Yes.
>
> > Great! I think your draft patch makes sense really, which takes NAT
> > into consideration.
>
> You could submit this officially and we could give it a try and see if
> anyone complains down the road.

Great :)

Thanks,
Jason
