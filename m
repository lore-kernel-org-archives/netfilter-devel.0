Received: from mail-24424.protonmail.ch (mail-24424.protonmail.ch [109.224.244.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E822CCDB
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Oct 2025 20:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760213719; cv=none; b=bddgSFUJ8W3IAGgIWd09IbEu9mN5i6TI/VsYS2p6xc0tuZYJmZ8Al4/X/ygBCtdrmN1Au9hNFnq7WZReD7I2TSCwEiMcaRMT9VXUK/M+OoXGb0M2oeGN/INaThGPgk37Ahwx/p2oTA/0IdtKxPNe9oX3zXOEUu1aaCbd8oGvwkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760213719; c=relaxed/simple;
	bh=zIFv+vWhnTxb6zmXcTfMwdTR8H5vU8Ev7sWv9prmnjA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZvsYwtySvj3yCGXvfQ2o1j2gIqQPwlpQYCaM8e1ZzuE14FwmbxzVAmMXlkFUxAmVeyX47Ek72sAkobRmbWahKjKNNBM8+dNNQEqCPidSNtBxPC2SaP8bXGcUyCj1At0W67Vcu1I14eCOWqArCdu/q4oXi6qmmUvsqgMV6RUjkFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=L2vWNcX/; arc=none smtp.client-ip=109.224.244.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="L2vWNcX/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1760213709; x=1760472909;
	bh=C4rSuH1BqPY/FHM8g+TeiweILdZUUDML1Fv0LFrreXE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=L2vWNcX//oNNRyXbx3MmKA0nLtFaMJZMt21K6qtdhu6pwiOYzQIzTrgosRlVc34yX
	 cJmNQNwiUvn7imsBasEoFjmZfoEtctp6v84KjHW+fC00mjMUhrwVqosUBSQWdF2WJ9
	 ooa66K6RrBoAJvHKAHSdFpLS3q2gT1q7aBBVuxnctawNnASXZCQNToP8nJFnHmf/Dq
	 KH38TsckB+cA9BA7t20R8sjlIhQsxskD0XSAO5Xsm5KDGV4aYSLcxesdBTUIPBUd6s
	 w2z1guT4dcA3wkBgASv2+BQpgTIeLQrjfmlYW1OAii/X0ZdvOV+Ou+/kQ3/Hejobr3
	 5vXSXlrrl0X9g==
Date: Sat, 11 Oct 2025 20:15:05 +0000
To: Florian Westphal <fw@strlen.de>
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: iptables: zero dereference parsing bitwise operations
Message-ID: <e2mf5Q5IBD50dFQcvIXCNkQCKwghz-hLmCunP33gaZy33srxWrQKdcL1J3GKA8a0H05T6p4kZGFpR910g7JBZusbg_AmEZKPD1UvW_mEheQ=@protonmail.com>
In-Reply-To: <aOpigXfhOrj02Qa5@strlen.de>
References: <s5LZtLzqFmQhlD4mtmgcKbrgkfQ-X7k7vvg7s7XnXHekGJSKOMyOdmoiONo7MzuLVqYTFPntt74igf8Q0ERSPy5R9f8L1EfwrhOZbs_nhO8=@protonmail.com> <aOpigXfhOrj02Qa5@strlen.de>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: abc66f6a23956d8deb868c54b133b49f7e0b95a8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Saturday, October 11th, 2025 at 13:58, Florian Westphal <fw@strlen.de> w=
rote:

> Remy D. Farley one-d-wide@protonmail.com wrote:
>=20
> > While messing around with manually encoding nftables expressions, I not=
iced
> > that iptables binary v1.8.11 segfaults with -L and -D <chain> options, =
if
> > there's a rule containing a bitwise operation of a type other than
> > mask-and-xor. As I understand, iptables and nft tools only generate rul=
es with
> > mask-xor, though the kernel seems to happily accept other types as well=
.
>=20
>=20
> No, nftables supports this, but iptables does not.


Hmm, when I run `nft list ruleset` it terminates successfully, but it does
report some errors at the end if the rule from the example is present.

> netlink: Error: Invalid source register 0
> netlink: Error: Bitwise expression has no right-hand expression
> netlink: Error: Relational expression has no left hand side

But I'm not completely sure whether it's not me incorrectly encoding the ru=
le.

For some context, that's how it renders the rule:

>    chain example-chain {
>        accept
>    }


> iptables should not segfault, however. Care to make a patch?


Sure. I think it's fine for now to just check for the operation type and
error with something like "unsupported bitwise operation", like seems to be=
 the
case with nft tool, since this issue appears to be extremely uncommon, if i=
t
hasn't been spotted before.
