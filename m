Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B45225397
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 08:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752049294; cv=none; b=o2wBAH1dCmefrvs93PTVy1X3fcFgiytFuoJA1Zy/3vnEUl1G2CPDOt+aViE4MAQr/AYOIh52ExNeVm0mkt5ITTuSgumk7onKruYqxUF718Tb1S+t0j2SqvCKMazz1O9OSFyNmwPwUTxeP8P8szpvtv4THBd2M4YKfjz0ZdD2Wm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752049294; c=relaxed/simple;
	bh=ckyRm0enfVjmN+8bEXMCVszo05DaltDdfV8EKcYo2zU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KUuXbxDScWukWl5DzlRSQa/2/6k5NKiTx+dr2LtFqdM7Llb0I58Awp+BRsbnvPSKIbmto4PKnlb6NLu18J8QrMtB8JdH9HPb3CCksP9719hIaqFtA641L2VWwO39mE2VtJ+kya3GQN7X2UHJUAAwrHAZf5OMrS4D4b0dEAT2zYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=Io91Noim; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="Io91Noim"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-60867565fb5so8795961a12.3
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Jul 2025 01:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1752049291; x=1752654091; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=IIY1qdYnNRSWia/sQ0DcpA+sma7gafJUV5CauUUesdU=;
        b=Io91NoimUWJVbkuv8hdq5FGo5UogO4bsYktaXa9txZFS2RVZ/UgBAdBMfrDmb7YSfL
         lnRpsfPCSWgQd0RbsoDFAztN1UPcsZBjTEJT/22McpYb3LD0GsiACMWNpbfpGIEr4JnK
         eWG9g/pAmTH7Rog3xu1GuLh3Q36V8GRH7Le1Qi6UlYqtUYdOnjgGg356mtXOvMJBwDC0
         cTHn9IHqNGp9RWWhDI8fJ/vMe0WZ08P3ISZCRtWWdWu/wOhBMbla54qGQlgSIA0Jf6tZ
         bMOp/acMu0HUpEwqcLPD2z4hr/+6HfneyFRTSBCStRiumKiyt4fN/drMXaDJ+U7cyFH5
         ugDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752049291; x=1752654091;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IIY1qdYnNRSWia/sQ0DcpA+sma7gafJUV5CauUUesdU=;
        b=p5rT5Iihfw48VtN+QGfAmXAf3xxympYvf8txh8GYIAyRCdYcrMDiAi1ln9rU0MVS3t
         BD8FtPyZNl6rT3W6aa3jBeRz51ggJK89aSJXA4TllaoCokioJ60Lq/jDSMfkIESE+Aeu
         vfJUVfZmvyeUYTxxyeD6x6SHyLq/8Qn0xuIFCsPtNN037uScNM2d17EDaiDs/KWHBWYz
         IWaYdsUKDf+Ubjj++JDlzSu+5d637FtoxU+6FZ5kYpsMMZvSTz3F4/t1faVCWpzp3522
         RrXuDx83x2pRz723VNthNB2I+7P8HrfieIil0RKwGQgRJ9vNo6cm8q9ecTFCzEOiIgv7
         STkA==
X-Forwarded-Encrypted: i=1; AJvYcCXODUopA55DuYURTSZJGJHc6WGplOTdPRYjLUexLGSCiea7e7dsnr0AvY1PBCY3DRH7XnfWjhjG0D9ociNW7KU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx47/HIVlfew4w4aSyEi3meg+zLUUchqSL7ZXPvzWBTASuDKHze
	EgQGL3p04Dg45i622jV9m6y5zrzTsZUS5CDbSmP9a2lscrD+ByNKeWqo5vcIPHQzx0E=
