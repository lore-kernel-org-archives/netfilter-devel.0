Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB3E3BD223
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 22:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773355207; cv=pass; b=X/ll6Qh//7pHCcvsbX73U6dHZPdhyP0Hwq7h+C5WlKWf1YYyC8det9tgOKBUvuoXbh02mGGPODPavCVsyn6JhfgqJqTNITOb9pC7lRbz8WUJe5NzVb5W+96ZHqs6IN0fao5lVQn1MmVshX7xXPnU4b/9aqhXRAsv/Vfrp7LsdPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773355207; c=relaxed/simple;
	bh=vSKF/IWgkiHnk/6pe4mrBwJos6YfET7/eS7bzaqGAkI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QlO/tzLkM0zYeSQrSAkqP2XEyJPXtBTVHBCHzXnR67FykAw57rcyY78ePlS5oqGREg+9Nn50sDlikTiYJC6cUWabx/9E7OtFv4NTxg2pYcrZ1/IBpYgAmm5aQXF6zmhVJ6IWmK0yYuEih5yZm2aJPkfALprUV5UDWg0jkTUzzZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ez3o2qpq; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ez3o2qpq"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-899a5db525cso19440446d6.3
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 15:40:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773355203; cv=none;
        d=google.com; s=arc-20240605;
        b=kliBcDWzw7NZcW3lrpEfMBltCbvI8yp1quuTl4rbINuNIsprLPqAPCEAcSLB7AM+6x
         GOd2/l3mHfeg6lJAO8EpqzIM7gEmLUWjvYhOLtnSeXMBtpP6ZaqxoEPYKHtsxX8i4Cyv
         BalNscEVY+NzVW3OxwlNEI/gqiLr64uzp+Af99LZlp5udLws3e1V+wMNczNx5Mis3MeP
         64v4likbTXhRq17q1oNciEpQh3bBZrsTR/Vmk2Ors0jsWSrT0Q7nkMGIb8tqGu3uQ0+h
         Co6a1pdb8eYRfsmtkLsTMSYwcN/dcLmqgwDJAU2rA4l+VnHqATN6o98PMMy3J19jATo3
         pCGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ttTay48bxAfNWoQs/U3yPOmW4SKFj29jAOlQXsWNg1Q=;
        fh=w1qGaD9oJ4I1jb65gNtOK9FmtObBBo6QsCj6W/+eqeE=;
        b=Jlh5QG0S/3UHvAEd7yWP7O+QVSnL6R9lHrEzKo/LZlv3o2n+PTWOUVATnVLarca6gK
         g1ssWndOggHqqF8etudKuoNrHe9RU5kokX2NRVwh6VMylPvf9qVlbBcL+uH4IbrG/g1I
         gCBO9SlR9jy5QNEpEF5MuawEusvjtbCSGwIcJ1xCS4VNHrQ2t9Cr24zAgbvKJk5tg0c/
         E4XrwuKZjO3gG11EoRqyshTdkln2fvPnegzFIGY6F/02p4wAZPlHnewBq0JajKKvf0it
         x4Gv5BlS0/HJIrkCPRHw4ScOvS3mp4pM+LNNzNoc12N+H1Ezsxh8dys3MIGRXRcvjWuC
         FdvQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773355203; x=1773960003; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ttTay48bxAfNWoQs/U3yPOmW4SKFj29jAOlQXsWNg1Q=;
        b=ez3o2qpqaTyls3UekYljtl1WmcPFfbhqPQk7VK621dutlecL9EAeBp0w7gAu3B2ziz
         ef1bD5GihqeU/rJz35cSd5KN9YUifVeaJBxThDoANc6kPjSn5NTbdEz97h/lX52jWjsZ
         ifFhKq7wv6PQk7ixhICCsejedvyoyZcAqlkcTC58pVYAqfuaXbzMqJz/Nw4GquTKzydw
         bbxRXpb1oWGLj0WlZSOgCzblTWPP/l5dFfYIE09+v/mPbr9iLjlaju/8Aw3cqibcLNWL
         7AVbTpxSoJ4IjmjMiNU1AzjFhs+P1o5aLhhcgYO1CNJzp/ov41MjYnD4n6CDNSeOxvQi
         CepQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773355203; x=1773960003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ttTay48bxAfNWoQs/U3yPOmW4SKFj29jAOlQXsWNg1Q=;
        b=JRR/mzm0wUOLOR8ErU9BzlEuSfxISsRiuBMG6vn6SCqR02ees4xjgOpFM+Mbdu601+
         YjuXne4cg3H2iaYha2k7qOnYUKxga8ZzolVeR2Er25I1+Ddy+MAXUesKF1M0ub/6cbSA
         O42x024dR6xdvbLWoUHoSTnbSrhfadnP9b3hzRdGDtNV6jrFuj1OhSrQDLGNZBk83emT
         O0Gp9x9OjDZyNPOVAQNsNMS0o9cNsTVhoTJDvK21uLVwFsNwcytyBWXBgX12nytJti8u
         qaNxwZMm/Z121Bm3ZxHQpt7uL/ZGjNAPGGg2x/v9Veat1LmB9gB0GDbY0sz6uDPnKfQu
         WJ5w==
