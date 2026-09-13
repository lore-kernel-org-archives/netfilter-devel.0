Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D048E3C1F4F
	for <netfilter-devel@vger.kernel.org>; Sun, 13 Sep 2026 07:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789283651; cv=pass; b=NC028dyIZ2PfZ8+SE4V/4Ib8K5UiH3zJ6z6/EH+vrrScd6UPWwmmuoVCRAoOkKjrny4m6bOF0p/oZe3gY8NzEOuyZDRkrWgDZBmmVN3RJ7dVT4en32wX75CBGVb4lvrwPsqR88pzoSP86QbAcY/HjeN3FiRUFW1FV5ubuIZAvis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789283651; c=relaxed/simple;
	bh=37ug2nMqVijwXjDMz+dkuUWa2OB5OvqNxj209iQ0QhI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qpL6Sr4v8KzquU2ZGqBYkXBdHr7pwwz0hNlRVefX4MLLOTRbKUXrFjEaJ+mvHa8euKKvHPKCgRWAbj9p9CkJXa1/a7KCkDn2Pyyksd3D9csPsi0TIIvSV9trv9LLp41k+pqB74RNTbARTqVVjNRdje/n8GW2BqxPmUTHz/JeSiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=W5N88WAd; arc=pass smtp.client-ip=74.125.230.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="W5N88WAd"
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a2ff176d5bso11534291fa.2
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Sep 2026 00:14:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789283648; cv=none;
        d=google.com; s=arc-20260327;
        b=nYEB+BMWWR7dIJdeN1PFwqfrOojXuNiFXAQ7upuuZTz9seyc1Lg+8rdLdgT+HCDPjH
         PT0O7ZXa2y/ZaQ5S3CKfLLEOK+yxTtsPweHSl3ZJq5eozOIfdYPcSWXUFs9pfHrvJOnK
         G5tH/Nz/u0OP2Tig6eK+nsIZwP2Vj6MCtb9IW1YcQoEcVgXsmpambf/OVOjswZP8Gz9z
         DzUF+z3gMs//Jo36kA3urX/5Q+W4J5ljKTL9RMMgBNPBGBDahCGgRaOeajD/UIDdoA4l
         UDTe4G7kXUhC3brLQFI/wohexmAxqK7E8ADOCGd4+psGr4O9GetNmT93AerB8/FxQsBQ
         gXiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zc6rn6hBg7Dbx72kKEyqG0IA3oFbZYoVZQLtRzcZKOg=;
        fh=MvvXm+fRmQ8Hp0kNxU3WbgETHsAIdoktgrhKWDXYyUw=;
        b=Y/R/ZQuMq3KYp3JQPgr4yUXWd7WLiR7cm3CE4cK3fMtMxMRpUXckbTkfLbTziRwi4S
         2HxtATEGOfuAWCKkBhfj4i1Mg1GfBd2PI94siJGTmJADsCsrQZ0XAE1jrryQD4djTayW
         pV4Ik/B6CjmHO3seXg1mbNsTALWjmns+AzL8k54G1ZBununk38liAizxScED4lvd1wl7
         UeXtthpahHmP/YsvW8QQV9uiB5OCwJRw9Id/oQ7pKr1O02mnWHFGbTNfCrblvJGTuiiE
         v0PWqPdeKag0xOV8RvpzSnfgq7wu19UXLQ5TbqSFibkFc7Ivva/iLjSu/lIbfucyvenp
         O7ZA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789283648; x=1789888448; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zc6rn6hBg7Dbx72kKEyqG0IA3oFbZYoVZQLtRzcZKOg=;
        b=W5N88WAdSLB/LLV5+MllrleynP8UTzD5IVug07B9VXEVXlZhejamBLAWaEIo1kQNjH
         GnjePwnoI1Fn9Nf8qU4tshKUSHyR80ixzy81aRmSZrk3c0ThU6WQONsY+K4LN8cRlPxe
         zJtwP8l+fnEq9qVl1Z5alg5KY9kgwQiqlKzm5sQJx9VfFGrkEYPpTIkjR5g8AYBt0FJ/
         HSvfwhqyf4Ru001u4tJsqCfhhGjeNngzVgWjBN4aFEgVwRCghl7LUy9YjC7EcIT+E1qs
         THHZNTIzrR+6BXm459mfo1WZLKIlylVtkrHj1P4gRPLTyF2fjCTflotmyGyHnMZpPZrT
         +Kgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789283648; x=1789888448;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zc6rn6hBg7Dbx72kKEyqG0IA3oFbZYoVZQLtRzcZKOg=;
        b=pbIX32NmAMhG8rgaIe9O189FIQCeiCGy+lDGdQbJqWJrS0/fQmSYHkLylJoPIZfSjJ
         eGjoKahOl2HtJGdM2LTpcW6MF9JKJjRjGI0o13YSnPFQyjuQ0wAoWgL7lNKqbekTLrob
         gTKIL558QrhIJQzRlA4/XFQnGOosfx9eY+ogQKDlf32PTnOdehzXgAEWeqHxhRX/7ljL
         AeIT9bS3of/9zzjgIybgOpxmADQ7GbUsD3LSVPRv9pu3hiCz2i4zek11pJV7O40hpWD8
         3pk7TGp8unmnHDbuJn7/jnAcf3uf1V5aAkAmQVa44SEMpZXiy5Gq4Jn7ezL8sLZVwcOC
         K8CA==
