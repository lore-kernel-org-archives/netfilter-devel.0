Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A8B629
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 00:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710895508; cv=none; b=oidHA1qHynzI/cUy0DK8Lj6sP93Mx9338K429fHPWz8h/YbJVD6ZJZdNpe7sjqTai0skl4J91FHC/tfqkvuAHeNd4aFUSvdasKU98DvJKe7TfYQkp3Ssja2uvprqOY7vnAmIxmFp6yJra+rRu1ydzyDSoUVxF6kjdDm1t94imC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710895508; c=relaxed/simple;
	bh=K/jYzLMSoAqgk6C+XuFCX8XGVxsRfLXFrti1jvUcHag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=tttLmSHNLR3KZb8SSC43D1gS0T4wqYboi7NZ5KjJRcPEq8AMS/+Vrn9bATsGDrj3Zvwwwhj3PW8toNo0ZxuJEurNgqquzHxXuXDC1Z2hC9GTJuorONZ62k7o1Nxvb360pYofMRebBo8tga9a5m7VjlGw1rYXDLI5rNeOve361wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ezSDG0xq; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ezSDG0xq"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-69107859bedso43519966d6.2
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710895506; x=1711500306; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q6vIIpOFjmQe3YbqpxB6EFRgNSTh5urU9MHkyUkQmDQ=;
        b=ezSDG0xqTVr0QDOP7Ff73TxmUHJVDwzbpuDQ73S63Zak9jXZz3KqZb3SbT3lT6V+ni
         2thsnRSqxrh0QChJrGcQ0rkScOUPcVvJs5pYx6qQFpTHtcH6MkW/U1ScNGak/2TFBchr
         fxMOBN9tV3UG4GIdmddmEjTeyYcIosp/ORaD2NtStkCxgdC+CDKs0j+u2FHNBqezOJ7d
         6Wfpq2rSGAadoVZcoEftV2+eu/RFxnojXkkXm9t/FdD5ks01DGTruKuv03krRkr0GR2C
         oDHniLrd7aNYGpwenFjC3hKqjX7zSzPlYTMkUA5y4v3rQhz5jT/AWIYkQYpazinJq0n1
         j0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710895506; x=1711500306;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q6vIIpOFjmQe3YbqpxB6EFRgNSTh5urU9MHkyUkQmDQ=;
        b=gtQeTu3w4tI31QJXhmf+PESK9JgDSFaKLstemBaLF+5oiBvOoZj46yLHO+bk0KiMW+
         hzhQ096YE+0QoF3017VuX0D7Js8Ey0C2TAvQBtAwVps3sITkSYeVV2OyfzH9QWOiD88A
         JicfDatDp/JY0dRGd/N7BjLcut9MEQV+YYqVUuRXyV01grOS2051T9iDi2FxjZzNF/5b
         yXVZPhXhxZs5fegkHIp/QM12pZ7RofL1u56/vEq1vPTY2G5l2dWzo1bUPwbtTXtoNaXI
         QT2ewMHnuz4wKlyjxSsLMwSJkxAnHFdKZHJJ4NHXRwp9hxk4V3/9DlJgOoaRpL542ZYd
         a1Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWOAvyTLsHQ3+Z4e1fKGbAR9uz5fcBrH3a12bV2Sc3AFlbL3RKgHfT2kQN4UWx+a8DiPF1fVOJCQYWiZPA2s2flU+fmxXimn+9kOLddOPfr
X-Gm-Message-State: AOJu0YwjNUKfnT0tEAau0WGfh+9KFPFLcYQIO8QZx0VBgB6YfqmRZPkN
	Im4Ldi92YFZ1Th8QCxK2O95HFV307k7G5c/BeOlGsUx+U1xNDkrVjvXCDnAB61mt0IQ5ykF33LJ
	RFCM9pKAlBX4XYeQslx7M/gf+qPI=
X-Google-Smtp-Source: AGHT+IH8EVntUGhG1tm4LWSqA30DSKILUJsMHuSnhSpcW/3iRhcKTHGw20lunmkA6NmZpTbPm7WK55ar7Prf/Em6kZo=
X-Received: by 2002:ad4:44ac:0:b0:696:456c:3b51 with SMTP id
 n12-20020ad444ac000000b00696456c3b51mr341944qvt.43.1710895505988; Tue, 19 Mar
 2024 17:45:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPtndGC29Zc6K8V3v4LStfrcnvdCNNfTmjP-Ma9dM+21f1069w@mail.gmail.com>
 <ZfnAGWIgPfiS5i9G@orbyte.nwl.cc>
In-Reply-To: <ZfnAGWIgPfiS5i9G@orbyte.nwl.cc>
From: Sriram Rajagopalan <bglsriram@gmail.com>
Date: Wed, 20 Mar 2024 06:14:54 +0530
Message-ID: <CAPtndGD29xG1koLq68BBuQricfg1FWh2QideLydphZ-OUsL0=w@mail.gmail.com>
Subject: Re: [PATCH] iptables: Fixed the issue with combining the payload in
 case of invert filter for tcp src and dst ports
To: Phil Sutter <phil@nwl.cc>, Sriram Rajagopalan <bglsriram@gmail.com>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Phil,

Thanks a lot.

Regards,
Sriram

On Tue, Mar 19, 2024 at 10:10=E2=80=AFPM Phil Sutter <phil@nwl.cc> wrote:
>
> On Wed, Mar 13, 2024 at 02:38:07PM +0530, Sriram Rajagopalan wrote:
> > From: Sriram Rajagopalan <bglsriram@gmail.com>
> > Date: Wed, 13 Mar 2024 02:04:37 -0700
> > Subject: [PATCH] iptables: Fixed the issue with combining the payload i=
n case
> >  of invert filter for tcp src and dst ports
> >
> > Signed-off-by: Sriram Rajagopalan <sriramr@arista.com>
> > Acked-by: Phil Sutter <phil@nwl.cc>
>
> Patch applied manually (your mailer messed it up) and improved the
> commit message a bit.
>
> Thanks, Phil
