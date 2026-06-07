Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C47332F742
	for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2026 21:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780867791; cv=pass; b=YINho2CFODio7nn9PvpRMudeO1B7p6hyGhhp+tkT2dcQ3RivX5+nC3DxW5Zh1K5fdIpfixXj4mAEUKMerHllfIh7Ay+XyOCS+5V+lZxf5XGtrBzTBlgIoDcbaxNSAs8tWf2Mav3HLISCIvyzghvHEbHNZGtXOc86lILHBVSWVTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780867791; c=relaxed/simple;
	bh=SfHTzSYOmQQIndLq5Z85edH+WHw8MejqpmILcdxWCvY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fUnych9tmrd25XpR+j0yb7MICuKnXjzu66yGxMmH0e7ur+6FC1gDgB0fkiQDsRA4ymJ3+GuS4UAbpeLQYUAI75jwOWcbXqUgYKoYadEKRUzpnbj1rrUHEoB/IR/2H/lf03NicFOWZXNc79kiEKRCQvg7eDXIXZSq3bCGMdFDOlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TTgFRFkp; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TTgFRFkp"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6913fb25322so1953401a12.1
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jun 2026 14:29:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780867788; cv=none;
        d=google.com; s=arc-20240605;
        b=cc6TGiCrA/3qbYL1sxdwdi9DYxOQz+F36xA2BG70GkJzUiSKIzr/XZavx7c24SZa8+
         VctkjsL+yueGUikVTDP24bdTcNM3aupxIqJj6cCR1PQWlWS1FtyZbBDr+tVQjZiZmk4x
         MG/r7o/EScogK7uHN5qBkNUocNxrBu60LtD+KTo1jZvIcY5PAxxF+1bYzuTWGDivibKY
         D2U/YM4fe/9fK5nuhQJ8CjeIaHixH45hBTGT+Hh8hKvIzO2zkSkEYh6hJeeYyJHlYboZ
         /VsyRTJc1gaiEcFrLRXYJQyYq5YRMOX8u9JyCALVusBdFPsayvOG4z4cH1MnrbpfmjsF
         MF9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SfHTzSYOmQQIndLq5Z85edH+WHw8MejqpmILcdxWCvY=;
        fh=x1DjluY4crz/j78KPEbHEsSUXKhz/dNBEN3VgTx2tXw=;
        b=TXqmmfSueekdQsZjoxYEVUkbTJ6UW8+6tFsfJYW4kFjTYzNWOHuqWXoywA1YAYYeDS
         VSq+MJ0ClIB9DpghLvvTYlMz+H2eIrcPvcqo7ARiAFlCLJck8ylHXZGGdPCnriReIGrb
         74WtCfwecra0oKK5DjM3nf6M+UKbTFncFqBglorq3dgO/7bSqDsOhzxbg7gG4px9YkvH
         XcglMaemQy31Wk86ooHTbT6UGwlWhndeSCzBiNib7dAYBtcqq+73mmbcgETI5Y7n6/Ge
         GOiHOb4JG3UcDTXmIs/dJ15T8ut96TM2FO3OTOPQr4jjZWO1KwB4R8FRRWJxmdhR6T5q
         uCBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780867788; x=1781472588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SfHTzSYOmQQIndLq5Z85edH+WHw8MejqpmILcdxWCvY=;
        b=TTgFRFkpYnVfbYG2ZVNXPU72mmyGaCi9VEAVHm9pY6mhsh1smARdS7uc6OErXV0EQe
         eWU2RyxLEZGQu0oe79TQdeO20MDeV7hJLGyK/1Ht/2VEyUzZ3RzS3k6lkj9GT8MHE4DV
         zUCmvb71Qtn+T3eDzbHiBWfDoRTE3kE+Vh9NBRmcweuxq/fkwmeOh+7AFFKU89MnBTSm
         3d8M5o6waywVa4NNaeZquE5wvrzzXKSgjwtfwiaMpMHwsNEAuen2tFv2BSyQGGCVqhpZ
         kpEmFbX3Hl1xkitHFrEtw9+GqjuPC17lomMipDZpAWb8dEBo6rgWktXykjMqDWOSyn0y
         7J3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780867788; x=1781472588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SfHTzSYOmQQIndLq5Z85edH+WHw8MejqpmILcdxWCvY=;
        b=jAcL9dxD/kCUJEB6BRmUCgpejU1P18ZAuJQ97pyC+t6Ol8iB/NlE8WRS9Wpyq5c1Ga
         SflTqFxO9LTdFB3NP+rCFWbGStjZMQAr9I5yoA1CbD3GpijBTkBbI1TRaWYQhmzV0o5D
         5+3Q+xCCt6tGG+sa5QdwWc4efGnBmQ81VFOMePQAR6tmVUUx5GuAECIyteKgJ4EvFtDR
         UEysMGEVWncwc+jueMIYuuD43DoVoUo51AqhaEwGL5F6ERgZtwLB6TuPYpCX+mRVDykI
         +k7BbbUPHlfsVUUcGXftI8QQYzUUQkXK3vTR48B/Rtv2G3f6a65MBgoLZTuIZWnf/rZ1
         YbUA==
