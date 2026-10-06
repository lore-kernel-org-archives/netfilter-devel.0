Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7C09475
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2026 03:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791259040; cv=pass; b=R6QrMw5mfZdc0jLgqc35qkr8Ca1sckQp+iJz+/JJANDL8emhKZlXp2uplI3ht5gbejWcmgeL33Wc82QSeLAVehEKv5VTIXU1DTvvKP8aoy58mvbDeB5nl95ecrW+05jPOg90yxPHW/eBQeUMO9EU5DA9KUpjuJ0O8h+j4JyZfXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791259040; c=relaxed/simple;
	bh=AsQPTCijFFnSl6uhcmGXEH58t82NdDV5ST2wdTt6GoE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PxtpMKjQmUe0OI3Hc8ZVSjlGXCM7SUH8pU9fLZ/HSIgGhPJYW2Uz5ABjdDK1ra6tUgEMJLdwLAnea0GwSFtPhIIe6n+ysIUmLLU0JRSqTNGMd1JL1zwd0/pHOFBzj5NwJ7OGFnZxK2WhemvGYG0mFaJs9ai+Cwb31Cs4xWUL4/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fuZ5d/fB; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fuZ5d/fB"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6aa8d04fcddso809715a12.0
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2026 20:57:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791259036; cv=none;
        d=google.com; s=arc-20260327;
        b=rYvfPs0KzmJSYrt3GMAEXJlzqE1Gw9xOXrznO50GQpjS8/mFYupq9wkWT3YanFVeJx
         EYDgTHpnoK+pBRjxzJnhqhjh5ocS4ItKMgA6ofpoIdlZY0A3HH+Wc6jqPnO0K5Ax4nmD
         N/vT4e6QMaWao4c4o200sByOiKqeSul6NCM/ugktt7Xe2RegjuQ8/4zfKS4UqUxcQwGW
         2CWBovtLO1Uw3WDmBL9dGzBsPW5vO7IFspWVN3LSsw93oIAhlbdlCgHQZE6Ienig7wwT
         q4dAh8tXdLWIACIHL4xqL7nwdRPmiGFhlYT7/UdJTj+N1908EjiZ3WIcbfZ+fcjT7lm1
         GKdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AsQPTCijFFnSl6uhcmGXEH58t82NdDV5ST2wdTt6GoE=;
        fh=mR0cbyxmUQHmfjxk4mYftttVM5KZY6kWflOlGBd9wIQ=;
        b=G/6baODj6LaS2NEdZolfqCyoS6mgdYWiebukTNaVq+VVmuSAYhJrmQme7DMgQMAG2m
         g+G+FJ5rs4MpN22Lcj594I6za0ChRuckd6N31CnfWirOIWYG9jBxR3JX65XFh/6P1YlP
         sfwG8OA6ZRoQPimQrFaY8afht1GR6h465YJpt4bJHHP5E0UopnJmsjueAyQuueXyDRVD
         JW6k0FGPdkdoB2BdgU2Xa2gLJNU30K6iwzXNJN+b6E29M4uOoLHCk6vbKUjap/pPXSxx
         uzaNv/TaLpvL/BsWDc4bnvK3px2+Rw1w9UHom1v6l2V3iaRoFOuAU7UVZNdsDSfKg6w6
         Qkwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791259036; x=1791863836; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AsQPTCijFFnSl6uhcmGXEH58t82NdDV5ST2wdTt6GoE=;
        b=fuZ5d/fBYdVJWcmI6k/DPPngY255c4n9mWL97UrU2omDaP1i6tXuy6e1feARF9Kgiz
         mri5EiedH0ERmeU7PZZsa/KQXORrGHU5TAncgNhlFC0Coa3qdytBVFiJVrdU+bQr3apQ
         /KEbHk+K17Re5XiibuPK8NfxmJWnPxxNCh11mXLjrqXZFvWx38kzshF9rgsE0+BKmjcY
         drqEU2KA5GC2EZXNJD9q+wTN37hBP42GSRL6CNCnPdiF1aviIWfeU7bPNWGIovu8f0E2
         6LvDtZudLBH2PyHY+xzjgozHN9zxZnCknXBB3194nfq+bsfxrHRYe2GR+iYUJgv7mUY6
         oULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791259036; x=1791863836;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AsQPTCijFFnSl6uhcmGXEH58t82NdDV5ST2wdTt6GoE=;
        b=C2rUbDvxg6B4h8KcqvsMoXS3o3lQ6zECPaxXhpay9rsuFmr3Tdylp4qHo9AFLHJ5Bx
         pn86f6MzwyOfqFfKoeDN2kzC73RFc8sDylemH5OvyNVi7Tg549OqchDTSyM4WaIiGoy3
         K1DkgX/TSUHBWlsT+27SlLWbgAa77y1rArJCon4xQJSoqnypDBDCrLM0bFhXLsFP/GPG
         KQ1xG9tr9ClPsFzUSYBDFx9+EjbX5f2ojZzBrwGRo61XXTIp58LSMyU8A3DNMuI0tMER
         m51VpzE2C0tPO9nZPYyLJUqR/dDvNZkY/XPLr9UfkCy+VUD3oWYAKJoG8Kb63LaCl/Dz
         6hMA==
