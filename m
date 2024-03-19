Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A397BAF5;
	Tue, 19 Mar 2024 02:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710816804; cv=none; b=PCQa1SbALWbxgOJ5AeAIuXbtVPneJxVdWXzRAB6IGL3X7P+qA4AZPfoKZBUVutMxHLcx2Il0XHkCA4gUsMvDyXd5OPFgQcM/cLJHSQ1lLZb7WdLLATolJqOEmNv2yquHjS7nMNnPKFDlFCCys12ynyH4JWFGbPlYGSrvaD2Xzyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710816804; c=relaxed/simple;
	bh=Zxyts5lPZvaP44xiWGztqFVT+KpEO0dnNEyK7IoDbV4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jSvFwbmncKHsvwLnM9l0vzJiqI+0U80e29+JEFof71/rTCvJFn3a5cZQme8gPdDz3YAhyZK3Uh5IQqBRV/XzuGndfvaPU0F4XHfb9IAqMIWDCwUYh56WyhM9gjCrSfY2+R9qg2ZhlliKYWS4TjVKCTbcfKL6AD9S8jipKQx5sVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CidIsDrD; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CidIsDrD"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a46db55e64fso26077566b.1;
        Mon, 18 Mar 2024 19:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710816801; x=1711421601; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9gD6BrNu7wEli3QCno5011uW/xmhOWQhod+0lHWEwc=;
        b=CidIsDrD6hJ6Pxj5OW6sw/FGViw16r2xJxvsNCk8qIP1bxEdg1HZUWjfQfHNIrdEiu
         JCyGIfkf7eZeMadxULO9o5W7r9SqOql9jyFtJYHVQVJBfiR3L9+vrxnOaVYZ50LzFaKO
         11TAzVBDobzcaW66PSQj6YKjZf7QUWD0Nhn0I19d3Yahvq0H00PIS2e6FHz556Zd4FPK
         AglAlHyi/V/1/f2YptJ+VYCcgx9C27cMj3j0wTC0kCTWsSOVqYYFKg1A5ciE8BtrKTBu
         7zcfPJIbDL4eB4PapcwAut51sOyKgRu3NvMK68Icj1Vlr8nAhsdcIzbzcv82HSPiLWyi
         2Urw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710816801; x=1711421601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9gD6BrNu7wEli3QCno5011uW/xmhOWQhod+0lHWEwc=;
        b=W5q29p6DCIPjbovRIIcjUkxF/uZ2X43KO9qcCnDwl7J3y5B+Yp8F5iG176HWGixVOK
         +RLvhBoo5hFlTzTZ34w2F39GSXMRPaLgVnVfGo3yAev9WOWetKEOP+NPDkffz/7FFd1v
         a6PXnGejtsJ2gGMLY9Ke6euFskDSrK1RyqfzgIpKsgSzx56ntb/yl1b5DCLsW/fj3Y3q
         H1U3zGiSuuW0dahOd8nIU34YXgPAeH0p5/fOVpP6ImUJcFUXbbSziUKvW59v1g7a8rLU
         sbiNc45KlsT5BeJcqgK1QyCQJ+AYqd33jNIZowTVPqzZ0KSLasMZvGIc8IrsNFIzBjdc
         S2Sw==
X-Forwarded-Encrypted: i=1; AJvYcCUP+O5IgMWKJfQuoTeU70bmV3BywEUuA3cl0c4P98S0sl4tSzD/k5WRxXj47MZnOVhQPGOLHZkY1W+cr2CcOhJ92bOsTBZggnBjiwWIPW7toIWQlFDPizGJCpeWd8FYfTuO8WFYR0Ip
X-Gm-Message-State: AOJu0Yx23A4v9QWrZUqLHc2v9Zgb83u9JPNE/uOp4Ii89GjBJO2W8usI
	9WTJ7ZU4xa6lIDoCH4IZRLuq5O1G1ICzUmmAY42kEubpul1FuceirV4oZGphKMG/6JuzQ8RIMtx
	L30brGRX2AeKmbaFOgBDARF43RDI=
