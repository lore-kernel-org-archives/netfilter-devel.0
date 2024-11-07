Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E5D2170A3
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 12:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730984302; cv=none; b=FRncEeK7oPIwXEN9G7SR7WUGvSRLJR8L6epT64XlRKFDVvHiGm/97JYuQBtSROn/h+7ovH4mI8YKPWUOfp8TIFirxjxY7nhrsP2iB8P8oj3J07esJs32lOnGRec7e0geMQRD8rSqD0mnA5hz+wEK9d7KUzYxkWRc5vWlcMMbppg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730984302; c=relaxed/simple;
	bh=rREI2uB/V7gITxR+FOWEnJEJj7Zp3xpW1kT6EnF6GGg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tSJpWEGxAFez5BjjGDNbzlHDcLonlb94c6Zh1TumGQjPRBa6AYT75Y2H7K+LKJi4RRFGMAccGbNL/m0nwGdQhuERKcWlDbMgZ5ORgZe7y/xeMjxqjN6o2vz0EB6Yy6moqIaBF/hQy1Oox/NSWDmVk5ZyqzTZfFNULh8ZXfgWaNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=skbpCdXw; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="skbpCdXw"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-83b430a4cfdso41375639f.2
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Nov 2024 04:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730984300; x=1731589100; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rREI2uB/V7gITxR+FOWEnJEJj7Zp3xpW1kT6EnF6GGg=;
        b=skbpCdXwJBG3FGC/3cRT+KVeKXU4yQTcnJqXu2BZnOFy9VhPb38QQyBv/lQMAaycKh
         5xusSgBIuE87Upwy7eU+Rh80cALiUKEWtfVJPsCQ4D0/AhoSRo91mbIm7oCVZ+zPJNl/
         rc3rnI9vlGHt7Yogq5Kmkq0KmH+OOt5JgVBaR57iZj6zksGoCqVoReRMzlnRE9AYu0z2
         ua+wcCsEtdb+ReYnRxpKlfUqpPB4YD7KMFa8fU/bgjyV19fhIOH1C71eBcxp/venA4qF
         c5/Rq0D6lzwVwo9x1DCYyDnL0vQggt8INSAnc13x3bqcyZB/nLTKSZxcNhpCGVyyYAB2
         m88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730984300; x=1731589100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rREI2uB/V7gITxR+FOWEnJEJj7Zp3xpW1kT6EnF6GGg=;
        b=MI7oXPUw9eY8NlTVX2Or3e0KI8edfrR5NmGMdisrOCPq/BaL75RWu8/a4vPu69QSZY
         MIw/Bt3BAsValNMAKoKFzvg+hpNQFlJd5rfXdjA2nLYPcbu07caDQe/cZPMslc/9Jsmw
         5Mt79tvR2IL3jpkOhGhR+7J/L7hGJ0j8UO2SX5OhHlWEFK1v6li4MYgYj7aQAQbUT+X5
         uGGmSG9GyW3rr9cp8W5UUK/pICzBXSjICkaX/E3juaXjTTnXPjQdT1ydfGsn9KvVrKSI
         KymImm9SiyOYv/fekx1HynOOhQTdNtA5m1M7kQYvB/SuW6QS7tTH1YCGpn58SX7/UMTr
         zM5w==
X-Forwarded-Encrypted: i=1; AJvYcCVhCLSGE5XTlWZK/lS1hLapWu9la6m3UUWeK/+z/xa9FXpgAYeRK3IwzLuQuIGN+B5V9KhAAbdR5CU+d0o7Kxk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlBio7M7fek/gV8YGdXguwya3mHdGewcP/2jBa9yWkxwdRGHQD
	/yBVZAPdf8yE1fO0chKhyvQuqyL2bKPPP7lsGf5e7wWjCoaLiq/I98knVFGAvUpgxkiW04PtwJX
	u/ItzhqJmWmrzqBfoGWN0zjHG5ygfTWKDaCmM
X-Google-Smtp-Source: AGHT+IHscjrM5yEnv7CrhyReHBjY7qQl+IXVp7qcac6OeEOBi7Zjcp2eWSsM0avGdTAuio9QA1rDs6cVw4QugdFls4Q=
X-Received: by 2002:a05:6602:1354:b0:82c:f85a:4dcb with SMTP id
 ca18e2360f4ac-83b1c3e7acbmr5270606939f.6.1730984299791; Thu, 07 Nov 2024
 04:58:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-13-chia-yu.chang@nokia-bell-labs.com>
In-Reply-To: <20241105100647.117346-13-chia-yu.chang@nokia-bell-labs.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 7 Nov 2024 13:58:06 +0100
Message-ID: <CANn89iLjhS-bTjxDH37K6NOVHU6FgD6KL3LT0nRGyZBvtADYjg@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 12/13] tcp: Pass flags to __tcp_send_ack
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
> Accurate ECN needs to send custom flags to handle IP-ECN
> field reflection during handshake.
>
> Signed-off-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
