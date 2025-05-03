Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1926E38382;
	Sat,  3 May 2025 02:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746239259; cv=none; b=t/V9rrj6AN+7nDxbGqlAFnl3i1LTS+kNTMCEYZxKeyyLDf7gdYtrNdHn/zIBq5zV+Sx1HlW+BI+d/cK52tUdS05wDbF8/mr4Vl819n3hFzV2Tj4xKb6SR/jKHi3RhoeIohP2eSMDtB59WgwRg6W7WEBUSo0FF3ec76DHnBfaIro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746239259; c=relaxed/simple;
	bh=B+kv+itT1CshbsvpuR0NGbgTA2q00d/B2Y7LcG8e4xQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rbyUMNnf/d2dR12QmSmoSXE79jKbOwEOBOxE2R4m0NFAVEDBKclEGURjrSLgrg6QhMH+jW4gc+ymMgOORVKXXdj15sCyaw8YOOYjDBMgKPai4nmMm1VK9+fzEt5nRD6dk1egmMB8+44vGNXrIslEmiDIolOYTagXi4oMhBP8i5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gKgtdrAu; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gKgtdrAu"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5259327a937so717132e0c.0;
        Fri, 02 May 2025 19:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746239257; x=1746844057; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B+kv+itT1CshbsvpuR0NGbgTA2q00d/B2Y7LcG8e4xQ=;
        b=gKgtdrAuUb+zqUsmgAP1L+WNYBgp4YV2Dzei3BkO4uu+lejmKYrmsshe8YBIL8ZzFN
         Cmq8x3FJkHfLH1avo2yyG6/dZOTQgW0yG8jo5chPWd1l81UXp0M4NGN+nJN3XKx4lKX1
         kPGsj2FfHLQTAwg84GgA2emztOlEKIEe7PPuJvJ0w1rMWjtVOPjiyUVHLgzs1jor6n8P
         roKFQ5E5y3Wyf65DxrTTxjBwoRGfT2MauZRqZEopqFwwaVsXHQjcs5kq9x5GDvkZzCv8
         MG2a6zjYZbwLLsqr2daHYiR8qOGR0CE72pYj3jURtpZqAWyRLTtG01AeBvaPM5az8q9W
         obGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746239257; x=1746844057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B+kv+itT1CshbsvpuR0NGbgTA2q00d/B2Y7LcG8e4xQ=;
        b=AKUzN1P4RfPyWPA7K2f5PyvWTG+FTVPqwW1hIXP+K+vUokro95PABHLo0KIKR7LrDw
         5/GEnfPh1vFIq2HjoiEkrtPC8j6kxf56fv04xJqxtOeZoqEzN4vnl/IpzCfnIx1nd+ly
         lSvfJIf6RvGHmAAJEVTAG6Khrmn5TlIhlfUk4KjofJhLd3nPIJiEZd2U5GfylTYTtTt+
         msKHZnpuKqTCpVk530ujMpob1c8PPooIj4oi5ncvzX1OEoC8sI4LNLORQD++NoVmJXUK
         jcfIsPmRiP+/aroFtWrq48J0DqTjlSONAg+tb/snVpaC9PLYpf/557CQForJg6z+UU/G
         2XOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUp/bdUmFFopQCnL1rUbYyc4p5Mu28sSbUHBDLOHkB4f4KtxAeXYXl3ZZ9CQccauV+4mH7KapEL5N6Xz9o6zg2v@vger.kernel.org, AJvYcCV90v115iISgFXtnboMRwj2cidbcvNau0vAUEtBE1Yq4uPlrl/CvqoxEdqbyntlLhjrqXZMy95PEnMGP6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMiV8/LBLWcHPq2GFzugi2xDlqPPwtWzX2CzS+L7RlVHVFhbeo
	0yaWj2jCpnaEshgQD9v+jVFGmTZt2rKlg93gRVpNNTSN13bkPiE2XbG1i4h4o8mFkuO5xJ5W+ib
	ES8YtOJR32H2Hxr/ByT8PgxGJq3xt5w==
X-Gm-Gg: ASbGncv3O6MNvG9AlecMkWY59A8hqB11QttSW1xDiZZjdkSZSPCLhV5ysXW4EWxJMtQ
	cVjzSShuCuG7OP9WYQ0hLKb57Vc9eq79/Q/dcFTXmkUUrgTdtyzYM79B+ee644qP/SbNwa/3sai
	zJjDraljoJhbuHttvK2VY+hzg=
X-Google-Smtp-Source: AGHT+IFUBR1h6bKNYRwWrsKI1kDj3COpn2Z8/jkLaCy2QYOeeAkJnWsHzRLQeRiZL8otyCs/jz35vRH8AExQnNEMCXg=
X-Received: by 2002:a05:6122:1814:b0:50d:a31c:678c with SMTP id
 71dfb90a1353d-52afd2af9bfmr597295e0c.2.1746239256734; Fri, 02 May 2025
 19:27:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430071140.GA29525@breakpoint.cc> <20250430072810.63169-1-vimal.agrawal@sophos.com>
 <20250430075711.GA30698@breakpoint.cc>
In-Reply-To: <20250430075711.GA30698@breakpoint.cc>
From: Vimal Agrawal <avimalin@gmail.com>
Date: Sat, 3 May 2025 07:57:25 +0530
X-Gm-Features: ATxdqUHurII3h99Z3uDYEDq8BOYvuwUe-h9vQBOmYUO83Tq5Bq1CwXZ5yFeb9AM
Message-ID: <CALkUMdQ4LjMXTgz_OB+=9Gu13L8qKN++5v6kQtWH6x89-N4jbA@mail.gmail.com>
Subject: Re: [PATCH v3] nf_conntrack: sysctl: expose gc worker scan interval
 via sysctl
To: Florian Westphal <fw@strlen.de>
Cc: vimal.agrawal@sophos.com, linux-kernel@vger.kernel.org, 
	pablo@netfilter.org, netfilter-devel@vger.kernel.org, 
	anirudh.gupta@sophos.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Florian for the suggestions and comments.

Hi Pablo, netfilter-devel,
Could you also please review the patch and let me know if you have any comm=
ent/s

Thanks,
Vimal

On Wed, Apr 30, 2025 at 1:27=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> avimalin@gmail.com <avimalin@gmail.com> wrote:
> > From: Vimal Agrawal <vimal.agrawal@sophos.com>
> >
> > Default initial gc scan interval of 60 secs is too long for system
> > with low number of conntracks causing delay in conntrack deletion.
> > It is affecting userspace which are replying on timely arrival of
> > conntrack destroy event. So it is better that this is controlled
> > through sysctl
>
> Acked-by: Florian Westphal <fw@strlen.de>
>
