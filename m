Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5C81FC0EA
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 00:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788393683; cv=none; b=NLt6XVaUNz7EK0ZD2Jl+5dT3G8omxjQigILZbu7VADky16Kba2CnP/of//kQrTH39q0JBqW22sQUvJchzZPHn5XhpLXGBQaglem6TBRARv+dQUrb7Vqjarjn50pv/245SDYasJSWFXNyYmbyhL5KQsPWdPj+eY4uZG6VE8Y7lAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788393683; c=relaxed/simple;
	bh=/ug1Z2+I/7/9KkF0qxyodAnWWFqdK3oh857MdPbdGF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YpisaS/quRGG5SAK9DBE2iV+2e/3W2mmsYvlIF9rL4RZ2Lri2Fgmywx2K77TIN25GsQ0leQ194Dyvc5RpmDyX1A7iskr5TIJINrc/HCUmfO2oLjpCbu74p7xPmrjqtbsg2OjNlasX+mZxWHcOa5x1Rt6RHAmerNrk5LEmPCBc5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ExG1IEvw; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ExG1IEvw"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49b0eab380eso4554845e9.0
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Sep 2026 17:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788393679; x=1788998479; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a+rMgzxIZCYE3X97ZXCU5Wap0gn6wnGpiJQ6Mt5cqyg=;
        b=ExG1IEvwz1/NfGx0A1DKm3xiibNAncJBxjV/szzEurRpLpl0MQeMmFhIevRU7snQL+
         qU3r/R+rxHv1oBa1YH2vYoCA+LnJPI8S1cqy83uxLkDeb9ui1gWeUOE776A3KxuvGO3a
         UWeq2CjgXISye9Ock6U0DBHbRjVlliBFWGgzXAt11MxhCu3jCIDdok2Qe4I6md31LqSi
         qPgAYhWZ+pbZ+G2k6macTL2PIxpYHx135ljzgerT00yspZK4r+PZ+2f8+1gRKz+CSKK+
         qGX/9tpkoSWCwCeRmMQl9YTKywJyBTRZ8ovm/klnQ7qEtW6Mh+LKN2UCBFEQUI8vKoSd
         hiHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788393679; x=1788998479;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a+rMgzxIZCYE3X97ZXCU5Wap0gn6wnGpiJQ6Mt5cqyg=;
        b=eG3u13A0q0HWUyCuZxUvcWn8vjKNF+3p/KKfccnGHaENtrxGgY3/KscCAMMPC4Ec+C
         IEK8r8JS1OuoQXx69zdDoZwo3AYQ7skRHx1Yma6TrhZbMjv8jwpIB3GLqFYs995gdcsF
         FKjZ9TGmxt8h/k7lCjeMU79iMwphFOYnFad8d+eyyWalJJO6whJq+pyN9VcIBkHyABNI
         vfyndGXNxaOwCgsAKKc2zJw/oLMUROQO/mjGYwoXFuyPyHOFvAN/wWfExVForeWWuFCb
         L5vHttnSzjm0YVF8hm+FlYhk6Y3VzRiVIJFumz02AfoQqV+Id1DNR3tpua/UjCNBlQRJ
         DWyg==
X-Forwarded-Encrypted: i=1; AKwUvBweE9tLR2Fa8mPjg3ucOuoTFK5uaZoSa5JCeD1h+T7ODPDIa8wGBOe1Todn2+OrqsiCSJuYJG9rNBoIysK4ATI=@vger.kernel.org
X-Gm-Message-State: AFuF++nxcXEzUy/JwaJxiG6OC0Tfu0by7/7dxkTjTraTPnDMziJZqN6K
	/i66WGnLKFXDXszaj+XEPHytGLGxs2Ygz1xUv3UZAp+DhCFC7mMbH764
X-Gm-Gg: AYBFou3fgtYwHYDOzlYm6khRhwkqYLMfPGZpMTHpIGJddPpgoBmGSebSXLT74Vg4CtR
	1Ei2Dii3xJyl70NlgDu24gURxpy/goSdT4+luXkYTsa68qhdkQI5K7hBGtyzp+7gxCbn4Umk2wX
	vKxMM7vg3AnRd5KNEXuA+bpafDksxb7QD6l737FYo2lux0EMHeJQSBo35Lvg3o2zzf699eS3OGv
	iAa9zcbVqTZEOuWZI8GgR4XPvyoHHwe044L3L1JrejwG7ht3GR9Ka4Zr5hidWB1w+WXoNl9a1uj
	2rHjnQoAoSKlHlTtysttN0QS6tUlBI/V0bsimlUyj8bnVmBnXMXwujn4RwTd+Oaqb6ntos8Li8G
	v47DxkXU9Jgs59yWboI8KCWV1auQlp2TDEnG0qoweXhNTK3czlmBrqAWRshke4bTveAZ5VtIW9p
	9Mwr1rwXGWLR5GD9FB2Ir9OplIt3h3mrIzagKR3AuMCiNaw9bl/b034hzgFoeisOSwA7Frcq2Y4
	/MCWpLNnSz4PfUqQy0qSYnttakuD7nUh6AArERfT/3v5o1iJEumbj3EYPL+3Q+013sA+v9WPvWP
	UVB9y0C1gyYcF2/etCO1vMdyAxk++I7P9XyGtutUdIBpDv39O1JCe9XQp8ArEQjH7GEpLXI5se/
	+bpvi
X-Received: by 2002:a05:600c:ac8:b0:49c:f13d:ffef with SMTP id 5b1f17b1804b1-49cf13e05ffmr2151795e9.19.1788393679115;
        Wed, 02 Sep 2026 17:01:19 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a1c2-c401-11b2-c123-0d12-6c0f.310.pool.telefonica.de. [2a02:3100:a1c2:c401:11b2:c123:d12:6c0f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-484492ce5e5sm9115290f8f.36.2026.09.02.17.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 17:01:18 -0700 (PDT)
Date: Thu, 3 Sep 2026 02:01:16 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Mukul Sikka <mukul.sikka@broadcom.com>, Keerthana K <keerthana.kalyanasundaram@broadcom.com>, 
	Stefano Brivio <sbrivio@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>, Bin Lan <lanbincn@139.com>, XiaoHua Wang <561399680@139.com>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1.y 6.6.y] netfilter: nft_set_pipapo: restore cloned
 mapping table memcg accounting
Message-ID: <api29LfuC8U_RRUw@gmail.com>
References: <20260831194905.45045-1-kmehltretter@gmail.com>
 <20260902-daily-reply-0014-pipapo-fixes-tag-ack@kernel.org>
 <apitu8BYUvG-WJt2@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apitu8BYUvG-WJt2@chamomile>

On Thu, Sep 03, 2026 at 01:14:03AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Sep 02, 2026 at 06:14:13PM -0400, Sasha Levin wrote:
> > 
> > Whatever Pablo prefers :)
> 
> I am fine either way. I just got confused with the double Fixes: tag
> that point to the -stable tree commit hash (if I understood correctly
> after Karl's explaination).

Thanks, I'll leave this submission as is.

If there's a similar fix in the future, I will probably split it to make it
more clear.

Karl