X-Gm-Gg: ASbGncuDaqbAYuq3HpPOEXEqh6CCf1OtrLYbRBa/aqz8K38jfYRbykPy9Xs31Tvbw9C
	lmlmFtECeqafUogqMKkCifEf2GAAq1KGTKxRKDPWYmH8FvSVkYqjsRe9SQSKELDL3o4OPtNqine
	Pp0phGl/FCuAMeFNoncNLofkKaF6xS6FSOp4nBqaSuAvXZhQ23/JeavF95nJvO171Emu7wMhC8W
	Jcmt/1srK/AT1LKfKWwmlU+wTUUT2r0YnUP39mP5bWtz8NSgGAXK0W1L6jhIR35r0erxWrj9pVM
	kV6tcqe/XxZ+ieXqxaJwY9dVAoSgZo0C7ool203vAjw+aPZ1lyCtDdQ=
X-Google-Smtp-Source: AGHT+IGfHsYxZ/BQIrPnRIlZl++93uSpuvwPAd/R6OibEs4U8BXiJ1ECoDNeSW6UPcLJalW4MgZSaw==
X-Received: by 2002:a17:907:8694:b0:ae0:b46b:decd with SMTP id a640c23a62f3a-ae6cf7621e5mr183572366b.31.1752049291233;
        Wed, 09 Jul 2025 01:21:31 -0700 (PDT)
Received: from cloudflare.com ([2a09:bac5:5063:2432::39b:b0])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f66d91ffsm1061547466b.14.2025.07.09.01.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jul 2025 01:21:30 -0700 (PDT)
From: Jakub Sitnicki <jakub@cloudflare.com>
To: Tao Chen <chen.dylane@linux.dev>
Cc: daniel@iogearbox.net,  razor@blackwall.org,  andrew+netdev@lunn.ch,
  davem@davemloft.net,  edumazet@google.com,  kuba@kernel.org,
  pabeni@redhat.com,  ast@kernel.org,  andrii@kernel.org,
  martin.lau@linux.dev,  eddyz87@gmail.com,  song@kernel.org,
  yonghong.song@linux.dev,  john.fastabend@gmail.com,  kpsingh@kernel.org,
  sdf@fomichev.me,  haoluo@google.com,  jolsa@kernel.org,
  mattbobrowski@google.com,  rostedt@goodmis.org,  mhiramat@kernel.org,
  mathieu.desnoyers@efficios.com,  horms@kernel.org,  willemb@google.com,
  pablo@netfilter.org,  kadlec@netfilter.org,  hawk@kernel.org,
  bpf@vger.kernel.org,  netdev@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-trace-kernel@vger.kernel.org,
  netfilter-devel@vger.kernel.org,  coreteam@netfilter.org
Subject: Re: [PATCH bpf-next v3 5/7] bpf: Remove attach_type in bpf_netns_link
In-Reply-To: <20250709030802.850175-6-chen.dylane@linux.dev> (Tao Chen's
	message of "Wed, 9 Jul 2025 11:08:00 +0800")
References: <20250709030802.850175-1-chen.dylane@linux.dev>
	<20250709030802.850175-6-chen.dylane@linux.dev>
Date: Wed, 09 Jul 2025 10:21:29 +0200
Message-ID: <874ivlg4fq.fsf@cloudflare.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Jul 09, 2025 at 11:08 AM +08, Tao Chen wrote:
> Use attach_type in bpf_link, and remove it in bpf_netns_link.
>
> Acked-by: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Tao Chen <chen.dylane@linux.dev>
> ---
>  kernel/bpf/net_namespace.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
> index 63702c86275..6d27bd97c95 100644
> --- a/kernel/bpf/net_namespace.c
> +++ b/kernel/bpf/net_namespace.c
> @@ -11,7 +11,6 @@
>  
>  struct bpf_netns_link {
>  	struct bpf_link	link;
> -	enum bpf_attach_type type;
>  	enum netns_bpf_attach_type netns_type;
>  
>  	/* We don't hold a ref to net in order to auto-detach the link

Nit: Doesn't that create a hole? Maybe move netns_type to the end.

[...]
