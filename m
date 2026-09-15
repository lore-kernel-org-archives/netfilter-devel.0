Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A9D3911C7;
	Tue, 15 Sep 2026 13:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789477223; cv=none; b=S/4mbKNRSJbCosqDYudbRMYez3sSPKscTZCH5JFlspIYsm+l89iEOOws+M6yz+que1l17B970YLgFpnp6fYoHd2pANjwbkhdDJp4MNvW9GQVK6sk1e/SlaKlb3CYQgWJYE9wkLLW+06Jp0AgtTS42QzZ9upmQo4UwG9JsYai4B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789477223; c=relaxed/simple;
	bh=XsWsPGuQxBgmDgDWkT+nmlfS6wXT6E4HKkgq+vWo7VM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XI86QvYRn4E4i1JvafSRohEZ/sPypDpp+FSE07Ov86mOg8fSxdS9XD0EgbOmnsT73AfYneiGu5MAEIs6A03pE5y2KApbWgEPTqMldcr2CdMMDUXC13fQLhpLPv6xI+4HUnMf5wSqwSWx1tlSJIjSRpQ9sdGunqq6NX5npWPNEj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=TRHiaEub; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="TRHiaEub"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id B9CAE4E4064A;
	Tue, 15 Sep 2026 13:00:18 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 8451C60498;
	Tue, 15 Sep 2026 13:00:18 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4CB2711C7AF9D;
	Tue, 15 Sep 2026 15:00:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789477213; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=3snnb/Y2y8ku4fecmXgJCGMJyog3YWcxnfWoyeQCnlU=;
	b=TRHiaEubLE5oQobB1fmn+oYjmR1BkpQZqLjnBwaWlpotIe5gwLAV57O5QUx16xTPYRVh8G
	Id6vudvenu3cT+5W4nCU2JemFRNRjlk3ZCWyR+qk/PdyWPpjJtWOtg41lcJw6fCb40Dbqn
	mwPtLdfOPyrb6gPtL3bXVaABxLQYl08Np2kAi4e7pAbxvQ2FbEfErksHQoMoVVGW5KTJXD
	XI7LU4vrnv+W/vcO5ZcCPM6RjKu/t/UA8Cbtf4PW9TLJx6MM+wwWYx80gyI7JmrNVfzvv/
	cnf+XqeC9Qi2FbVUiGTUof/d4zgjkelydhYtROHTbZYpbDxGMFOLECMvau4KRA==
Message-ID: <823f66b1-5a3c-4ca2-812a-de2c5281c49e@bootlin.com>
Date: Tue, 15 Sep 2026 15:00:05 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6.1.y 4/4] ipv4: start using dst_dev_rcu()
From: Miguel Gazquez <miguel.gazquez@bootlin.com>
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
 Martin KaFai Lau <kafai@fb.com>, Hideaki YOSHIFUJI
 <yoshfuji@linux-ipv6.org>, David Ahern <dsahern@kernel.org>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
References: <20260821-cve-2025-40074-6-1-v1-0-cad5cf499b76@bootlin.com>
 <20260821-cve-2025-40074-6-1-v1-4-cad5cf499b76@bootlin.com>
 <2026082454-jacket-gravity-6ddc@gregkh>
 <2d335ef9-baeb-4672-bcb3-c00bd988c83a@bootlin.com>
Content-Language: en-US
In-Reply-To: <2d335ef9-baeb-4672-bcb3-c00bd988c83a@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

Hi.

Le 31/08/2026 à 18:08, Miguel Gazquez a écrit :
> Hi.
> 
> Le 24/08/2026 à 15:47, Greg KH a écrit :
>>
>> We need a working 6.6.y version first, before we can take this one.
> 
> I sent the backport for the 6.6.y version

The 6.6 backport were merged in 6.6.157. Would it be possible to merge 
the 6.1 version ?

Thanks,
Miguel Gazquez

> 
>>
>> thanks,
>>
>> greg k-h
> 
> 
> Thanks,
> Miguel Gazquez

-- 
Miguel Gazquez, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

