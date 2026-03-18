Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A02C32F742
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2026 15:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773848825; cv=none; b=Lez+M7RouhFluqjLQntU108T50UgSCx5DiRXrH6J2d24maFs7IryJSn0mgdaZBEvR3gwbESz0CPdZPPvn+5xcXrvXm8piXyYDE7h+fkwGaLscslyWp7PXemnOArqGugcs81YJQmCil4UVJeV3ZaLbCqsi1upjf1C7knoMb4mTUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773848825; c=relaxed/simple;
	bh=NMASCyNr78hVZF++y0WcFniLptR1hor/t1Z7DcCR6lI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hM8v25dr3a+ZoqDlD08ycn9xGupj0g2NX5K5YWTbY6Yb/n3NA5PWYpxkyAQ2QmqSTuaU+dITuiTRF7GaXdFrdCK6HzCi1k4FKWQIpu97DVpfKdQad0eZNHcOOKkWStX8B37VSSc8HAXzPIePxmN/7uF5Fg7G9B2YoqJhT17/JTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=Aa3WkMT+; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="Aa3WkMT+"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2c0e3a2605fso106877eec.0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2026 08:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1773848821; x=1774453621; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uPmEzJ0VNTQ3ggqObd/FQhZq+HNjL3FmdQs1CRMIpkk=;
        b=Aa3WkMT+GDf0XEzorgpFOjFGDWt0aC05CBHEz1dQeIfaJbVNzaISHR4dO34h4D/O7U
         slgrCFPjAJCemEOiRSlwIs5BrzusgrTp+356BfMPjgYsDxyFSSN+w+KRxoQw6yiD0zhj
         9eLXwandTZ0fPrytNeKCXOMZQsTBOOdCihF7wyrL79FRKaVc6ETL+6snsRinCVnABWOz
         TKQfVXjOP5kXJT0oRm/uH4Ith/j9LDvwLRV3QVqpTknoP53dWVIjnbrjVsF18cgJXCUa
         Lw62oWi5af/z/VrBngeKyySumkbdiLj9aftI5KkWTaR4dRR3D+mtuZ0OyK9eIuNW+Lfn
         nnBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773848821; x=1774453621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uPmEzJ0VNTQ3ggqObd/FQhZq+HNjL3FmdQs1CRMIpkk=;
        b=WzsgF31dxOs8dAORJbcTgrAZem9B1H8abI9TdrEt6QAy3fwPgUUM1z7/HFZCvxkx0P
         ptJj1cw886e7nK8tpXtiIvRz2onJp/nSXOrueZGPxpihEDmOIoZAPNpjjAOhmKbrYhWC
         oSt3kGGiD9e6vlndIPJrDzRyMlycS8KW1UjOz1h6Un0ODO5dirfvMX96vyJO4u0V4YFK
         Atj8UhQNMUYtyvH8I6KGiLwhIdQHd7+JQwb009OnvIKopzbyYqKkyJ+H2gCKKc+5iXt2
         0rQBijYKc8Qxoj5L9gO5O/zVFmpZaDc/EcMdJMJfgIQ7tjIMhRJIvr+e1o7BMhnT/+/y
         InUg==
X-Gm-Message-State: AOJu0Yy7LvEBBv8gyZWhYTV5Ei00XAYCPhScYujxezbNqucv90hlfMp6
	jSwfK+GRsDw5ycGrv5u0KSNDT8UIdB9f+ZJc6XFqg0cTttFZoZNUmjsfk3pc/ldUpYw=
X-Gm-Gg: ATEYQzyuJVLeb2MLDMvemIx/pC4nfGbHkIQ5RAun+AEo5d9k1RZJrgWR/dI/IapRF+N
	47GU9gjFOCNQdTRsuZRRTjLUl5/1VCAOxPxSWig6btpimmy5T5IJxSKAuhZcayltYUCRiNKbo2e
	df/X2m0HmKveWCop8boEGynu+Zki/Xg1Pf5GCsmSUiImBN7OS5f9Wb9neOfCChgBx5hvOfC1m9u
	oKaG4w6DhHn1ApSCaHl4Ff76Pl9jihHuobNmMf2xtuDVyKSuDKkh7xXZHlsL/qqZGHmw1U5gxEb
	88O4ptGW1RoRhas4KkWq243nCsZrWeKLh90qTlLiC6fHPTDYXJs7nrKWW/GfI6ZgoeEJxWNLPm0
	K2PfVLkW8+UV4AIxQ34tNTfyG1ZBV11bQTxt//tbDH1D9AFy+4yFAP8aT9/+8s7fnvIccyUrnJp
	ydqbUqy1Qd/1gsZTo=
X-Received: by 2002:a05:7300:cd90:b0:2ae:55ac:3ff6 with SMTP id 5a478bee46e88-2c0e4fea972mr1783239eec.1.1773848820730;
        Wed, 18 Mar 2026 08:47:00 -0700 (PDT)
Received: from 20HS2G4 ([2a09:bac1:76c0:1460::e8:b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c0e55a489bsm4561693eec.23.2026.03.18.08.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 08:47:00 -0700 (PDT)
Date: Wed, 18 Mar 2026 10:46:56 -0500
From: Chris Arges <carges@cloudflare.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf,v4] netfilter: nft_set_rbtree: revisit array resize
 logic
Message-ID: <abrI8CZV3c8fi9x3@20HS2G4>
References: <20260317170721.12396-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317170721.12396-1-pablo@netfilter.org>

On 2026-03-17 18:07:21, Pablo Neira Ayuso wrote:
> Chris Arges reports high memory consumption with thousands of
> containers, this patch revisits the array allocation logic.
> 
> For anonymous sets, start by 16 slots (which takes 256 bytes on x86_64).
> Expand it by x2 until threshold of 512 slots is reached, over that
> threshold, expand it by x1.5.
> 
> For non-anonymous set, start by 1024 slots in the array (which takes 16
> Kbytes initially on x86_64). Expand it by x1.5.
> 
> Use set->ndeact to subtract deactivated elements when calculating the
> number of the slots in the array, otherwise the array size array gets
> increased artifically. Add special case shrink logic to deal with flush
> set too.
> 
> The shrink logic is skipped by anonymous sets.
> 
> Use check_add_overflow() to calculate the new array size.
> 
> Add a WARN_ON_ONCE check to make sure elements fit into the new array
> size.
> 
> Reported-by: Chris Arges <carges@cloudflare.com>
> Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v4: use maybe_grow: goto tag instead of grow:
>     Add note in commit description: "The shrink logic is skipped by anonymous sets."
> 

I will be able to testing this more in depth early next week. Just to confirm,
this patch requires this to be applied first?
https://lore.kernel.org/netfilter-devel/20260307001124.2897063-1-pablo@netfilter.org/

--chris
