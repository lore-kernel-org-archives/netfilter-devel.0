Received: from mail-24426.protonmail.ch (mail-24426.protonmail.ch [109.224.244.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37FC42AA3
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2025 21:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760131013; cv=none; b=O3PzZ4+VuEUMYMpc8jAr4PrO1Dsz1cJvaD2MKBbOa+wd15RBPCTXxayN183vsgnJXTb7F/kNJx7AXyNbP4QzSHuZmUGPb4jHGm3ob6y2w/+ZWYt5py7acDRzbOv9OqIECaOEj3LfjUfAjX6bwKOpKLAie+PINkn5kmvLibDjrDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760131013; c=relaxed/simple;
	bh=4M9RgFdC3r+/fyxCuEQ2okJbynrygynqjwDLbz3cF4E=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=r4aGHoZ6tWmvVe6SMYZohD4fIkxFEJHwAIaKQqYJTdAXFCNfbBAllei5OWv3H5ygvLm1Yf1nEt1scytY+puCX7OgF6NhcDCR/IxHciiivggvimgZXJ9JL3okGVAWsc2gJxYua59/VyUSKDLN2tJXDM4JSSUUPH0RAPBDzRSaxlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=zDwCWVFZ; arc=none smtp.client-ip=109.224.244.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="zDwCWVFZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1760131003; x=1760390203;
	bh=OJ2G/9W1C4mnwA05N3ZcP5ByfjOvCm4w8F58UHA93dk=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=zDwCWVFZrCzXkk7ikrdOm0Q5ZGR2/Io/dxbIOXg4TjM/c1gx3DO8dcqAX4mEKa/tt
	 ET195OTgjaSHKOIwMW0iu7O18m7RKFX64ZFgp2VbxlGjuMqHOnelfqOcjiuu8NmQh+
	 J629/QKWumcCyKzlZd768ul5ct7pVavOlxhOq1y7g6NQSfVg0s0nsYnDiqFNxACC1l
	 HO9ShmmuDCkueZzA/lySA7oqLqTJzXmr6Lzji9EPNuH1aHVi9+OJgkpj1G23qngrWn
	 NJm7SHWKUlKmjbnPIH8poPJ9dK9M7r2oOQp2fSjOJqNVrziP3xFLJg8f9X4sK/UMJU
	 ws91jXJaNUqHg==
Date: Fri, 10 Oct 2025 21:16:38 +0000
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Subject: iptables: zero dereference parsing bitwise operations
Message-ID: <s5LZtLzqFmQhlD4mtmgcKbrgkfQ-X7k7vvg7s7XnXHekGJSKOMyOdmoiONo7MzuLVqYTFPntt74igf8Q0ERSPy5R9f8L1EfwrhOZbs_nhO8=@protonmail.com>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: 5ff8867e02e487a2fa9bbcc0740898afb5f4d787
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

While messing around with manually encoding nftables expressions, I noticed
that iptables binary v1.8.11 segfaults with -L and -D <chain> options, if
there's a rule containing a bitwise operation of a type other than
mask-and-xor. As I understand, iptables and nft tools only generate rules w=
ith
mask-xor, though the kernel seems to happily accept other types as well.


For the reference:

> /**
>  * enum nft_bitwise_ops - nf_tables bitwise operations
>  *
>  * @NFT_BITWISE_MASK_XOR: mask-and-xor operation used to implement NOT, A=
ND, OR
>  *                        and XOR boolean operations
>  * @NFT_BITWISE_LSHIFT: left-shift operation          \
>  * @NFT_BITWISE_RSHIFT: right-shift operation         |
>  * @NFT_BITWISE_AND: and operation                    | These all seem af=
fected
>  * @NFT_BITWISE_OR: or operation                      |
>  * @NFT_BITWISE_XOR: xor operation                    /
>  */


Hooking up a debugger, it looks like nft_parse_bitwise() doesn't check type=
 of
a bitwise operation, nor validate that it's attributes being used are prese=
nt.


From iptables/nft-ruleparse.c:

> static void nft_parse_bitwise(struct nft_xt_ctx *ctx, struct nftnl_expr *=
e)
> {
>   [...]
>
>   data =3D nftnl_expr_get(e, NFTNL_EXPR_BITWISE_XOR, &len); // <-- this a=
ttribute may not be present
>=20
>   if (len > sizeof(dreg->bitwise.xor)) {
>     ctx->errmsg =3D "bitwise xor too large";
>     return;
>   }
>=20
>   memcpy(dreg->bitwise.xor, data, len); // <-- zero dereference happens h=
ere
>
>   data =3D nftnl_expr_get(e, NFTNL_EXPR_BITWISE_MASK, &len);
>  =20
>   if (len > sizeof(dreg->bitwise.mask)) {
>   =09ctx->errmsg =3D "bitwise mask too large";
>   =09return;
>   }
>  =20
>   memcpy(dreg->bitwise.mask, data, len);
>  =20
>   dreg->bitwise.set =3D true;
>
> }


The bug can be reproduced with a rule created using newrule operation that
looks something like this:


> OpNewruleDoRequest {
>   Table: "filter",
>   Chain: "example-chain",
>   Expressions: ExprListAttrs {
>     Elem: ExprAttrs {
>       Name: "payload",
>       Data: Payload(
>         ExprPayloadAttrs {
>           Dreg: 1 [Reg1],
>           Base: 1 [NetworkHeader],
>           Offset: 12,
>           Len: 4,
>         },
>       ),
>     },
>     Elem: ExprAttrs {
>       Name: "bitwise",
>       Data: Bitwise(
>         ExprBitwiseAttrs {
>           Sreg: 1,
>           Dreg: 1,
>           Len: 4,
>           Op: 3 [And],
>           Data: DataAttrs {
>             Value: [ 255, 255, 255, 0 ],
>           },
>         },
>       ),
>     },
>     Elem: ExprAttrs {
>       Name: "cmp",
>       Data: Cmp(
>         ExprCmpAttrs {
>           Sreg: 1,
>           Op: 0 [Eq],
>           Data: DataAttrs {
>             Value: [ 1, 2, 3, 0 ],
>           },
>         },
>       ),
>     },
>     Elem: ExprAttrs {
>       Name: "immediate",
>       Data: Immediate(
>         ExprImmediateAttrs {
>           Dreg: 0,
>           Data: DataAttrs {
>             Verdict: VerdictAttrs {
>               Code: 1 [Accept],
>             },
>           },
>         },
>       ),
>     },
>   },
> },
