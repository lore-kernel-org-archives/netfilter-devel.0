Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4A520D4F0
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 12:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730983323; cv=none; b=Gbv5XjQrwM0OPIQG8tRo4PykeuAIvv7noLaPR8KkGdjg3h/TIdoewrk+twgTDpl4PdXM9Gui67QlwyNTM7NznFErOC4iwxvyN/svKt4a7MzIkX4yZZMndz7M0MR8WuLiyvv6NlmTbr8Qa/rJcfyRtrM/mUcEcNhffUlDddU8KYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730983323; c=relaxed/simple;
	bh=eszVer7v5MZOo9DIIYGY54udjtPIR+aDB9DkBBxxPlE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UMGO2zB1HP2H3MGVSq7iydk75qNx1URjC5wp5VDW9va39nlI9f7cvdgiYOpKc35vLhvyRCSXAPLDxCp6HaZReDgfjfxYxjHTrjPLLCnKwY6QXBd5v2p2PVQEgfnbF0+mXUwFwjCOYdJGkQPod/9J5u3TwcR8Pp4zNLt+mwYLEDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BM/02SW9; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BM/02SW9"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c9693dc739so1279788a12.3
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Nov 2024 04:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730983320; x=1731588120; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eszVer7v5MZOo9DIIYGY54udjtPIR+aDB9DkBBxxPlE=;
        b=BM/02SW9Q2TWDfyfzNzCko0eNNQs6Ze6FC8cafjxc7/gZecBTnhXIiPK9nGCxWWscC
         eSp8zmFzlMrZIALbYnJSkiq5xV99Ybq8FDzgrMt8C+KacD7rvBx3UZewczDPyGT7PPmU
         X3IeN9FxrHXV2TGIqP7ulim2QZTUa/fUJN8HtGqmuYHbt7Hv7yQq7d8TW690UyqYpVVZ
         oLNAtCWXlRITPFproY0VI+bJ0/u2EiW1psDgnb+iyOG/CDrDCN6teqUWqFjLUzTYgbeW
         X8iWG8ig/O7iB7haw7thlzr7AJFm71/toPU/6fgYJNEoFkIG/vTV2pj0tMYpxvg+SlAV
         5tAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730983320; x=1731588120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eszVer7v5MZOo9DIIYGY54udjtPIR+aDB9DkBBxxPlE=;
        b=tHqdKcyVmOjogdN4YA83gyYOiDQJFMvlU6EpHBy6PDDFD5Fc2JShlwEi+xrBY9u6YK
         CKacfLm/bHs5jSM3kXtfTQfxMeRIu+FyUTOmu/GB1o+DRZ39knnD0efNVL1lDSZXWVKV
         Rpp3WRjdGX8sTMnAFfQ1u0TDCz3nXeIhxW3M5ngL3XYYcyy3v4RGCCJSDWJJdd4u89Vt
         hrXkJQrq8uog8HWlvVCZd8gEIIrLCUx2oBLkC2AHVpnGnkIPCYwQNMwDjw4oo4aFQeA1
         pBxFYKaz3d9T0+PS9aznhc/M3FvEctS4kGErsouY5/0h7PggGw3mLdKo16E7z8xF+f5f
         zGrQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5Dk3va9VE2ffuj1UQ1wEKr8plopQdb70LsDJhplVzMeDEtH+jKHpj0SRpeb81d0sq3biexVZiIxKtnyWrYtQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/21RBRCHh/fHXgHhh+ljKt1bimPgthvZ66CmI/mWpBpuVuSCc
	AV/XifFv9zm+uPOpj0HOFnIdUNDGz47Pax9WpGEi6nfbldJWOsIO+XaMN6BxwCG/o7XVa01Q/Ts
	VlDQg8bUDukQo7g2isIBDTLxVrnyFU7vOJ9LP
X-Google-Smtp-Source: AGHT+IEL7BA48iGiB0onh6CZQgBTepxdP23ToRimZkZPRQGzqbCFprp2kxPExb0PKC2m/vGnut0zUfqphh494iJlqjI=
X-Received: by 2002:a05:6402:d0e:b0:5c9:76f3:7d46 with SMTP id
 4fb4d7f45d1cf-5ceb928c9damr15768331a12.21.1730983320099; Thu, 07 Nov 2024
 04:42:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-9-chia-yu.chang@nokia-bell-labs.com>
In-Reply-To: <20241105100647.117346-9-chia-yu.chang@nokia-bell-labs.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 7 Nov 2024 13:41:48 +0100
Message-ID: <CANn89i+wgm3DQafFygTQgqwX8p7AGmrBz1b0nocejrw-=xnhDQ@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 08/13] gso: AccECN support
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
> Handling the CWR flag differs between RFC 3168 ECN and AccECN.
> With RFC 3168 ECN aware TSO (NETIF_F_TSO_ECN) CWR flag is cleared
> starting from 2nd segment which is incompatible how AccECN handles
> the CWR flag. Such super-segments are indicated by SKB_GSO_TCP_ECN.
> With AccECN, CWR flag (or more accurately, the ACE field that also
> includes ECE & AE flags) changes only when new packet(s) with CE
> mark arrives so the flag should not be changed within a super-skb.
> The new skb/feature flags are necessary to prevent such TSO engines
> corrupting AccECN ACE counters by clearing the CWR flag (if the
> CWR handling feature cannot be turned off).
>
> If NIC is completely unaware of RFC3168 ECN (doesn't support
> NETIF_F_TSO_ECN) or its TSO engine can be set to not touch CWR flag
> despite supporting also NETIF_F_TSO_ECN, TSO could be safely used
> with AccECN on such NIC. This should be evaluated per NIC basis
> (not done in this patch series for any NICs).
>
> For the cases, where TSO cannot keep its hands off the CWR flag,
> a GSO fallback is provided by this patch.
>
> Signed-off-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
