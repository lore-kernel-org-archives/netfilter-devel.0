Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97FC2874FC
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Oct 2025 14:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759762727; cv=none; b=Dss+Tt6WfKey0liJZIAuDVCVTgmXMJGmibQtjVmdVRjFPmCWZqGeQeGVHRnKTZ+mRiORVBqqtW3DxLH5miTd+vmaqqgPy+4BhumYKc8Emwlj4cZUA5go70m1gXRnbYnUOaI/uug/Xepc4xkRB0FAVqR80lLlrie2G1l+nUS9PlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759762727; c=relaxed/simple;
	bh=mRWBKOfnPkiJOVywiDRCg0xI4Cf7b8EHWy3jStgw1sY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q8KAxebWkcDAi78bEUqgyaWGCpjhZyd+DVIav9QgLxEK5sy0Lc9kqM4Do3DHaEwrHqV5vC1ew1o1SyzCQDWrk2Ek7AXkBAUPgKgQE0v1unWMLv8pu6UB7MHmkfTQaMPR3coFpDMNKJvGRLCYKOrpur88T0tL0+oAdq42q/NZ2IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e3rFSQUa; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e3rFSQUa"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-88703c873d5so173594339f.3
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Oct 2025 07:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759762725; x=1760367525; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mRWBKOfnPkiJOVywiDRCg0xI4Cf7b8EHWy3jStgw1sY=;
        b=e3rFSQUaBwgKuMC7y9BgxofbmXJQ1jtReSxGpjj3eMTxSEbT/ABqLESwvFUmy1rq5x
         N/2IShK4KperRg0ZJGWH61VMpjytA/CVRQLypw0ACKksj4fY9ACWiIyPtEQ+jD9HY0ZU
         59MectskVv2MOGUM1qjbwaGGZeiD3rPp2qhOGIdtEpnE+x387tryDUWZfRDSWEkUZkQk
         0UHeEURmHYPJFx81X867GlgauPfRMAd3NRt95hqD0KNIv/UiyVbZoo8hKrnoAdMoyeTR
         9vafKHY7CDHmRkiE1R/h3MzORWI/ygQCjP3JiEjPf8sgybYnuEKEOxv/btLWQHq6QKrM
         xMbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759762725; x=1760367525;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mRWBKOfnPkiJOVywiDRCg0xI4Cf7b8EHWy3jStgw1sY=;
        b=ouDWpP7YS0bDaL8SNPwVS3u10sdD0bhVjbsUSKyyuHUP2JUBLknkzJ31mNbrBVBq78
         wXqe666bNE30UrtnvpBXlL1RqzNNmpWpmwp9vFr8Kc0Ok2xVpLPfNw0vnnl2HdYpT1yL
         Tp6cp6cMlsGaQGhKkE5FThnGBFPFwLFpiRyvCZCYAKOC3TjoKDW5XWcs1kN2WU9KHeuC
         OmldKzzB7VAwz3GlpMzPdZDrtaFhW33C0gUYylNrvfTj4R0sc540auwQx/Hs573xDxne
         5I1q/ylO/+uLMRw08xx/aE/40eZyb0JlzpLMpwECRL6vJKclGEm37fpMVg6vc5NG+EYr
         NP7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXIMO8kWoPmZi1aY0RmS25mjdUr3VD0RuGKfjMcNXnmGq+orx6GPicsUnXUV4Y7BTi3kzlq94A1WyBG5uZ1K/g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBHpUPnLqOKc0OWNqjnGM6v1VrgcJQoG4Z/bdhdcryTtdK4YFR
	oPxPxh734YpXVCuHFiaDH1UvJnotjD6V9ayjmZcNFb/sSKeAxvOgzeCasb3PKO8MGXnB2m1R4aG
	et4P7gEVPX+kwDF3ZzfFsmqKHw66w0rnsWfAi4gs=
X-Gm-Gg: ASbGncsWmGktio0i/uI0e9k8h02g3Pq2jvURnwouj3cTxflZbWYvfyI0csY6zXYx+dq
	0JeXRW5+iOZZ931PTlnI1VNjZBK0sogqqYSVBqNg7tt5gvZS94ZTNpXf9562zc7uhP3HJuLjpqZ
	tCOSg6pBUkFF1VaM3Ez0VoRv/hrelOVf6vB2yP6o09bUx9XjOdAvZUxF9OFvGW+vc91B8XWHfak
	GwnkzWb2+BwdLM9f1tS4AxOdeIJqiGg0IYSQ+ZUsVyc9mQm2g+yajZsYcHWt4Ojwn+kpQSAhMR4
	MVoghcG4LjPKfq+S
X-Google-Smtp-Source: AGHT+IGuu+5Wd6OFjiLkaJq/X/WOR9QfI5vKL9nQRsMOVVDc7dyv5uX1gb8WLmlPpPld+2cWTdALFvgWWRlQQcoYiMI=
X-Received: by 2002:a05:6e02:2144:b0:426:c373:25f5 with SMTP id
 e9e14a558f8ab-42e7ad846c0mr147878845ab.17.1759762724644; Mon, 06 Oct 2025
 07:58:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924140654.10210-1-fw@strlen.de> <aNRwvW4KV1Wmly0y@calendula> <9a19b12e-d838-485d-8c12-73a3b39f1af2@suse.de>
In-Reply-To: <9a19b12e-d838-485d-8c12-73a3b39f1af2@suse.de>
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
Date: Mon, 6 Oct 2025 16:58:33 +0200
X-Gm-Features: AS18NWBgAZK-FVPL4Gi0VZuQgLyyjTH1Sw01WuawkZzCKh7LvnKGH7BjhjoYtjQ
Message-ID: <CA+jwDR=zBZQYUu_GrhGpsyFLG8TvhMF4rp2Vh1CgxYQwBZO8Rg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6] netfilter: fixes for net-next
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I was wondering whether it would be possible to submit a backport of
Fernando's fix to the affected LTS releases, if that is not already
planned.

I'm asking because this bug broke an unofficial Go library that I use:
https://github.com/google/nftables/issues/329.

If you think that would be appropriate, I'd be happy to help move this
forward in any way I can.

Thanks!
