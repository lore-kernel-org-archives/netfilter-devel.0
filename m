Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DD13D3488
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 12:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770294235; cv=pass; b=OS7eFZzXJ9VBbwCriakOvsk8lDrR9MnGx26jFk6o066Ooi9+e94NCXB6M7RNxFVdmka86vXoZSK/yYAOBYarILYQsb5eux3l4/PoHtSeG9yPbxN5V3PyQSW+q7Ap2bYTqu3KUntMsdw3tDIkqgPubChAJa/0kq6r2byxr7iCspU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770294235; c=relaxed/simple;
	bh=O9sIjWKgRixXEtdvd6AtajZi7D+wByC4tYSI0a52pSc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l+Vuov2XpUTCQuqP56KJZGWOQXTupiLHN+vF65QBevaAKEn2F8RHzmN9L2K3sGeh6TgYQvInpyejAJL7DtnJZyzoLGDJmBhPbxf4At8ni7Y/AEYG4C6bvALGTBhTOFoK2GD4CileTCrIQa5dCzDGoyRWRrxY5zr9R9ft0KvV3xE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mMA5v3YM; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mMA5v3YM"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-649e97f1e99so700280d50.2
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Feb 2026 04:23:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770294234; cv=none;
        d=google.com; s=arc-20240605;
        b=AmyeW/8bbvUOYCIdDcsVLVQpU5m5oyo178E6ZF7eKFRzQoXjHadHGp4cxCVwCIdkb/
         zhksdbUxI1rqhMNl51sGEnMmxXv5iGvkiWWhdEUidXU/lLMUMSO+THxuoR51JEK2WPfC
         2lRcKwNNSvQy6VtA8m/AJJqqn1fDWeyhvM9vRu3767AYqsqS+J5K0TJHafKvOzCFttYI
         135XPP6U3rycpm2du0PPwtJNokTpPjwko5B4ol9T2m0IwZ1JxLz2l00bgNAB+Iwlce82
         QTLwN/XdVdvWeArn1XNt3qKT+W/EX2dvyfFlPAQJzXbu9WTHsXHKI676FR2wIXX3HaA3
         y5KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xuLdfS3PfDrpe6Ag0ImxrWBPON+V1ycwunsX1i7QOX8=;
        fh=Xi1nH7avnIu9wNLOM4eFUJun09id6WGR95/OrwpPF9Q=;
        b=kUJ7l6ES/dZK3mfELsQtq461wEFohh+VcUDe9daBQSlvx5xlkJXW4Ao1ESQJdrm0EU
         9pnPq79bL4T+XreVPOEznn0mm2ssWbyVau7AUbUUJ4mwIzpDVT+bWYo6JsE614H1Yxnk
         97vYyqGey9SkDTHD4w0PI6nZUEz+1Vupy066LhM3htZuIvyCOaRL+tiU03mQvkUKb3HA
         /OJtdLIrBp77J6JHE4Eqcu5j/bZ90UBP3cbH6WC4kPLRzxlzQmS99YWh+J3Syoog/aNw
         TmTbhURwe6GB4qKxxl5xP1F6772KJ2o8PUysszHcnVGtz+BDgDD7ZsqvRUJqEycrD3lc
         I1uw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770294234; x=1770899034; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xuLdfS3PfDrpe6Ag0ImxrWBPON+V1ycwunsX1i7QOX8=;
        b=mMA5v3YM8LeTm32ARtTUyykq6EXsQxUgRF9L3puI1SKBGIo27vMkcAKDJERI4Ouqon
         AOouTZnPiS0FylcfP42D3nbGssdvfUsRcL+IlWsKO7MV6VlAp4nIOC5E8W9JxYFILtVg
         O/7LyWiEmFoaRJOZ6SYiguJZxPjSxZxg3PsrD4Y7kJAHkWOvTTPPLFgH1Zc0JrzZYDEn
         47vJMrVGfiwdvSBTPG9W8BvkZcrOiF0LfZWp76QpL0gJ/K4RVPmTF8Ra/CG0Y329Cu61
         +Ndk1Qdm7OM+EaWKV/zKf1d3H2wAgPoB3249fLezBK2e7/zx7MhXB0QXo3kFknzZ9iI/
         inzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770294234; x=1770899034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xuLdfS3PfDrpe6Ag0ImxrWBPON+V1ycwunsX1i7QOX8=;
        b=WCo5IeugTCQWV4yU3welK/FOSKN0CPeedlui+9s97pUsbO8w7jlJibCv3g9sRRaHup
         sNXPAqMNzifHhSTEoqvWepeCrhwOmA733FILBlb/JXLi+YoaYwnGLI92YsG1HZzSfPCu
         Ao5iVlLKBE8kXWY9rnVZ0jn+IIgypqBOqkm/fp+UWHfEUyzZVhewReCWOiQfn/Zj3JuA
         Spysu3RJKzV+YG8yJbyXBEDKdqVz8bhidhOaaZScnVH2i6NmSnd6VNIptZ9B832T+fBj
         y2EKoTVeIeAk+nygvnV811Ob7iJCBeGsxifXYAQnelYtioGtM49Rn7J9B4+qlnNc88KT
         HlAw==
