Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2361DA23;
	Thu, 19 Sep 2024 09:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726738279; cv=none; b=ZXF9/2IIS0svKr2tHoNEsL1rFGnmWUyuu1VUnHEmdnwF339BhKWGKxi4bgGCN8QA0eH2OFaUofBKW6llT8E8doZLQ5UnZn1PObqxrgTJIATB7eyy79fdKiEDKyQMsmK4mxS+MCPxgY8TJfR03m6iOz+wDpQ364eztiJnRRkR+sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726738279; c=relaxed/simple;
	bh=nQ3lqo1I2CKZ30nxb/1kHVqsvS/ncqJgiZKU/ul0xTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TD6yOYZ9jfBGBgsxyCMr7lgPWyEdx8kiTl2sDoDwTgss3EJEH1P3X98VYvYRHOilhECPZeylihh+rkV9MQvtJwsa/gtlwKnPJjHBUqGmTDEO+8OEQMvEDGIQC7jSrWXEv8ogd2aPUMXN6IzHCbFOrQWv+00Cd0PDVvWGD1cTI2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c40aea5c40so1218925a12.0;
        Thu, 19 Sep 2024 02:31:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726738276; x=1727343076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ST7vrp03N+o606LQWEMLeEB588qIp24tdnToE5qhzcQ=;
        b=oiKSECT4u0noSGq2SBoardxPZ28y2jSg+lhjtNI0VzyRg/APxpwaioCtIbAiSjDoYR
         8H+/VV6gB+IJ8SLQsrVayaPw75xgx/9KEWcWtSarsZl5tXKjeD2oWpTDSSEiR5qVQIae
         olFhnLZ7jLGkMj1K6KjySmdGhxUvA1GQEyU8y4EUGxe4haisbzkssKJC08gOLOp1ycpF
         pCRKitXuJT/qjwYeQV8BMUigVn1VND6ZpW0lFk6QUMLI7PYpGyOVtcwrB43NlNvC7IC2
         tEoghpR1tXybidmM0TSGjesDQg2jrob+h8J5cpMeFz9UfIN4ZkQxOFP8yRcs4slszTM2
         wsGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJODsf4mNGB6tKsuQPp2zt6dOO6GyKj+HQee1KPW+EYeivZ8uTDEkhPBeLTSosw7mza6UAeTM+igYHsnc=@vger.kernel.org, AJvYcCVVlFGh7q0z+YHNWA7Ul3Qqk7fnMs/VToE6je6f3lamoX2YeRGg2O2IPzE4jiM4hKhmGe+O4km2@vger.kernel.org, AJvYcCXJCXxMdxyLzpM5SRkJU2SJ205dtDBOr3gO/aZVHi3MFvxtnuwLGX8agdtMtv/Te7lLoS17gCcpUX2I0tVZkxBP@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9yauNYe2Bl5tYEO4b4SHYuHVp0pUbUWpsmE9YoeDWyp/dJLWL
	44Bx3S/rheh5pV6coRez7mhWRcnO+1j7rexCGKwtJA1qcmxGSyG0
X-Google-Smtp-Source: AGHT+IHTuCSYj/XYHQKqTneOv6VMVN5wrhYxzrHoKIwTzfFbGo75cCNBZV0kPWcUqTCsrIGiWagHzw==
X-Received: by 2002:a05:6402:909:b0:5c4:30fd:abf5 with SMTP id 4fb4d7f45d1cf-5c45921ce37mr2731986a12.7.1726738275797;
        Thu, 19 Sep 2024 02:31:15 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-009.fbsv.net. [2a03:2880:30ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c42bb5e86asm6134727a12.46.2024.09.19.02.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2024 02:31:15 -0700 (PDT)
Date: Thu, 19 Sep 2024 02:31:12 -0700
From: Breno Leitao <leitao@debian.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, rbc@meta.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY
 selectable
Message-ID: <20240919-refreshing-grinning-leopard-8f8ca7@leitao>
References: <20240909084620.3155679-1-leitao@debian.org>
 <Zuq12avxPonafdvv@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zuq12avxPonafdvv@calendula>

Hello Pablo,

On Wed, Sep 18, 2024 at 01:13:29PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 09, 2024 at 01:46:17AM -0700, Breno Leitao wrote:
> > These two patches make IP_NF_IPTABLES_LEGACY and IP6_NF_IPTABLES_LEGACY
> > Kconfigs user selectable, avoiding creating an extra dependency by
> > enabling some other config that would select IP{6}_NF_IPTABLES_LEGACY.
> 
> This needs a v6. There is also:
> 
> BRIDGE_NF_EBTABLES_LEGACY
> 
> We have more copy and paste in the bridge.
> 
> Would you submit a single patch covering this too?

Sure, I am more than happy to work on this one and also on
IP_NF_ARPTABLES.

Would you like a v6 with all the four changes, or, two extra patches and
keep this thread ready for merge?

PS: I am in LPC and in Kernel Recipes next week, I might not be able to
do it until next week.

Thanks
