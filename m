Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C412C17B6
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 12:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761222500; cv=none; b=VfBs09QbngxVDn2DGi22vGJpLApGuR8xrI5wzfw4miuy3lMDYSXQjjD0lkLBdOaLZ0bKdRlJHu5CJZMrFZEpJrBJLkab8nehAEqRjhvuOzMTrMcEqTGzlRsVvJRtQN3d8kSE3roS8/g6bOCrFK6cokY6Lkino5hD5D/ht0H2XK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761222500; c=relaxed/simple;
	bh=NRuEiGlR1P7yV/PP+dLzB7hBSKXtU0GCDSnidNKRMNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X7sRgFUPIDuRGaLqSfOUE7FqT60dsczGVwdojgcOZSI5ROThy1K0KQbBJ8WlJxvRw8OjQZQO9YLSpDv6YAX+KtLfYTfP6bmf+NF5YtUKRTEGZaI20nYpG9U1m5zEJVEd6qayjkuHtdYaUKaaVEjudAhpvaugtEixkHT842tkgy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=bbtY+p9Q; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="bbtY+p9Q"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-7817c2d909cso8437157b3.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 05:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1761222498; x=1761827298; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NRuEiGlR1P7yV/PP+dLzB7hBSKXtU0GCDSnidNKRMNs=;
        b=bbtY+p9Qq5lccw1lrW2Zhz115uH37ukbn9sKwqBv8MLeogoWgB7AadXOH7agN4VapP
         OYxBz6EUx/xth5Rv4tDLM6Z0vVB7dg9Jz6S+Y/tiyFhsszcz6972jlPI73ht/Zq9AcdA
         NM6tnVh2aUC0gHFjuM36ZeOK1V2lbZ6fGtvza71MpQs6rTFaslITLCdv6zbqz5FwVIJS
         +cfE4uh1LOIjBec5xhX5kave/wi1N/6fcRqr1hpDRvdSk9ZkBwA7diE8LJJD3Yi+uxdR
         zyUw2OUwHs2fDoSllsdJht0snufbZr1OJZnJ1jf2+D0O6ctH74vMPabmDgS2ioHm0/Cn
         D0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761222498; x=1761827298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NRuEiGlR1P7yV/PP+dLzB7hBSKXtU0GCDSnidNKRMNs=;
        b=D/UF+9UA9nei7Oh6l6nbRbScI2IVWhqs8E85PwV1B9zQeY7lGafmyalWznCuxkIufB
         fiePDTUj8j5LDLvs59xszeFJcvMQ6UQoGu8mk8z4Blu83NZJKdn8kN0HRYQ3WC/Hkedc
         xTu8gxM+CyDb2ERevyeklKDVgAh42JLcKAtvaDBiSgKOWxf5QG1EwHXCLOsnRr0dkXPG
         vJf70zkTo5eNDKKo2lzmwsrHnwrPSNqvbVRLE4uk7Mxeynsj1Yopq2BePfLsqjP81rZ/
         ZjS/3JjZgHbE7Hgp4g7x6TVr7BsJJ1fIbjwHYHZcS3iVMCs9BjjaDO2rbWk0NBco91OM
         VpJA==
X-Forwarded-Encrypted: i=1; AJvYcCXcLbTPbJ/WxpZ5s/WtVzPRUoTAAXDgjkNh54kNkdxOWwiJtS9Npj7ndv1Ys+5c79rEXquz+SM1PauTdjXlu7M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+JotexXZltc4w1YApczTIhJhavjTvFxVM5KdXmmdUIhVgt0Rs
	C2+L/JBVnZ12lWPq594QN2oCZxnsS2SnP5p6A79nVxw/T8dcjcIDfGym0jAfJrhcW2f6gjuEYXn
	qPoQEnSwrjy336j4OR+ltqIZtpqgGOPSkFEXBDdwlvA==
X-Gm-Gg: ASbGncucP09GdiviVyROesaOevQDALudfA+W/SI6Vew4n8cg5nImYBHob/i4HeWprVJ
	Q/2EhIomciC7/FtfHZWIotwzCEH0oBhkBb3S3hkeISQcVxBeW1iOWUcPM1oNSPfUY9xc3y49mWZ
	4TomL0JmvhvsSECe9j03PQv3/DkdPKk08ywrKfbUwmS6Qlkw2n3WLXYhdlz8k8ZJkeX07oa1qEF
	QAOy71wzz+3z1C5V4daObAxD94iIxopkHeJ9fXhgyAIW65dpnkdKKII07bfchHzdsUFPDQo
X-Google-Smtp-Source: AGHT+IHPdOwhOaGe9iCo/jmJBjE5mGyJmdeKgFJXCNxjw25XlX18zDCJznwpoZz2/B7vt5wZIicUgZEuvLAzx18kSkA=
X-Received: by 2002:a05:690c:600f:b0:721:6b2e:a08a with SMTP id
 00721157ae682-7836d2d6737mr364106547b3.37.1761222498021; Thu, 23 Oct 2025
 05:28:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251021133918.500380-1-a.melnychenko@vyos.io>
 <20251021133918.500380-2-a.melnychenko@vyos.io> <aPeZ_4bano8JJigk@strlen.de>
 <aPghQ2-QVkeNgib1@calendula> <aPi8h_Ervgips4X4@strlen.de> <CANhDHd_iPWgSuxi-6EVWE2HVbFUKqfuGoo-p_vcZgNst=RSqCA@mail.gmail.com>
In-Reply-To: <CANhDHd_iPWgSuxi-6EVWE2HVbFUKqfuGoo-p_vcZgNst=RSqCA@mail.gmail.com>
From: Andrii Melnychenko <a.melnychenko@vyos.io>
Date: Thu, 23 Oct 2025 14:28:06 +0200
X-Gm-Features: AS18NWCPma5wE5y2xe9JBDWGT4k5clLS_A4FnlSPmz2JjrF1PCHSnh_T4kzSeHM
Message-ID: <CANhDHd_xhYxWOzGxmumnUk1f6gSWZYCahg0so+AzOE3i12bL9A@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] nft_ct: Added nfct_seqadj_ext_add() for NAT'ed conntrack.
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@netfilter.org, phil@nwl.cc, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

I've taken a look at the `nat_ftp` test from nftables. It actually
passes fine, I've tried to modify the test, add IPv4 and force
PASV/PORT mode - everything works.
Currently, I'm studying the difference between NFT rulesets.
Primarily, I'm testing on 2 kernels: 6.6.108 and 6.14.0-33.


On Wed, Oct 22, 2025 at 3:01=E2=80=AFPM Andrii Melnychenko
<a.melnychenko@vyos.io> wrote:
>
> Hi all,
>
> > BTW, this fixes DNAT case, but SNAT case is still broken because flag
> > is set at a later stage, right?
>
> I've checked SNAT with the "PORT" FTP command - didn't reproduce the bug.
> I assume that `nft_nat_eval()` -> `nf_nat_setup_info()` sets up seqadj
> for the SNAT case.



--=20

Andrii Melnychenko

Phone +1 844 980 2188

Email a.melnychenko@vyos.io

Website vyos.io

linkedin.com/company/vyos

vyosofficial

x.com/vyos_dev

reddit.com/r/vyos/

youtube.com/@VyOSPlatform

Subscribe to Our Blog Keep up with VyOS