X-Forwarded-Encrypted: i=1; AKwUvBwde6KF1c96JznY4XRhBgnDPtrpy+3B+UWgjsgI4w7MNTwsnTl9xm7RrmIxe2vx9gMbGCGM5WIBtvv39IRAgfA=@vger.kernel.org
X-Gm-Message-State: AFuF++nInZBGUCuNEyo6PlWW0NMyzCi3R02OXy1mB8WSf882xAokwAF+
	DCsU0IOnGnSo+JEXHvROi/BrFfRLJ2CEkGLQ83+xpu5NtRdUTErYUiNAGvCr+JP6iq/UOJjIDvx
	S4JN4kyew1lvoE04LiifH0i86n6f11OWr16zH4comoyk=
X-Gm-Gg: AYBFou0PyOcVL0Qlg4WO8ONu9D2LqC5bVR6u8rq30+azfpnU0PEfFHZo3Bg3ZJ/bmO9
	YiC36RXSd2S7F64HzX94tdaXq+ienqQckjUFaCC7Ka5uFMGuuGpdVNUsAEfqLn4D9qU1HHHFVJ5
	VFasPNi7fKhEhtCZY9poEeLrFcxlfDj0qdvwbLXppSXmMlW9XTSADkhCGSw3Fyiue8NTAomxLqj
	WMsvpA9ANDVNSnnU3vTiAAjnxSB/BW5aewb0C6gbt8CoZsojo6kF33m5LZJN+kbkFZ+BobnwwgH
	e1Fl61RAwcF7dSUMkyAn1JUBeS2vsovahuTCcEPXgW1LW/efy9JEFtQfRz51waWGaj51jl0dIk+
	swf/WsCHSRdQ=
X-Received: by 2002:a05:651c:4cb:b0:3a1:4f33:f60e with SMTP id
 38308e7fff4ca-3a5a521976amr22625301fa.8.1789283647218; Sun, 13 Sep 2026
 00:14:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789110326.git.zihanx@nebusec.ai> <d99cb205-24fc-7446-55ad-4ec9d79aac1d@ssi.bg>
In-Reply-To: <d99cb205-24fc-7446-55ad-4ec9d79aac1d@ssi.bg>
From: zihan xi <zihanx@nebusec.ai>
Date: Sun, 13 Sep 2026 15:13:54 +0800
X-Gm-Features: AcwNN1VXwXGHgzutYNNcW-pu10V6yDK71GNfucz-I1ocWnp42Hrzm0uFodmzH7U
Message-ID: <CAANe3eQFtNuPpw1_W11hDf_S22WK99LD_FDSijt1Gu85_hELvw@mail.gmail.com>
Subject: Re: [PATCH nf 0/1] ipvs: avoid stack overflow from recursive
 connection expiration
To: Julian Anastasov <ja@ssi.bg>
Cc: horms@verge.net.au, pablo@netfilter.org, fw@strlen.de, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, phil@nwl.cc, 
	netdev@vger.kernel.org, lvs-devel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 13, 2026 at 1:50=E2=80=AFAM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Sat, 12 Sep 2026, Zihan Xi wrote:
