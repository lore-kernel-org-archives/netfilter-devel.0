Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0172319DF68;
	Thu, 15 Aug 2024 09:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723712651; cv=none; b=Z0oyjamUQlB3W1QTzjaodCPwUhqfLSC34/udDbfecIevEhmZmiY048m8MghTBLRCzvozRSEWJRdkOkuTEmKGYNuBS8Avp+49re6t0ae1bIRZdDP4XCto1Jjwzn/MYdFRj79mqGccHlDP4nfmDxYrF+aGxUeTuow2L1V0P2Drgng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723712651; c=relaxed/simple;
	bh=Cy92Jp84Df9o5H0KPaXA6rhuX88LhcChTDxIsiUS+FU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lmXuCX2UJYOsa3X2fiTekWm41wIIsgJrBbEGDIcivr7oaVJYYCz/U7qzpa9oul9srN7pT3ZqTcCKx+fgZCOg4vGaz+v6h87U6i69+B/hsVf4wjbCNsz0cEG+2O3OPUfYKOeB91qgwYu71WtzEtTSUK6yWTrhvo8RRWShL/8t3m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2f01e9f53e3so11039821fa.1;
        Thu, 15 Aug 2024 02:04:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723712648; x=1724317448;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GGdA1uTAZfwjQPOwAEugx2cuORuo6xK2pemc/JdMcEs=;
        b=NfVTLe/0weUHYFQGcaouRf+JHCXzM5ogrTYw05eaWi/vqeMZJvatibAkWk78y/am2r
         LZOsAdO3BHf8YP5dDz0MyAgsHSkrGm7YyY5SFf24LA0KAFHXTH4GFgS0FSNYl7q70/wb
         0frwGBQqINqwfr01EIe69wxpq99haZMoN2gIqs+4/731yWi+KW8k4mGy1kjoZKyG5NFQ
         NtFkPxtNn0C1WBWNoFNIp202k9xa2G8+tz6utdUb69XT9lkfH1L1avqGs7Vz3ToeBlr5
         0LDjw6b+NZpq/Z7bwEUbw5Is7vRDpGpMnyD0683LPrs6BCOzB9bqxhObjtZNHN3e/UOK
         Kbdw==
X-Forwarded-Encrypted: i=1; AJvYcCXJVxIpSp+QrD73yfs29leNg4ArhU9M2Om8h+yjjJAIdbu9vHyJ59/Fhd+bIB3D1go+9InwCmA7CqybhLSFTEvci63o5Q+0wHg9souLYljpTYs6nkzvDOW5RyWLvjr+jydN6fVRgTjCRUx9miXYuaWaG2VHAi4Td2Zv2BwZw2iH/GA6WMro
X-Gm-Message-State: AOJu0Yz3nY9noErHw0vIfyy/H3qjVJfzn0FZN5DG8uKLheFowA+vZ0ZZ
	HRNSh0p+OUhrwjP/qheI/ZWVK9XNW9p5uvLuq97I8i1DNXzyFWYV
X-Google-Smtp-Source: AGHT+IGEOchYHmiCwd/DoRSgts40Fxyf+kMc/9VZZdbawHLe55tHQbdSBvwegPU1kWP2Jr4dfG0TsA==
X-Received: by 2002:a2e:e09:0:b0:2ef:17ee:62a2 with SMTP id 38308e7fff4ca-2f3aa1df04emr36835281fa.14.1723712647572;
        Thu, 15 Aug 2024 02:04:07 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-011.fbsv.net. [2a03:2880:30ff:b::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838c70afsm70871266b.15.2024.08.15.02.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 02:04:07 -0700 (PDT)
Date: Thu, 15 Aug 2024 02:04:04 -0700
From: Breno Leitao <leitao@debian.org>
To: icejl <icejl0001@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nfnetlink: fix uninitialized local variable
Message-ID: <Zr3EhKBKllxigfcD@gmail.com>
References: <20240815082733.272087-1-icejl0001@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240815082733.272087-1-icejl0001@gmail.com>

On Thu, Aug 15, 2024 at 04:27:33PM +0800, icejl wrote:
> In the nfnetlink_rcv_batch function, an uninitialized local variable
> extack is used, which results in using random stack data as a pointer.
> This pointer is then used to access the data it points to and return
> it as the request status, leading to an information leak. If the stack
> data happens to be an invalid pointer, it can cause a pointer access
> exception, triggering a kernel crash.
> 
> Signed-off-by: icejl <icejl0001@gmail.com>
> ---
>  net/netfilter/nfnetlink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index 4abf660c7baf..b29b281f4b2c 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -427,6 +427,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>  
>  	nfnl_unlock(subsys_id);
>  
> +	memset(&extack, 0, sizeof(extack));
>  	if (nlh->nlmsg_flags & NLM_F_ACK)
>  		nfnl_err_add(&err_list, nlh, 0, &extack);

There is a memset later in that function , inside the 
`while (skb->len >= nlmsg_total_size(0))` loop. Should that one be
removed?
