Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F05018562F
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2024 10:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730714608; cv=none; b=IAVCQm0Or37JMF+qqURJEsOOceq9QXOLfHG7iUjKUoZVHih5J05IDo85fLCY+9XpfDy4xombHVWLBdFJTtzYh4osJWTQ7SuFzzO3qyFOYjadGVhbzi5Z+AzZl7v1oMP/UAKOPJpTXhjeISr4LvBY/Cr/ynsujNqd3EUb7Usi24o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730714608; c=relaxed/simple;
	bh=CWglM5hIy4jAwRXpP4BzXZF2EZmcfeSaEOn7EsHzNSg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G852Vvl/Q/mgQzJYXWQOg9M5SQs6kHZfqrs8TzDjdFhWhZdYBfjWL/MJPPLwDzKBby5nw8oSdaRJoQgWsOq0tKtQDjwPUrjhteG7SE1p79F8Xk3kysfsJx8t7Z5VBteYJLGvdpRTVQXwmfwaCEhp3NgfHW4IOuHZRMUv/LLqBIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LAbBGDSX; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LAbBGDSX"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6e3b7b3e9acso33729707b3.1
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Nov 2024 02:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730714605; x=1731319405; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CWglM5hIy4jAwRXpP4BzXZF2EZmcfeSaEOn7EsHzNSg=;
        b=LAbBGDSXtOXpuiphyLltDjxq1ZggTYADKn2mlM3WGu+HBW0haDqjL49Ptw8eMIypiL
         dNTx4SKXCpqVimeE5lJIiO85P4xh04sqnUVT5bWXSkjmOY/qUgR/HWdFn9NUulSLycIL
         UXojKlYDsQArh0YT4Z5G3wa17XMK2rEgoYtwEwrOzeVlys0zoRchgI/99g434AM4IPE1
         McIpfJmhKBVjiYKWUI+rLJEb3eVNI0RY+mK5xEHHCMrnHOWox559l9JpXgy0ONXfwuP6
         4WS7TkhJEc09omqIk4gcfhQYphF0ffz3ZKkLApAvlLZ1cxFLnXEXCEdw8ui9j3VQLk9o
         w/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730714605; x=1731319405;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CWglM5hIy4jAwRXpP4BzXZF2EZmcfeSaEOn7EsHzNSg=;
        b=M8siFdDCBCSVouOpiMwZO7igetbBGzP5hRdQtot3COryv9Fw5c9qnbYevfq9RW1e9J
         KanyYUEmtj2YpYDL6Vi6Yji2b9VWqb80/3BBRbnODem6nSo4KS7iaYk2kGX/cHtR3F+I
         auRmNRTKXz/pPkUeI7vV31CQUHR0KJf5K/BCFKLnmuR9ukbLITlg82l+p4iJO3DHbxOF
         hUsIjfvSympsWfU1/lLg3n7nhF/sTJ6URQTxMYTj/6dnYrkCIGXfjJgynhCIppxg62eJ
         sjRaeB4gfw7tHIGlRFffOZRvFOlK2NPVvUpQqIbjLIIUGaTwhz6tf0+nR+aK47l9qRE6
         Lkpw==
X-Forwarded-Encrypted: i=1; AJvYcCXUtMLNrxmd/Gpb5j3uBFE75vkQljdLMs48APtC5TL6bMvJ5lhpiZibrRu3Y53LcgGQkbO2xkLjnX+Jfa6StPg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuMq5CmIeE5RK3j48WQYuNWeMoDb7d+Xs2g9Va1mrYDU7zt6we
	DbM6Zg3u9e5+RzWRaWnbksgTGzVpVCP+nTuDbZKSJImqzSTLroXNs7bUVPv2xBdauAom0JMhSr/
	IKY9sA2pw3fCd2wpnnXl47VIqwwbFODqH
X-Google-Smtp-Source: AGHT+IG9JsPj8U8ZwCnet4pWDIfHKL/0xArkuFPRA5txr0npEA+W/r+PPb15r+/SPxDkqA8vb157OuVwgD0fLhXW7ws=
X-Received: by 2002:a05:690c:6413:b0:6e2:1b8c:ad28 with SMTP id
 00721157ae682-6ea64b3742amr121189727b3.24.1730714605379; Mon, 04 Nov 2024
 02:03:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030131232.15524-1-fw@strlen.de> <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
 <ZyiPTuWKtSQyF05M@calendula> <20241104093933.GA13495@breakpoint.cc>
In-Reply-To: <20241104093933.GA13495@breakpoint.cc>
From: Nadia Pinaeva <n.m.pinaeva@gmail.com>
Date: Mon, 4 Nov 2024 11:03:14 +0100
Message-ID: <CAOiXEcfNUrATSXafH8WOgEzMBZcGk+O5Or1PaVYL4nPWMJvV+Q@mail.gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I'd suggest to add timestamping support to the trace infrastructure
> for this purpose so you can collect more accurate numbers of chain
> traversal, this can be hidden under static_key.

Another problem with that idea is that I am building an observability tool,
so I can't modify/insert any rules, because someone else manages them.
When using conntrack events, the only change I need is enabling
nf_conntrack_timestamp.

On Mon, 4 Nov 2024 at 10:39, Florian Westphal <fw@strlen.de> wrote:
>
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I'd suggest to add timestamping support to the trace infrastructure
> > for this purpose so you can collect more accurate numbers of chain
> > traversal, this can be hidden under static_key.
>
> This might work for nft and iptables-nft, but not for iptables-legacy
> (not sure its a requirement) or OVS.
