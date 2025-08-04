Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F129E55B
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Aug 2025 09:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754299463; cv=none; b=jv5RAs42ycd05Trto2yPCDHSB0gCccl9/HD7fytrSu8TOQurd5iv+2k9k3DGIW9NR2zEJ8mkIY9M01l/lRYI/65uTaUS4wB1sfEkuQTq3PWOlLVW9/tTgzpTFH96Egh1rkGitNI8S55i/1DxpzALz3+CaPVyBpEtOKbeFtjYLm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754299463; c=relaxed/simple;
	bh=Sg5wwkIpwO+WwAnKiZvq9tbQ0r842RE4/Qfo7SKqz9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CCCvgWO6qwicmV0I5XMZmIMIv5eUAk6hgnU7SQsZzKjlJvZh80JrHBSPl05YUdFVDS6GHQ56rl8PTriIyUE+z5i2jUU/N0dANdx82gX2P0ErwK80vbGSHKPPfycEBpvZ7/7BmLdWa85YtHrZ+WXgrsFOO8udwOb2GDzMqtkSrOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KFvJUsav; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KFvJUsav"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3b782cca9a0so2265794f8f.1
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Aug 2025 02:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754299460; x=1754904260; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OeCRLfRVaak7VS0RXXb9g6B2zUIV/q9ywRHFsS4qx4A=;
        b=KFvJUsavz6mFuK3wt8Oq/m8vvGK6rsWsobI9XjPC5AySXImtBDnkEb2d6jLDxcc6RS
         dHv6qHRYe/ABKLacyiU63Pq9zgcgc8Y3xxHbwJd619+R4o3tpiGaroMyCDHJf/PXdQ1c
         PX/ZZCH+6ut3GR405UuHYydPbUrhM/EEOiVHEKXzIMivBaPycFq5CIycH+z9oVyf42vH
         ktIu48OxzXZvFWoDhHd7Gq2Rs/YHcccB4BLCIwYsjC6Bla4dguACgna5KCCQ8diYnTmn
         7Oh/7PQlThUknOymHSoKxBP+K2oAR1oPKJmXlVgNWUiu1PUmAVJZhyYnQ86jbX3Yt9vx
         dq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754299460; x=1754904260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OeCRLfRVaak7VS0RXXb9g6B2zUIV/q9ywRHFsS4qx4A=;
        b=te1Ktbh1U72vjpv0pgUPMvEZ8G41aeHSSm6ZvBjXKPKQAK/Gw1c/Bs5HBiLpp3IxZF
         bkbjOuOcopAd5D+ss5aaxCqR1hFisKeyadTbf6+3RNBJQsxso+qkLwjOfquCOeJVqif9
         2tw37YVzoGqfIKP7GWeszEYBeaMLLTslW+pA7ZJeFDC3rGzizn1Y2snRy//liA75uWSj
         VJJdBrHq1CKHBAl2OdIsri09qsKwjfy9FpMrS15lg8Veva8MPzw5sXyTJL8Pu2OsgCah
         /KUcbjtv9bBQwHk4j1OomMOu25z11nEmeTEcGKOkUqPybqK+FnHxK77OxIP4vbiRkxCS
         1sMQ==
X-Gm-Message-State: AOJu0Yz6ouiMVIM1MLkShHhEnuyA5g0Och1dZ3B+aCHAi+UhWy1urdDm
	rytxPK1GtRo/RMF6etmysE+rv4656kWpQQd1Hc2qFYsPJefmIT3OFeqp9htMl0pLQGI=
