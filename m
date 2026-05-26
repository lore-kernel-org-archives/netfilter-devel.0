Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D403B27FB
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 09:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779787867; cv=none; b=obXQ1RygPbezZWaNA4Y/NLSI8FIuCHCbCmw7X/zrXWOcQBD9sTuQiJ/XsaLAZmmYIdy+2K1aCDFv7UnMkr8oXvT+MvCi2hKU8b3OeTLGgVqK/j2Xxqc1tJfkLTty3rzyzBptw+Z6BTPBru2RvWjQdQuwv7s8ZsovsmG/C1AsD68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779787867; c=relaxed/simple;
	bh=uvz/kgTUH5nCjt/wXXr7H3t+qy4vkWiuM6wRqHR4LwU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cuCr4UmhG1FrdKLuju0Ks+EqQ5FrEyalZyIL7whUhSuMzXKsju7aSzGvHpIiBbWlJpvCDNEkgNFpKXHSSQefiEHgOnFErnZIrVJxqkAi+T2DUNgb5XPQ8dxdJpIVaP85r99Zvh2qnjXQwwK8LYQREX+8WlmHnR7g1uMN2+uB1RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fk5w4p22; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fk5w4p22"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48e6db3ff7eso53252925e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 02:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779787865; x=1780392665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lhyGEGziB4p1he7Kr6BJJdkSVJk+rI4Mohkv26Jk0G8=;
        b=fk5w4p22H469kjTbAqXGPjbdafQqqIhAKUOmSuq0hdyM6mOLidAfdQduJ5hmt1nn8s
         Zn36+AYkcwj2+Zy616X6CLrIN72cQlp0J8bcyETDBA3rkXfu0KfxtepJ+X+fo1RjhbRh
         jqJYkxRqt5xdjkwusO4vMUEE2npOz6tKB9+QHF18MXRUk/qZdBbRQBTgEa6BHiypq7/5
         zub+pc2EW5Gk9ct2FUNAKcT+Ft5gmJ8pzrA8975rWPxalQVGhBUP3t15njsbHDqR8c3K
         mZiCys7KO4zb/Hao7KCHaCh3J4PPMqtgEWH99+oWJTHihC3xSZp2lZMLdVL/1PMwpkgH
         nyjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779787865; x=1780392665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lhyGEGziB4p1he7Kr6BJJdkSVJk+rI4Mohkv26Jk0G8=;
        b=i1xS4OfYWXSCT4Qk4wxQljE0LTlOZJWT721wslfUQOm324DkT2MA2HZJpv/T834yiB
         mlYLNG49nSeB3HRVrNQxNkCELLKHjicZSWayBKonp0QqYWAR/f+3iIoTYxnbXwXVrGVZ
         1oSMciyWDkX30nouYmOnt/wd5+xARLZWWnc2t2+QTnhUlpSjMOYl4DkcFyV6kKEckgLt
         5U9VtdQLlFF1PWNBmC8tl1QI1s4GF5+BoOE3vgAkdsS3oO/1xxWLmSTYl5MXSj1VBj2g
         auZXdhlqvXyR+fXTSZ48ULTb1zZjEmppNK0Jyt0WxovTypA062tovYVIkwv24Ya+hGsB
         casA==
X-Forwarded-Encrypted: i=1; AFNElJ/J1wmC7GUq7AM0YNpR6+sYBoQ25jKdlhLSQU4X8gvmtASs6mk2n9U27glSzkgiCb7i1bCwwLu8qVE7smjqvA4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFgBHgoimuyKK51CJ2TB9DeH/SIphrCQqWdwInBHKyVQwm0V8d
	XoelZVXHdFRF4ITAJIcML0eF3FgXOii9FcKRKO6dvYl+livLpXeowmCj
X-Gm-Gg: Acq92OF5WfA9ROMZiJ3a0wP+np2oE26GtmQGG3JPUaf/MSAZZdlsKm0kBY/hR1pt6S3
	BDKttzGt6XSlyck5Yuk5+CjOiaakIlwY3TrczYyUP67nkA5xwGbyJUfbiMQVg/luJQ1Patn73xC
	ZjK6qXnCzOajq4JlKneLWpRgXdkLSxf0PjO2wnh2B3iqULvVLnP5VaKrZIxbNeTKQM0ncjgWiZx
	UywmW22xiWMIeZU46sJQLctizpAJc3hOQKYGyHvdGw3R3diQ3wmExEDClD/yumU0lxTTFy2iRKn
	wREZiQT+2JIHJ9iGtbh6rG40fGjndq9OiZBZ8FlwF2H3ZLdQxgx88R8MK9pjXXc3DjjIW1EieN+
	t67mjhoaBQZxqu2rPvI11XsKR3Drzw3PzMm+mdl9ADDGGKOL52AxTZ+f3JMBpyZjCUbylIMhtnX
	XFuI4OS295wV6bgEr+PQiFbvGt2PWPK0mPFV0Z4Mu0qQnjK/odhS3ecaqE3ZkMzxm9
X-Received: by 2002:a05:600c:4ecc:b0:490:3c90:2cda with SMTP id 5b1f17b1804b1-490426cef73mr281947435e9.20.1779787863622;
        Tue, 26 May 2026 02:31:03 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d4741bsm35437657f8f.22.2026.05.26.02.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 02:31:03 -0700 (PDT)
Date: Tue, 26 May 2026 10:31:02 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Florian Westphal <fw@strlen.de>, Kacper Kokot
 <kacper.kokot.44@gmail.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Phil
 Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: TCPMSS: fix dropped packets when MSS option
 is unaligned
Message-ID: <20260526103102.003aedd9@pumpkin>
In-Reply-To: <b82e4092-1f4e-40ca-b117-31c062ea54c2@suse.de>
References: <20260525201116.407338-2-kacper.kokot.44@gmail.com>
	<ahS--cPlhv6NHAcO@strlen.de>
	<b82e4092-1f4e-40ca-b117-31c062ea54c2@suse.de>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 26 May 2026 00:08:15 +0200
Fernando Fernandez Mancera <fmancera@suse.de> wrote:

> On 5/25/26 11:28 PM, Florian Westphal wrote:
> > Kacper Kokot <kacper.kokot.44@gmail.com> wrote:  
> >> Padding TCP options with NOPs is optional, so it is legal to send an
> >> MSS option that is not aligned to a word boundary and therefore not
> >> aligned for checksum calculation. The current TCPMSS target is not
> >> robust to this: when the MSS option is unaligned it produces an
> >> invalid checksum, and the packet is dropped.  
> > 
> > Is this an actual, real world bug?  This code is 20+ years old, all that
> > this hints at is that they are always aligned in reality?
> >   
> 
> AFAICS, these issues are not present in real environments as MSS option 
> is placed at the beginning of the options block making it aligned by 
> default usually.
> 
> I would say this is more for correctness. I wonder, if we are touching 
> this code, we could use the opportunity to make it use 
> get_unaligned_be16() instead.

gcc and clang convert x[0] << 8 | x[1] (etc) to the appropriate single
instruction (and maybe byteswap) on cpu that support misaligned accesses.
So there is little to gain from doing it any other way.

-- David
