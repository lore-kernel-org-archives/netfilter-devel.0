Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02D1244186
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 02:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748485249; cv=none; b=G7F3ihY1dpdwkBEBq7pq9UTtEyU4tQMwcfWcvjP1BA59LnZQEEiWRChu7zG8ZVn7U7N5GuRmSs+xExRZk+d5MqIMWXQ4eZvP58KrUfz37otgtLUatp5fWUUgl3xvfXP72Mz4NHmhQcLuYpwuGiQ9ZoGr41lcinmzBZUQWcyTz7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748485249; c=relaxed/simple;
	bh=L6yvGsV26j931a0U1mpzGC5CpVWsCvykof5oykchlYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jE9P7cm7uNjD+Ym8GghdLI0gUfg0IutkZgrwdgKDVhb5I5bkxv3G3235moJUBS8oOCxCYrFRNjvf8rddh12KqlMtt4Vgq28wwWplkZ7dFTG9x7qlj/UH1mjEuh/jHyKaLpv4TuZ5HdwoXOfNSXRXMR77hQ3dRdzDsE8rBcxNDPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=betz1hlr; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="betz1hlr"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4769bbc21b0so4276321cf.2
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 19:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748485246; x=1749090046; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pX9Lko8ow/hkOX79HSeeCnmYuYVGbFrCZJeY2TXJ20=;
        b=betz1hlrljLw/hrm48wHhl37RDhhvSJ74hmEpxf+CBQp0x5KomJnffnd7CfzGEKP5h
         6+q0hQpHqTPMfpGuxeCZfzmcvmb0S5f9fpTwU6oYIdeKmGeMnBlqqqZRXZK0313NDTWZ
         /akJaCfggO6Dh8sszP/j0QSIrn/86TFfo3baNtnuzxKOhOE2eq1rCcZDQwMl+O6CmY1x
         qiCYDLfaq/4LPyrz1BAGKCQljxfNpT4dc5V4HksOjs6o5794GjJy0Ay9Eo7opp7uNp2G
         bNxIWLNwJpgk+CPTH/lu3CYEmSh+31abITfTL+lGnYLmnsLz4Xw9pqPScis1M0CYFx44
         i/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748485246; x=1749090046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2pX9Lko8ow/hkOX79HSeeCnmYuYVGbFrCZJeY2TXJ20=;
        b=E9HK/9+fbsJbn7mAUt1lV2H40oAC43bB5NytgU1wZCwZ9Y3a6DwEeZWYmjeUzSJVfo
         sz67HW1R13zQcl6AWnroqr++6ouQiIzV185n3WDTK5qpDusDru2ZiOofCbyExqQ7Ggf8
         M/5wZvTcbDn3QdztP0OPoGSc6y+kSSFECeAnKGJR/XsrKI2bJvAp4etOyAK2JsUAVla4
         0b3bLGBlmbELgYd1FiWrRWqWLDHWmm/70NlGaaRa8F5/fT2GMc7xrW0vafx5cae1CzlG
         NW4OO44NENmzJL4qAhnLgNqFP8+bhbShz/eZUc7z1eygEMRGKcU93d7n+obguONbiqMV
         wa1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXGOoB4XSzENVGM8xx2Gq3nRLCLgPoV1ED8jSjoskxsmU204z/1YEii3nEsVJxvyjWVW7ABnZNx9rLyKuioj3E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzAmURvd73S6lWIa1aCG6Vcz3HqhvBVCOKNSQMGD73UoEVwuDa
	ltzwvZTHJbsiFAO89m9533V0dWQdcSfPxu4acktWD8eXbXw5KwifTowsbJib3dFDXG4J76vkJac
	IAbOZX0PXBwK/Jv0c/k4FqIDac3b0cxg=
X-Gm-Gg: ASbGncu6XHsShuLfqnvFUGkP+UBOxudakeBpFxIcZ1k2Ds4vGZ+5A1ClA/q+ypBe3Ci
	GD2GMwpeSegwfdXt2H/XURp/HRx/RLEUAyOv0kUhjP1GbdmrguLp/vhZIWAtF53GU+dWxLI7Zlv
	BhsAs1aSkkRDwI3M62nrrxw/OFI5N4bzm8lA==
X-Google-Smtp-Source: AGHT+IHMOh2EUeuq0ZaAlGKxJXquPwxoZuRpiFrpmjJtYwTSi2UaJwqe1hnWem8+h749/CStpbasBaz6q6ed3n79oHg=
X-Received: by 2002:a05:6214:2a83:b0:6fa:c31a:af20 with SMTP id
 6a1803df08f44-6fac83d3e61mr8414026d6.5.1748485246321; Wed, 28 May 2025
 19:20:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
 <aDbyDiOBa3_MwsE4@strlen.de> <CALOAHbAeVhLAe3o3UL8UOJrCRbRP8mqYZy37CYNHYFa3zss6Zg@mail.gmail.com>
 <aDb-G3_W6Ep19Zjp@strlen.de> <CALOAHbCYhYCLt7zJfdmSUWk_jpWXudLokXvQTGSJt_g4WALGsw@mail.gmail.com>
 <aDcNjpqOKNonzrT-@strlen.de> <CALOAHbA2fT+zcnjivX8-D00FrNyGnj3tvvEX1PghAEwk+uyRSg@mail.gmail.com>
 <aDeEvHI-qJNkrruz@strlen.de>
In-Reply-To: <aDeEvHI-qJNkrruz@strlen.de>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 29 May 2025 10:20:10 +0800
X-Gm-Features: AX0GCFv1gXOZNSinxRFhFkZjHB5-q6g1rYHrJ3ms80hzjK6ajj5U2X0WEbVByrg
Message-ID: <CALOAHbB-60sDDw=dZMg2y4j_nJeY0FzhZ3m6DDnPXFDXLUFWuA@mail.gmail.com>
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, kadlec@netfilter.org, 
	David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2025 at 5:48=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Yafang Shao <laoar.shao@gmail.com> wrote:
> > On Wed, May 28, 2025 at 9:20=E2=80=AFPM Florian Westphal <fw@strlen.de>=
 wrote:
> > > ... and that makes no sense to me.
> > > The reply should be coming from 127.0.0.1:53.
> > >
> > > I suspect stack refuses to send a packet from 127.0.0.1 to foreign/no=
nlocal address?
> > >
> > > As far as conntrack is concerned, the origin 169.254.1.2:53 is a new =
flow.
> > >
> > > We do expect this:
> > > 127.0.0.1:53 -> 10.242.249.78:46858, which would be classified as mat=
ching response to the
> > > existing entry.
> >
> > Could this issue be caused by misconfigured SNAT/DNAT rules? However,
> > I haven't been able to identify any problematic rules in my
> > investigation.
>
> No, because even if there was an SNAT rule it would not be used
> for a reply packet.
>
> Can you check the dns proxy and confirm that it is using the "wrong",
> i.e. the public address as source for the udp packets?

No, it is not using the public address. The DNS server address
169.254.1.2 is a link-local address,  not a routable public IP.

>
> Alternatively you could also try adding a NOTRACK rule in -t raw OUTPUT, =
for
> udp packets coming from sport 53.  It should prevent this problem and
> make your setup work.

This is how we=E2=80=99re handling it in production right now. Without this
workaround, the issue would occur intermittently.

>
> Assuming the dns proxy already uses the public address, no dnat reversal
> is needed.

--=20
Regards
Yafang