X-Gm-Gg: ASbGncuGgu6RIfPlB5pkFzpiBk+LXoVOHyzpTc6peTFY/JLKu2pZRMmENVFuSoEiup5
	vurNcVDTs8llzMu50gmHfd+xO/JjrZT0BVAMVBKMwJ60vqhcYkjcTB0mJwdG6X7t8OG2Ki8RArP
	khb8vSAOHbxHM1wlk3jhnjrrf0hZOTzpnOIW7gcNkLhvFZKdvJOA1uOxo4Awo2seeg+EpzEQvpG
	im7fjkn86fUbdVZwKqWqe5YC+EYUz9yKYBRAshSY/89d7Wvzd4cK5JNMMtGDt/EOsqSukNJmQRs
	sfn7IN3dHxT/jubjQ+VanACVla1FPxfJNFzfMTK8NldEWBJ8vf27dsFPCbM5TDqlhm22DwtcmaA
	TcjJLxhoErFh5GCKbHGtZ59wfTBa8fSAgSKiGfw==
X-Google-Smtp-Source: AGHT+IHwg0VhUO/EzWGor6qutLGgMblvGtOB0Odx+ueO3jXy20UYBAGnJWJfZ6MYW6EmQXGQ9MAgOQ==
X-Received: by 2002:a5d:5d07:0:b0:3b8:d900:fa79 with SMTP id ffacd0b85a97d-3b8d946482cmr5632079f8f.5.1754299459646;
        Mon, 04 Aug 2025 02:24:19 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589edfcdd0sm159301275e9.10.2025.08.04.02.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 02:24:19 -0700 (PDT)
Date: Mon, 4 Aug 2025 12:24:16 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [bug report] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Message-ID: <cd3b87dd-9f6f-48f0-b2f2-586d60d9a365@suswa.mountain>
References: <aJBtpniVz8dIRDYf@stanley.mountain>
 <0e275ffe-e475-40eb-ac19-d0122ba847ae@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e275ffe-e475-40eb-ac19-d0122ba847ae@linux.dev>

On Mon, Aug 04, 2025 at 05:05:32PM +0800, Lance Yang wrote:
> 
> 
> On 2025/8/4 16:21, Dan Carpenter wrote:
> > Hello Lance Yang,
> > 
> > Commit e89a68046687 ("netfilter: load nf_log_syslog on enabling
> > nf_conntrack_log_invalid") from May 26, 2025 (linux-next), leads to
> > the following Smatch static checker warning:
> > 
> > 	net/netfilter/nf_conntrack_standalone.c:575 nf_conntrack_log_invalid_sysctl()
> > 	warn: missing error code? 'ret'
> 
> Thanks for pointing this out!
> 
> > 
> > net/netfilter/nf_conntrack_standalone.c
> >      559 static int
> >      560 nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
> >      561                                 void *buffer, size_t *lenp, loff_t *ppos)
> >      562 {
> >      563         int ret, i;
> >      564
> >      565         ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
> >      566         if (ret < 0 || !write)
> >      567                 return ret;
> >      568
> >      569         if (*(u8 *)table->data == 0)
> >      570                 return ret;
> > 
> > return 0?
> 
> That's a good question. proc_dou8vec_minmax() returns 0 on a successful
> write. So when a user writes '0' to disable the feature, ret is already 0.
> Returning it is the correct behavior to signal success.
> 
> > 
> >      571
> >      572         /* Load nf_log_syslog only if no logger is currently registered */
> >      573         for (i = 0; i < NFPROTO_NUMPROTO; i++) {
> >      574                 if (nf_log_is_registered(i))
> > --> 575                         return ret;
> > 
> > This feels like it should be return -EBUSY?  Or potentially return 0.
> 
> We simply return ret (which is 0) to signal success, as no further action
> (like loading the nf_log_syslog module) is needed.
> 
> > 
> >      576         }
> >      577         request_module("%s", "nf_log_syslog");
> >      578
> >      579         return ret;
> > 
> > return 0.
> 
> It's 0 as well.
> 
> Emm... do you know a way to make the Smatch static checker happy?
> 

Returning 0 would make the code so much more clear.  Readers probably
assume that proc_dou8vec_minmax() returns positive values on success
and that's why we are returning ret.  I know that I had to check.

regards,
dan carpenter