X-Forwarded-Encrypted: i=1; AJvYcCVBTGe0ANcIXqgvAfgIIFQb72xj0lcztuB+gVfcGiNkz4YtZzouatMMHUQiFFsYflux6WkPXIl1DJeoFwmiwnw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywcgu64ApQNkfPD1y0ZkQ59ECpyVAjWBWQBUVG6Nbcaku+VgDlm
	OsKgmlNBZlSJv08jhnC67cpRfGCn9SI2uDwrYa8hkZGzqFI6cnViulfrLI8Y/mMqswnonIzpZSE
	tgISZexciAL67CPaFnN5uWWfFe1oE53SqNmI5tXA=
X-Gm-Gg: ATEYQzxPhhquHbIsnWP8Xl5ClfzHchKz1a39qAFDl3p6qYEFb5ltyM+FOtiaauYRPbX
	ZPapAO0QEShyMJ5VRqk6cSKftcdaXQ+mGtMdY+AGAvKQ4ARa4t1nIFiHyFvgLNGWHKBeHJ0f8h5
	GAMotEk6SVfVNKNurQYuoEh996D46Ubzoal3fJUTkXRrhx7jzzWEHIFlWqSjhh8A6VnA2IrYKDI
	qxfopOzfpKvw2FgW86eh1rrin/DxzJkWvV9nrfs+zW07QLMpw9sLR91DwTRTEOW7wINxQrIKY37
	xU6m8Io=
X-Received: by 2002:ad4:5d43:0:b0:89a:a0a:c0ff with SMTP id
 6a1803df08f44-89a81f51cf6mr22162056d6.52.1773355202866; Thu, 12 Mar 2026
 15:40:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312145506.2192682-1-qguanni@gmail.com> <abLdnHeh8lEKqqB-@strlen.de>
In-Reply-To: <abLdnHeh8lEKqqB-@strlen.de>
From: Guanni Qu <qguanni@gmail.com>
Date: Thu, 12 Mar 2026 15:39:51 -0700
X-Gm-Features: AaiRm52l4ct2mcrmqbFxO6Mz6jS-Tn1bk-IrbfvSrIDA6BVJmYwfFtFjeYijqlQ
Message-ID: <CAFzOa17VwKpnyLjejeBbAJ9XnbuykDVzb0-5HLsPDSdW9aG_JQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix OOB read in SIP URI port parsing
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, kadlec@netfilter.org, netfilter-devel@vger.kernel.org, 
	klaudia@vidocsecurity.com, dawid@vidocsecurity.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Florian,

You're right, the minimal bounds check isn't enough. The simple_strtoul()
call assumes a NUL-terminated string, and the SIP packet data in the skb
is not guaranteed to be NUL-terminated. The current code relies on
incidental zero bytes in skb_shinfo.

