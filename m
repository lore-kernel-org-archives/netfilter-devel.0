Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AE0233707
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 11:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754566567; cv=none; b=tRgPG6VPyZQt0uQKo1KgIiXSyOHE5saG/9qPnDrxwNcYzunmhFtr6mz3b9Z3Exw31u9zsTPxnqDNFKScFfn5dbODlR4CB+9od/XKkqOsyZi4t8ureCiQ1PpYTBIRhn4XnXDA9xQrDs/OQ4DUInzr+2+702wkbrImEyJfYPox1IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754566567; c=relaxed/simple;
	bh=rINS/1oBgFK82gTJZ3TSjDbuZA0dUTDcTbyacL5IJ30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VFkIrmEtr9Nv54YmqXKM2kQUBSY0kOFJMKh2KwADLjQKyThIYTQvZMknOM89/UnTa+GiRj/musNd5RUG643467W/UwnLQ7UF260vVU4fBav5t3DQUadgUECLhIEN0C9Bed/MKm5YJuacOPZ29UcxcFQl5RaSwzyILw7MpYhedME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BuQNwabu; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BuQNwabu"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b06d162789so9693371cf.2
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Aug 2025 04:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754566565; x=1755171365; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rINS/1oBgFK82gTJZ3TSjDbuZA0dUTDcTbyacL5IJ30=;
        b=BuQNwabuuyQBn3d7E38XB+/Emgwen3zGwf4gvwkunelyO2tLKK1LSabhzzR/Q6+QxS
         Wvr+q1bVGR1c5bbUUlWcQdS95mG/PYNCBH/rF05HKWeJtLkocNocsJZtIHl0+Z39sPBN
         t2t5PtxI06+PRVJ6BtXFKIjN7aqNEgx1rvz7vOj1JHhQlD28KM/1p1BIteHZn8hMoHok
         6pQklnninczalZi45SzeGa6ncTTkJB9tmky3G8y+Pel58eSIEKLmXv000g+DabTECeMd
         JWNPy5NW82ps8llDbrhvd5F5uSzJZL3UqWxYRCyNlqO/FfVCXpN2dsZJkm3mmk9e3mV9
         3qYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754566565; x=1755171365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rINS/1oBgFK82gTJZ3TSjDbuZA0dUTDcTbyacL5IJ30=;
        b=nR4YMAzcWAfh0j28HX60IXaSzmu1oa1a8dpwKnTDFHBQkEtd4anHq2WlHGPBARImOA
         CsI6nU6MONeoMzoPMb4M7CpsMokk2J52X22x9Js7DN2epfSZqAyjcHUPTtCZX4qBh2AJ
         UvDetQtdcCAqH3oh/Peg2en6nICsx5a3CWZYA4tGDE/GJiMAxWrjrV8Y9PYWPzEhXC3P
         K9J4h2w1sFSmDlmAjm0Xp1chC09KbP6eQpJ/RpKbc4/nk9tsE+BnG7JEJpQJw57+YJ3d
         +t/hq4ud/pzoBgyFH8jq2yGReDxS2ov5q88qxKtMjCCzkq0e0WW5LuCiO1/Ef+aShBzr
         0LMQ==
X-Gm-Message-State: AOJu0YybskypSyOLb8k5yWO4yCdx/CiHeScarVfYLSVoIfbpvPGX8+2Z
	wb2j0FNZjYw6Lo8hvFXCMciNxn300yR4ePjBBQ13Q1mfZQDySyxQps9ZwbUM1h0jZmgaFVOqRTg
	TAQIBERChX9Q8bsHacnfGSPH7UwQP+w3FaFHsOrOl
X-Gm-Gg: ASbGncsVTp5uwIayVf9jbJ2E4yRd+NhCQSvzMZKSOIX51toI5oQ0huCe5uzzQnuT+/X
	aln0FwnrHwQg7NKqDZstmqRxcaUX+Bcw1E2NC29ZVIKo3LFQJptABnMuKxD3Pc/uwO0d/OYi79p
	I5lxi9ABFPWVXSoVUYWMJUmFV0WTGOqudviSL+wkG7ofi/qvFCMuXXMFXmd5odVVSnM3EsCuWe0
	WWyIF+u
X-Google-Smtp-Source: AGHT+IHVg9rMkoh0qVm3TF7LjNVDVApq6CFUBuY/LSvBIkOM08ZaIhb4ZF9e0y76nOETS7IpnStuVoxiWRcO6yBVp/E=
X-Received: by 2002:a05:622a:20c:b0:4ab:cf30:1892 with SMTP id
 d75a77b69052e-4b09254bd74mr101451741cf.22.1754566564482; Thu, 07 Aug 2025
 04:36:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807112948.1400523-1-pablo@netfilter.org> <20250807112948.1400523-2-pablo@netfilter.org>
In-Reply-To: <20250807112948.1400523-2-pablo@netfilter.org>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 7 Aug 2025 04:35:52 -0700
X-Gm-Features: Ac12FXxvf8GDtHZlGhsGTiJkMDxY38vb5E-S7wVaKk5vvJbhIidQjY_eSM4kwm0
Message-ID: <CANn89iL1=5ykpHXZtp0_J-oUbd7pJQTDL__JDaJR-JbiQDkCPQ@mail.gmail.com>
Subject: Re: [PATCH net 1/7] MAINTAINERS: resurrect my netfilter maintainer entry
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net, 
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com, fw@strlen.de, 
	horms@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 7, 2025 at 4:29=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> From: Florian Westphal <fw@strlen.de>
>
> This reverts commit b5048d27872a9734d142540ea23c3e897e47e05c.
> Its been more than a year, hope my motivation lasts a bit longer than
> last time :-)
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Oh very nice, welcome back Florian !
