Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120BF1FC8;
	Mon, 11 Mar 2024 06:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710139085; cv=none; b=cG4t/LJtuBBc+Jfk4CO3glBKOm+ErWBrGdYjRZ2A+ibBUpWev6f0dc+dq5Cf8WrTKm26Db82hfSdFbc0oT1mkjrx3NLf0+L4GVB3XgVVHWobSt278D5SUOEijl5JEuDyKoBiYHdt8zIMfVj4brZjQtjDtbyZNlYmCMFsZ1hY2rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710139085; c=relaxed/simple;
	bh=Aqb6BBWNll3+hpnsELWQUt4hhGw1V8CSwmlr2TRbU5g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j2JIecxkJHbN3KjZTVbwZq4Njad5IKIIwJ1jtFRpGc0cFwObJXuz+TCZKVA3MdGZmk3IrIUZPGNCaInKjz0aEmQFa7h/gcrQobGWAyZKKR3PGiTUG1TuyiJO4WFm1sP6wwAj5jld/RMnBfL+Rp4ptILiFMTwZQC/tHUM1w0JGc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W0fLzX16; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W0fLzX16"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-56845954fffso1640129a12.3;
        Sun, 10 Mar 2024 23:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710139082; x=1710743882; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cS0QGSvHEdQlDyUDpS8E5pUNEdREVeoje2jYqROdBKc=;
        b=W0fLzX16MXZiLF+tcKgKr7p3ezEmCS9OvAghLMyF8UJGvtm4KqkL0mwBsB0kxvlDYd
         l68dCWhnokQRu1x3kTkcQA6bnHeSXL8a33g21+EqNDy467lC1cEfoTJQwQu8QXAltHiM
         6yti/NHjzRR+xwKpkn0s330WzAvcOqzqjec+RzxdvNyus4uNrXvroMQsS0XI5bxRnT2D
         2YF0XUE+uxB5WN8GzLS+zfzz/ca8qRSGMpXGnMU6kNmMe1gHFq7FckZTBcR4NaVKTejP
         aa6evzbSIxMIqTZ1jM/oQb8WfnjdzWp2cYX+XXojx8y0Vu+ErPYt4y5VUVScf7Ou5PoQ
         YoWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710139082; x=1710743882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cS0QGSvHEdQlDyUDpS8E5pUNEdREVeoje2jYqROdBKc=;
        b=WoK4pxhH/jgXTmbXGanSklYzRI9EcG2Fw7HAF2DeLeB2nKheSA9QpGRDFQ1BtxJTp1
         lXSHQFDX+Kc2QLWnxLChKnDzkUY0i4q1fIXHV5SuCxCwqRnf2hlGmFk/hQz2vjf4ZfaO
         SVIM3xwHeQpazaazKrEOfgisrqNXa4St9oDNqbr2P0v6JBFREV7WiQGYl06w3K7zYPtu
         RIENfDIt9vMG/kptfa0n7cUNJXSMnpQSwBxTDeJjWo8hOBqh6c/GSCBkc9TSJQfVEeEO
         4ejFxN3KFLI3pSAu2+0RAMFRS3TQwkjUXyYjIWIIlPTDCkjd4jlfcv3Hf+krFL5ir91+
         bRew==
X-Forwarded-Encrypted: i=1; AJvYcCUpVutyg5FqRpm2w38+ydbhXODTOk7XyThilNw7JzaOl8im7FUrN1DJ9+19CKZV38ie07vi/VCESGa/Vmhpoodg/NglW+WJ
X-Gm-Message-State: AOJu0YwhKh4Aqyz/ub2OMDei5D7NoORfDcPekULVjljqqPkG9Vkng2de
	DVi3PoqoOoQWf9Ne2IbB/u+pPo0KRd2q6VqwntbYe8OOAiNkdBqmcXPihzcn5ShqQG2JJmCk6XK
	5UJNh5DcZfD9FcV7RizRl/Nae8ikh5AwNrV1n7m9Y
X-Google-Smtp-Source: AGHT+IFzDvfLBfrvJrCt8VPa01iAkXICZuuTCkrwxMbdihcYb9F4MCopUQV6IM91ZVK98mhF0XnLKpeKgiwLGRWwpas=
X-Received: by 2002:a17:906:5917:b0:a44:4c9e:85ef with SMTP id
 h23-20020a170906591700b00a444c9e85efmr2644805ejq.77.1710139082188; Sun, 10
 Mar 2024 23:38:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240308092915.9751-1-kerneljasonxing@gmail.com>
In-Reply-To: <20240308092915.9751-1-kerneljasonxing@gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Mon, 11 Mar 2024 14:37:25 +0800
Message-ID: <CAL+tcoBsTjTRMiFzq_EHyYSBr9rROO-QFY5PZ3Aj-M4YDLpr=g@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: dccp: try not to drop skb
 in conntrack
To: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org, 
	fw@strlen.de, kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 8, 2024 at 5:29=E2=80=AFPM Jason Xing <kerneljasonxing@gmail.co=
m> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> It would be better not to drop skb in conntrack unless we have good
> alternative as Florian said[1]. So we can treat the result of testing
> skb's header pointer as nf_conntrack_tcp_packet() does.
>
> [1]
> Link: https://lore.kernel.org/all/20240307141025.GL4420@breakpoint.cc/
>
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
>  net/netfilter/nf_conntrack_proto_dccp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_c=
onntrack_proto_dccp.c
> index e2db1f4ec2df..ebc4f733bb2e 100644
> --- a/net/netfilter/nf_conntrack_proto_dccp.c
> +++ b/net/netfilter/nf_conntrack_proto_dccp.c
> @@ -525,7 +525,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct, stru=
ct sk_buff *skb,
>
>         dh =3D skb_header_pointer(skb, dataoff, sizeof(*dh), &_dh.dh);
>         if (!dh)
> -               return NF_DROP;
> +               return -NF_ACCEPT;
>
>         if (dccp_error(dh, skb, dataoff, state))
>                 return -NF_ACCEPT;
> @@ -533,7 +533,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct, stru=
ct sk_buff *skb,
>         /* pull again, including possible 48 bit sequences and subtype he=
ader */
>         dh =3D dccp_header_pointer(skb, dataoff, dh, &_dh);
>         if (!dh)
> -               return NF_DROP;
> +               return -NF_ACCEPT;
>
>         type =3D dh->dccph_type;
>         if (!nf_ct_is_confirmed(ct) && !dccp_new(ct, skb, dh, state))
> --
> 2.37.3
>

I saw the status in patchwork was changed, but I've not received the
comments. So I spent some time learning how it works in the netfilter
area.

I just noticed that there are two trees (nf and nf-next), so should I
target nf-next and resend this patch and another one[1]?

[1]: https://lore.kernel.org/netfilter-devel/20240308092915.9751-2-kernelja=
sonxing@gmail.com/T/#m0ced362b380cff7e031d020e906ec2aa00669ce6

Thanks,
Jason
