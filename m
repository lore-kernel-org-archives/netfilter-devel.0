Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com [209.85.208.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A1C1397
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 00:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773879349; cv=pass; b=uZufMurkdDbROK496gmQ1GDDXlS4GXf2QEBXgaaG6JdKH2CA9kwWlm5zcvTRc4ztgTJIkgYxH2nnjYF/dUKsasS23XDWmk3NfrKWl5WvvjHvCpY5PkZBEJDg0XbfssVyZYnAmgYAPvoWysRQyM8/5CrBZBEdGD9Vy8E3W9RDrl8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773879349; c=relaxed/simple;
	bh=HXN2W9HeN3WsC3iU8xLukccmyY1MXO53L/HXxsrNuxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=JQZYQKBk+XwfaAkEd295ZITE8Bv+rQQJcG6gSLUEzkMYDtRVBjeykCv1hLq1HIdvY5U30SHHjN3EGuSdTH01Uhwk4XQ6exM+5e3A5J+WmmDsilje5KY8Mlk/n/1nX852T8pMqL9pM+o6Y8Sl2k870E1TRGKoWVPsvwRXsdiGv90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AcBz1Wdl; arc=pass smtp.client-ip=209.85.208.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AcBz1Wdl"
Received: by mail-lj1-f193.google.com with SMTP id 38308e7fff4ca-38bd3c6c502so2850251fa.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2026 17:15:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773879347; cv=none;
        d=google.com; s=arc-20240605;
        b=h2DbKu7i6GA1pBbOi3gylF18riLX+8cqvCFTXMgo2w8L4JEjKAjA/rGlrvDCQF9V5S
         k1Zn4nnKHUA7C2EGyOgBh5sMWZArrrvfH3XHkbft/y8Y6tGbIFyKTbFZp4Sgago5jHeg
         RekGdUCeBZgz6fBfTDfTCZLXgfOv4dUT/uJSsIsekhUrZU3lwa3xNEH3sQ1LlevBxaxF
         ahF2cQw8dCmLZu3QgerEKI3Ddp9vBDt43AG6Wsgp8VuWqXgXB/cSxopzpZ8Vu2t79JBi
         emM/tukm5da/627e40bYVdWRstDTK3PKXjITiIeb3JmpPcg49BLKUqxoONmmNlXo67j9
         enhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=HXN2W9HeN3WsC3iU8xLukccmyY1MXO53L/HXxsrNuxM=;
        fh=arsyrOdwBFzH023MFbpNx2rg8E9aK7iXeqMNMbxeCdU=;
        b=VFHLotlD0Hr0HC5d+aWbGhsrBd32JPNZODFDe6LaTeJ11U/wG7OfhAAtLKeLh/Xs3V
         4JZ2lJeFQt/z74VPneoTF3dC4ohHXSz612Ps/qzwfmDeTgfkDjVyFdISIu5WWMOoLXPW
         //DGSVZppwcQzP/c94Wo9AnRVV/GPaGPXTObMZvKanhQryBpVG18JgwtW91mofXLYD92
         MuDo8P2DrwTYUT369JHZmgPaBmUfe25VJal5jplSPD8t4du6/7We9Pa/hLc+4Xh3mMl5
         d/FMB0T1nQeBc9CGqUK0AmLJW8+OWJjNa+m9d6TVwLAfRzW6C+jl+/+vsZlFuBWURU2h
         Ypmw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773879347; x=1774484147; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HXN2W9HeN3WsC3iU8xLukccmyY1MXO53L/HXxsrNuxM=;
        b=AcBz1WdlMskdvKsRyk+ijshfOZz+rJvqK4kLoiwj5IRvV7lKMYSIM6iezY2JqalpmN
         EGGJ3EzlYaOJGVcaP29JCS1V75A6f+wjlvSvZlaKlWiZeOU9ixF+q2ghKLPrCDiVSfSO
         dvLbyGvsOkWcBnnI2l/XD17K8QJQEVyCotyH0ma6m6H2fgIsZp1arSgJk7YIJhvw26ww
         L/RvnQJsGF7HkxPgUUrz3+AUZnZFJ9MhrGeaND1ez7YTJdyNlSm1BvieWvMbfznvEtSU
         +XxTq2lFN58jZIsCZFg3i/UBJncxZHFtPq096u8XeBb94cOqt7GcG8gDo+HmrRbv5X2P
         qw7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773879347; x=1774484147;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HXN2W9HeN3WsC3iU8xLukccmyY1MXO53L/HXxsrNuxM=;
        b=Kfba8SSZ/nzB0EuaDDObu6LTg/1Ov/aet/j4YSpH/crMEUuo7YIqwXupUbuHyGY8Im
         htm+tS2VaMcZEyE6N0/okB9GH0tk/8/TjUj1jwAfbGht+v9GSl9RuV5hjXEf8I+UY8N9
         gWNlyy6YAJ0vM6Q5TUng0H7y6DIyJFnZfDqPD/WhKfZdd9C/wNejIVPRUP24mtkNBCgt
         JfgBgFmwkKmOULNWxAs4XPInKj7MZ1WY3sG10LeIEt/+7ZpbSmAEZpSYEpKzs5962DZ9
         +lGHM/pFDPQHrXwGNy9vIjbpGy2alJcl7OD5mwWFjek53X8ANBA7XnbemCaDJQbfqsHt
         T4Ng==
X-Forwarded-Encrypted: i=1; AJvYcCU5MEGwXT6XmgyhpPYRK9eXms3ldh1DKOTQtwXRn8chjBA22utgzx2qvKCRF2WijT3AaZZ57o389qVrA+xuls8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNQW4bPGqzq8uOi8ei0mMqm4d/kaSCLZfPzDii/falPeKYzJoC
	6qFKuNCNIhRJJ1ztM3ZNAa+bwP7K5/pf12Y78jO0D7Mbykn47qC6+UUAISSuFW+U2vfvouVHnDp
	RYm7l99O0KcK6o6V+MboEWwi8/+ba/Zo=
X-Gm-Gg: ATEYQzynI5Xp476+i+MvGQkqmYUG5d17Vs4UkGCVfMz9R2YRnXbuRlUdLOuUzBTM5Pl
	svG1w6QN2pwahRkQl824c0n5+lw0pMRlC8hTLxBBXv+32aKeeH44rxO9JewwJEeZLA0ImslwYuO
	xs4XOVszqQEQDRNXn4EgDRWG8VXSRBaKuTq7PMvmyWSfg2znUY4TKmF1u2wkyFKJRbdsbl1zzFX
	gxqXg/QARUguH2LJHldcf1RTzeonv6qAorriwo1XDW9b3agzqA4TyuRcDKPP6IKY1EsJmu79rN/
	YhxX3bwrxjTzZ3uj4n0=
X-Received: by 2002:a2e:a4b3:0:b0:38a:8602:71e7 with SMTP id
 38308e7fff4ca-38bd58941dcmr15543891fa.28.1773879346420; Wed, 18 Mar 2026
 17:15:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260318025651.151116-1-chlorodose@gmail.com> <abqCdqPLJyKmBQc-@orbyte.nwl.cc>
 <abra_o50miSi49Aw@chamomile> <abr0mqg2A0V0DiWb@orbyte.nwl.cc>
In-Reply-To: <abr0mqg2A0V0DiWb@orbyte.nwl.cc>
From: Chloro Dose <chlorodose@gmail.com>
Date: Thu, 19 Mar 2026 08:15:35 +0800
X-Gm-Features: AaiRm50QkSiy1xqgdUUFyur_FO8d3fpHG2sh5MDOcmLpOO7Mk0IqQOq5mcjlT7g
Message-ID: <CALUf4NpY__xsCa4=RHw-D+Hixvnj_1yuS7K_qJ6WJ0qSoTyRDg@mail.gmail.com>
Subject: Re: [PATCH] src: Export nftnl_set_clone symbol
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>, chlorodose <chlorodose@gmail.com>, 
	netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I have a use case where I want to construct a daemon that keeps a
reference to an nft_set and repeatedly uses it to handle requests to
add elems. I assume I must clone the nft_set from a clean copy each
time, otherwise I'll resend all previous elements to the kernel. But
I'm just starting to learn nftables, so I'm not sure my understanding
is correct. Am I misunderstanding something here?
