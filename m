Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4903B3E274C
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 23:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218141; cv=none; b=L1pOzSXGpOea6gQVu6ooRcMKNdZSWrF4zWaKrC1VUVH00yBywRvcbGCZcxzE1z02exvF9mYwe7D/3kC1A2to+NZuWuEtR7Pa/MyJKYhzJBWbRanJVebPqeNdzR+Afnz6AYIkjXNMA9ljs1BeL0p3jC1nL6kvql6TxkzTQGcDhrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218141; c=relaxed/simple;
	bh=nLjNT1G5JUYYPrhknY0eB9x0ZjckXKrDo9yhKokRjVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DhHiJsMWUXmkQ9Hknju+FuS9KefZF3IeVtbFfLJAGJLTQPxvIXx/3QgXAhPP+34yQ/ayklXzhgT+2hTbZS8F7YO8Pv8cZLAd7FKlElZuuIetnLLGOLWT2mJePAAFVLtRorZe7PUt6TYyrZxe2x7UV9f+27NDEajuhPwnrfnHI4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NDowiLX+; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NDowiLX+"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-495437bb891so3640345e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 16:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788218137; x=1788822937; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4Cbbg1ZOVRL0U5f2uy8yCobIVDqIxQsXjzjOSTe5SUM=;
        b=NDowiLX+9lFsVlgSpsbSBI75OdoGWkBcd3+W3sPqomHUJpEOngiZS3JDPCNK1zCk4D
         PcT9p7Nna0HxKYETKWidlLgKKejGVXkefLQCYsmapqoXMMXjOwnN/bL19XZlsyqt44Ao
         iAzD2ha+jTDygPTOv/mws4TcV37rJ4rQJo+0hg4NJn5xqvKQq9rqFtypGeCFvGNYL9yf
         wL4rQSduJCopY8p2S0Oet+5tRnKQoH5kWpK4ERvz2J53riqnNK6rp+mSgeWsn6KLmSh8
         4LbJUyeF8HWyWUKI6vTvLDaOC2J31Wmjjr7D0Bvn1WXm3mFpepcxRKG3saI/T19WDCC+
         VQ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788218137; x=1788822937;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Cbbg1ZOVRL0U5f2uy8yCobIVDqIxQsXjzjOSTe5SUM=;
        b=R++PAgL+dtCPE5vYf2NY/XpyE68zh7NnmD4QpK09j2SIWx85RjHqzbo5zISJA3O4fi
         er9OoS/URw7CbVZI6M2H1Beb06YUlGsNBDBTKMTNfB+Qe+08dpDX5zdZks0fx4sn9M9j
         brfUsuSY4TbfRgekzF+P6bRef43TU6CamnGbwuDAuofYSevoVhUL7a0/Zx0R02Fs9hhl
         /F2cd0xvBXimtcZa4OtSt3/vMxV6Lop/w76AWSLmIjhjIZvJyOnQ8K7hKBt6ktM15ZlD
         KnqLBLqpwH2CapWFxnsa08NvSuJrO1RE1H/4ibqLrxZwPCuvR8V9JAsdQp6mLa2KNRsn
         qTrQ==
X-Forwarded-Encrypted: i=1; AHgh+RrW3XgDXjo4UN3LbOgcB3cTYeeTeKFrEWUs3qc9x10Dik3agMdD+uXNtNfPHoosfhn7C3gM0hR3bfu0oLJr0Pw=@vger.kernel.org
X-Gm-Message-State: AFuF++n9fgKHHzzDPG4vy4zEsbswIoxGSYldDLz8D9RCz311QZ4GGNvQ
	1eFMa4/1SvzYijcAVp/QKXk6T2qwEa7XM0qJMH6ejK3VBDzgmXeUKxM7
X-Gm-Gg: AR+sD11k5s55I98h9KQat6LOpJuDlvkvyaHLdA/nQb9ZaL1Z+keXlvPHnzdg4QvruqF
	9AzVSmUo3tvbssz0BEcYUTwiqUyrZQZgncnxSO3tSbDBbLqMQFTAcjxqCz3nHhIS8hXlge6vE0U
	DAvkw3w0fBjUKNaFhXB6t+aKEDSC0g77JLutwJ404lbxqi9e7sfDrWsKxGtCh6fuGAw5o73lP7E
	T+2DfOhnkzT4SZxL1zpeuHNL8LktoC48IjxoMsAFcyDa5SNyjsmDB+CRcAJhep6GdWHWr2ts40B
	Jt6VnRTr6NRvVMFoNH/cThYx9n/5PpiPe7lSLK0/U8Z/PsDGEnlqi1wiSoTaBZSCh/o7KiUNZDz
	alEF5Ihg3aCG1qIikAxmdrNTLzHk4SZivEo6qet7IFtyfWXrZGD6kFT2l0Yrg29hEE7f42+2ld3
	/eicY47MGQZawidQpD3sXM36e0PInWB1/6gDJ2e99/g8ogD6enARn5+NmsCfQ4mnli2GXqwTQuL
	0gtbLm5TsT0KOL+xwg0kpPjlHH6oy0CU5iBLaQ/RTauSax24k1hnNiYyjOg5mxjilpAPCVkJCRf
	Ll9JUkHM4vPAcCYVcbEiKQjVDuno9PCmtxVYnu8jFudqqEXXBpzByR6hT4lqn9U=
X-Received: by 2002:a05:600c:6819:b0:493:f783:c46a with SMTP id 5b1f17b1804b1-49cdd41ca5amr23361785e9.6.1788218137195;
        Mon, 31 Aug 2026 16:15:37 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-acb9-0201-68d0-34d2-ad1a-175a.310.pool.telefonica.de. [2a02:3100:acb9:201:68d0:34d2:ad1a:175a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48442d6e9cfsm957147f8f.22.2026.08.31.16.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 16:15:36 -0700 (PDT)
Date: Tue, 1 Sep 2026 01:15:33 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: stable@vger.kernel.org, Florian Westphal <fw@strlen.de>, 
	Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Mukul Sikka <mukul.sikka@broadcom.com>, Keerthana K <keerthana.kalyanasundaram@broadcom.com>, 
	Stefano Brivio <sbrivio@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>, Bin Lan <lanbincn@139.com>, XiaoHua Wang <561399680@139.com>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1.y 6.6.y] netfilter: nft_set_pipapo: restore cloned
 mapping table memcg accounting
Message-ID: <apYKQbvpIWvY8Jqi@gmail.com>
References: <20260831194905.45045-1-kmehltretter@gmail.com>
 <apX9AZoNkpVrBMIE@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apX9AZoNkpVrBMIE@chamomile>

On Tue, Sep 01, 2026 at 12:15:29AM +0100, Pablo Neira Ayuso wrote:
> > 
> > Fixes: a4983e89e3b1 ("netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR")
> > Fixes: 32bad10de347 ("netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR")
> 
> This two Fixes: tag do not make any sense to me.

The two Fixes tags are for the two stable branches:

- a4983e89e3b1 is the 6.1.y backport
- 32bad10de347 is the 6.6.y backport

Both backports changed this allocation from GFP_KERNEL_ACCOUNT back to
GFP_KERNEL, which introduced the regression. The accounting was correct
before these commits.

I used one Fixes tag for each target tree. I am not sure what the usual
preference is here: one common patch with both Fixes tags, or separate
patches for each tree. Which do you prefer?

Thanks,
Karl
