Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B735D330647;
	Sat, 14 Mar 2026 18:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773513100; cv=none; b=U7OTe6E/mmibeNMLvs8f5PghgJcGdt5qrHFkwPmiqvraWsgFZipuK4xcbxUM2CSh75Kab9bvNlcZnCED2jCmFSiCAaeFg4XdxQqy3jezLPLv4sPMH30hqu7aSjAyt+3GldXEEsQ13RnLykeBgeScX7Hjw/op+MM8ADXSFH8Pgy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773513100; c=relaxed/simple;
	bh=fPUnpvH+13rR0HzFllKlUpx+HcMjkbPPOaiuktJnc8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzL2mGp08v5rJckh9MITLdTRUyp8Q9nXKRRsX9eCM5juvMot7jBhFs9fjVCZ6NgIOXjBEyJ8/JOjKR9xILyDstQv5hlBbjiQp0j/4KG01dVRyf9OKDMV8v0sL2Eb6LY1V+X9lFS7vaMsXRUQa3yrLLDCs2zJrblYsnK7Fa6RVFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 54041606E1; Sat, 14 Mar 2026 19:31:36 +0100 (CET)
Date: Sat, 14 Mar 2026 19:31:35 +0100
From: Florian Westphal <fw@strlen.de>
To: Jenny Guanni Qu <qguanni@gmail.com>
Cc: edumazet@google.com, pablo@netfilter.org, netdev@vger.kernel.org,
	davem@davemloft.net, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net,06/11] netfilter: nf_conntrack_h323: fix OOB read in
 decode_int() CONS case
Message-ID: <abWph_Nu9TBQ4r6I@strlen.de>
References: <20260313150614.21177-7-fw@strlen.de>
 <20260314161236.2454291-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260314161236.2454291-1-kuba@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.

Jenny, could you please double-check?
I don't think this report is right.

> netfilter: nf_conntrack_h323: fix OOB read in decode_int() CONS case
>=20
> This patch adds a boundary check in the CONS case of decode_int() to
> prevent reading beyond the buffer after get_bits() returns a length
> value. The fix validates that len bytes remain before calling
> get_uint().

SO far I can follow LLM response.

> > diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_=
conntrack_h323_asn1.c
> > index 62aa22a07876..c972e9488e16 100644
> > --- a/net/netfilter/nf_conntrack_h323_asn1.c
> > +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> > @@ -331,6 +331,8 @@ static int decode_int(struct bitstr *bs, const stru=
ct field_t *f,
> >  		if (nf_h323_error_boundary(bs, 0, 2))
> >  			return H323_ERROR_BOUND;
> >  		len =3D get_bits(bs, 2) + 1;
> > +		if (nf_h323_error_boundary(bs, len, 0))
> > +			return H323_ERROR_BOUND;
> >  		BYTE_ALIGN(bs);
> >  		if (base && (f->attr & DECODE)) {	/* timeToLive */
> >  			unsigned int v =3D get_uint(bs, len) + f->lb;
>=20
> This patch fixes the CONS case, but the UNCO case in the same function
> has the same vulnerability. In the UNCO case, get_len(bs) can return up
> to 0x3FFF (16383 bytes), and the code advances bs->cur by that amount
> without checking that len bytes remain:
>=20
> 	case UNCO:
> 		BYTE_ALIGN(bs);
> 		if (nf_h323_error_boundary(bs, 2, 0))
> 			return H323_ERROR_BOUND;
> 		len =3D get_len(bs);
> 		bs->cur +=3D len;
> 		break;
>=20
> The check only validates 2 bytes for get_len() itself, not the
> subsequent len bytes that will be skipped. Does this need the same fix
> pattern?

I don't think so.  Pointer can advance, but right after the swtich/case
there is:

358         if (nf_h323_error_boundary(bs, 0, 0))
359                 return H323_ERROR_BOUND;
360         return H323_ERROR_NONE;

So bs->cur can advance past cur->end, but then the function
returns ERROR_BOUND.

> The decode_bitstr() function has a similar issue. In the SEMI case, it
> calls get_len(bs) which can return up to 0x3FFF bits, then advances the
> buffer by len >> 3 bytes plus partial bits without checking that
> sufficient buffer space exists:
>=20
> 	case SEMI:
> 		if (nf_h323_error_boundary(bs, 2, 0))
> 			return H323_ERROR_BOUND;
> 		len =3D get_len(bs);

AFAICS we've checked get_len() doesn't cause oob access.

> 		break;
> 	}
>=20
> 	bs->cur +=3D len >> 3;
> 	bs->bit =3D len & 7;
>=20
> The check at the top only validates 2 bytes for the get_len() call. The
> actual advance at the bottom can be up to 2047 bytes. Should this be
> checked as well?

AFAICS it is, right after there is:
410         if (nf_h323_error_boundary(bs, 0, 0))
411                 return H323_ERROR_BOUND;

> The decode_octstr() function has the same pattern in both the SEMI case
> and the default case:
>=20
> 	case SEMI:
> 		BYTE_ALIGN(bs);
> 		if (nf_h323_error_boundary(bs, 2, 0))
> 			return H323_ERROR_BOUND;
> 		len =3D get_len(bs) + f->lb;
> 		break;
> 	default:		/* 2 <=3D Range <=3D 255 */
> 		if (nf_h323_error_boundary(bs, 0, f->sz))
> 			return H323_ERROR_BOUND;
> 		len =3D get_bits(bs, f->sz) + f->lb;
> 		BYTE_ALIGN(bs);
> 		break;
> 	}
>=20
> 	bs->cur +=3D len;

Pointer increment, right after there is:

483         if (nf_h323_error_boundary(bs, 0, 0))
484                 return H323_ERROR_BOUND;

> len bytes without checking. The existing checks only validate the bytes
> needed to READ the length value, not the len bytes that will be
> consumed. Should boundary checks be added after both break statements?

AFAICS there are such checks... :-/

> Similarly, decode_bmpstr() (which handles 2-byte character strings) has
> the same issue in both the BYTE case and default case:
>=20
> 	case BYTE:		/* Range =3D=3D 256 */
> 		BYTE_ALIGN(bs);
> 		if (nf_h323_error_boundary(bs, 1, 0))
> 			return H323_ERROR_BOUND;
> 		len =3D (*bs->cur++) + f->lb;
> 		break;

We write to bs->cur, but AFAICS the write has been vetted for.

> 	default:		/* 2 <=3D Range <=3D 255 */
> 		if (nf_h323_error_boundary(bs, 0, f->sz))
> 			return H323_ERROR_BOUND;
> 		len =3D get_bits(bs, f->sz) + f->lb;
> 		BYTE_ALIGN(bs);
> 		break;
> 	}
>=20
> 	bs->cur +=3D len << 1;
>=20
> After computing len from packet data plus f->lb, the function advances
> by len << 1 bytes (doubling for 2-byte characters) without verifying
> that len << 1 bytes are available. Should this also be checked?

AFAICS it is...

510         bs->cur +=3D len << 1;
511
512         if (nf_h323_error_boundary(bs, 0, 0))
513                 return H323_ERROR_BOUND;

So AFAICS this LLM response is bunk.
