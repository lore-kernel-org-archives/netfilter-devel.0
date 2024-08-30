Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B24014C583;
	Fri, 30 Aug 2024 14:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725026670; cv=none; b=qx32TZLDtV50xZ63w5iu3VMliU4U+YFX1YHyii4hEPVHZ+l1hM1rpHBnxoASlss4tiz7/M4bvGUMq+06MuySvbfX8y8hooe4jZOA9UxfcC2t666iGvBvTZpRFdxCV0d47B5gsS2PvNYmw+SoCYbRb+eAtnX6vDe6+DgYVVSbNpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725026670; c=relaxed/simple;
	bh=EDtGzwDCPpYma4gnssN7F4ucACRd/1Y8fuu4+Tm63qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TkfT13p269rkhNMVLPr2lH/JljMPKGmzZVPPfj3CUXgMOkt7ttcMN6TuyvqsYRm5KP96XxZN12Da9gjdN7u+UhAnzAhLWZcE8Mkf4dkVIaFPXvdx+eQjpmwj65hSNe1LqpX5Ez8stfq+1crT8MU6YIwamA57tAZhQtdZxRs45yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a86acbaddb4so225051666b.1;
        Fri, 30 Aug 2024 07:04:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725026667; x=1725631467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kre/ss1tAIgkBsnhcPCuIO9koTZFsoyZNAoGRxFRJ0M=;
        b=GhxzIuYF2Ehf8QDgpMm2f4oz2M7TWjiTJeC0aLZOQ/nDkNk5s1dxo1iL+EiW/VpZfJ
         noplzcCKa/uG4BkUY9iWiLq8X8T3xhE+9LkpmhgUBZNxPSch01CmQqMQ3KW288uyfDpc
         pKH1PvZ6JgJrao1Nsg4+mDJSnqCkZ/cU2OAEc+cjUlJ797wSmowToXqdJtWVNBOkpVi/
         TWHkI1x/BnePDOvYackHnZWQZkYegJ8ikUItOFHnBoyHniVaZBjYrILXnhrTTd0Vu45k
         gf0kyViGjOL4aKns7iKGsg5lDswgCEulhGHUb1ZRAlwUmnt3hiCxtEk7JPDl2kZ/7O5a
         kYcA==
X-Forwarded-Encrypted: i=1; AJvYcCVUWmvGLw+tTnTDy9b7jGY9Rt2YPPhZElhat8Hi0Hk8Dq2i5kGRdepj6UllCHxfQyqF0qec+kXhRpn5bNE=@vger.kernel.org, AJvYcCWGHK1uV0zDMGssPT+620CHhFj3v1NdOyWi8TLIVd+ETUU4EEumDhU/8p2+4omji3U+QAJVDcJd@vger.kernel.org, AJvYcCWX9gh/awOcx8JBT4f3XQGUEpNJhlBkfn1aRQDYw09dU6Z/KMtMFpuiDNMKRo1vjn3/ZjBjpGAlFsuYLv9E+dR1@vger.kernel.org
X-Gm-Message-State: AOJu0YySCcaVxMnWm72XPcrYpuS4DwWs/857CpRazobJOjeJbn8FzHMi
	DKT8tHLQaMVmSMgGuqLM1VUiNpsHlscO3nelB99y/xuhvsAmcRL6nPFscw==
X-Google-Smtp-Source: AGHT+IEom8Az9pSeNbX3ZL6UGkMDeP8c/1RMej6RxBKGaptLTJ+h8+ZIbCFiUUKuv4UfTxKedSJjHQ==
X-Received: by 2002:a17:906:6a18:b0:a77:deb2:8b01 with SMTP id a640c23a62f3a-a897f789470mr586363966b.1.1725026666524;
        Fri, 30 Aug 2024 07:04:26 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-116.fbsv.net. [2a03:2880:30ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8988feb580sm218859566b.37.2024.08.30.07.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 07:04:25 -0700 (PDT)
Date: Fri, 30 Aug 2024 07:04:23 -0700
From: Breno Leitao <leitao@debian.org>
To: Florian Westphal <fw@strlen.de>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	David Ahern <dsahern@kernel.org>, rbc@meta.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	"open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH nf-next v4 1/2] netfilter: Make IP6_NF_IPTABLES_LEGACY
 selectable
Message-ID: <ZtHRZwYGQDVueUlY@gmail.com>
References: <20240829161656.832208-1-leitao@debian.org>
 <20240829161656.832208-2-leitao@debian.org>
 <20240829162512.GA14214@breakpoint.cc>
 <ZtG/Ai88bIRFZZ6Y@gmail.com>
 <20240830131301.GA28856@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830131301.GA28856@breakpoint.cc>

Hello Florian,

On Fri, Aug 30, 2024 at 03:13:01PM +0200, Florian Westphal wrote:
> > After a9525c7f6219c ("netfilter: xtables: allow xtables-nft only
> > builds"), the same configuration is not possible anymore, because 
> > CONFIG_IP6_NF_IPTABLES is not user selectable anymore, thus, in order to
> > set it as built-in (=y), I need to set the tables as =y.
> 
> Good, I was worried  there was a functional regression here, but
> this is more "matter of taste" then.
> 
> I thunk patch is fine, I will try to add the relevant
> depends-on change some time in the near future.

I am more than happy to do it, if you wish. I just want to decouple both
changes from each other.
