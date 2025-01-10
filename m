Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33239206F3E
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2025 22:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736548631; cv=none; b=Av81lZpNUBBkmQG9F4vmPT90ID0H0AT1tCdltH5+da6X+GADq6l7Q08a+WxjJK/ODciXfhzsEpdlAdyubtE4KwR1KHBJ6jzabVYFzuGVJ+qQMq5X05mLgKQWzbbH4MTu7IpEF/iDfBFLX3Q8VITmjZe9czoDLWvgWGhtQJpkwvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736548631; c=relaxed/simple;
	bh=GNg696eOxeZSwtL/+tcD2OCjOROfdhKg7BTtUyM+ueQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=PD6iqW9+NCRkN4vcVt74WOhuAAfFrM8uKGFyRUDFH5HgunA7rdOYiMEz+tgOIi5O9pJ3+M/ZgZ5zmjkr1hWTCckwr4P8YV+yBHTVJ6YEsvL3aphlR6FBH6+ZKKFvlL4aj9uLosRJj01Zp6vp7wXPCv1eI7MlsXJ03Ub0w0YiTOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gs3ZMxAq; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gs3ZMxAq"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ab2b72fb3c9so435988866b.0
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2025 14:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736548628; x=1737153428; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GNg696eOxeZSwtL/+tcD2OCjOROfdhKg7BTtUyM+ueQ=;
        b=gs3ZMxAqSvuACJA9l5NxTCe6EtET4th8YIXc4nAtKBJ4UrjyQL5keBmtBIodWqnc7j
         k/mcaB1JeV6xS6eKgG6OkyQwGX7I/pliFIXj3+2LTkWxNkETqinOTDZzWTdsYnxZBQKB
         PpABkXQH/U+ZUrYG7jDKnusAX149lBhcP55YhY4oGhMTXM/hukjDmq/25HmJFy0BqCeq
         RIP+llSTwY1OamMGp76JT+ZrVDcEhI7/BDMZKrUksNrOrfsGxDds12R4rwKHhU4Huyg6
         PmPANYDO2mVmZShZR8S9Z8WJE3BC1bii0WsrhjZVUw7HVLVJxEy+BpGUmxdi6f2ZBSLA
         PYXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736548628; x=1737153428;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GNg696eOxeZSwtL/+tcD2OCjOROfdhKg7BTtUyM+ueQ=;
        b=OTOQossq0xyUwkjrhIE+q97npSlsgaRVehWNM+wWmx2Z/yyqOj9mO9tcYX3Jruitu6
         4vfbOIguJZ068tgMv8wehZ2g1Dka3GfUyRqZzptSE3O8j1WcAJ2FnPgj/0o0MgJUhG+T
         SBeCrOdXaCXTBD92VdWwtiAdrJtaeyTcRohH8gopcWbc67om9Xdh0NVWEm/PQwAfFBwH
         rU2wu0dUR7bd66RgKGycPJaaqGbKeg0EVPgjVLJajwRsctBaOovplJM5aB+fjcodTVcd
         nLO1K27AOhooz/D9xrf2ZMSiN/abMB2hTwUR5RC4NtxfPvhve6SePbwRLxsZ8BdJkL/3
         H35w==
X-Gm-Message-State: AOJu0YwQmshkys02DP1SxbqoOIX12j9A9AIkQ6yQnQESoSXUl+7mid5W
	Rk38Epv3TqJswG0x6UJWrC0p+cAylU5t3dltwBpVPHFlt/s5NavXYAYVsl4UaH1lAkF8NZS2hIo
	lcMJUNI5cmorXGRx8e5JyudQSO/QT0/R9
X-Gm-Gg: ASbGncsaA6sqzlIErYbiNeuzzw5io+8Q4e/nKDdRtT+J00q8S3p7EOLSWZwkEifZqH7
	71s2f6Z3kaLaT3Bzca82WJ207xKjBgH1LprRFVZ/PA+8+09zasRTbwj3YPKv8mBuaa+GbvHb5
X-Google-Smtp-Source: AGHT+IGD28vEot31v9pwEoifNIehDzuLMNfMzmYXWKX1noCTVLlO938Q+0NT3RJ5is0Nc3ZpI+NPasDRwKaTfjgIy1I=
X-Received: by 2002:a17:906:4fcd:b0:aa6:832b:8d70 with SMTP id
 a640c23a62f3a-ab2c3c5c96cmr670281566b.3.1736548628183; Fri, 10 Jan 2025
 14:37:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHo-OozVuh4wbTHLxM2Y2+qgQqHTwcmhAfeFOM9W8thqzz6gdg@mail.gmail.com>
 <CAHo-OozPA7Z9pwBgEA3whh_e3NBhVi1D7EC4EXjNJdVHYNToKg@mail.gmail.com> <CAHo-Ooz-_idiFe4RD8DtbojKJFEa1N-pdA8pdwUPLJTp7iwGhw@mail.gmail.com>
In-Reply-To: <CAHo-Ooz-_idiFe4RD8DtbojKJFEa1N-pdA8pdwUPLJTp7iwGhw@mail.gmail.com>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date: Fri, 10 Jan 2025 14:36:56 -0800
X-Gm-Features: AbW1kvaIxoii2Ph7mKTfCTbSSmFRsR-V9v7z21lvMY28NC3T8gvxfAThmoD6eIU
Message-ID: <CAHo-OozUg4UWvaP-FtHL44mygWwsnGO_eeFREhHddf=cc2-+ww@mail.gmail.com>
Subject: Re: Android boot failure with 6.12
To: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>, 
	Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"

nvm - https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/net/netfilter/xt_mark.c?id=306ed1728e8438caed30332e1ab46b28c25fe3d8
