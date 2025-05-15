Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D9C1F153C
	for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2025 22:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747349360; cv=none; b=nO1fjBE/YXsTH+pA11eH4LlvDl2ViJ9yiEGbMfJCXlUhfLfnCU+Sg0E4I4jEgP7+6Ww4YteuaKoP4qZOxHjcHkWnWUsalja1cHUDqGq7v625V+Fazy2AWHK/3u5GKaFnFsZUlkw1jzjHcHN8GeGOeJmxcz/bezfGYsfJXz01V3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747349360; c=relaxed/simple;
	bh=wMCPviMa6NpmVScsLU7OrnqeSgQTjpebmvCX7qZvzrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FS4a6EUqZtKHMyVFwqhTsRyg9Msh2qTgT1eY53qN/97pYgeQkPljI7tB81ZoosEWCzPdlejnoUOfvLWfpljYTzbwBkSyaRzIJCtnjFkqRaLC1bCa/7vF23aV4hT6i89OzykUoCvlradRDkBqh3DSMtIsIM6qXd3gm3/nwJVownw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SBD5DkYq; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SBD5DkYq"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6f53c54df75so17923246d6.3
        for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2025 15:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747349358; x=1747954158; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bLoWjLWQrc2nVuQAuvy2PU/MMx8/Ilo7VZXPyacGnbg=;
        b=SBD5DkYqZrkDQInazXr5/XM5iZb5KVh1pakU8iFhUtA/k1TyeT4UNfQSJlvZXhCHTp
         TjkwT3aVXbMjlCHV9VSZsAO0p15qTLGuNu7eGII1z++BaHab52cozCZ99pmtXHExg3/Y
         0t/iyfh2KShkQvcB/0pRo7gwnxExAdAbXTvfSLv7tFBiynQDhVfOcaYdouvwqN+BWky7
         3gC/bQI6DcnG8YxxhsbxtcXI042zyM+9nrkgJ3J+3Wu8Wvgft8VUhf/0Q2RVWPWDBsqs
         ASuwz4ZE5cPSmpX4LusUQFgLXQbknOWHxFCCFh3PXUXbuAOEiZUpMGnCBdCRvqkFlsED
         JCwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747349358; x=1747954158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bLoWjLWQrc2nVuQAuvy2PU/MMx8/Ilo7VZXPyacGnbg=;
        b=htAF7rFMmjjIpUXkVjpuN8896RDxftKhohYU9c6iwbaCBv+rxblIvy99X39drsitzv
         Hy/SoH+pB7GzrSuJaEQ3m4lf1pKK0cQtpoA84ObhPm2LyZ9YyXxr4DqE6fy7hZkaYOaG
         0SE3nWi675nbSvWIeeQe6P9wNOm9WDkB/zTh6MwlETfX13jhu+T7sLMIwmxnfvDzNyDw
         /vaKEXwMbvPLVVPUvXsH6sgDzxZ7F9lAF4TMeVl1ysSwbfCAvheKur7r0sC1TV1JhGcc
         6Dd9T1E+V9NVOV4ZVtlc5qOObcz3mSz3SecnXd+ASx8Fy2+QH4J5OgThJkHlHR2FGkSK
         zlpA==
X-Gm-Message-State: AOJu0Yx92f7asm7EwNx7vDmKstfXHCG/aEGEt6uBBnnUgsriTglUI7zg
	maf0yUxDHFlbOxZcWta8nfagHpAAt1XgLDw4pP4uFtzDMOxbmnxoIXwOMqFskQ==
X-Gm-Gg: ASbGnctkqQxEhs+GBjfywih1TJSesdqyjulP1DW1gHHbbRIssgqR40cYtxId1dzMZrg
	aieZghJ9tafaQrJepSp/+xSZT41K+TemeaPDPk+e/rw7AqAHK8jjZ1fgGB/Gro5el6TleeNxY4H
	iTg20JLZOZxfbFNiRSsjiU/qz8B8WzNWfd48xNh9B+D5yFjZxnyVhph46UArBUF/KCy98ivkKxs
	J+OZbW8aPeiyZVwGdYeC913FHCU+CvR3Atgz94KminFKmDsQKFIGK+zKkKhgS4vZhNv2W0tkshZ
	WnIvpUo8oKo1VJlZVAPrSjNwi9Hq8YU5fBFsD9vxePjzLOdH1xDDYRhjQy/WSWQjqTTLoUYmYI1
	HPb+YDKB2
X-Google-Smtp-Source: AGHT+IH1Slcv52hLuwVoPVo1RbwyPVH27y5FAkfTZzXeUbz3nGa+aOCy7trj3zyXtoeBuC3hD9QlMA==
X-Received: by 2002:a05:6214:1308:b0:6f8:a7c6:22ca with SMTP id 6a1803df08f44-6f8b2c5f2bbmr8270686d6.16.1747349357843;
        Thu, 15 May 2025 15:49:17 -0700 (PDT)
Received: from fedora (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f8b0965aaesm4726826d6.76.2025.05.15.15.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 15:49:17 -0700 (PDT)
Date: Thu, 15 May 2025 18:49:15 -0400
From: Shaun Brady <brady.1345@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Looking for TODO
Message-ID: <aCZva4wbM9Q8ZR6n@fedora>
References: <aCQF1eDdqgmYE3Sx@fedora>
 <aCSF_RwSPS8zkSiS@strlen.de>
 <aCX_D98jCtRuwwoh@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCX_D98jCtRuwwoh@strlen.de>

On Thu, May 15, 2025 at 04:49:51PM +0200, Florian Westphal wrote:
> FTR, Ido Schimmel sent a patch to fix this:
> https://patchwork.kernel.org/project/netdevbpf/patch/20250515084848.727706-1-idosch@nvidia.com/

Thanks.  I'll still take a look at this.

SB
