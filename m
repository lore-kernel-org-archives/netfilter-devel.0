Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F0243C7B9
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 11:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786448252; cv=pass; b=CaKPFsJNHoTPud5ADk+uOGE+/vwtEgtN1eE9WvKK56EmXdFNrdB3OrCW4hF0BNZHAQrvYjmiiTvNaFlTppNQYCg76i8tmAbEvLzhbbU6ylMWK2aeKJvThgYRiLsdbp485LlJ/3ppbqyCZc2NZ+I8E89h/WvwnlSQ8aNFHIsBsms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786448252; c=relaxed/simple;
	bh=gpuZODGzj68Y84eTLk6uQfkMqrQHsTooID37VgaUIfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uk38J9dLAmdYiQSnoeEUcxtLDofYr580TuYjkH46KXGa9/zbzpUq1alfRsQnLVbxn8oVx7P53mC2FMocAaWnqCWXGMlnH3vDBxdWq+GEoyXgy2r1ay07xgpDuoD4MX51fqr7Jf+UEnPRUo4cBqV4OGixn2h8kCpNYyyo9OWrKNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bbl+BHnU; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bbl+BHnU"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-81f64e8dfbcso44362777b3.2
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 04:37:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786448250; cv=none;
        d=google.com; s=arc-20260327;
        b=SVW50xwKSMvhvsUo++S55H7MbVZ8x0GbSSG+zmSbMA8StCCbHyvQSi5Ar2vRbesczD
         tDTS6caFyFkbRtgtR9C01FNSl+YnPqtoA2kbf0Mft50TxewtZjOA8WJYTUPdajzAiOx1
         O5zK9D0x+P2OMyWAqiOCBxrTzJMfU/xOgoTmxs9p7B5ZRYCqeOfe0/EfV/szi9UICwN0
         oW4YLBQUhXsMalnkzGHL87IOiVXeEPqM50k9jN0Mf/m50idRF34fJpZSL6nhJm5mvdkp
         w/s1TlnTdaPsvjpaZnuLLKi5UQddTkuR2vn+aZBXqTBHBsdivs600Jlx1DnexYDnsigK
         jJBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=02wA3GNr7vAUbL7lTzE1Bgm13rZFC+V6O8LJD+mzFT8=;
        fh=x43113ub9UrsJIGMG1ejnZO0OmoNoruOtaH/j6SXnXU=;
        b=VaVr85as0Ov4EDsVKdvwWC6wKE3F0V6S9wC3iV5VVfUnMrOEBXgR94a2sq6YaUmBRJ
         fdA9kkSonU103p9VWf/XLzvlapCdXMA0bh30mCgTJeJykB23lRKaMZ8Q7FH6K4H6dCij
         +kn23k1oec7019VhSL4JdgLIJ9/XafHFY/y2t3fJ/9SZIMtni7M6vwKeBZGFGUPTcdfL
         hAlTG+EfOAlrXq+BUUAePNBBsuKkJtxAftE9hmNhSeKUBp4VEKma5sRIsRZU15ovPzsb
         Yb5YZMA+k5bfHSB7RF1sUrxl7l32vPzITLiiTvcTZtvtzdQf9pBOZW9tC87rqWAiSs4G
         y9TA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786448250; x=1787053050; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=02wA3GNr7vAUbL7lTzE1Bgm13rZFC+V6O8LJD+mzFT8=;
        b=Bbl+BHnUxmtUWv9+zlr8JdnyA5CY+o9iFiCEMdZaNDLHIFZf61jIFbJhpP60cOtmi4
         4HpHI4A8xcV3KD94rPzuanhGbpsBmbCIcXmIpVpK43OLJCySLNWOW6s8wu8IlZFcp9GE
         S3ZdTn/V9kMSvAkrlZMmbT63G/BDIcnoo4c53yUtP11lHERi/phjqvDmt1guB4QZXBic
         xoNuzdtO+dERrRG8bxWBzEOHsIeF2I+6Od9fRWmHIUr+zWpK4fkpv2A0HOchA8SGyxBQ
         NW6FoO5I0SW4Q4crdTx5MW+kZv4sI7gamVR78N/bj+Kzn6OjnoUgUGSLEwsqQHUOSFmd
         U1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786448250; x=1787053050;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=02wA3GNr7vAUbL7lTzE1Bgm13rZFC+V6O8LJD+mzFT8=;
        b=RMm4cRw4Disgjlf8VeGYYhtUanmClfg8sJEZuLwI6GSnaueAolM18QxjG5BWjPCf+j
         jBO3mcIMW7IVKKXbhLA4JZfVf9xs2IQgxbs75/BvuQrhiYoxE8xor0iQNUJEX6pYpYeL
         5p13IJqyF2Gw56hpxULI+cFHR0OcVlR++P/pDuPGkf+ZZkefm5Kfr+1l9FFEju7AuyhV
         yBBK4wVrBR5CBdDF/xKoTPql1NRe15/7xA089DvtxgAYIE/M1DIH0nR24p1B41CU5NeG
         d1L7Itu9XVtl8yYhE179+z89LqAmpNPRT/AfdKl7CWlaSFTlzBkazk3OwlgwjTuaPyVx
         J97g==