X-Forwarded-Encrypted: i=1; AJvYcCXk8HTzjX6zCEJ5ytlq/l3qRHFEzVvq1wV8xg+qZOqhpzjL2ARKl9xO4DG4uXttntY6QrGLZBbukhWuSy7RYb0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxELli1FbQ2USI+r5UHUjiLbgDN0mNHfS5ap2+3jD3GPXa+0LIr
	YptPL4jCILI+UMUxGJoBP6j5SjJ+q0AriQmSut/sThoQqryfJWyKibdtKYqUpVdf89pTrbToJRN
	FvtEo0Jm2tVZRW6stGa7FtnWu5WIIHHQ=
X-Gm-Gg: AZuq6aLkGjxdiipliFTdX/YBDRFnANxDEnb2oF4wUURZ/1krWg6pvNs7rhX+IJfnCe4
	/x7wNSWWaQlNR/M99/2U0dbcdR2oDPHZcJaW4Scx9ZbkptqeWwGC9ZuYuEH23MR2n15XsRsOYvd
	O9oFITgQqwMq+ZCgBm+uGffWAXyxUkGXI/rhgmk2d7I4q945ybBRoq6wiayKjXwK+c/pNKM9S8S
	7TAHS5ng+zunYpQgpQk26FeALyAwtmX1OxeL1EQDQbBgA3pbA3qVb1TdD/5Yks0e/iRxXUI
X-Received: by 2002:a05:690e:24dc:b0:649:bbf4:121b with SMTP id
 956f58d0204a3-649db333e19mr3694664d50.2.1770294234551; Thu, 05 Feb 2026
 04:23:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aYM6Wr7D4-7VvbX6@strlen.de> <20260204153812.739799-1-sun.jian.kdev@gmail.com>
 <20260204153812.739799-3-sun.jian.kdev@gmail.com> <aYRqOW_kWlfcEtWM@strlen.de>
In-Reply-To: <aYRqOW_kWlfcEtWM@strlen.de>
From: sun jian <sun.jian.kdev@gmail.com>
Date: Thu, 5 Feb 2026 20:23:44 +0800
X-Gm-Features: AZwV_QhCD0WB1XS3ICT6RUjv7g9LVF7DCnaxHjbOgv06s3aqLCZ9fvImeQd-Cec
Message-ID: <CABFUUZEF3w48iehUyx2Mcxwi0K6qNEja=7f1P6n1gq=AGv=daQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] netfilter: ftp: annotate nf_nat_ftp_hook with __rcu
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2026 at 6:00=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Sun Jian <sun.jian.kdev@gmail.com> wrote:
>
> Patch 1 re-indents, the rest doesn't.
>
> > diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntr=
ack_ftp.c
> CHECK: Alignment should match open parenthesis
> #135: FILE: net/netfilter/nf_conntrack_ftp.c:47:
> +unsigned int (__rcu *nf_nat_ftp_hook)(struct sk_buff *skb,
>                                 enum ip_conntrack_info ctinfo,
>
> Please re-indent in .c and check that checkpatch.pl doesn't complain.
>
> Also, no need to send this in multiple patches, its one logical
> annotation change.

Ack. I'll squash these into a single patch and fix the alignment issues.
v5 is coming soon.

Regards,
sun jian
