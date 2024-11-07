Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2A71DB534
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 10:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730975441; cv=none; b=uKmBepJgFsQkbYyXUiQxnVMLIF3RDnRvYJgocNisht2eUejf1yvrNKgJ/QQrda/a1vl5Jsb8xdaBsRUw3BVeXxgCDNYDx8Wl8LPNgxAx/o208fPGITQqSQkZ/i/LqYMHh6T2+NWu9wYdfouzzxTaV7LkaKNIjdjHE7UyNA3P9Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730975441; c=relaxed/simple;
	bh=61IjfaEQn3qQ+6EN/a5E8MM0e/Hk9Oy+zJvkGf4+Mg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qUDqmrKjZ5CUZ+dkhPmOhMAof3WrnGY3+5S817Cgdcf2HcVGB5EV8cUVT05pyDgLLJXGIDibqFNb+KsBCOutkej1z5B0bbNxMBYxHMrm9BdTMNLC13qu1KMKdYIL08UWRwHy0SPhKogawA0aiEn8+snwaESfAsdUT9eyYKll6AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jAfw0oTc; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jAfw0oTc"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5cedea84d77so1158579a12.1
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Nov 2024 02:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730975437; x=1731580237; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61IjfaEQn3qQ+6EN/a5E8MM0e/Hk9Oy+zJvkGf4+Mg4=;
        b=jAfw0oTcwQT2Z/rDEgo0gl0k1f56u++mOGPVW/DT/7pm19V2gb62bY8jCEscwbtufh
         s5sMurZwYkk6Om1v9MXjijNnRHwvIHoQK3i9WH6xYz++ck3/GqCMHd49k9zEdD3gnVU3
         ARfgDQf6MC9KtFd1ZpXSuoEBZBap8oC/saesBy6HRtM6NR7iLUWkumksXEpzrmgB0tZ2
         d8PS0HMO2kdzq2nxEFLPiYZCQmQh5xvtv/z6RENB4qQEf3erlItPn1KgN+3AEKA/Uavs
         3NGJqhAp+5Hulwd43F6fcmsntq0VeeQ5UjBk5r2px1f1uPkOP6YMN45vvpNCVlRtxJq7
         XVEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730975437; x=1731580237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61IjfaEQn3qQ+6EN/a5E8MM0e/Hk9Oy+zJvkGf4+Mg4=;
        b=ZKSZRwFvrEMKNOjqzV5h5sOMaKoI7ptJWyJKFQOW6R9DD7UaCgZKHpa03O8XE7uQjv
         KQKY7arSTO2wvTCFsw//muFDp3w3IVkKn0E6OsnBUIZ2hF0YerDCEg1XhRShamXDII9M
         uRVUAjWP262uTSNE4XXYX3cWfXP0CFqvEhOKPXtABA94fD6nUpQ2LeMR6MguVWrjzmSH
         qBQzgMLcrGo0vsTbNvDsLvyIt+vo18nbkdyzBOcEYfqikcCX30S9A9HWxn8e1pyq/E1Z
         8NodHzS74gsDUzJgZRMMtIMy53kj+GP1XONbdLYF7goOc3Mcjx1Rb/1dS3yPO9uXNOml
         5w0w==
X-Forwarded-Encrypted: i=1; AJvYcCUTO1jkfSIwI4WE/PFK7oCZm1pig66Db3qXtuMh0WN6fhYJAX9hnCRm4oXL71GXe2EGkQqmINOGcXGoPj6/XSQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc9QP5Bx5SjMfC6ymI17FccaJTnW6MlZkXU9m9+lNMz6ygJ+t3
	VsCPJHChMNLhHbpiT30KSXwDqqB2jSzxDPLloXV8LeF/rF+OPxnPwKss2BmV2/3J9cpN6W8TTV/
	4N5xeE0DBcqCvCvq/+MwA6AfwEzbrwkFtX8pd
X-Google-Smtp-Source: AGHT+IG6bVOhtvsLxK2YX/L0Vhv8DZK684ype8EIDiKokeSnIt6mIlhseeujo/6tMoM5CJtKr4np6cDpX0yZIhQp+YM=
X-Received: by 2002:a05:6402:2347:b0:5cf:505:c12f with SMTP id
 4fb4d7f45d1cf-5cf05a048e3mr565369a12.21.1730975436892; Thu, 07 Nov 2024
 02:30:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-7-chia-yu.chang@nokia-bell-labs.com>
In-Reply-To: <20241105100647.117346-7-chia-yu.chang@nokia-bell-labs.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 7 Nov 2024 11:30:25 +0100
Message-ID: <CANn89iKov5iu+rnGsbYrxKZZWcMQ+zKg6CPCY96TT1J_vVZ6Bw@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 06/13] tcp: rework {__,}tcp_ecn_check_ce() -> tcp_data_ecn_check()
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
> Rename tcp_ecn_check_ce to tcp_data_ecn_check as it is
> called only for data segments, not for ACKs (with AccECN,
> also ACKs may get ECN bits).
>
> The extra "layer" in tcp_ecn_check_ce() function just
> checks for ECN being enabled, that can be moved into
> tcp_ecn_field_check rather than having the __ variant.
>
> No functional changes.
>
> Signed-off-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
