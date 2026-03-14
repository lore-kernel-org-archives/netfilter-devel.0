Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F4811713
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Mar 2026 22:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773526610; cv=pass; b=DaEiEDOZ1hsWaZGGWEfQIJfdVouuykeGLi+RFXTt/M21YgL7OrhFt5r8SzIfXTfPgVh5Bd+PF8LMINVI5P/a5puQVAVqqRPIuN5vdy4k7M48FpTZycv2EULFjBV2qc8QURI/9JWALzQbi6rW7bqDUn/kCThq2gUTWq7WCFSc7lo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773526610; c=relaxed/simple;
	bh=AUAU206tazAsbgCoI/voDWbB3uRpWuYbp4omMWTwwLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cBNaGMo88ZEX4LV4LtfmtfT3AplEi32w1+uO9Cc1vwCVaKf8BPvbhEzmRKbLfhgsumcGPSarNCOkH8s36W62CAGSGkJSt8PgFiKSCOJPHVlG1LTURav3igfIXm98skxCrhZe350T/a3BZ+ba3Sh4vfKd1Dpu1s/NoNDPd57I0hs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z4gJbQfg; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z4gJbQfg"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-899fc9853b7so44144216d6.2
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Mar 2026 15:16:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773526608; cv=none;
        d=google.com; s=arc-20240605;
        b=FnKU8pXyMLoOPUC9gNe/ZlMBhHcUo8xpZ6sdsCliMJjrTV5JYqEizUAiWOzXw2iOcf
         poIWv+NH5ry3pOXgcohqdBKe9ONy2JlvGecKu30Osyc+UUH97WY7CLN+0yl8P1gdqKXp
         CWRE29ct5oIqyYyc6kX/8Ecl4hPXAp4/q5zwsHYzFTEQjiplTe08C4pamMyQW1G8aSbv
         daLLzcWlrtJfXZSpX0smYd1t621Sab/7vZbXnzhogp/QkczK5QzZ77eaL7ggwoHq/7ph
         z8Iz3+TqCnGXyktXVpALnEGpIlG9CCaSkl8Nl9EYFIfGZhh9s5FFntBKH3vtj0XMrlKc
         zRSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G0tXSjBlrHGT9o29rlF0f6tEkAF11nriwN3UoDjVXjE=;
        fh=JvUUlhWB0WpvfUZPK0IqvBJwbVmOKP8PLepHFMblP1c=;
        b=hkMhFfLscYM7/UGDb3OHgmtagKOLBAs7e84j5OOqR9beh1UXyokjY+sdts7vZ6gPB/
         EvSVFQ+peWHtH/Y4f4zEmlw6SAKhUk6N0Pud6SqweTECOnWWmvPG5kPgMs3dG0dq7SS4
         Om6OUQWtBd4WiYfnCSsZjd/LsmqhgUuSYwphz5324kPuIY+TngH265NiHqZRS9IHZ0gu
         E4hmnGq82J2s7AbaYvAhlC8Jitt/JoKgSNXjtpFInAmJA7WwXy35qTt2PPbBnFv1qKc3
         h49JFbd2R4khFGMILNOxn0l07ErfEHZWHxjzJ/+YUkkyuiDHmhd0jGGd4iOAyuN+M83B
         rAHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773526608; x=1774131408; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G0tXSjBlrHGT9o29rlF0f6tEkAF11nriwN3UoDjVXjE=;
        b=Z4gJbQfgILOU6MWtvbUdQ4kF2mRIFtGNTFipeQ2UHAlCyAz2PpljTOh86foefByst6
         f03+C9UiUBVkdH2MP1klRA6jCPWzet8zu5XmkgMP8AoLmAyE99MQgbJdXNc3coV+NG6m
         1OeQk9nJClMh6mI3Ek7QZZfm7c5p2TED30ACuo24ngvMRTt8t98QlJDuj+PbZQALVcOj
         SC5D39bZtiJadDm9HovLFsyoxzdNbj0f0omGgzdrsP5Pu5VlgjDtnYKMl/t9dTkZOGhc
         T5wElgmiOmlVq+KETUydGnOTx8LSbxfO+S8nz3elUY1pLldsRIpCLagGVA1Yyn+Ov8Zv
         l9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773526608; x=1774131408;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G0tXSjBlrHGT9o29rlF0f6tEkAF11nriwN3UoDjVXjE=;
        b=nJ+qCWBO27SNBJzMphmDTCSfng7N2D/A6yZzIU9b3QRCnbmlxNB5uMeYzbKeHa82qC
         sVP/5FJR3wKujU7SPGksrzuo/EZkjEjPK8UPqCayKMfnBF/Qq0fzTMbZixb10BeviMwG
         +9HcyMkwnx4JIZ7hAgiMVMjxuFBNFmSkai43TDi1IDsfWBLlIYCw94xLrpXPCfA6/cXr
         JlmB8MW05ZitFVZ6Ft3ZuYMtbuzMJhF0ZuT8H1Wdd7zNsHHlmy7RYW7ibBCrx70uExuD
         bRjb5T9HC3vV3V5crgGzegqyW3Fiywiql3+NLNuWd6nO4HDewPeh/m9qyggnAUHCf/Zp
         gGHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlwMs4VN0gVXDJpIJ249tCxsPoMOJuVlh42bSTl/1HHJT3r0L47I7MxOcsiT1QLsYStlc83HpAR12zYojiqYs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwinQMRix+9Dso5MoO2CLPl7gi/J8iAkkO83Lu+uVTvmbIjmxWJ
	Pb21SXtIGESIs2nDpRolnpMHuYwRw6birfOt0gAfqsUUKk5OBBVhlx8YUTN5fyHhjUOY1YtIVMw
	Hp7VzGZWx+0i27NXU+ghhoYBLN7JWplM15KrVX5s=
