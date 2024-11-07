Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C280BA2D
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 09:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730972103; cv=none; b=E8LYqvpAdIWaUp7flcJ+c4YHyvq3MUwTLhg1chCU6LodPSdBMGLGYkhGO0IrYzXkcx0VFfKWePKWlLcDcHdyKYZ3o5Qzu6dKMXIfFZTv8yIxj739sgzbd6iMoEWowuA9dqvtJL9WxmxMgnQD5T3jUcCPJehyzunLUMVCE0D9XZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730972103; c=relaxed/simple;
	bh=IN2DmLQ1o2SDyeRsGj1pPFvvBNQQ00WjUmtCXsGbIA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eDLBKq4CzcQbenALcRpWRdqHCZoEiOZ3XnCFiBvhvZFNkyxNf4173ee+5JfUE1fN86O7ab6UUXAOOKuptk5CK/x+WRBRlprKZ6NePV9R8cOmdTN/wVpPlU1raEcCgULEGdTLyoleyy/sMnRAncU4t0m5TC6Tf5PgtUO96be3ySQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kV/0bGMC; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kV/0bGMC"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c937b5169cso1401979a12.1
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Nov 2024 01:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730972100; x=1731576900; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IN2DmLQ1o2SDyeRsGj1pPFvvBNQQ00WjUmtCXsGbIA8=;
        b=kV/0bGMC6d7L/Qxg1x9tFqhMi3/uzO9SFrKbAICivZsT0AlaIXhLf4kQ/RhA6gkF6I
         ff6rFa2exRzpbg4jsWucoWTZCo/MaYmD9qLwXKP54ypRcskX9xutlCx4WBXS1TYWjlJV
         hJMT6PFoBRPdAI2L3tkTNv4sLmfqhGGGI9+SwevIzvLti5A6z8M25FvAC1zoXdLAtDsD
         /r0rsmC+kdl+d0q26Pq2cvVXAq/nYnLJaYKxMxqUY2aWgW3ht6yOA1pQXuYnnHjkhEM8
         9OQE9wK+gcACjmnOU42RGgHlRqcMmA6YiTAhBm8e7XhTz1d4Ii3IjCPOSo4n8x852AEN
         c+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730972100; x=1731576900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IN2DmLQ1o2SDyeRsGj1pPFvvBNQQ00WjUmtCXsGbIA8=;
        b=K6boV6Yo7K86DiCTznbN7d5BBZW7k6wFSY5C4bFWL2UmevMmTAtR2+3NthnjXZ6gNd
         uE9cXlw7+uyUj4+XyPE6TQMc/7gSPRYP5lB7KKttSnMixxJnfKbDbjYHxfV8euhb4mbr
         ZnM0fAsrCq6ZpUOijKJGBBZgBNRxEfJEo/TV7BqCIWy3/f+6d7dTDBQAYuImsWSrGEJD
         SbUaOwH+N5Ot//myIfqH03c7FBMJpsRsNYDfp6Q6MZOKOFJhF1P9+Enc5HKulMHL2Bi/
         7M64eVGT1yIh/OhJKlvKa+Ys1aSf05uH3u/m9wwHBP1nN99kUHErmPO90ODZ3S4jr9ZM
         LIjg==
X-Forwarded-Encrypted: i=1; AJvYcCWG1ODA7UJnsLBESYrKl+kDNfCnn+qYzsTQPGzcEqnORNZVUhPZsjcLr2S9xuMnesek+4okxj4sRgqeWnELoM4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKpbxZLr5ruQAn+NeyoofdF4dV5Yt4AcEgFesiFj5DBf/wJPYk
	yK/GQ/BCrS+aR9KKI8SwSxR8YNFquk2Gr8hNPkynRkF3YT56z+WMwC+9iYXZPhhBdwQUgCADiFh
	YkfuXadcVdE/XwQtKxWnmIIT52me6xYlrn+3Y
X-Google-Smtp-Source: AGHT+IE47nVRQew3dIPy8uphshtnLRVAmJQxcNisdb+tz1uWuD9hBOnbkuCslIypfXnTLuIB1boVwF9r1HAlZ+e2M4k=
X-Received: by 2002:a05:6402:84c:b0:5cb:991d:c51e with SMTP id
 4fb4d7f45d1cf-5cf067f0552mr482331a12.15.1730972100287; Thu, 07 Nov 2024
 01:35:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-3-chia-yu.chang@nokia-bell-labs.com>
In-Reply-To: <20241105100647.117346-3-chia-yu.chang@nokia-bell-labs.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 7 Nov 2024 10:34:49 +0100
Message-ID: <CANn89iKUnrHuf=V8uYNU5jBy7=sQByH4B0hZ=c4+G3oZzF4BnA@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 02/13] tcp: create FLAG_TS_PROGRESS
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
> Whenever timestamp advances, it declares progress which
> can be used by the other parts of the stack to decide that
> the ACK is the most recent one seen so far.
>
> AccECN will use this flag when deciding whether to use the
> ACK to update AccECN state or not.
>
> Signed-off-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