>
> > Hi Linux kernel maintainers,
> >
> > We found and validated an issue triggered through
> > net/netfilter/ipvs/ip_vs_ftp.c. An unprivileged user can trigger it by
> > creating a user namespace and a network namespace. We tested the fix wi=
th
> > the same trigger. The change applies to the generic
> > ip_vs_conn_expire() control-chain cleanup path. For the reported trigge=
r,
> > it only defers recursive controller expiration; testing showed no chang=
e to
> > other IPVS behavior.
> >
> > We will provide detailed information about the bug
> > in this email, along with a PoC to trigger it.
> >
> > ---- details below ----
> >
> > Bug details:
> >
> > The trigger entry point is ip_vs_ftp_out() in
> > net/netfilter/ipvs/ip_vs_ftp.c. It parses an EPSV reply and creates a
> > wildcard data connection using the advertised port. If that port is 21,
> > ip_vs_conn_new() binds the new connection to the FTP helper a second ti=
me,
> > because 21 is the helper's control port. The connection has
> > IP_VS_CONN_F_NO_CPORT, so the next connection from the same client to t=
he
> > VIP on port 21 matches the wildcard entry instead of creating a new
> > top-level entry. Repeating EPSV builds a chain of controlled connection=
s.
>
>         Hm, may be we should also avoid such long chains.
> Probably in separate patch, for example:
>
> diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ft=
p.c
> index 9e3e005a8263..0622169b5970 100644
> --- a/net/netfilter/ipvs/ip_vs_ftp.c
> +++ b/net/netfilter/ipvs/ip_vs_ftp.c
> @@ -237,6 +237,17 @@ static int ip_vs_ftp_get_addrport(char *data, char *=
data_limit,
>         return 1;
>  }
>
> +static bool is_control_port(u16 port)
> +{
> +       int i;
> +
> +       for (i =3D 0; i < ports_count; i++) {
> +               if (ports[i] =3D=3D port)
> +                       return true;
> +       }
> +       return false;
> +}
> +
>  /* Look at outgoing ftp packets to catch the response to a PASV/EPSV com=
mand
>   * from the server (inside-to-outside).
>   * When we see one, we build a connection entry with the client address,
> @@ -293,6 +304,9 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struc=
t ip_vs_conn *cp,
>
>                 IP_VS_DBG(7, "PASV response (%pI4:%u) -> %pI4:%u detected=
\n",
>                           &from.ip, ntohs(port), &cp->caddr.ip, 0);
> +               /* Do not redirect data to control ports */
> +               if (!port || is_control_port(ntohs(port)))
> +                       return 0;
>         } else if (cp->app_data =3D=3D (void *) IP_VS_FTP_EPSV) {
>                 data =3D ip_vs_ftp_data_ptr(skb, ipvsh);
>                 data_limit =3D skb_tail_pointer(skb);
> @@ -529,6 +543,9 @@ static int ip_vs_ftp_in(struct ip_vs_app *app, struct=
 ip_vs_conn *cp,
>                 return 1;
>         }
>
> +       if (!port)
> +               return 0;
> +
>         /* Passive mode off */
>         cp->app_data =3D (void *) IP_VS_FTP_ACTIVE;
>
>         The only problem I see with your proposed change is
> that we may need 2-3 timer ticks to expire a DATA->CTL->TPL
> chain. Or it expires on the same tick?
>
>         Alternative would be to jump to the beginnig of the
> function after successful timer_delete() for our cp->control,
> i.e. to use loop instead of recursion. I.e. ip_vs_conn_del_put()
> can be converted to function that returns bool instead of
> calling ip_vs_conn_expire(), so that we can know if to loop.
>
>         If ip_vs_conn_flush() demands faster expiring, a
> loop will work faster. What do you think?
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
>

Hello Julian,

Thanks for reviewing this and for suggesting the FTP helper change.

I agree that a loop is preferable, especially if ip_vs_conn_flush() needs t=
o
expire the controller chain promptly. The follow-up is split into two
separate patches.

The first patch changes ip_vs_conn_del_put() to report whether it successfu=
lly
deleted the controller's timer. ip_vs_conn_expire() then follows the
controller through a repeat path instead of recursively invoking itself. Th=
is
keeps cleanup synchronous, avoids recursive stack growth, and does not wait
for additional timer ticks.

The second patch is a separate FTP helper fix that prevents the helper from
creating unnecessarily long controller chains. ip_vs_ftp_out() rejects a
zero port and configured control ports in the passive-data path, covering
both PASV and EPSV. ip_vs_ftp_in() also rejects a zero client port in activ=
e
mode.

Best regards,

Zihan Xi
