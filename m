Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B822C15AB
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 12:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751631101; cv=none; b=nHA86wP4C1kjzfs0w10FDcjCQvG+T6IA+tAFq1CmWUDaXIi47CJPUQRhvJCVSQstpqWrKrmaC2Unn0KpDHFh9ImTnUQsuhItUQv3b2wkL2lJgX/bkVUBB7OF/Ec1Vw1cZrnhkH3VEBhLlVHwPQWuRUy5XxP8ItQgoMbqC3uB64M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751631101; c=relaxed/simple;
	bh=jjguSV9NRNPlM/Gr1Y4oA/s47zrJaXmgU+R0AqrcpPc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TRQWaXNetJjj7neZ3Uyw4NNVnJakfDi4ZUCw2RYIGLA75qww9bvNZPOELCbXHUzxjCc5NLQh6nO8wr/Gz7UyqemQkmE26EOv97cQTu/Gy27uu9lWJviaCKqOpRXAakueBKcu/m9tUjBDlafGj3CWHZRwyMZyLVPbwf/BqyX9siA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mLcZLCM9; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mLcZLCM9"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6fadd3ad18eso9701086d6.2
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jul 2025 05:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751631099; x=1752235899; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ElGYM1PIy0mISA67HoVQd0b8zzOMKwz0pZg71x6UZZU=;
        b=mLcZLCM9+9SGFSoA+BZV6VwXsbRB8UkPyC97vcq9JyvAWOpEhy85fXNR5hb89IBJ4q
         rWcxLjLiPoe8OcHcqIzKMcx6wHlXZToReenT6KCBEF0h/ri8ycn5A3S1zxeAbVGhGPpG
         uTNWauv2djZCkqKCHYXS/4dcrBOdfa87gwg1b5eVvBo7inw1fvB8iGluYaecL58TVHHT
         feniEZTM1BgvQa+DrMYrmLel1WlYLRGBtYL5aQBOFncaYco41qN09nKA07MU35T013xC
         K63+B0jSQ95wUegQLayFkrH5u1zNmzIhbgqj+T3x9yLmJWtKeV8RnzXlRh4s4/lYANID
         meOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751631099; x=1752235899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ElGYM1PIy0mISA67HoVQd0b8zzOMKwz0pZg71x6UZZU=;
        b=gw7KWbRLAFc6lQs92L8WbSCwaS9AFF+AzSn0mgt+1Viy8P10fmL/nf4mqpwc2u8L2U
         nYrJaDUQ8q/OjqTSCHX+jONpI98LN56DLxsBocUHD/t7BVXZjgZeJvqrISk1QUDUtDKT
         uWx+v0dsLKq/sjkVlocC45JERSEB+f9/KRiieNIMVbXIlEeSVkIV3tvnlNMBvGCtl99g
         SfeyGJ08IFRIH3j96sBv9WmipkLNeLqnCk/z2+nXJ7NYSBcwbDcCzbfdOs2TJdJmRZb5
         PzoaXh8Ko0Opc7HuM7T/dVxAnhaE0+p1ksvf4tD2L5mc9Ccsko7pu1ahXnnr3VdZ/51w
         TqLA==
X-Forwarded-Encrypted: i=1; AJvYcCUOnD10FHUvwmDa5Drn0o02/N2SrDoALQ+jH2+em/j143Mxi/HBvIHMtCmxZX/IjML+aoakAbMwN2El/xwhF8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr+Y+yVya2R1AmcJucufvEjbBBqYFmvKn0SWd2bSfZS0AJEZ3b
	+6cLiBGx97uoAxILBI8XjXrDr0Q8umB37luq8OXCycolN3l6p9JlsfMOqAOaSsENeNiRZ4Z66VY
	2Nr4t+ZspYYf6FMUViDuKSyIrDKm5Tss=
X-Gm-Gg: ASbGncsorwfLzdpiwDzTFV/wK7DraI93VZ/JW76CIIOCaatk6tqeUOqE0/eiRB0K/gs
	eq5u2c2BPN5qoDm5k/+ajDZFy9C1+aM32K/u9feIitDQV6E6g4eGf47w/ou49sUNKqIXkT6MbnN
	iozE1jiKUPcoouaa1A7mI+I6vT9i/B+Q/zPzyNp6pr9c8=
X-Google-Smtp-Source: AGHT+IFWwkMDpHZ2LESVAQ4YWRDCwf3z7jj0p32/nX7suk0MwfvaQlkbNu4cyPTP0UJnaiKXKMzujC6nrbhFuhBkATQ=
X-Received: by 2002:ad4:5f49:0:b0:6fa:c6ed:dc84 with SMTP id
 6a1803df08f44-702c6d849eamr32841126d6.23.1751631098712; Fri, 04 Jul 2025
 05:11:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250704113947.676-1-dzq.aishenghu0@gmail.com>
 <20250704113947.676-4-dzq.aishenghu0@gmail.com> <aGfA5_aH6QT5z_rf@strlen.de>
In-Reply-To: <aGfA5_aH6QT5z_rf@strlen.de>
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Date: Fri, 4 Jul 2025 20:11:27 +0800
X-Gm-Features: Ac12FXxsNe_6axQqiw0ZPIOpoed8rUd4iTxOQg3xwghzPQUr_YozfxPXtf2_s1c
Message-ID: <CAFmV8NfTqTQcfqrvxpZf2nv=mSf=CpDVCbWv=E+La1oii1jzJA@mail.gmail.com>
Subject: Re: [PATCH nft 3/3] src: only print the mss and wscale of synproxy if
 they are present
To: Florian Westphal <fw@strlen.de>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Simon Horman <horms@kernel.org>, Fernando Fernandez Mancera <ffmancera@riseup.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 4, 2025 at 7:54=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Zhongqiu Duan <dzq.aishenghu0@gmail.com> wrote:
> > The listing of the synproxy statement will print a zero value
> > for unpresented fields.
> >
> > e.g., the rule add by `nft add rule inet t c synproxy wscale 8 sack-per=
m`
> > will print as 'synproxy mss 0 wscale 8 sack-perm'.
> >
> > Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
> > ---
> >  src/statement.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/src/statement.c b/src/statement.c
> > index 695b57a6cc65..ced002f63115 100644
> > --- a/src/statement.c
> > +++ b/src/statement.c
> > @@ -1058,7 +1058,7 @@ static void synproxy_stmt_print(const struct stmt=
 *stmt,
> >       const char *ts_str =3D synproxy_timestamp_to_str(flags);
> >       const char *sack_str =3D synproxy_sack_to_str(flags);
> >
> > -     if (flags & (NF_SYNPROXY_OPT_MSS | NF_SYNPROXY_OPT_WSCALE))
> > +     if ((flags & NF_SYNPROXY_OPT_MSS) && (flags & NF_SYNPROXY_OPT_WSC=
ALE))
> >               nft_print(octx, "synproxy mss %u wscale %u%s%s",
> >                         stmt->synproxy.mss, stmt->synproxy.wscale,
> >                         ts_str, sack_str);
>
> This looks wrong, this will now only print it if both are set.

The following else branch will handle the other conditions.

Regards,
Zhongqiu