I like your sip_parse_port() approach. I'll take it, wire it into
both call sites, and send a v2. While I'm in there I'll audit the
rest of nf_conntrack_sip for similar limit violations and send
anything I find as part of the same series.

Jenny

On Thu, Mar 12, 2026 at 8:37=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Jenny Guanni Qu <qguanni@gmail.com> wrote:
> > In epaddr_len() and ct_sip_parse_header_uri(), after sip_parse_addr()
> > parses an IP address, the pointer (dptr or c) may point at or past
> > limit. The subsequent check for a ':' port separator dereferences the
> > pointer without a bounds check, causing a 1-byte out-of-bounds read.
> >
> > Add bounds checks before the dereference in both locations.
>
> I'm not sure.
>
> This bug is real, but I suspect there are many many more bugs in this
> code.
>
> > Fixes: 05e3ced297fe ("[NETFILTER]: nf_conntrack_sip: introduce SIP-URI =
parsing helper")
> > Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
> > Reported-by: Dawid Moczad=C5=82o <dawid@vidocsecurity.com>
> > Tested-by: Jenny Guanni Qu <qguanni@gmail.com>
> > Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
> > ---
> >  net/netfilter/nf_conntrack_sip.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntr=
ack_sip.c
> > index d0eac27f6ba0..a232054d7919 100644
> > --- a/net/netfilter/nf_conntrack_sip.c
> > +++ b/net/netfilter/nf_conntrack_sip.c
> > @@ -194,7 +194,7 @@ static int epaddr_len(const struct nf_conn *ct, con=
st char *dptr,
> >       }
> >
> >       /* Port number */
> > -     if (*dptr =3D=3D ':') {
> > +     if (dptr < limit && *dptr =3D=3D ':') {
> >               dptr++;
> >               dptr +=3D digits_len(ct, dptr, limit, shift);
> >       }
> > @@ -520,7 +520,7 @@ int ct_sip_parse_header_uri(const struct nf_conn *c=
t, const char *dptr,
> >
> >       if (!sip_parse_addr(ct, dptr + *matchoff, &c, addr, limit, true))
> >               return -1;
> > -     if (*c =3D=3D ':') {
> > +     if (c < limit && *c =3D=3D ':') {
> >               c++;
> >               p =3D simple_strtoul(c, (char **)&c, 10);
>
> I'm not sure this check is enough.  simple_strtoul() assumes
> a c-string.  Are we dealing with a c-string here?
>
> I suspect the anser is: 'no' and that we depend on 0 bytes appearing in
> skb_shinfo at end of network buffer for this to 'work'.
>
> I would prefer to add much stricter constraints everywhere.
>
> Untested example:
> static bool sip_parse_port(const char *dptr, const char **endp, const cha=
r *limit)
> {
>         static const unsigned int max =3D strlen("65535");
>         int len =3D 0;
>
>         /* port is optional, but dptr >=3D limit indicates malformed
>          * sip message.
>          */
>         if (dptr >=3D limit)
>                 return false;
>
>         if (*dptr !=3D ':') /* this is fine, no port provided. */
>                 return true;
>
>         while (dptr < limit && isdigit(*dptr)) {
>                 dptr++;
>                 len++;
>
>                 if (len > max)
>                         return false;
>         }
>
>         /* reached limit while parsing port */
>         if (dptr >=3D limit)
>                 return false;
>
>         if (endp)
>                 *endp =3D dptr;
>
>         return true;
> }
>
> @@ -193,11 +225,9 @@ static int epaddr_len(const struct nf_conn *ct, cons=
t char *dptr,
>                 return 0;
>         }
>
> -       /* Port number */
> -       if (*dptr =3D=3D ':') {
> -               dptr++;
> -               dptr +=3D digits_len(ct, dptr, limit, shift);
> -       }
> +       if (!sip_parse_port(dptr, &dptr, limit))
> +               return 0;
> +
>         return dptr - aux;
>  }
>
> Whats your take?
