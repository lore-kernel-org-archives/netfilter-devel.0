Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48CA1A5B96
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 14:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744725858; cv=none; b=fEHDHzk6IEb1VHZjLqOt0BW4vntHCDn20SveczmY5I6Ci4Hlfj1GQAKtabcSrsWa4+RoNJW84d2L19U+luTjLpuy5j9hItOLJSVRskOjgmhbQkiNUSERSMQGmFJpJrkjQXdAJscMaeR8nEVAoltSbkyNYwYtlQ9iSs/CpLMypBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744725858; c=relaxed/simple;
	bh=/UmmUha/roHZFE9FKAQFvcGFH+aG3d9XPdgA7Gx3P+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3SJ16H/SfG0N+PP7dJQo6KnEediECcS9vaq/+78dzfgWMYdsu26hjxDHm2w+o+IvZwM8NZYGxAp5qzEj9HAQ1ag3UG5jvRdCifkDkcSnsVUAcrdz5w0/r6A376cYStBl0onkLBGfGA6DUaYG2DphXmDjmAwPY4tZCx6vmhD1g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MwOvvI+f; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MwOvvI+f"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-736c062b1f5so4672000b3a.0
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 07:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744725855; x=1745330655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/qjm+9+/XxyezAD1iimBy/zvNtPxtx3lGI5kk4L4D1A=;
        b=MwOvvI+fGjScPWKNWrwnLDYSdN44Nw2lZtT7jz67VA674tgNI+Xn8XDn9bovqJFOhi
         rC65jKX9JBqKDGiZ6eSENKC620FvReSla9CGIiM1U2omzAy3JehGvFcSanmW4UjkbtXl
         L/UBAe/CuO0mgihSKMzNQQjegDd0vX6Ptpl+FKB7xp4Tfj0dslzd0jiu5xh6SeLTMtle
         d72Pf65lyCGlmvfTt37WeMgnyPG9NM3mTvSEMiACGpRGHZv0Laj/qOwa/6h7wgzGt1zZ
         Ex+UHUytSxJCc9Q9eYcHwgjU+Q2Rtp5Y4uMdqtgwFOUX/mwFP31kDVItXvAE6I+Yu69U
         ig0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744725855; x=1745330655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/qjm+9+/XxyezAD1iimBy/zvNtPxtx3lGI5kk4L4D1A=;
        b=rz/QuK42Idp2zdMMvjBtVd2Kd31XgT/wuSPamcOKqMH/tjQi6WAgRc5Jt5lUwpjzK6
         mGvhjCx3GBNIKQjTct3t93sEOt7AWY/EmsTn7ZuHATVZwhACchGmwKeLDgwEH8Lg7tw1
         fdqw1ysXm9FFQyOQrn0hiq3Di6uD0z0NB9G3funRy7m2uCHREvAuHRrc3C59ICd5q1+y
         EgKZksPmeUaUuE0WRLoPo1q9fA8Enlf7Fdvi8GCqfwB+a2sHsoqOVL4lcbi7eK79Vv8S
         t3m1iMhHtUBC/7fn3R4puzWPa5z39AMyAyW8BuMazxZlLQf0kJp2Q7h2bI6/18B8bTTX
         wS8g==
X-Forwarded-Encrypted: i=1; AJvYcCUERML0zBbdgz0kvUfCqa0H54wGijXWfzQ27FHBEWmJpE1m77mgODrgGTIo0XsPRRkWO2ihWnxF/gTWyzfhtJs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzud9MQatHbA8AY//EtOaUUIGW0ooGJDwx1Z/umxofJJ6SJ9vnT
	sso37Az7HWME8DeRfS6xM/WDUQQZpVBWpqAVVAClIiMR/cqYTra1s247rw==
