Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nWHX/a0M"
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E84C2
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Dec 2023 04:51:06 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-a1b68ae40ffso32383466b.0
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Dec 2023 04:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701607865; x=1702212665; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fo1ThhbKoMzsJlIm4D9guv1fWm5cgJu3zNpJmLRbFO4=;
        b=nWHX/a0MFbkLDQKRzdlB+BjJu9jm7jXLhPCPOlZo4y1ewxJ8Zro/tuapWqwblksOU9
         ypqjCZntFuiNduP64rjfUOkogrXb39zsPRU26BQNR9F4gYnsQ6h+2+gyCp5NJrXzvivs
         y2IL2FkHzGPfIfk2inN0cuhADu/2JD0gFVwI+kDGsGzUt0rF5Gdj404o1i6SzOnA2FlI
         yU86lxv9ugE1Q9FUup4C4HCWC00vdVqIufjuQLN6vNzKC5ly2tWaRWmVLmLDYouuaS5q
         joO0K3w8Mp3gbsYkZ8wjl/Ik9QU+G+/3knoswUu94xGWuxn5wseswrYnCBZcUHyvSQnB
         qxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701607865; x=1702212665;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fo1ThhbKoMzsJlIm4D9guv1fWm5cgJu3zNpJmLRbFO4=;
        b=cg92XMo64qzzO384rHFdT+qzErXUDtsPY0EMhVNtu1W1UHfcednGyI0pqQXkGpwwH7
         e5yGV1KlsvJB2rz+XE7DjiupDzCFnT5DNAobYVq20zewuwCh5ESyMXrx5OrQsvdxHI8s
         XtX9zCYnyWQ46vv7k6oKzkEmuWTjvQQY/AaUhtH+uREweE1YVT2+iHNcKsQGJ2t/79ER
         CTEf7SZzT32MBlBnOaUE/SNGOJu7DqYQwmO/sYYkLOK4l1A4CFp9qDjMrc2DbiAXaujc
         GG3UqEP3EBJ7iBCQrSt/r10IM1K+5JASxbLxnwgfEiqxoDphE6ixOsX1Ai+hk3twPb6C
         ZpFg==
X-Gm-Message-State: AOJu0YyJ0pp8EgVc0jpb5hbB4np2pdsTj2RqujS/cn4BGq+xc98aOL1z
	VdSE5Gv6OGpPCjwkDDEkqfcjfq3AgjrFpD3Nc2wgTo7Jxn6XGg==
X-Google-Smtp-Source: AGHT+IEDoaDhzsjYqcH6TU9y8ERRyTWVED7Nack3L4TOjXQxn2mW0OiQ9uss+gr7lF25CGoDHq9p8H6/bdHdEnVcndk=
X-Received: by 2002:a17:906:378a:b0:a19:a19b:4235 with SMTP id
 n10-20020a170906378a00b00a19a19b4235mr1582788ejc.160.1701607864504; Sun, 03
 Dec 2023 04:51:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHo-OozyEqHUjL2-ntATzeZOiuftLWZ_HU6TOM_js4qLfDEAJg@mail.gmail.com>
In-Reply-To: <CAHo-OozyEqHUjL2-ntATzeZOiuftLWZ_HU6TOM_js4qLfDEAJg@mail.gmail.com>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Sun, 3 Dec 2023 04:50:53 -0800
Message-ID: <CAHo-Oow4CJGe-xfhweZWzWZ0kaJiwg7HOjKCU-r7HLV_TYGNLQ@mail.gmail.com>
Subject: Re: does nft 'tcp option ... exists' work?
To: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

FYI, I upgraded the router to OpenWrt 23.05.2 with 5.15.137 and it
doesn't appear to have changed anything, ie. 'tcp option fastopen
exists' still does not appear to match.

Also note that I'm putting this in table inet filter postrouting like
below... but that shouldn't matter should it?

root@mf286a:/usr/share/nftables.d/table-post# cat disable-ipv4-fastopen.nft
chain postrouting {
type filter hook postrouting priority filter; policy accept;
meta nfproto ipv4 oifname "464-xlat" tcp dport 853 tcp flags syn /
fin,syn,rst,ack counter tcp option fastopen exists counter drop
comment "Drop Outbound IPv4 TCP FastOpen"
}

On Sun, Dec 3, 2023 at 4:24=E2=80=AFAM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> (ran into this while debugging
> https://bugzilla.redhat.com/show_bug.cgi?id=3D2252550 &
> https://forum.openwrt.org/t/how-to-block-outbound-ipv4-tcp-fast-open/1795=
18
> )
>
> CC'ing Florian directly based on:
> https://lore.kernel.org/all/20211119152847.18118-6-fw@strlen.de/
>
> f39vm# tcpdump -i eth0 -nn 'ip and tcp and dst port 853 and
> (tcp[tcpflags] & (tcp-syn|tcp-ack|tcp-fin|tcp-rst) =3D=3D tcp-syn)'
> dropped privs to tcpdump
> tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
> listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 by=
tes
>
> 03:59:51.539225 IP 192.168.10.2.34324 > 8.8.4.4.853: Flags [S], seq
> 2804210339:2804210653, win 32120, options [mss 1460,sackOK,TS val
> 417951723 ecr 0,nop,wscale 7,tfo  cookie d2f9ee39dc952129,nop,nop],
> length 314
>
> and yet on the OpenWrt 22.03.5, r20134-5f15225c1e (5.10.176) router I see=
:
>
> meta nfproto ipv4 oifname "464-xlat" tcp flags syn / fin,syn,rst,ack
> counter packets 1 bytes 386 tcp option fastopen exists counter packets
> 0 bytes 0 drop comment "Drop Outbound IPv4 TCP FastOpen"
>
> so AFAICT it sees the SYN, but not the option.
>
> (and yes, if I run it longer the first counter increments exactly when
> tcpdump shows an outbound syn with fastopen, the second counter never
> increments)
>
> btw. this doesn't appear to be limited to the fastopen option.
> Changing 'fastopen' to 'mss'/'maxseg' or 'sack-perm' or 'nop' also
> does not appear to result in it matching and the post match counter
> does not increment...
>
> I understand "tcp option fastopen exists" translates to:
> inet
>   [ exthdr load tcpopt 1b @ 34 + 0 present =3D> reg 1 ]
>   [ cmp eq reg 1 0x00000001 ]
> (but I don't know how to read that)
>
> Is there perhaps some minimal kernel version dependency for the above?
> (but if so... why does the ruleset even load into the kernel)
>
> - Maciej
