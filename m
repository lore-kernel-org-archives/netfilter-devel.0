Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E1926ACC
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Jun 2025 15:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750605600; cv=none; b=SFwNq2uCzf2s/X5QHy2YnKT/BuXOUNYWsvSttWoOUnuT5dOAIk0HwiwVbNm7A9K47f5cwk1lGB/OJTUVOC7vEKzrIiPFqNCf+WqTSnaGPj/OWz29l7hba5lgsXNekbk2P8yi5oBst4IDqSpa62S8JvrKSGNxwBl14uwS0wtsR7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750605600; c=relaxed/simple;
	bh=Fri17WEb7ASsJ04ppmlgKNtnJj3e0T2NKxCgzEsiY5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mg1Ft51MLJGyzaEoLNmowyRvUoWO7r7ofSsBfdSnIjcZs/mb6FqpXeYQK5pDIIFx5oa91r3g4+cJKNW6eSPU6E1sh7tx/9IMs++0kLaBifVOoBWcVWdCdeTprQRp+QeA2GgcUVQu7wBFl8Hi6rjA6eUTdbW12J4lGG26nJbw89o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gtKqjrgy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gtKqjrgy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750605596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ui17LHHqbs6BVPCX7Zo220AmgIy0ZRsASBcrCNm+cZc=;
	b=gtKqjrgyqdlyckokxV4NGmStDkAOI2+mY96bh9UZ72bGggDPYAXUD10gu88SuWsxxYVwG2
	2bcUNxJzKcXlHGOctE4hw6JUpjUj5W5v0QPiKjTl20IF3XXAbSXjdfl90I3IcfzrfiBbdX
	Rtn4Ar2kjLkoeLKWJp8LauM9JRNpuVM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-4xOyudOTNtW7GYIoTht4Ww-1; Sun, 22 Jun 2025 11:19:55 -0400
X-MC-Unique: 4xOyudOTNtW7GYIoTht4Ww-1
X-Mimecast-MFC-AGG-ID: 4xOyudOTNtW7GYIoTht4Ww_1750605594
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b26e33ae9d5so4052555a12.1
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Jun 2025 08:19:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750605593; x=1751210393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ui17LHHqbs6BVPCX7Zo220AmgIy0ZRsASBcrCNm+cZc=;
        b=sJRqeDfWri0eESQfr0AFUVW5mHfwiX8LGcugMjIGskG/NrEqCdJz1HjpMTTbMGU/cf
         0d6+r4CVMIxm+xhOCcYLcQn4kxxtfLrE7Yht/bJUvKh97xvwBKC8qMuR9hcVSRXCYtSq
         /wun1Cvok4WcjtlWxPYo+3JS3NB/k3c4dKpqAuQ+lVsTs9LGFOX+MLrsZeHFCmm33Qmq
         /w8mTVhuJQbzPJiLa2NBTlSU2Z/HfZa4r36ASFyzd68f9cQvpZtU7YO/0lsKHyS0Tet4
         1bKr4bT1z7HLw33jsTQpkaHYkkFswx8kFQbweHYk0olRlB12XQYQZot0qJDT+S4cx+FI
         2Msg==
X-Gm-Message-State: AOJu0Yw3GBpS2jL205ogC7hRyM5d2jg13mKtiII8ht3Bq9igFCXMXYUy
	+/2MFTGOOSSMw3mSv6PNgSm4cF4EgDHopb4JPgsrY7m63AWShrE9c8DSji98ihJBZgwrjsPu+S8
	cPuYmUjlmvmPARjCm2XsqBLbtwPsZOlRy8ikdlbFRK1fPwEwi2+eKWKnh5aFSR3Bni5oQ9YrWP5
	8uw83ClgOKWzZAeQAF3tEtmkSFj/N3CzWMCQdVy4LwmGzaOCWtBqnpgek9qA==
X-Gm-Gg: ASbGncuzovQdIRxpF1ybLc5528ttdvHCpvFnzPifEBIZoSr8/yNOHNjZHqyt+cDrYLO
	JHX0QEuC0OIZ7v7WnjxDGVVBV2uWXYpx4IrprChE22dkOwJN9tF+KlIh9FyJs9O+dFGuDFXtzzC
	EoXtXl
X-Received: by 2002:a17:90a:dfc8:b0:312:1508:fb4e with SMTP id 98e67ed59e1d1-3159d8c5dfcmr17931252a91.17.1750605593313;
        Sun, 22 Jun 2025 08:19:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcqeJtZu2OtM4S9SgmfZcivCMnTKVVPkwL9F3S2hqr1HewyfflRNqb7yKCH/z1n5czi8iM4kPZRn+wwAbOB/A=
X-Received: by 2002:a17:90a:dfc8:b0:312:1508:fb4e with SMTP id
 98e67ed59e1d1-3159d8c5dfcmr17931234a91.17.1750605592976; Sun, 22 Jun 2025
 08:19:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250622125554.4960-1-yiche@redhat.com> <20250622125554.4960-2-yiche@redhat.com>
 <20250622125554.4960-3-yiche@redhat.com> <aFgQreFzWJJlLVhU@strlen.de>
In-Reply-To: <aFgQreFzWJJlLVhU@strlen.de>
From: Yi Chen <yiche@redhat.com>
Date: Sun, 22 Jun 2025 23:19:26 +0800
X-Gm-Features: AX0GCFsKLeRqaPEKYM8mmcbwi7kdDDPL7PTznIEVNAJ_zsZWY-yeln5rygB63VI
Message-ID: <CAJsUoE1X4dUBZvjf9uKYq1S6_SN+vSahw4S-OTzR6V-sPFgbXg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] test: shell: Add wait_local_port_listen() helper
 to lib.sh
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you very much for your review and thoughtful guidance!

On Sun, Jun 22, 2025 at 10:18=E2=80=AFPM Florian Westphal <fw@strlen.de> wr=
ote:
>
> Yi Chen <yiche@redhat.com> wrote:
> >  ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /de=
v/null &
> >  pid=3D$!
> > +sleep 0.5
>
> You might want to add a wait_for_tcpdump_listen helper, that checks
> /proc/net/packet for tcpdump appearance, or /porc/$pid/fd/ for
> appearance of the packet socket.
>
> No need to resend and no need to work on this, just something to keep
> in mind of the future.
>
> I've applied all 4 patches and pushed them out, thanks for addressing
> all review comments.
>