X-Forwarded-Encrypted: i=1; AHgh+RqrIsHwAO1rk4tcHGoOKezn0hXGAjyi5+ijM2wBwwWfM4k4lY3NGS70nNpZHVM583xc88SE/bHrH/f9NzH6AM0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyT+KzqG0Q52cjEl1AKCEbnkF0EMsu/9Niw0YHfUOinmxcRTqrf
	WyxQ/taZbomYg24QTdrCnjvYJ5UMP+o6n9jp3cGq9BiWEoJv7Jeux4wDI6ZNgbpVYIYOwX6HRvD
	VH52bWKJeeDC4qZSNcBBNRo3oJpLkdHs=
X-Gm-Gg: AR+sD11Xa0qx2l9viy9sbgLDn1epwsfrDay6r1gLFqIXdJ4fH5Ot15wC/6SH2NjeOTg
	5ghmyVwyRrbuEqYI2OVPfIXPJDL1sdjBsqO7gy23Pcz5yrE5ySN6K07h4SDceRzctuQyMX0ylo0
	gbrtoG7EBVieecvwInSCwrle+GH2NlVNVdNbj3cH75dMG1L6kmOmafn/Agx5kucuQZp22GYOtOa
	AWIeuk/4SXOg2ugmFHlZCfEiD4m/9NXAINOE2PS+0nKS/efiTKmJ6F1klnO0cd5ltUOrAbQARj0
	iTuNxNRQe8KAzxwBwXuh4I1Fw7iJs1Tc48b4NIGM9dPx
X-Received: by 2002:a05:690c:630c:b0:814:7a54:3a93 with SMTP id
 00721157ae682-82f2ceefb77mr17793617b3.23.1786448249594; Tue, 11 Aug 2026
 04:37:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANE+tVp8_NhE+KL6ZNPGjaGMLPxrCWw_A5sY0jotrvThB6idXg@mail.gmail.com>
 <anr3YZJrnS_2RbEp@strlen.de> <CANE+tVr69qqyreBbWWk_2FqpMfQAqde-JF=weECditGJF=uZ3g@mail.gmail.com>
 <anr-MVb8okTwL1X2@strlen.de> <CANE+tVqc+NNN8EfpK+cEYV63Pmn3OHS81PBAGqB1RHidraChLw@mail.gmail.com>
 <ansISMIJIOfIUrAA@strlen.de>
In-Reply-To: <ansISMIJIOfIUrAA@strlen.de>
From: Wei Fang <void0red@gmail.com>
Date: Tue, 11 Aug 2026 19:37:15 +0800
X-Gm-Features: AUfX_mwteNvpOL0nmjT_bwBHdao2sjOLME1eLVUy0NIXXnKZXOzimnkR0H5Sxdw
Message-ID: <CANE+tVoK9apuFYNpm13tUHU6TvtNgdNi-GkYg03B6gOPHVaRUQ@mail.gmail.com>
Subject: Re: [nf_tables] pipapo: inserting an interval that strictly contains
 an existing one is accepted; rbtree rejects the same insert
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, 
	netdev@vger.kernel.org, k.chen@smail.nju.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Understood - thanks for the detailed explanations.

Best regards,


On Tue, Aug 11, 2026 at 7:32=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Wei Fang <void0red@gmail.com> wrote:
> > The report is about inserting a *new interval that strictly
> > contains an existing one*.  On a pipapo set: first insert
> > [1.1.1.1..1.1.1.11), then insert [1.1.1.0..1.1.1.12).
> > On the kernel under test:
>
> There is currently no way to detect this is in an efficient
> manner.
>
> Kernel would have to lookup all combinations of
> 1.1.1.0..1.1.1.12: 1.1.1.1, 1.1.1.2, 1.1.1.3, ...
>
> It checks start and end key only.
