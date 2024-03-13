Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D811B5B2
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 09:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710320524; cv=none; b=HFACDjPGiQemli7sdt7K8z47ep9cTTW6USWKMv07Guv4IYrkHPgGsnznJKH9bLqzltLbPi9k4BCmB88oo1vVId+rvMvgmN4DKlLxbqtzNQ6h491VvpdbEJ2G4yprYbgoXbA58qLKhplHct/YU/YyYUZgr/+i6SA/844aQVOpL3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710320524; c=relaxed/simple;
	bh=9tNcYfhnSoQgaO2FiesfXMaiRdjaWnvXggf748ViwS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=AoTobpqyIIniqXd/VLj5g55AfNGe7Q8WTjZF34UBs2XBpW2rfTJ57cYbDwm1xDteVf6s+wgil6nEVK2AuaQZGDtii25ElnQUUINbJtmYNy04GRJg3kiWhY3/vrBHm+R16Z7oV3P/qGlzj1778uhMyW8kT932MBbjd+BxwnfIOLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=asGnYWV4; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="asGnYWV4"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-690de619293so5485756d6.0
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 02:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710320521; x=1710925321; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSb9DXrmyj2EDPmyGWsnwCi/1APGLxyqLSLge4c/eoM=;
        b=asGnYWV4ztuqdYi49eQSPen4dHQdDqjtxMl/9Fi7C1EjOnNdEJM/Rsd0Eq6zVLTS2R
         UiaEpqMnPP3+ipzXl0jgP/SRQWBgYOEryKMoNNc5AqQtigTeSjyd+p1WWbA6QFXFtxmN
         3Ub2V9Y0qgVkbsOOLsdkSLdRXRM1PxTwjjmliQcO7FJ26jjLNkLtT3GuLgp0nAHrjO7Z
         HHi9MM18Mnd3DLTGtYHUBkyFWdW2LhnuC+oQbxAF2tRZzPbXV7FcuHkgwdYz1wVkjarn
         FNnyr8XmEcy0R2Dj2xfqjY8eDg43Rh0ZknPX388uCqP0ZtBHHG/SGxIXFkcGMbK5glLn
         Ml9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710320521; x=1710925321;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bSb9DXrmyj2EDPmyGWsnwCi/1APGLxyqLSLge4c/eoM=;
        b=OZqM5kXkUEGmlZLG15ep5ksX5LTx8/dHU2FUex+qd4Gd+HqsYHo7IVRqTPicAzuFj9
         EoCKmoAGXcBjBNPit2ny25IpSzWKCdaDUx21BPXEZCiNkA2+oTSnFrZ1OKYJ6EVNQw2F
         vA/3Ci4J2J7kUTwMt3IW74OlQCCh7ame9OTtqfI8MGDcB5hT/bzW8vpksZPqxBJ+opyH
         Hs2FAcfo9ZeykWdE/hX+UHp7/o4TPIXPHZJvY/9nGXwSk+RGrfqPFhfCzHn+fXgDTx2h
         d14pE2LRGq5nl5hF7BAw9STuXAF2vjbo/I+6p8BhbQGjrN48YvN/joRpsvx1/gb55Bdm
         o8ag==
X-Forwarded-Encrypted: i=1; AJvYcCWsYDbrmjNISxnYQv+DZj7K30C4NRFiqFj6BrJET53ZDZiPkmq8qdHg1pUdckz3MxPzTifhbxR4EwZVMwXpeexYRgoa2VkFqT4GzBD2/3hX
X-Gm-Message-State: AOJu0YzN396VAgZCjuxqE8uzm2bEBbNEBzBaQ35YW7tyHIAEgQ7fJhRp
	u2L5fZoeRLA09sqKNyYT/3RWfKuF7HmYrCQzzgWpvUPb4TpBj8SeX6UVG+tg4OjnrAa++JLIyor
	x7xDlXcWuGvlsdMCiCryFpgfTg+zXaq86
X-Google-Smtp-Source: AGHT+IHbSE2NZv6f0wIXWnKVClcnxYP8/YgkNpAKtdcLYhoQ78QWzWGc7l1rmN05xnbB2zkp189WQczLbtsMDqb2fRc=
X-Received: by 2002:a0c:f354:0:b0:691:14ad:7ffd with SMTP id
 e20-20020a0cf354000000b0069114ad7ffdmr1406409qvm.32.1710320521497; Wed, 13
 Mar 2024 02:02:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPtndGDEJVWXcggRkw66YLjhu3QyUjJ5j4YEbvJLj-qbPkQaPg@mail.gmail.com>
 <Zer252IUJr07J_eX@orbyte.nwl.cc>
