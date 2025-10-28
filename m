Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04032344047
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 17:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761671428; cv=none; b=ZaaV84494t4ubURC7Ek4+YoclYjnRwo44MWv23NRB8wceloQtDjgIgPT6NqKjsACuKtFzRViEzOfFZdphPV3zJoiqeAfOCX7e7CMTuJe2EcfnKZjL2efZn3hMZLhEoLpp8hh+Cb4d/vRZHU4Br0OG74wYQFOHyxMIjLfpiZEmkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761671428; c=relaxed/simple;
	bh=m3I9dtve6TdfQpeD/5c1k/FwNdSdObvUw7hMoEvNVYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=In6y0fKyQV+k3dcQVPu8fd6fBMpBY3l26LRWndhcBjkyEM4vTYR4sCOafIcLjb0UDjyIFbHTsm0ekKo05Exq9UR3CrAztu5SOYwa5EJTeZeRBXvqRXmCs/ON0Lnyl4DDLo6XjczfEulQxzzO3VvkJMpgFyQDGiIBc6MKDOXsAZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HeRHG5qE; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HeRHG5qE"
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-292fd52d527so63598915ad.2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 10:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761671426; x=1762276226; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NkkeBtodNmN2EMa9qJLybudRjmngQqkOpn4I47bN1Os=;
        b=HeRHG5qEN5uTjjY3ibkWq33IiamipujAhi60b9r1rM5RRPJZix2+MocaWLMsgNdzzn
         rCRaFyrKnHeUaypQDn1k3K/dqscVruRVqMTp+igbGbC+db5aiAfFYeE0f5PSLqzGly0B
         Ovbu07ITP9IM/2fwN+YgCr6l72LfCsLXcf98t50rQ2aT51I9i9QHnWZBcPUJfgmI0dRC
         hcDVe7L3na0X+uTihwIrNh/OF7NNAdsSDaUs/thpRtSEuaO3pAwmuCxPhAYF4SvzmzBq
         +g5mLWYTq+KRd+hIVppWWv9JlGPQ/3UNy/vJ92ZwMl4d1BKAHGUXeTSQGuqNK8db6i73
         GIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761671426; x=1762276226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NkkeBtodNmN2EMa9qJLybudRjmngQqkOpn4I47bN1Os=;
        b=sUkJFYCRksEkHdEtxuCvVGEOUjDgskktCVoM8zl3YCSvkukcFhTnNMbAmfrzQKfkQH
         Vdo7N+Qe78196VCACQoIw/z3rlZ7z/tbnZwbsskPnoBL969bQPoj3oUxS1rchwIoJFtf
         ReaBsjQ9OyklikAXLnt/47V7es1tGDNy8ExDCHoEnga3qPCD2nbqB7wPXpCbKPO3owyj
         Ks7jVLL0Uou9ENZ8fXYroS6lr6mudth3nSa++tBypJH38JOpzwjBsK6ZDC2ssu2vyC15
         7rAyL3ul+iVXqfqAvI9qhQHvLxlmDHmZKYGY+rFghsBizGkCcAJ6hAGi4bnBZmPHo5Eg
         v19g==
X-Forwarded-Encrypted: i=1; AJvYcCW/SU+gOExgcyxS2AIOHnhdMhmg81Vk7h4+cWHSDTfJuJM2QuGUfxPrQGqwcnh0djwljDMY7Ol11/y/3c+PuDc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIM5h253dC1tWJ/9cKUz+uJW3mjcD326W5FKPjGFKl/Jq3mm10
	lpG0sq/JiRiZ129dnVGe6/Vcyn9O1vshYrzJx5boQxUySEcvMGPAqEMD
X-Gm-Gg: ASbGncvZPijO41J6qj650jLiDc6Rcvz3ba1aMNZOQIi8IFuVu+Gblnoz1BjiLMgBwsv
	ypaMqPYj1dZ9XVb/BDwi3wEJXaplAlFhZjIr9rIi5QOz1dfUlDVWyc+u7UtLLwD00xoGRFXeEAM
	3KYeYmJJpLJIlxSn0Yguchr3ibphbffyRD6k91vPj+KNyP0IVXTblquMD1ne/cLSk60CXdnX/mk
	rx6zkGVJiVHVDuV4sJW8zcbD6iP9mJH3aeSqmdC7A3pji4PdM9gilW+QX1bPIyZhXlw45wfVKPb
	ZcCx2Ow7eMzl1LJs+1f//+gbXOEgvegfuZukAPVr+NSydOo68qx59cw6zFXljWq5d2mNxTcqtnT
	naccYYgbt5vk7L95agCh1Y4DZzai2un/bICQKaWiojgNyJ/ZT3CyFvmi0Cup2fO6TTbnpVnDdLz
	azmsHTmJmyn63YJ52PeCg=
X-Google-Smtp-Source: AGHT+IGQ8ffNexl4HmIkFUmg1fdyuZl4JbBMFVH6xuxPDuvHwL2uHadtShWy1RlMi1Xof4Eda3TnCw==
X-Received: by 2002:a17:902:ec83:b0:27e:ec72:f67 with SMTP id d9443c01a7336-294cb391897mr51139475ad.6.1761671426009;
        Tue, 28 Oct 2025 10:10:26 -0700 (PDT)
Received: from fedora ([103.120.31.122])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf3bbcsm121911965ad.15.2025.10.28.10.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 10:10:25 -0700 (PDT)
Date: Tue, 28 Oct 2025 22:40:14 +0530
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
To: Simon Horman <horms@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftest: net: fix socklen_t type mismatch in
 sctp_collision test
Message-ID: <aQD49ukK0XMUHTUP@fedora>
References: <20251026174649.276515-1-ankitkhushwaha.linux@gmail.com>
 <aQDyGhMehBxVL1Sy@horms.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQDyGhMehBxVL1Sy@horms.kernel.org>

On Tue, Oct 28, 2025 at 04:40:58PM +0000, Simon Horman wrote:
> Hi Ankit,
> 
> Please preserve reverse xmas tree order - longest line to shortest - for
> local variable declarations in Networking code.
> 
> In this case, I think that would be as follows (completely untested).
> 
> 	struct sockaddr_in saddr = {}, daddr = {};
> 	socklen_t len = sizeof(daddr);
> 	struct timeval tv = {25, 0};
> 	char buf[] = "hello";
> 	int sd, ret;
>
Hi Simon,
Thanks for your reply, i will send v2 patch with requested changes.

-- 
Ankit