X-Google-Smtp-Source: AGHT+IHssxyvNdr3L63+NZHNAhghqNLhvpUa2mxbkYkJJG5PKll9ckbnTkur9sYto5is8knHGuxl+1hhHlNiTTniOBU=
X-Received: by 2002:a17:907:6d0d:b0:a46:a927:115e with SMTP id
 sa13-20020a1709076d0d00b00a46a927115emr6713763ejc.39.1710816801073; Mon, 18
 Mar 2024 19:53:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240311070550.7438-1-kerneljasonxing@gmail.com> <20240318201608.GC185808@kernel.org>
In-Reply-To: <20240318201608.GC185808@kernel.org>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 19 Mar 2024 10:52:44 +0800
Message-ID: <CAL+tcoCDs+0OJ3VE59KSyvvyzOxqf0SW-hojDeccwdB=PazwqA@mail.gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
To: Simon Horman <horms@kernel.org>
Cc: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org, 
	fw@strlen.de, kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Simon,

On Tue, Mar 19, 2024 at 4:16=E2=80=AFAM Simon Horman <horms@kernel.org> wro=
te:
>
> On Mon, Mar 11, 2024 at 03:05:50PM +0800, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > Supposing we set DNAT policy converting a_port to b_port on the
> > server at the beginning, the socket is set up by using 4-tuple:
> >
> > client_ip:client_port <--> server_ip:b_port
> >
> > Then, some strange skbs from client or gateway, say, out-of-window
> > skbs are eventually sent to the server_ip:a_port (not b_port)
> > in TCP layer due to netfilter clearing skb->_nfct value in
> > nf_conntrack_in() function. Why? Because the tcp_in_window()
> > considers the incoming skb as an invalid skb by returning
> > NFCT_TCP_INVALID.
> >
> > At last, the TCP layer process the out-of-window
> > skb (client_ip,client_port,server_ip,a_port) and try to look up
> > such an socket in tcp_v4_rcv(), as we can see, it will fail for sure
> > because the port is a_port not our expected b_port and then send
> > back an RST to the client.
> >
> > The detailed call graphs go like this:
> > 1)
> > nf_conntrack_in()
> >   -> nf_conntrack_handle_packet()
> >     -> nf_conntrack_tcp_packet()
> >       -> tcp_in_window() // tests if the skb is out-of-window
> >       -> return -NF_ACCEPT;
> >   -> skb->_nfct =3D 0; // if the above line returns a negative value
> > 2)
> > tcp_v4_rcv()
> >   -> __inet_lookup_skb() // fails, then jump to no_tcp_socket
> >   -> tcp_v4_send_reset()
> >
> > The moment the client receives the RST, it will drop. So the RST
> > skb doesn't hurt the client (maybe hurt some gateway which cancels
> > the session when filtering the RST without validating
> > the sequence because of performance reason). Well, it doesn't
> > matter. However, we can see many strange RST in flight.
> >
> > The key reason why I wrote this patch is that I don't think
> > the behaviour is expected because the RFC 793 defines this
> > case:
> >
> > "If the connection is in a synchronized state (ESTABLISHED,
> >  FIN-WAIT-1, FIN-WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT),
> >  any unacceptable segment (out of window sequence number or
> >  unacceptible acknowledgment number) must elicit only an empty
>
> Not for those following along, it appears that RFC 793 does misspell
> unacceptable as above. Perhaps spelling was different in 1981 :)

Thanks for the check. Yes, it did misspell that word. Should I correct
that word in my quotation?

>
> >  acknowledgment segment containing the current send-sequence number
> >  and an acknowledgment..."
> >
> > I think, even we have set DNAT policy, it would be better if the
> > whole process/behaviour adheres to the original TCP behaviour as
> > default.
> >
> > Suggested-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
>
> ...