X-Gm-Gg: ATEYQzz3Ihmh9nZN7LaVT85ufTB4oyIvRLNGQI/6Gns0a2ljX6uZNs59NyJSVkGxkKr
	zoyP4QF58w0Lcq3ZkhmVBu7BlcnESaGGPpzm01EtGsnkJkYii/yHZ+xwY08d9NBMaubsa9/TVKI
	FIbkMAjPtIi5W72FcN7uUPgma4EiVvV2C6O8Sy+bap1vEK829iZIq6jYR4rshKhpm/XPheaIbUT
	a4ctIgaBXzpZ2A+ORxsCqu6cjagGks1rJoK8QxCS2Hk7WxbJDXA+hzBpiiuyUhyplFzbzyMOUBW
	1eNlWxk=
X-Received: by 2002:a0c:f20a:0:b0:89c:3f22:c89e with SMTP id
 6a1803df08f44-89c3f22cd88mr38210226d6.24.1773526607950; Sat, 14 Mar 2026
 15:16:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260313150614.21177-7-fw@strlen.de> <20260314161236.2454291-1-kuba@kernel.org>
 <abWph_Nu9TBQ4r6I@strlen.de>
In-Reply-To: <abWph_Nu9TBQ4r6I@strlen.de>
From: Guanni Qu <qguanni@gmail.com>
Date: Sat, 14 Mar 2026 15:16:37 -0700
X-Gm-Features: AaiRm53U-YxvRHMnI-41Cs6pO5s3TBMB9CUSqSi58p3r8jc9CU69w0krWDJLG2Q
Message-ID: <CAFzOa16enGosPApaXYmypkUb8JK=SMsvi2XMSrDP+DShm=GMLQ@mail.gmail.com>
Subject: Re: [net,06/11] netfilter: nf_conntrack_h323: fix OOB read in
 decode_int() CONS case
To: Florian Westphal <fw@strlen.de>
Cc: edumazet@google.com, pablo@netfilter.org, netdev@vger.kernel.org, 
	davem@davemloft.net, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Florian,

Confirmed, the AI review is incorrect on all points.

The UNCO, SEMI, BYTE, and default cases all advance bs->cur without
a pre-read check, but each has nf_h323_error_boundary(bs, 0, 0)
immediately after (lines 358, 410, 483, 512). The pointer can
temporarily overshoot bs->end, but the check catches it before any
subsequent dereference.

The CONS case my patch fixes is different: get_uint(bs, len)
dereferences *bs->cur++ inline (lines 258, 262, 266), it reads
1-4 bytes from memory before any post-advance boundary check can
fire. That's the gap the patch closes.

Jenny

