Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795700205;
	b=5L6miU3Ke0RBJEQIaLQfL28qVG6DSz2I5EoB5eRvqh4Rbol0+2nYAoXvfiHHejxXsRvg
	 eMAxrRKVfHv68VUcEAQr7fL/2brwhgqJb/fNvEz81hKyaAWawpG/dAgP+1PLAzoXbn7Y+
	 RM2d0lXwfs7iQtM+2jEbrWX51vPPxmvrtTh22ivbc9uGfr5iCu+2bxf6oaCBa8l/AL7Yh
	 ZTiB0PMfgjrrHSdylcny0eYK2uuFBwjLXJ1Q0KfPrLXaDFIynZqCwPMfEtO2UGHptYtwV
	 rTx90k/d/KtNAQ5DkGvIW/T6au+ShX4IRhHwJdvVPxcW1eB0HQWF1wawfopUNdhaZBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795700205;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=fshQ5H++9xpVgnK9VrrbU9Ju4zsh5/KFJATHWaeaVKI=;
	b=UiHX5FY15nL1lTgTLWbU9Q9c3xbs5G9IYM0sZluvfD5a5FVwJsE7Bt0EZj+5w69tIrWc
	 32lw9nrPy26JBv4gEK0mEbtwYfNZvGzHtVqiMStxoRElu2D3ZGIzJhSqS4cmJYzh+Trc4
	 Lm76czHzve8NVfYbJYim4HWdmruN8Tv92uEZGHMxb4AlXkaonX+jeBb+EEGYS95j6imB3
	 5MhmuwXjLdD4urj6FxDHioI2usO28eznCj2cv9CfsTtmJ2EGEHD9hc03MvUUOyOr1Ke0q
	 IuoHGAV6Wg+HOHV2nsf2SWqVfbd/YvuBegMKZvE9T1fqkvEL1nCw+aSb4M8edfSt/xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OJWAL3DZ;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=eqxBjXrm;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04E1606A323
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 13:36:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B04E1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OJWAL3DZ;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=eqxBjXrm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795700203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fshQ5H++9xpVgnK9VrrbU9Ju4zsh5/KFJATHWaeaVKI=;
	b=OJWAL3DZAZObLAJ+iVmhDeVYyo8Dt+lG438rhRKUpzc05KxTIpZQHCbS1DxaVUEtv6pZ9F
	NXkLO5FJUUu21J/edUc0z6PffJt1Z7T7TBdPF0eX38Q8Y4VmIar9PH+UdKlYYHPe+NGn1t
	WUWoBErKXa4lqc2iS+KTDd5hVX4K8IY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-rpih7gnTNsmWFwEY2CtWdg-1; Thu, 26 Nov 2026 13:36:41 +0000
X-MC-Unique: rpih7gnTNsmWFwEY2CtWdg-1
X-Mimecast-MFC-AGG-ID: rpih7gnTNsmWFwEY2CtWdg_1795700200
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1f03f2e8aso61322965e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 05:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795700200; x=1796305000; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fshQ5H++9xpVgnK9VrrbU9Ju4zsh5/KFJATHWaeaVKI=;
        b=eqxBjXrmrEDjFh+3RvPCBs/6oLZDfX8C2FWHpIkQ4iX2sCic9o413WCzt8lzbc2aih
         kEGT6DBhpXl+UrmoRs0DxC1cZ0MASm95OxyANzPuU154cVGOUD1ZqHXQO2CG2dk+1PkV
         1FJf44VqHqxy1BEa5/v7MfAwaGhkO24O7YgMXbPUaoasuL0gFkw+FWuMrQhpjqtaKyGg
         U/+L2QXuvtT3vNvY/YdYvp8EZiinoIol7ufAmjRq8q+yzjuTSdaP8ebch8vh+7olYuS+
         e8pmgwhZ7HPhJW8R/fifS/5/GyBQiK6exPbZNXgqX+/oyLlS0uCip1+rysDyt0JHJS66
         mJgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795700200; x=1796305000;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fshQ5H++9xpVgnK9VrrbU9Ju4zsh5/KFJATHWaeaVKI=;
        b=UMnAg/t3iutQuB9wu1pKQRCwVGLoYvzyWV376UpOSpoICxylwNDGKeIaQu8DhBO0x6
         i9SXserWhscl2GPGd7FS1dMJ67unmYxVKx7roAShG0v34Q3KDJXfq9jO6vFUzQmXz727
         01T4jY/DfxwcyzBWh3eNVQ2/vRwFBsn2iLkpGSbJ7e5xWQWVxf0Kr0wytjrU4NImdTER
         /e+P4zk9NHkovyGkSLwxzHtpD2NUVNkuTRME5VQhcPWmCPKKSX1cRR8w7c7hnNtgiMsV
         xEvQbu88/0AqUyC0l8kJQvRoC9gBD+XB5aEeSYfTo6KJ1dt4WMmN3q7962ZG/OlJcjfD
         pvGw==