X-Forwarded-Encrypted: i=1; AKwUvByNI+UtU1fcB1Gc0MieN27wnUK9Xgy6x+aoM2ErSX1Xa/KrG1FC/3L7/eu5bGoxC1k0IYz36YA7FGZQr9q1M6M=@vger.kernel.org
X-Gm-Message-State: AFq9FYLLNY9IDkONS5dBFhkPZf7J+jkbM9p3NLA/n++j/wXo+0esXFsk
	ROJIliqgCyEkWe89BYk0HRfBnClNrfE0JR0nfc8VsBfplyHEBSGovFtztPubfYInBP86uQCTh+T
	KulhZgaemZB7pYgAka/4DUb1d9zJOMhg=
X-Gm-Gg: AYBFou2rFlijNEz18Gl/Kf09COqwpqwZD2nCE4Ml8H86hi3VeudRpcq5iDjJCydUsuc
	R1ZbC2mEPeruDoLEOV39Y5Bw1cEpXqK8rzANpLQHE54H0Op8VNfZ9Xvv8/cBJG5p/vmfzQBbS/l
	oYymw6Fu5bW/i/E1R8T/NSJknct5/froZrPRA17LGYVrv2YaCcl9wMVXLNrJFXxM7prP4wUOXaK
	HrCEck7pN00traVFX7UAc2i6+xb23CJsVrgzYzHJSpCR0NAD2wDFHHENltrKgy7qUoowaRb+1b0
	r20i9LHEfe/4gOVi0nk8LkY3ByLCDn+NGgZNkh2JKqOrRHnfPlC8X6Nc
X-Received: by 2002:a05:6402:2488:b0:6af:a270:b2a7 with SMTP id
 4fb4d7f45d1cf-6afe280985dmr147282a12.0.1791259035733; Mon, 05 Oct 2026
 20:57:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHeizqHDqx3ue1=0QL92ef+6C63Ur+v1Z=d93smgdD5zTj_-Pw@mail.gmail.com>
 <arORyXjxvZUoEAIw@chamomile> <CAHeizqF--yGMCLGBEv9f7Gs=dmbZO6+DwSh7KZjpDgbNonCotA@mail.gmail.com>
 <ar4db-oTyeSGTpCy@chamomile> <ar6DFv-zudWg6i1z@chamomile>
In-Reply-To: <ar6DFv-zudWg6i1z@chamomile>
From: Subham Pal <subhampal789@gmail.com>
Date: Tue, 6 Oct 2026 09:27:04 +0530
X-Gm-Features: AclHuK-4B_jprqNVXhLiushIvBfXup2XgaXBALX2ddQEQ01QkjBFDMAPA_kUpzg
Message-ID: <CAHeizqFAFRLf2bGdw-pTLh-ovWFR729Z47obV7m17TrcMb6SVw@mail.gmail.com>
Subject: Re: [PATCH net 0/2] netfilter: nf_conntrack_h323: fixes for NAT
 bypass and ASN.1 decode
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, phil@nwl.cc, kaber@trash.net, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 1, 2026 at 9:28=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
> > We will need a reproducer here without requiring such hardware.
>
> This requirement is too strict, apologies, let's remove it.

Thank you for understanding and waiving that requirement.

Per your earlier note regarding the target tree, I will rebase this series
onto nf-next and post [PATCH nf-next v2 0/2] shortly.

Regards,
Subham Pal
