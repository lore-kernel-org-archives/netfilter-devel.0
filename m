Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48A84B53E5;
	Mon, 31 Aug 2026 16:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788192494; cv=none; b=qcdkzWOFBhDmf7gItco9sk0Bmw02JCucD5w05X8qw/mAh2CL4YW6+sKYLkkSATWXc5Ft4b1oyv7G06xzu14D34fCsGkfi6hGrsUdo8oTkPUrFgOm5GutHtEoCV0aex7iu583IbWcxhCED90nmLXAwbFVzUqndtOfLusxNkqP+Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788192494; c=relaxed/simple;
	bh=WHOQNZF3WUFg0mYJDCKbEeNUeeXEiQebbyFdkqK7PBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZAwf/KzaAZgSTRn/dwwuWWR1EDaNlvitxds7ePV4f8jMJSiZYpNiVxuKTwMQgBd/dlpX9IFnyilj+wvITbhuMqfV1n9xcZlO5DplLZrdQ6Hxh+IwisWn8tlFTTR4puw2LcT/jdprtgNMRoKFt9XzMlvizyUw6xqk6tXqPECB0W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=tyFKKIfZ; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="tyFKKIfZ"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 519A91A1906;
	Mon, 31 Aug 2026 16:08:11 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 266D360231;
	Mon, 31 Aug 2026 16:08:11 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 04B7411C791E9;
	Mon, 31 Aug 2026 18:08:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788192489; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=+8ZebgPAjuIHcgT3bCLdV3LtzjyA0gL3LmHxoQrhx+A=;
	b=tyFKKIfZYtSmHbB6SRGVddmbIWu4KlkYfzUm/ZI2B1ma+cge5AYk8BUQSvQWjBihB06cKO
	7w9p/nW3GyfTL36vc0dF/x0Y/y/K6m5UASja3v+Ocja8lCvnUd5i2nCo3J3O0Sk77gTIVQ
	7gsN6+Y/oPsj1I+xfUyupgxFglmDjR87mDEQCc6SqymXfSTleH/de6puRt329aaYHFs0dF
	J2SqYyhjyhE6S5TiFBFTtfDNl2fFOxv+jdbB9zftCyuIjqjE4tyHvG+yC1f1eansSxt0ex
	NAezWFPnePq8tVUGtkvoZDYUHZ+NUDPc9nRhY4jSynn3zDZpfUm+7ayqfzSqXg==
Message-ID: <2d335ef9-baeb-4672-bcb3-c00bd988c83a@bootlin.com>
Date: Mon, 31 Aug 2026 18:08:05 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6.1.y 4/4] ipv4: start using dst_dev_rcu()
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
Content-Language: en-US
From: Miguel Gazquez <miguel.gazquez@bootlin.com>
In-Reply-To: <2026082454-jacket-gravity-6ddc@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

Hi.

Le 24/08/2026 à 15:47, Greg KH a écrit :
> 
> We need a working 6.6.y version first, before we can take this one.

I sent the backport for the 6.6.y version

> 
> thanks,
> 
> greg k-h


Thanks,
Miguel Gazquez
-- 
Miguel Gazquez, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

