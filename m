Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4E7296BCC
	for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 01:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779846127; cv=none; b=HSpWOV/enPXL/Ug/XHPCumH4ng7JW4xT+jugEwG7rhq5GW2QvkMpnbXA/dS52LsrW3Tt1RHZB+Ku30deXSM6PELNVK7nzunz+WGEJgOIa8ZSyVSEMQLd6A88FWw+wMPJsOOWVikUQMvTnDEtrPVfyMMetph3hPrgR9xNTrd/E4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779846127; c=relaxed/simple;
	bh=32dsN97BG1ZtaFA3Ti+ukBCBqCSSr6/wnuQlbV8qZMo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qwaOxl/oW3diQSoLWYkmifa7CflLIVpcCW3QLoa1fh8vZZ6CyUiKrAY6A6fXaB5sEtNHcfi43Kv40hBVlyUzfSAxMAJ546laJz7sErjeRRcuEy94P43iLxhNXo4piF5ZdYY/yalTiAiBlNq49gxIgaaJ6QKMO81V3MGfAABuzLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U1zUVIcn; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U1zUVIcn"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-90fbf21d9d3so1701827985a.1
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 18:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779846125; x=1780450925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tfHhtsUGD4nsHiG1/1+cWW06MDN0GRT266FNCCiFv9w=;
        b=U1zUVIcn5wqKsesqNfWQeCvMalIJASt5utNWytw25hLGHOyvU8ofcQWLzpOCxaeyib
         /ZhbQWGq6SLwrEatgPKCMpAuFjX1F5YaIzfnIqfPYymk66x4am24UeW31tl3z+AeIXD7
         M1i63npsp5e4oDIBvNy4CGAyhQp1kz33WUzk4Ij3BascBVEF5doFQvXC6a13LhWUJUJR
         IibPq+PMULJA7blmuuC/Aq0Wpvw2uaF8RvNEsPoWHfMQ5zRce1RUOq+ptrBJsVyO55ap
         mV6q/aPgGEI5nqTAAa9ktZAXajH/XA4owJgYvPVIgDOwlp5l+9uQitGH2hDklePho0AD
         ASMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779846125; x=1780450925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tfHhtsUGD4nsHiG1/1+cWW06MDN0GRT266FNCCiFv9w=;
        b=q/vc0Qa6v74n16Wo4JcfT1LdZ1/A19/WUn4FEq73S9rtGvG5ciazL+xevNh3fei2of
         gItqvevgLlQJOTGd7W3wC4o43B4F/C+Cc4eAIWJ2lJ0+IpPqT7mkVh55QkAkhyxhSVSn
         pNmKwyG8TvC7r9N32nQR2CIjrH8gIXln0o2ZzRJXFcWd12woSOoRRdN3wONG4UpqNc3d
         VhAREccejOv6sSwEV2bhSjk9IeWzXi27/N9/jU5nPbSAib7JHtdXxuYJG6ljYUBmrX0E
         5kW+j9fzfVWJMF7WQieSDNnBhmnNzpChzNniqo8bvnFas1Fa0HD5pKIynZDSFeQqGFvs
         QmSA==
X-Gm-Message-State: AOJu0YzQ13yKmDNIa7IARcHeEkgQYXNd3OVnFCfIaPBc7KZaPYQenPMc
	gR+M8hBYYIt3/R2lCqasnpC+ZPuS28d+IxXE+9JiY7yYXWoYoGf0D0my
X-Gm-Gg: Acq92OFGGDxvgdQRphNqOZRpFxkZ7PsKxebEh1gpcR3mIlaHlAdbYHuktZZ35A+Xn65
	s8+MwGylHLnO8LLg7MXJK62q2w4zQpqv++1Ju1xSUtpFppZ73IjtK4UdJeezfYRMCHTuTqxETW0
	HvU6k2p70iINTl33IVx53cztlOiq9TANy4BlKUoQGrY6gt78VvcsmxpCQPTkuKaVsL6nTvB9XOV
	boF6pNwaakFWncl9Zg0Z1cEnbuj31jlGWDVs4BSu3vthS9caySlhwU7Ua9goezzSmSUlXvn5NFU
	iOTjsCw5UbClqFU4eUnmBhzWiZg+pS6r0Gyms06DDBctyYJL+q1d4O7VNZHchFlHlaFOqmZjVSf
	lb5w2XrshbJIrVUEFf9fTNL4NAkBTu3v4E3APBUbLuV61AVNcR1D5GjRUM97jMkGFDxYhlFCXqW
	KeUF8IwcLlbVheJnYf
X-Received: by 2002:a05:620a:1996:b0:914:cd24:cb0f with SMTP id af79cd13be357-914cd24d09emr2062826685a.40.1779846124760;
        Tue, 26 May 2026 18:42:04 -0700 (PDT)
Received: from playground ([204.111.226.76])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f870eae0sm354427885a.18.2026.05.26.18.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 18:42:04 -0700 (PDT)
Date: Tue, 26 May 2026 21:42:01 -0400
From: <imnozi@gmail.com>
To: netfilter@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
Subject: Re: ipset not completely working in mangle:PREROUTING
Message-ID: <20260526214201.0e3d6f3a@playground>
In-Reply-To: <20260525205736.1c76666f@playground>
References: <20260525205736.1c76666f@playground>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

OUT! OUT, demons of stupidity! Or to use a slightly more modern saw, artificial intelligence is no match for natural stupidity.

It works much better when I also add the VPS IP to the *whitelist*!

Sorry about the noise. Sigh.

Thanks,
Neal


On Mon, 25 May 2026 20:57:36 -0400
<imnozi@gmail.com> wrote:

> iptables v1.8.7 (legacy)
> ipset v6.34, protocol version: 6
> 
> I have four sets:
>   - blockSetHost (hash:ip)
>   - blockSetNet (hash:net)
>   - whiteSetHost (hash:ip)
>   - whiteSetNet (hash:net)
> 
> I added rules to match the block sets in filter to INPUT, FORWARD and OUTPUT. The rules match and jump to chain blDrop. In blDrop, if either white set matches, control returns. If no match, the packet is dropped.
> 
> This works well in filter. But there's one artifact. The blocked packets are 'accounted' to the internal server where they would have gone.
> 
> To fix this, I added the rules below to mangle. Here in mangle, the white sets never match and all of the packets (that matched the block sets) are dropped.
> 
> Is this another instance of 'it doesn't work in mangle or in PREROUTING'?
> 
> Thanks,
> Neal
> 
> ----
> The rules used in mangle; eth3 is internet:
> -A blDrop -m set --match-set whiteSetNet src -j RETURN
> -A blDrop -m set --match-set whiteSetHost src -j RETURN
> -A blDrop -j DROP
> 
> -A PREROUTING -i eth3 -p udp -m set --match-set blockSetHost src -m state --state NEW -j blDrop
> -A PREROUTING -i eth3 -p tcp -m set --match-set blockSetHost src -m state --state NEW -j blDrop
> -A PREROUTING -i eth3 -p udp -m set --match-set blockSetNet src -m state --state NEW -j blDrop
> -A PREROUTING -i eth3 -p tcp -m set --match-set blockSetNet src -m state --state NEW -j blDrop

