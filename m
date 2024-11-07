Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E821E1A25
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 10:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730974816; cv=none; b=kmvq6JcqDhDJl70i4Pk/uq5wAV8COA3CekFXU95HZiaM/VUJaGephVVeI6Gz7v+Z6NH7pXolMmXClGicK79Ecbp0D144MrPR1qdB8ohhOTQw42Y45PE6xNdCs77Su3CAWVkN2ef4XvbYkTAVKH2Fy4jdz0E1fV87xHp0gYtFhqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730974816; c=relaxed/simple;
	bh=bUxECVvtmUIJzXf5AGWp9FhEUdjGnW1lzOApTrKw1zo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AWCb5BjZ3zVOYFYiLux7sTV8IOJCgflUK2voApzqXmZ0Ec0CKvrR/W+Cm1OW3mA/8vQhWslvtzK1Lhy1OkKl1BkUQ6PvLJaRNmAAzYZmzU/l/RMRU3MQL3HqFYhE8qQaPhIq4vpa/SRPsmK+Q5yL+n2+PpYVjhR7DGcwAc7hUS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KDxG3uPC; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KDxG3uPC"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c9454f3bfaso947221a12.2
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Nov 2024 02:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730974813; x=1731579613; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FYkYxsCTkmOBoiYKXh4ZEjpdsXpKEPnOsWN6My0/IN8=;
        b=KDxG3uPCQBtQP6pyIiemjLfQFKi51+a9g45kJykQ1M7qqHDBz/LoDllMnRWp6uxUh7
         wQmNH9/wAZIHCXhnchzmn1bVHWORSRZ+oHo6h6r/PvfQim5DYQM6/4GFJMb6tOOscX91
         pkjoqa+An9CiAql8UETuclxiXpsTN1ZtSGQv8HeBzIlgsyvQL49Re6qL7Zsv2l9c7F7W
         ynmPPC59VRe1SCavxIHB/PEM7hfMDRDU3GX7th75mMjDJm5zvg9+E0pnyypsibGETjur
         uFdfpmJAUjKnCe7T/k2fxNcrF/Jo1t/PQOFSWJeyS41l+awUmfwTLrNdIfhNRfVGLAoa
         xosQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730974813; x=1731579613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYkYxsCTkmOBoiYKXh4ZEjpdsXpKEPnOsWN6My0/IN8=;
        b=H9etCYTs0IQZB80Y6eZ0PSQ7B2+Ksyo6yjRJGKfxmV9ydj2BeXoCley8FmNsqXpkfK
         5tx/f//v4sv/VccUA5WcOXFgpUuItYWAcuu71bIDY2sRrkqJd9ziHrwfk1U9QhmDC24n
         7LVbSx4SgVRnF1j87oDx+xYbd0s/O9n6Q+EfpocVZl7XMTNTOZWeYjuWthx/U8S+Pd2Y
         fOHC/xbIXJOcPBxtQ7Qt/WuTwQV9kGOIkyYscc3HXSyhLDbWJG9DM2NHIrzvpBJkjMQ9
         G9nb6Dw7horjazhdz9n5uiB8ZkTBg5d9q/ock3drDcDYHP1ebQlKQ0KLR4ysoJmcNY6E
         Ui1Q==
X-Forwarded-Encrypted: i=1; AJvYcCX9O2LcM0i+04WnO0biCpakEotc8F3RzQMHgfzQdeLnimFjsKAc8NpuIcSrxWnjxY2uep499N6jteFMGr4XZTA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhQT9xw/9+VbRSeGjiueeJm8P25c6cX2JaC8OhUOzt8gjqF01w
	K6nHPTqi60PIUvJv/NmxMGGvSo2PqqDZy+GtVP4sH29aW9r5xQ5fqYEC0vEKgJbb/eoUIOMntsa
	umL2zMp1c52u9B5GAHKEhI/jkYL736LiOlsxN
X-Google-Smtp-Source: AGHT+IEU7BzKwJ7pIKK0HTYYkeJhG9pSpe6xSVtPpm7vbqKR9LQ1JnPQTbahhd3bffBAr5k3cN7r3J7YdMHmn1Qs1UE=
X-Received: by 2002:a05:6402:84f:b0:5ce:c7ca:70ca with SMTP id
 4fb4d7f45d1cf-5cec7ca71a0mr14020115a12.34.1730974813080; Thu, 07 Nov 2024
 02:20:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-4-chia-yu.chang@nokia-bell-labs.com>
In-Reply-To: <20241105100647.117346-4-chia-yu.chang@nokia-bell-labs.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 7 Nov 2024 11:20:01 +0100
Message-ID: <CANn89iJiaAuuHntM2j-FvtbM+g90GHft5BgaNxOZ58jkpzP3UQ@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 03/13] tcp: use BIT() macro in include/net/tcp.h
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
> From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
>
> Use BIT() macro for TCP flags field and TCP congestion control
> flags that will be used by the congestion control algorithm.
>
> No functional changes.
>
> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
> Reviewed-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> ---
>  include/net/tcp.h | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)


Reviewed-by: Eric Dumazet <edumazet@google.com>
