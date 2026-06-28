Received: from mail-ej1-f66.google.com (mail-ej1-f66.google.com [209.85.218.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DF63537D0
	for <netfilter-devel@vger.kernel.org>; Sun, 28 Jun 2026 05:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782625515; cv=pass; b=QtDhdqNyH4fNfPKH2VIZ0zxy7NGSezplmNJjtbV5YctcqqZIf4w2iTN0CSXm8J42cvPSThXAhUqUul6ydDFIaeCGC1diuUcByliioOqJqRVcOexyRODBGubRoLVMv1TlyxYUM289lMbZ/UTMt6zneKTIdZIdOr7NT4o622GXqwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782625515; c=relaxed/simple;
	bh=Hc1AF5CYasLbTlGV9oYOuBcM5iYw5fAGn0qVWD48s/c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u7Id+NtFBBZ0ai2vghsxubIXimXDBeH19Qo2NkY1uPgK2n3FVJoTM1rlxWqcCgJ7M16mq1czAItIo54T95OAsuRjXttW4BBh+RP5jvGGIUUwPUvQf/b3vbwfJAm6BZzCRYYxAZFGG0ZeFTTIeD0n7IILOdWu7poOuHpL7xrJcj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qDb0WtUB; arc=pass smtp.client-ip=209.85.218.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qDb0WtUB"
Received: by mail-ej1-f66.google.com with SMTP id a640c23a62f3a-c08acccf4a4so301977066b.3
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Jun 2026 22:45:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782625512; cv=none;
        d=google.com; s=arc-20260327;
        b=ZQe+BpgyAJXjwWaDMcpj5LHM8dhq7WMH5ZJiCPPUPilgfY4822ZDj5kqf/ly09NAVZ
         wZ9rrB0zflFz9c941EgEgd32vyGJstiK3Q09vqhxXUxymoSgOW6CPfYyaFd/Eqc2Efu9
         CCRUdrH/Iwl96pJcqu8AEia6xP+BsPJA/mDB1GX6etRqUe+xe/kH2dILs2VRv+x/mFnq
         KXweYgul3jHYw8Rmb8Juf1Hi59twxAFeUDUaChzGdH5EybJSA08O+apMRtAS9lfqDpTB
         8XXYP9iV6Gq4rP1zJdjcNI+CKgKn1Zvu3FEgq4fUQqGyuVFjVah5VvUz8CB7RndP54XC
         2xTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ryg9VsI2q7eTLjDcyzpNo1Dk3naB663ocaoFsbpektQ=;
        fh=5Y7oQifNETRcX1uboJzbb0g21+FOVz3uHJbOY7/DDQQ=;
        b=XWk/bZKCRIIWvm7I6985v128iUdaU7/T8Nsg4mQf5FE09rwpfl0BLo6GdhMMJ92GDm
         vd0MiLSaFtKfHjhEE+L8ofArriS+avdjmCiBFnsW/hNfnPOef7EjDXa9ouUm1eXbXu6S
         G6K1saDFJGpYK4mdGtyPNTWfYiGnqYmXF032nZwzQnXuQfj3feXKC6OGk46Tzh8B1DkU
         oUaxTCkcm8O36x01/f02et6VqcXW3omfL2Oc+GoRDyG9TWDLO2VSxRFLGAX/uBbjKoih
         0wVBBceDirLlm/la9kWtFgNdT3algHCGBVPou3XpjKhh2n4oa+N7rdn2zGnbtPlvWv+Z
         vAOA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782625512; x=1783230312; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryg9VsI2q7eTLjDcyzpNo1Dk3naB663ocaoFsbpektQ=;
        b=qDb0WtUBM4TNXbdDLx3grZkIoo9ks5xMoFBWzMgZN2X1llCp5Y0zCL5Icw4GMgUEpd
         JOQz1Qnvf9T5mqw66oEQ6Fq8OexuTVNYyC+trQ+Aw9MXSuZNgieJmtiDhlQlV9v9CczS
         DodNVaIoniFecE1tPn1CiQiCqlBx8FSaeulgXh8rASjwFBwBVuRXbUQ+W7ORLkQ83vvS
         JwDhZ5fterh1lkuDXuM5F6Ije1eFB2WIlpIdLMiYBnaZR0fjWyru+G4Utoch+LIPafYL
         Qm3dahv0GZzm3G/tGmaX3D2SNsgnO2GVIdSHB7mlt1Yx34nfl6xn8hcQjd0qosh3Gdo6
         GNJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782625512; x=1783230312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ryg9VsI2q7eTLjDcyzpNo1Dk3naB663ocaoFsbpektQ=;
        b=AAtLiQYt72cPW69BQPNyC5G1m0vsvs9t3ZJM+DtVNOnTojE8MplDGiW8qLjt/KbA7L
         0xN1wy0KlGBaAx6agXovtBSlVV321G9MMJwUSGU92W7cxM5pMotsUcn1iNvjQCa4j76a
         30KFeyrFxbLqM9Wum+vnyFMcnwlMYiH4FePv88qezclS9damNtdFOuJcI0uzpJF4H2c6
         CZHZ6FtN3Q6rEpBU+7d6dwit9sovOH1vK8wughajldy6J4DoicbDPMFI7R3LCw2hqX/N
         4d0Pd4rsk3D8QzM7H5Fe+pC7YPYwUerrVxrSWj+04P23q2B4Bh98FYT7fvac8agy3i1P
         5heA==
X-Forwarded-Encrypted: i=1; AHgh+RrhzxN27pf88LBBPZwcmNSIaCYqusL67xbgtnsAWbFuvDKpgv3jgphwYZBPVD85G39HLQuECgkuADx8Bai/IBM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzX9nkI23sj9J4BTVZ8R7Bpppf5aX3+riBYIAV+RuwrudezrDEv
	phsglpfBWOuFZF4gMvKQLQobmJcGjsN4k/oJXw/miYbi/XQ0X3NUE2IhITuatyYre9944zeOehS
	qf87AR+vYWsIBDIHmU46ImFmEBFgwJBA=
X-Gm-Gg: AfdE7cmim1acHRQitdRqfxNainUP7ywfU/wj9kUv/3TyRUZxDzi7W+QgQECylnn64z0
	DS4hrnoZVOduUAQnneDMBFN2jN+5Pgl6qrY0anuewJ0BYetXp2tsIutLAPpr/1gFBuhXWxOcpaX
	tH8cIM2x4Taxywr8GM3dUdBBbweEEnQBh3VTyoAAPssttBrQ63cCLpQY0jvAQTNoQpljxonD7Pa
	D6k1c6NfknDYInNwINUwIg4dBndDt3WhOZHyc3AplYUBb/9R/vDfJ93E7B+YyBR0tj4uySM
X-Received: by 2002:a17:907:3c86:b0:c12:fb7:2b33 with SMTP id
 a640c23a62f3a-c120fb7321emr647148166b.22.1782625511876; Sat, 27 Jun 2026
 22:45:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1782540466.git.roxy520tt@gmail.com> <1b914f41d725bc064c9ba9830dc8169329737270.1782540466.git.roxy520tt@gmail.com>
 <a37698c7-46de-1f04-5306-b6a6af7ee6c7@ssi.bg>
In-Reply-To: <a37698c7-46de-1f04-5306-b6a6af7ee6c7@ssi.bg>
From: tt roxy <roxy520tt@gmail.com>
Date: Sun, 28 Jun 2026 13:44:59 +0800
X-Gm-Features: AVVi8CfHVbnPZ1rZlBSrW9Z6b4N9_UcNROEh7oVZYpN_tGY6tdLcfHYQLaKgELM
Message-ID: <CALMqdkR704S2BG_QD_bgHTFp2+1QCi7n0T4zoZyTo8mDZevYSA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ipvs: preserve conn hash flags when late-binding dest
To: Julian Anastasov <ja@ssi.bg>
Cc: Ren Wei <n05ec@lzu.edu.cn>, lvs-devel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, horms@verge.net.au, pablo@netfilter.org, 
	fw@strlen.de, phil@nwl.cc, kaber@trash.net, nick@loadbalancer.org, 
	yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com, 
	bird@lzu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 28, 2026 at 4:47=E2=80=AFAM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Sun, 28 Jun 2026, Ren Wei wrote:
>
> > From: Zhiling Zou <roxy520tt@gmail.com>
> >
> > Synced connections can be created before their destination exists. When
> > the destination is later added, ip_vs_try_bind_dest() binds it to the
> > existing connection through ip_vs_bind_dest().
> >
> > ip_vs_bind_dest() copies destination connection flags into cp->flags.
> > For an already hashed connection, changing flags that define conn_tab
> > membership breaks the hash table invariants. In particular, adding
> > IP_VS_CONN_F_ONE_PACKET after the connection has been hashed can make
> > expiry skip unlinking it from conn_tab. Changing the forwarding method
> > can also make unlink use a different single or double hash-node layout
> > than the one used at insertion time.
> >
> > Preserve the flags that define conn_tab hashing when binding a
> > destination to an already hashed connection.
> >
> > Fixes: 26ec037f9841 ("IPVS: one-packet scheduling")
>
>         The problem with the fix is that we should do it
> in the hard way: the backup server should be able to define
> its own forwarding methods. Otherwise, we can break existing
> setups. For example, master can have localnode for some
> dests, this can not be preserved in the backup for the
> synced conns.
>
> > Cc: stable@vger.kernel.org
> > Reported-by: Yuan Tan <yuantan098@gmail.com>
> > Reported-by: Yifan Wu <yifanwucs@gmail.com>
> > Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> > Reported-by: Xin Liu <bird@lzu.edu.cn>
> > Assisted-by: Codex:gpt-5.4
> > Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
> > Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> > ---
> >  net/netfilter/ipvs/ip_vs_conn.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs=
_conn.c
> > index cb36641f8d1c..016273906aac 100644
> > --- a/net/netfilter/ipvs/ip_vs_conn.c
> > +++ b/net/netfilter/ipvs/ip_vs_conn.c
> > @@ -998,7 +998,11 @@ static inline int ip_vs_dest_totalconns(struct ip_=
vs_dest *dest)
> >  static inline void
> >  ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
> >  {
> > +     const unsigned int hash_flags =3D IP_VS_CONN_F_FWD_MASK |
> > +                                     IP_VS_CONN_F_NOOUTPUT |
> > +                                     IP_VS_CONN_F_ONE_PACKET;
> >       unsigned int conn_flags;
> > +     __u32 old_flags;
> >       __u32 flags;
> >
> >       /* if dest is NULL, then return directly */
> > @@ -1011,7 +1015,8 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_=
vs_dest *dest)
> >       conn_flags =3D atomic_read(&dest->conn_flags);
> >       if (cp->protocol !=3D IPPROTO_UDP)
> >               conn_flags &=3D ~IP_VS_CONN_F_ONE_PACKET;
> > -     flags =3D cp->flags;
> > +     old_flags =3D cp->flags;
> > +     flags =3D old_flags;
> >       /* Bind with the destination and its corresponding transmitter */
> >       if (flags & IP_VS_CONN_F_SYNC) {
>
>         We can here unconditionally drop the IP_VS_CONN_F_ONE_PACKET flag=
:
>
>                 conn_flags &=3D ~IP_VS_CONN_F_ONE_PACKET;
>
>         Because IP_VS_CONN_F_ONE_PACKET conns are not synced.
>
>         And here when (flags & IP_VS_CONN_F_HASHED) and the fwd
>         method changes between MASQ and non-MASQ for
>         !IP_VS_CONN_F_TEMPLATE we should call some new func
>         that properly hashes/unhashes just the hn1 node.
>         I can provide such function with proper locking.
>

Thank you for the review.

I agree. Preserving the forwarding method is too conservative and can
break backup setups where the backup server intentionally uses its own
forwarding method.

For v2 I will drop IP_VS_CONN_F_ONE_PACKET from conn_flags
unconditionally, since one-packet connections are not synced.

For the MASQ/non-MASQ transition on already hashed non-template
connections, I agree that the right fix is to update only the hn1 hash
node instead of preserving the old forwarding method. Since this needs
to follow the conn_tab locking rules carefully, I would appreciate the
helper you mentioned and will use it for v2.

Thanks,
Zhiling

> >               /* if the connection is not template and is created
> > @@ -1023,6 +1028,13 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip=
_vs_dest *dest)
> >               flags &=3D ~(IP_VS_CONN_F_FWD_MASK | IP_VS_CONN_F_NOOUTPU=
T);
> >       }
> >       flags |=3D conn_flags;
> > +
> > +     /* Preserve conn_tab hashing invariants after late binding. */
> > +     if (old_flags & IP_VS_CONN_F_HASHED) {
> > +             flags &=3D ~hash_flags;
> > +             flags |=3D old_flags & hash_flags;
> > +     }
> > +
> >       cp->flags =3D flags;
> >       cp->dest =3D dest;
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
>
