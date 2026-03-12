Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AE9367F53
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 20:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347710; cv=none; b=nCdoOgswFFc3VwSD7+v5buO+54qCXik2k3RvEVstUU4W1sGK4rAl18f7W7a3eU9Va68Hc/hhZOb8pcFyHR2ZMhMAxbV3KUI44exyCCg0cN0yEBEOtScVqGTrIXjje+0D2VO6z5nSvekrBY4ck6f07mgJdBIqAnHn8VQVCNGvIuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347710; c=relaxed/simple;
	bh=PCph8ooVcjJu9IOl+Kjjgu/fLSJ6MQr8MA29G0K6afI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cT9cDv9fHQe+STT9rme/BMCzE9mlN4rdY/FArxSAcmIO0KdT71vbQQ4ftkZpBP585z0LgbeP4GWGy0r9w1YF10hnFRIywSq83uH1LAEpRtbG3xCgkSfoLvbvI7I3EBYRRcsc572EQ4B91XoZvsnTLcv7BtdBMIh+PrHoPMtRL8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=fhlFua7Z; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="fhlFua7Z"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-466f935a82fso1011633b6e.0
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 13:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1773347708; x=1773952508; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CAAvxziM3U6eepAuJhCiC5rWl+NjjgbbEgcGcSdOuAI=;
        b=fhlFua7ZeUQxA19e7/ynOvW2ZzD1v7W25LelsC/KxkaJxZ5dUx/QdsFLX74Lx/TfLj
         9mAHylCzFjGa4PG9+cM10bl+IL+W3BAgydoUo7jde1YjxjSJukZBhSku7ok+9y8uBBdL
         PXm7e8X4wsBKRORRt9AYVGu5JbEDiE/ePHE2Rtf66aCag0FyioWj5rLVm/iY9mJhMGUM
         EAirHG8Zp9VmL4oJbYrUdj3D8kzrMawivFMZ9mtoJijFU1cNTh+9j1UmSpUSH9ikFWdu
         8dsWvxbySfmzln9uNMdPAC5RtrdqWeHSbJ5jAzXbMNdXr+fmhMS2MowzyjqTw+QNIzH0
         IUUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773347708; x=1773952508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CAAvxziM3U6eepAuJhCiC5rWl+NjjgbbEgcGcSdOuAI=;
        b=SBjlP7XJ2+iah6SOOuyM1EYzbKgrsSCnYNM4yOcNmGnT2dj2hf9N5HGP5rJXI5b+UQ
         ZsBGI7ZlPDoVWdg1BNAdkZhY19Vpqm/L7rM4h6l3Qpi8mR5CMq74rFdZGjh1fA+L9jkp
         QUf6rA15niDyXCC4AiEIzTy2WVqU3FbbMiKGpOcPu3t+V/2uWsy9NDFyw4Yg9GFvxSm/
         uhUED0VuXYhfc66gQdyxYZdAsNxRMeoNli1Pu4eS4JUgMIFodV7nv70T9TI7zR1XX3uM
         bhcfVR11Ch4y23Gco4coqer7ovY24dmXGhN9Y6dVR7/3FhueVjnOhhrXU40EanasXGxL
         pjig==
X-Gm-Message-State: AOJu0YwiDnc2sh/JbtdO/M8tEenscsd1/qJruMTBz7K+sGa7xIeg8OQZ
	zV8wHqtYnMrM8XJC/bT371gWZJjSsd0GiQOiHXELySWIQqClshzPFF699ZvWJsT/KPQ=
X-Gm-Gg: ATEYQzzo3PNiUK0VXzGVMdHB0eRmhZfCW/YceCaZvSye3sEiB7VjR8X4xnereVpZFkJ
	u8q55ceIKABbrHUyUAg9VrH1PzsgsIgMcCceehDh7mdEFE5k2DdjUtksKOZ8w+hk/+nLrj0nAWH
	LGtBemq5eL61sKKz/Wj9NWB8f/1E+q+6o5cpvCx/a7yCx4lsF7yOEIhb3FmYv085V0QgN7+RCas
	yZnDQ/RvdjDynTCfBRw/Zf6/1VUpLi+jGzXmS4slhYS/wEmhTpdtwrUhoogO4fV4NtucChA/xgv
	It49NAfxC0ROzTF0POqwydujS+r7qIZiHiv3Y5UisfeF2a3w4Cb/JlhnLOyYGxTjaJKD59+20+b
	tPxzyNsfhEF+gvtko2W0xyWO8VxNwhq3bkTEMLWL8tTUzgCNy7c6KP2crireZwQmONspsJ/N7R0
	eWNuMTXg==
X-Received: by 2002:a05:6808:1185:b0:467:15ad:9df0 with SMTP id 5614622812f47-467570a20c7mr393439b6e.7.1773347707963;
        Thu, 12 Mar 2026 13:35:07 -0700 (PDT)
Received: from 20HS2G4 ([2a09:bac1:76c0:540::2d4:51])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46743aca62fsm2113020b6e.2.2026.03.12.13.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 13:35:06 -0700 (PDT)
Date: Thu, 12 Mar 2026 15:35:04 -0500
From: Chris Arges <carges@cloudflare.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: revisit array resize logic
Message-ID: <abMjeP3jMDa3HE81@20HS2G4>
References: <20260312011423.3492328-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312011423.3492328-1-pablo@netfilter.org>

On 2026-03-12 02:14:23, Pablo Neira Ayuso wrote:
> Start by 8192 slots in the array and expand it by pow of 2 to simplify
> growth and shrink logic.
> 
> Use set->ndeact to subtract deactivated elements when calculating the
> number of the slots in the array.
> 
> Add shrink logic to deal with flush+add set, otherwise the array size
> array gets increased artifically.
> 
> Reported-by: Chris Arges <carges@cloudflare.com>
> Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Chris, I'm posting this patch, but I am not sure it fits into the
> scenario you described.
>

Pablo,

Thank you, I was able to test this and here are my results:

* v6.18.13 (before nft_set_rbtree patches)
Slab unreclaimable memory increases to 1.4G then levels off.

* v6.18.17 (no patches)
Slab unreclaimable memory increases to 4.9G then levels off.

* v6.18.17 + this patch + nft_set_rbtree: allocate same array size on updates
Slab unreclaimable memory increases to 3.1G then levels off.

* v6.18.17 + this patch + nft_set_rbtree: allocate same array size on updates +
 NFT_ARRAY_INITIAL_SIZE 1024

Slab unreclaimable memory increases to 1.6G then levels off.

So looks like this patch is a huge improvement! One modification I was able to
test was setting NFT_ARRAY_INITIAL_SIZE to 1024. With that change I was getting
a memory profile similar to before this patch:
- 7e43e0a1141d netfilter: nft_set_rbtree: translate rbtree to array for binary search

--chris