In-Reply-To: <Zer252IUJr07J_eX@orbyte.nwl.cc>
From: Sriram Rajagopalan <bglsriram@gmail.com>
Date: Wed, 13 Mar 2024 14:31:49 +0530
Message-ID: <CAPtndGBH4LKmyXd1xBp7DLYpLO2NoN6JWLUai=+fqUX8TMs7TQ@mail.gmail.com>
Subject: Re: iptables-nft: Wrong payload merge of rule filter - "! --sport xx
 ! --dport xx"
To: Phil Sutter <phil@nwl.cc>, Sriram Rajagopalan <bglsriram@gmail.com>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 8, 2024 at 5:00=E2=80=AFPM Phil Sutter <phil@nwl.cc> wrote:
>
> Hi Sriram,
>
> On Fri, Mar 08, 2024 at 02:49:38PM +0530, Sriram Rajagopalan wrote:
> > iptables-nft based on nftables has an issue with the way the rule
> > filter - "! --sport xx ! --dport xx" is wrongly merged and rendered.
>
> I agree with your analysis and the patches look fine. Could you please
> submit them formally?
Sure, thanks!
>
> [...]
> > % export IPTABLES=3D/usr/local/sbin/iptables-legacy; sudo $IPTABLES -A
> > INPUT -p tcp ! --sport 22 ! --dport 22 -i vm2; echo -e "\n---- Before
> > data ----\n"; sudo $IPTABLES -L INPUT -vvvn; sudo python -c "from
> > scapy.all import *;
> > sendp(Ether(dst=3D'9e:00:fa:a3:c9:48')/IP(src=3D'1.1.1.1',
> > dst=3D'2.2.2.2')/TCP(sport=3D23, dport=3D22), iface=3D'vm1')"; echo -e =
"\n----
> > After data with either one of tcp sport/dport being 22 ----\n"; sudo
> > $IPTABLES -L INPUT -vn; sudo python -c "from scapy.all import *;
> > sendp(Ether(dst=3D'9e:00:fa:a3:c9:48')/IP(src=3D'1.1.1.1',
> > dst=3D'2.2.2.2')/TCP(sport=3D23, dport=3D23), iface=3D'vm1')"; echo -e =
"\n----
> > After data with neither one of tcp sport/dport being 22 ----\n"; sudo
> > $IPTABLES -L INPUT -vn; sudo $IPTABLES -D INPUT -p tcp ! --sport 22 !
> > --dport 22 -i vm2
> >
> >
> > ---- Before data ----
> >
> > ip filter INPUT 41
> >   [ meta load iifname =3D> reg 1 ]
> >   [ cmp eq reg 1 0x00326d76 ]
> >   [ payload load 1b @ network header + 9 =3D> reg 1 ]
> >   [ cmp eq reg 1 0x00000006 ]
> >   [ payload load 2b @ transport header + 0 =3D> reg 1 ]
> >   [ cmp neq reg 1 0x00001600 ]
> >   [ payload load 2b @ transport header + 2 =3D> reg 1 ]
> >   [ cmp neq reg 1 0x00001600 ]
> >   [ counter pkts 0 bytes 0 ]
>
> You're fibbing here: That netlink debug output can't come from
> iptables-legacy. I suspect it actually comes from your patched
> iptables-nft or nft too. :)
Oh.. yeah, probably yes. iptables-legacy would not use the VM instructions.
Sorry, for mixing up things.

>
> [...]
> > Author: Sriram Rajagopalan <bglsriram@gmail.com>
> > Date:   Fri Mar 07 20:09:38 2024 -0800
> >
> > iptables: Fixed the issue with combining the payload in case of invert
> > filter for tcp src and dst ports
> >
> > Signed-off-by: Sriram Rajagopalan <bglsriram@gmail.com>
> > Signed-off-by: Sriram Rajagopalan <sriramr@arista.com>
>
> Maybe avoid the double SoB? Apart from that:
>
> Acked-by: Phil Sutter <phil@nwl.cc>
>
> Thanks, Phil