On Sat, Mar 14, 2026 at 11:31=E2=80=AFAM Florian Westphal <fw@strlen.de> wr=
ote:
>
> Jakub Kicinski <kuba@kernel.org> wrote:
> > This is an AI-generated review of your patch. The human sending this
> > email has considered the AI review valid, or at least plausible.
>
> Jenny, could you please double-check?
> I don't think this report is right.
>
> > netfilter: nf_conntrack_h323: fix OOB read in decode_int() CONS case
> >
> > This patch adds a boundary check in the CONS case of decode_int() to
> > prevent reading beyond the buffer after get_bits() returns a length
> > value. The fix validates that len bytes remain before calling
> > get_uint().
>
> SO far I can follow LLM response.
>
> > > diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/n=
f_conntrack_h323_asn1.c
> > > index 62aa22a07876..c972e9488e16 100644
> > > --- a/net/netfilter/nf_conntrack_h323_asn1.c
> > > +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> > > @@ -331,6 +331,8 @@ static int decode_int(struct bitstr *bs, const st=
ruct field_t *f,
> > >             if (nf_h323_error_boundary(bs, 0, 2))
> > >                     return H323_ERROR_BOUND;
> > >             len =3D get_bits(bs, 2) + 1;
> > > +           if (nf_h323_error_boundary(bs, len, 0))
> > > +                   return H323_ERROR_BOUND;
> > >             BYTE_ALIGN(bs);
> > >             if (base && (f->attr & DECODE)) {       /* timeToLive */
> > >                     unsigned int v =3D get_uint(bs, len) + f->lb;
> >
> > This patch fixes the CONS case, but the UNCO case in the same function
> > has the same vulnerability. In the UNCO case, get_len(bs) can return up
> > to 0x3FFF (16383 bytes), and the code advances bs->cur by that amount
> > without checking that len bytes remain:
> >
> >       case UNCO:
> >               BYTE_ALIGN(bs);
> >               if (nf_h323_error_boundary(bs, 2, 0))
> >                       return H323_ERROR_BOUND;
> >               len =3D get_len(bs);
> >               bs->cur +=3D len;
> >               break;
> >
> > The check only validates 2 bytes for get_len() itself, not the
> > subsequent len bytes that will be skipped. Does this need the same fix
> > pattern?
>
> I don't think so.  Pointer can advance, but right after the swtich/case
> there is:
>
> 358         if (nf_h323_error_boundary(bs, 0, 0))
> 359                 return H323_ERROR_BOUND;
> 360         return H323_ERROR_NONE;
>
> So bs->cur can advance past cur->end, but then the function
> returns ERROR_BOUND.
>
> > The decode_bitstr() function has a similar issue. In the SEMI case, it
> > calls get_len(bs) which can return up to 0x3FFF bits, then advances the
> > buffer by len >> 3 bytes plus partial bits without checking that
> > sufficient buffer space exists:
> >
> >       case SEMI:
> >               if (nf_h323_error_boundary(bs, 2, 0))
> >                       return H323_ERROR_BOUND;
> >               len =3D get_len(bs);
>
> AFAICS we've checked get_len() doesn't cause oob access.
>
> >               break;
> >       }
> >
> >       bs->cur +=3D len >> 3;
> >       bs->bit =3D len & 7;
> >
> > The check at the top only validates 2 bytes for the get_len() call. The
> > actual advance at the bottom can be up to 2047 bytes. Should this be
> > checked as well?
>
> AFAICS it is, right after there is:
> 410         if (nf_h323_error_boundary(bs, 0, 0))
> 411                 return H323_ERROR_BOUND;
>
> > The decode_octstr() function has the same pattern in both the SEMI case
> > and the default case:
> >
> >       case SEMI:
> >               BYTE_ALIGN(bs);
> >               if (nf_h323_error_boundary(bs, 2, 0))
> >                       return H323_ERROR_BOUND;
> >               len =3D get_len(bs) + f->lb;
> >               break;
> >       default:                /* 2 <=3D Range <=3D 255 */
> >               if (nf_h323_error_boundary(bs, 0, f->sz))
> >                       return H323_ERROR_BOUND;
> >               len =3D get_bits(bs, f->sz) + f->lb;
> >               BYTE_ALIGN(bs);
> >               break;
> >       }
> >
> >       bs->cur +=3D len;
>
> Pointer increment, right after there is:
>
> 483         if (nf_h323_error_boundary(bs, 0, 0))
> 484                 return H323_ERROR_BOUND;
>
> > len bytes without checking. The existing checks only validate the bytes
> > needed to READ the length value, not the len bytes that will be
> > consumed. Should boundary checks be added after both break statements?
>
> AFAICS there are such checks... :-/
>
> > Similarly, decode_bmpstr() (which handles 2-byte character strings) has
> > the same issue in both the BYTE case and default case:
> >
> >       case BYTE:              /* Range =3D=3D 256 */
> >               BYTE_ALIGN(bs);
> >               if (nf_h323_error_boundary(bs, 1, 0))
> >                       return H323_ERROR_BOUND;
> >               len =3D (*bs->cur++) + f->lb;
> >               break;
>
> We write to bs->cur, but AFAICS the write has been vetted for.
>
> >       default:                /* 2 <=3D Range <=3D 255 */
> >               if (nf_h323_error_boundary(bs, 0, f->sz))
> >                       return H323_ERROR_BOUND;
> >               len =3D get_bits(bs, f->sz) + f->lb;
> >               BYTE_ALIGN(bs);
> >               break;
> >       }
> >
> >       bs->cur +=3D len << 1;
> >
> > After computing len from packet data plus f->lb, the function advances
> > by len << 1 bytes (doubling for 2-byte characters) without verifying
> > that len << 1 bytes are available. Should this also be checked?
>
> AFAICS it is...
>
> 510         bs->cur +=3D len << 1;
> 511
> 512         if (nf_h323_error_boundary(bs, 0, 0))
> 513                 return H323_ERROR_BOUND;
>
> So AFAICS this LLM response is bunk.
