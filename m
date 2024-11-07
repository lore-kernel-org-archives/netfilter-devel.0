Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FCF21218A
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 13:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730984450; cv=none; b=IJ7XW/Xwz0hF909Xw16aa3kj0iSVLIZLkKXyXW+CqGtPqjR4s2GGbrtTLhobn9gXKRUaaljnsrUVMFdkDle7dQXR4v+FXS3sHHsltxL8UAWKP/aU/55kyQyYxEOKTSp/b7IiJiNSgk+j/Y8BoxkN8IKbyGgjuEUrmhK6fbWnLLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730984450; c=relaxed/simple;
	bh=p4UEKjXCdABntYejobRIzxDpqOYdvcSt0E1838hsm8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KcO+HAK5dslDgLxncnzS1mv9H5Gi5MbsdMmiiBxL+JITroKgWygJYQe2SToq99SaVWoBFS7LP8UdiVzMptXQ0EagkiRo2s2QtZWQSqfMCGDqruRAO7lz2wl396m4L4o8VN8beJPBnQE0NECWGFVDDkF2X+DaKStZJ5c86xzjmAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UCwRFupW; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UCwRFupW"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83abc039b25so36898939f.0
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Nov 2024 05:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730984448; x=1731589248; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p4UEKjXCdABntYejobRIzxDpqOYdvcSt0E1838hsm8A=;
        b=UCwRFupWw+JktWP4pwjBDobTKh6OZk3ch6R/8PPujFQvvdrjoLCTJZIiyTaqpYeW4t
         8f1Lqa6SNzK0j7yisBKF1h6wd5ZMnyZoQz8dPr+8NdexQC8oemXM6/u0N1uNY/HwbM1p
         uIvrOcLZcO2wgDYqWPan+7RLgpw26YBLcROQQfqtMpyHZaVuTyAgihJwku8Fz3HOjQ/8
         mmpf/AsdBJUuowMdDQekFdrsdKxYDqPUnnyHz26O0ks/PmbbV/h4nR8ZIkxRTSVyyuoF
         MoEH9/HNcJNNkoie4on/zIhhqWk4SHeDYmMkUZv7M+2fXUQHSZ4FDLSweynXUy9Mz2Uv
         bF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730984448; x=1731589248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p4UEKjXCdABntYejobRIzxDpqOYdvcSt0E1838hsm8A=;
        b=rvINdoy7+Au+ySyxYN8U6MfPtpWXk+9o2qtI7p5ml8vkUtzi7zbKB9Ejj3veUUuTxH
         hKVlUYu5tNw4CrCxQLEHxB3QgP8R4YMk+wBRf1XeqseTHrs0De1KIP8RHfLIdFeln+sI
         vDEndCKYpitNAbxfjcCgJs6J3LgjiVulvu6d4Zb0Bjal8n1r3aJD9R5dqLHr6arYH9gg
         9xLUbgHCzf1YebyVFXyjRgdHF/VfKaOUNrDEHDkuL2V5kA6sMSfkqbndLCmxoBxdXRW7
         Q8RQWALFW8Jh3wyBtAfAJcurNrT3ONYPDJxal9obtWLTP8/S5IYIS7xJ1mubz4sCGoLY
         xlUg==
X-Forwarded-Encrypted: i=1; AJvYcCWoMreJ2Pql2zEyWrAbza6mfZ7EYRgs3cKaf5C7ZK/dH9hVV34doxrrIrLtCRcw+3L+3pfoFRy4dv1LcqOR8Xg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+pPqb7JnGpbAeWWP6G5wbahP5+9nyNovUTgr/Ovb0sA+Yfooa
	eNbOwi3tqBOiIXLPbvM8X3ATHL2rQinygy6oWkJmjJEKNItBqZUMMAbxDPDC7KVuvKBKm4Fbyu1
	5fIs64Pdm+bzHboUBjOJB98oND2zbzdvcBvlv
X-Google-Smtp-Source: AGHT+IHZQS/HhfwkvGWUZIAeVlAFJWzHuuER3nlOt+WywBAjpvJLtzoplwoRmTjIUwT28kqkEHyJXODIdEmT2sTfWLE=
X-Received: by 2002:a05:6602:19d0:b0:83d:e526:fde7 with SMTP id
 ca18e2360f4ac-83de526fe52mr680897239f.6.1730984447792; Thu, 07 Nov 2024
 05:00:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-14-chia-yu.chang@nokia-bell-labs.com>
In-Reply-To: <20241105100647.117346-14-chia-yu.chang@nokia-bell-labs.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 7 Nov 2024 14:00:35 +0100
Message-ID: <CANn89iL3Wc9FGBGB7s0jHm2MZ0i+xA38NqR31AJpL-4nnBHcJA@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 13/13] tcp: fast path functions later
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
> The following patch will use tcp_ecn_mode_accecn(),
> TCP_ACCECN_CEP_INIT_OFFSET, TCP_ACCECN_CEP_ACE_MASK in
> __tcp_fast_path_on() to make new flag for AccECN.
>
> No functional changes.
>
> Signed-off-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> Signed-off-by: Chai-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

I guess this patch should not land in this series, but in the following one=
.