X-Gm-Message-State: AOJu0Yx+ZjzcecfcyJEhKAyzF1VasWndlj7ShVx7kT37pZ2A5CNYphGy
	MOartrVjzqMei4jLU5qbZd6vbDzjmHuRSIDH1jdWyNd5azNgo8VWnCe4lbo0grn0llePbQN3Gzl
	GkA+WYc2UNysUyfOS9Pp8e22+T7slw5k=
X-Gm-Gg: Acq92OFt4UzH7CIId76BaHFY/z6o9yVIvkO/vUvEdM97r71f7AonOaaeYEZHZl3FB69
	xSzNiMfQ2vMGC/zqtlJvBPX6Z67HLuq6fVnZPoZMSXWX+X7lJF8ZuDB5hjHHmmG3T+mVDUAHVM/
	0EIUoklox7lgkzW8+0jLKhmZfIRxYxdAIhzNQBQdUUuOkWlYrnbjaO5Wdu34roZkVXENepMTS4g
	FntRrEK7+6ZfSykSTiLJFpI6TR9yZ8gNy/42l0ZX11YpBYF7kte4hB7L3mtjpCHVb5kgLrtkzsN
	0jMXQRCwX+8PKhdXDU9YPR+oiVX50E/SI16beIuhOE3Yxr/elcLbEuZ7bXTQyHDj6fEEDjDEVYY
	+gclOi9S+CwAp97ByHT9F/VhXhaGVXfWfkl6g9fi7uWygtr03vCHELN02MVKTmdybmWX6
X-Received: by 2002:a05:6402:5291:b0:691:706b:183a with SMTP id
 4fb4d7f45d1cf-691706b1de4mr2702719a12.6.1780867788402; Sun, 07 Jun 2026
 14:29:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260607164447.39700-1-rosenp@gmail.com> <ab136215-157e-491a-b9cb-ba9c1d3c982d@suse.de>
In-Reply-To: <ab136215-157e-491a-b9cb-ba9c1d3c982d@suse.de>
From: Rosen Penev <rosenp@gmail.com>
Date: Sun, 7 Jun 2026 14:29:37 -0700
X-Gm-Features: AVVi8Ce9fYWTiODFznvTrealT-vixadLgQb-5zzvM-_Iajy9bEIbkeCRTdx5oXE
Message-ID: <CAKxU2N_K5fV_ophrqOyp-0f6hh6opGz2V_BYN4JN2ABo4bwzdw@mail.gmail.com>
Subject: Re: [PATCH] netfilter: synproxy: fix unaligned access to TCP
 timestamp option
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, "open list:NETFILTER" <coreteam@netfilter.org>, 
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 7, 2026 at 2:27=E2=80=AFPM Fernando Fernandez Mancera
<fmancera@suse.de> wrote:
>
> On 6/7/26 6:44 PM, Rosen Penev wrote:
> > synproxy_tstamp_adjust() reads and writes the TSval and TSecr fields of
> > the TCP Timestamp option via direct __be32 pointer dereferences. These
> > fields are at byte offsets 2 and 6 within the option, which are only
> > 2-byte aligned =E2=80=94 not 4-byte aligned for __be32 access.
> >
> > Replace with get_unaligned_be32() / put_unaligned_be32() to safely
> > handle the unaligned access on strict-alignment architectures.
> >
> > Assisted-by: opencode:big-pickle
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> Hi,
>
> as mentioned on [1] this was already fixed in [2]..
OK.
>
> [1]
> https://lore.kernel.org/netdev/a8cfeb06-6ffb-49f2-a14d-c5a50bc4e5be@suse.=
de/
>
> [2]
> https://lore.kernel.org/netfilter-devel/20260525124450.6043-4-fmancera@su=
se.de/
>
> Thanks,
> Fernando.
