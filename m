Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E29193070
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 12:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982376; cv=none; b=RogHFPuvXoHxZvXJSZDMohKw+LiyCteaHLaZSnNSzZqIF3ZryElA7YvUmPcffQVfWzTT10/DHiEbVBBw7SCfipOiHJ8F/lqJl3LnDFDbpNKqD0ceUiGvhTV1HfZrozLX4A7X2WIo8BQpEyp3xXVnY8XsI1EtlSFY/SnFWGvN1S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982376; c=relaxed/simple;
	bh=5zXSMHay5lN1TpbYNJto8uojGDIwvumMNYSmtiNSyHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HfZ6xsTJreBRZWgGxp06edFOPwasOWOAv/oDvE4EylJUgf/MyXT2NyPHtXkKPohLcwshcSfRLPM9ukYlXqCsEPQxRnSbtm34pYWhxp9bwVaKXWKzQ3j0bYLDqr/zxBSe7IAslQkhxrFZA2XXIuh/AFkJm6oS/s6y1zjbMOmQtMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lC3RdT/v; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lC3RdT/v"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5cec7cde922so1110908a12.3
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Nov 2024 04:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730982372; x=1731587172; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5zXSMHay5lN1TpbYNJto8uojGDIwvumMNYSmtiNSyHk=;
        b=lC3RdT/vx73nvPLY9RrKtKmAj8PQeQpTJ683mRbVWmwc/A7d6MU03hJ0QJ+6e1JHVn
         q4TB+wKxYSEWuXYJNbb8og/PXV4bkmU9BfdcF8fDqyi1Yj2Cdx4wGbsMTbzXxcn34Rwj
         tmoBpkZKX7GKU1kNx7P/aUdUK6Yfvw2FE2M4Qr8Gx8CO0IQwGHL0WNxUV9yB3Pxn2Tz+
         ke23Sk6jQfb2rUT3u62TZXoj9oi+r1o21pfYXRq8+0p7k/oePN8Jxohj+DO1nz3bfcdE
         jxCRs95te+9+nrkKg0tWjxtgv5Phlf2FAFvFoaPTSTdr16x4L3EX1ZIHuIrV5DIYNJ2f
         LkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730982372; x=1731587172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5zXSMHay5lN1TpbYNJto8uojGDIwvumMNYSmtiNSyHk=;
        b=wVF4NCN76S14TV4gIkxrBLiMjm6DP35hTtYbnPNrV3qwGFuRf2CMRfYYzeSfTwm2I9
         GdPqWLtJRS5uz1KTcrQFBMDC27YrbIOqXhU059ODjkOuhRENQMKQaQWqdVXzPCdnq6FC
         7FHdfquMynlBy1BVHRWVwEivZIPyeU1hOmF8B8qC9Z1YipsgjAxXCaUJpVznezG/l0cJ
         hdwlj6AaWTwF+K2/ZjPfsODqaO7HC84ZTkDGglqghXGEV/n+IH9wXMar+bswSme0BqE+
         wX5SdmFCc8VdxiWIJfkwjYXDRiUlxShAGedmUF6mfgXPAkb2WlJ2rB34CBvhRr4P+R0w
         P2Tg==
X-Forwarded-Encrypted: i=1; AJvYcCWigGY0zeFqkoSidSZV53I0tIGzEFthujj1CL+XAtYAYBXPuch9V6JZJSofy24kajsODH/HmsGuaPeonOyff9I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0tTkuIeE7WMx0Fd1DvWHfnXt8vcoRLSTRohr4mWKAXZaVW+vS
	sDzBYwOW3oUIFTZLnJDnZC13lnACWe5zQjq5CPsZfce57DC/gajkp2mRH3ALUUI3kTNhQSryVAx
	E4n6IAv/2uW+MFDzpSwNJGbzNrCStEHQshlJN
X-Google-Smtp-Source: AGHT+IGVPMRjwZLTsyPzHyCyQ9RXbpiHJJOsrZ3oQv3uPas1VIJ0ZqwQatoNAPvlwz0bKAIqloB0JigXqH37KGVCtJ4=
X-Received: by 2002:a05:6402:42d0:b0:5ce:ddd4:7c2f with SMTP id
 4fb4d7f45d1cf-5cf05969b85mr823129a12.7.1730982371959; Thu, 07 Nov 2024
 04:26:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-8-chia-yu.chang@nokia-bell-labs.com>
In-Reply-To: <20241105100647.117346-8-chia-yu.chang@nokia-bell-labs.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 7 Nov 2024 13:26:00 +0100
Message-ID: <CANn89iJV63py_q-wFGHHV1CsmjPFFdGc1z2BtnxG4=2fk8yMyQ@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 07/13] tcp: helpers for ECN mode handling
To: chia-yu.chang@nokia-bell-labs.com
Cc: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net, 
	dsahern@kernel.org, pabeni@redhat.com, joel.granados@kernel.org, 
	kuba@kernel.org, andrew+netdev@lunn.ch, horms@kernel.org, pablo@netfilter.org, 
	kadlec@netfilter.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	ij@kernel.org, ncardwell@google.com, koen.de_schepper@nokia-bell-labs.com, 
	g.white@cablelabs.com, ingemar.s.johansson@ericsson.com, 
	mirja.kuehlewind@ericsson.com, cheshire@apple.com, rs.ietf@gmx.at, 
	Jason_Livingood@comcast.com, vidhi_goel@apple.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 11:07=E2=80=AFAM <chia-yu.chang@nokia-bell-labs.com>=
 wrote:
>
> From: Ilpo J=C3=A4rvinen <ij@kernel.org>
>
> Create helpers for TCP ECN modes. No functional changes.
>
> Signed-off-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