X-Gm-Gg: ASbGnctLz9XL/YsWu8z23WDXElx4wNIqkk3QZ8g2GKOI3wxTZIx0MF+fPzw3DSTUeFT
	4lIrR+sq1lUH+hrtzqv6NDVprqkR5oHUO+rDDXwxs7KS8jg+NPJOtCNk+1l+Nt4iVK0SGKS/+d8
	peI5iK9WXQmeDjeB1XRIoNmweAip5MX0u22S4u6auzLJVqVbtAQEt+K2CJvL6xL/y2Ahk6keswt
	wWiZLz9cEL/YRCR4q3YgdW8V/sUOtD9HkETssrl6Eef9Io7yH43K7ETiSepLblHMMqQBpXIpDNR
	CA9DGiZMHd2K7GqelxmZGEOm
X-Google-Smtp-Source: AGHT+IF5CWAIzg5kxxOUmlzDCghwy/f6YbRWYUD23+7WMPWUfhg0r68jhHUuYIpwzN62aQLcYT2SxQ==
X-Received: by 2002:a05:6a00:22c4:b0:728:e2cc:bfd6 with SMTP id d2e1a72fcca58-73bd129e592mr22777086b3a.18.1744725854855;
        Tue, 15 Apr 2025 07:04:14 -0700 (PDT)
Received: from fire.. ([220.181.41.17])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd21949e5sm8502324b3a.4.2025.04.15.07.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 07:04:14 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Zhongqiu Duan <dzq.aishenghu0@gmail.com>,
	coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <horms@kernel.org>
Subject: Re: [PATCH nf] netfilter: nft_quota: make nft_overquota() really over the quota
Date: Tue, 15 Apr 2025 14:03:59 +0000
Message-ID: <20250415140401.264659-1-dzq.aishenghu0@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <Z_2EYV1JiDkgf3gm@calendula>
References: <20250410071748.248027-1-dzq.aishenghu0@gmail.com> <Z_2EYV1JiDkgf3gm@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Apr 14, 2025 at 11:55:45PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 10, 2025 at 07:17:47AM +0000, Zhongqiu Duan wrote:
> > Keep consistency with xt_quota and nfacct.
> 
> Where is the inconsistency?
> 
> > Fixes: 795595f68d6c ("netfilter: nft_quota: dump consumed quota")
> > Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
> > ---
> >  net/netfilter/nft_quota.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
> > index 9b2d7463d3d3..0bb43c723061 100644
> > --- a/net/netfilter/nft_quota.c
> > +++ b/net/netfilter/nft_quota.c
> > @@ -21,7 +21,7 @@ struct nft_quota {
> >  static inline bool nft_overquota(struct nft_quota *priv,
> >  				 const struct sk_buff *skb)
> >  {
> > -	return atomic64_add_return(skb->len, priv->consumed) >=
> > +	return atomic64_add_return(skb->len, priv->consumed) >
> >  	       atomic64_read(&priv->quota);
> 
> >From xt_quota:
> 
>         if (priv->quota >= skb->len) {
>                 priv->quota -= skb->len;
>                 ret = !ret;

They behave differently in the case of consumed bytes equal to quota.

From nft_quota:

	overquota = nft_overquota(priv, pkt->skb);
	if (overquota ^ nft_quota_invert(priv))
		regs->verdict.code = NFT_BREAK;

The xt_quota compares skb length with remaining quota, but the nft_quota
compares it with consumed bytes.

The xt_quota can match consumed bytes up to quota at maximum. But the
nft_quota break match when consumed bytes equal to quota.

i.e., nft_quota match consumed bytes in [0, quota - 1], not [0, quota].


Also note that after applying this patch, nft_quota obj will report when
consumed bytes exceed the quota, but nfacct can report when consumed
bytes are greater than or equal to the quota.

From nft_quota:

	if (overquota &&
	    !test_and_set_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags))
		nft_obj_notify(...);

From nfacct:

	if (now >= *quota &&
	    !test_and_set_bit(NFACCT_OVERQUOTA_BIT, &nfacct->flags)) {
		nfnl_overquota_report(net, nfacct);
	}

Should we report when quota is exhausted but not exceeded?


Regards