X-Gm-Message-State: APuU4Z8GO2Y7G3ASBK8HyV3rq6VdkgjOTrPn2vUZxIL3U7M8BNrGG+Nu
	g/HOXwq3AQFlkLZ9xJaWwFjUSZTJ9TXjAUPrVP5H8TGUQMKFPwKSBgUakYmrXgnqtBAzOw2TDPZ
	9A4r00yDmAh4OmjOBRqxyYbP1cJFuvg2mss7I8JUyqIfUkh455l13ELQnQ0lKPXBOI6hCIA==
X-Gm-Gg: AZFdTZdVAEmnfXUbdCkgW9dg5eW1jdSLbfX6KY8v6Us9fl4ubRa2CtNYmw8RGPqFhO9
	WsjiK/D3hZ5SE6vbVvk5Xa71uP/1TxaEtPJNnI1qHuimiIfta27faNEezd9mZ4KqF9ODCIPamk/
	hVKzMYQdDldD0k622jOxC5dJdqZ10VVknYO/dotbsu0DkX450nsw3U/wJWoH8kaqGSYl+Vtla2Y
	mFrJL0pfpM4ulBD8c0W0fYVLaY4r+xy4NK4YpkyR+bU4RcJwWDwxSIMSra0EUwq8CNfDKE6nkjF
	9ABDd8UkVdGCWbndAsYhMtVwHOlSa3SrklQ4xsgnJdvZrRg+sGhnB4ZOYR1cbedgkHPp2twDPv+
	MejLzhJfUpnhroaDSaCk1bVdPUOYIenROHvjLxFiFFeLMe0D+ti8EIZuKID9BvPh6QghvbbUq9R
	x3qLJJoUKllbZJ0zsBOK2w/FvyS1RA/UcFuQF11l9RWrIS
X-Received: by 2002:a05:600c:8210:b0:4bb:6a2d:b438 with SMTP id 5b1f17b1804b1-4bb88786c81mr424078265e9.0.1795700200396;
        Thu, 26 Nov 2026 05:36:40 -0800 (PST)
X-Received: by 2002:a05:600c:8210:b0:4bb:6a2d:b438 with SMTP id 5b1f17b1804b1-4bb88786c81mr424077645e9.0.1795700199939;
        Thu, 26 Nov 2026 05:36:39 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884a3a3dsm590393965e9.10.2026.11.26.05.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 05:36:39 -0800 (PST)
Message-ID: <87c0af53-95f1-485e-bb5f-00db3a9d3d43@redhat.com>
Date: Thu, 26 Nov 2026 14:36:38 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next,v2 00/15] Netfilter updates for net-next
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, edumazet@kernel.org,
 horms@kernel.org, fw@strlen.de, ja@ssi.bg
References: <20261123135726.3940688-1-pablo@netfilter.org>
 <8e69f35e-73fb-4558-910b-45f5e723c64a@redhat.com>
 <awWSHujeBmMMOonS@chamomile>
 <f0a3c071-0142-4c62-b74b-ffff8121c8d9@redhat.com>
 <awgOALX8V2RXY-uH@chamomile>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <awgOALX8V2RXY-uH@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/26 11:46, Pablo Neira Ayuso wrote:
> I am preparing a v3.
> 
> I will make a few changes to address some of the comments that
> clashiko.
> 
> My plan is to keep the ipset rhashtable in place, I think some of the
> relevant comments in the reports can be addressed by follow up
> patches.
> 
> Let me know if that approach works for you.
FWM, please go ahead.

Thanks,

Paolo

