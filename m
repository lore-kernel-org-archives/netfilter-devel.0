Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9721AC883
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 10:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727347412; cv=none; b=sqCJv9D9ITeaaxyxQJQE/rLj4254jWSdWE1HJdFBcWmHvN6LS9lrzjt0QaNKhOFOB5/dOjEMe77WBrchWQVXB+cvnrimBz79OAUUNhWHBOIL5Xf3P7v/tqkheLxL19bZ1VCN1FFHCh9AvwmxRknt69khor57UcmNswo1c9i/iDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727347412; c=relaxed/simple;
	bh=5Gakt2DoJ4z1UuRlr/M2fgCvIvW1bB1P+wsWFM/1UXw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sYWRaUAUbr/VQEE9WFQAfsT7ggOXTql8BR7BDzWUO6fyrPFkXkSjuJMH8yEOADZ+auJatUH55xqOk11vPRHoWMPGoXauNSpxmkDX1wmLhW3MG9BOD99mi7/p4qulGdXFRAiF6Z/UhGpW0gkDqNRhAL0audoH2qaSJII439VF30Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X+Krb7Pe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X+Krb7Pe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727347409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jgJFx8nZqn+WqDlfG0TuNzZ6hrFBH4AJtRN/e2xgEmY=;
	b=X+Krb7PesSIShGxo5XbJ+mg7YjjLCMtoeyAIheqXypikbgSy7ESI7nbiqEXv67kKlwmZZE
	BoDfx5700BLeGp4jNRpiD8qQvBEDITIRqlKKJsSxJTLyqGAlhs8okuBp3Qt62tfGAZtTD3
	M0r3r3xkAC1wRr09+nbyy9rS+BlFBSE=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-aLHacGKxMv-On5sOgHjf7w-1; Thu, 26 Sep 2024 06:43:28 -0400
X-MC-Unique: aLHacGKxMv-On5sOgHjf7w-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2f789363755so6235841fa.1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 03:43:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727347406; x=1727952206;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jgJFx8nZqn+WqDlfG0TuNzZ6hrFBH4AJtRN/e2xgEmY=;
        b=C3+1KekSLYAkdFVngl985B6hbdFs/LS3zgqtEZ9LnycBGyNOWFXpIofTTB9ukD62/g
         iDiyS1ZXW9ihhY8TIg58UFOCyzLCghIXR4xPIWSEA6jftie1x4CPzt+PzOAx1j0FARhq
         uP0x9Grrk1iHXNWlmlY/yE1shMTknY/P1C20xmrBmwMCRlsvpSTkbqxjcUV8TmmBH3xj
         u7i/gYFXuMAeFTEsGJe+heUh8gPF2vU7Ry62fnwQZR5dLPv7v6VgpJfC4TC/0iz7BrQw
         3GRYLoIlCoi2PNfF4Z2/UqyX51mgDx4Jk13XsW0HWGTTs27PCZIUFd+Na/nxZ8PvpoQr
         vj7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWecSh9u2H9xSAV782bReoQyEwYoi/rYmr75iVU7XWIzfy7y1WNt6oyO3T2noDOQTMfGPXHU+Ffb937Rcel4Rk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9hwF+fzK2Cb4yQ3P381VRoi2sjlhUCbnT1r/fL+DLgniU6CzS
	6q9LSNitJOQxb/CjGiyN2wD6JUKhqjQVHvfPpOtj4FDbGrMvFHo9jtm5gMwIx5q03o5TnKvP3zW
	p8l5IZP00l+TNU5k3FfWm7MBRQYfR/mIqC38JVwnfCoJQ5S5lVgguF4Y5MBQVkcDQ6Q==
X-Received: by 2002:a2e:4602:0:b0:2ef:2e6b:4105 with SMTP id 38308e7fff4ca-2f91b25afe5mr30703621fa.34.1727347406416;
        Thu, 26 Sep 2024 03:43:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHL/PYxkjSU1JsKxYIpPrTXtY7FH9B3Um4PVDhdD0TzBbEadjJ07Xh+OZpgtn7pXCfi6/oLsg==
X-Received: by 2002:a2e:4602:0:b0:2ef:2e6b:4105 with SMTP id 38308e7fff4ca-2f91b25afe5mr30703511fa.34.1727347405828;
        Thu, 26 Sep 2024 03:43:25 -0700 (PDT)
Received: from ?IPV6:2a0d:3341:b089:3810:f39e:a72d:6cbc:c72b? ([2a0d:3341:b089:3810:f39e:a72d:6cbc:c72b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e96a168bdsm43512635e9.37.2024.09.26.03.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2024 03:43:25 -0700 (PDT)
Message-ID: <ba889ffb-ba6f-450a-be9b-9fa75b20ee86@redhat.com>
Date: Thu, 26 Sep 2024 12:43:23 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 00/14] Netfilter fixes for net
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com
References: <20240924201401.2712-1-pablo@netfilter.org>
 <c51519c0-c493-4408-9938-5fb650b4ed8b@redhat.com>
 <20240926103737.GA15517@breakpoint.cc>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20240926103737.GA15517@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/26/24 12:37, Florian Westphal wrote:
> Paolo Abeni <pabeni@redhat.com> wrote:
>> On 9/24/24 22:13, Pablo Neira Ayuso wrote:
>>> The following patchset contains Netfilter fixes for net:
>>>
>>> Patch #1 and #2 handle an esoteric scenario: Given two tasks sending UDP
>>> packets to one another, two packets of the same flow in each direction
>>> handled by different CPUs that result in two conntrack objects in NEW
>>> state, where reply packet loses race. Then, patch #3 adds a testcase for
>>> this scenario. Series from Florian Westphal.
>>
>> Kdoc complains against the lack of documentation for the return value in the
>> first 2 patches: 'Returns' should be '@Return'.
> 
> :-(
> 
> Apparently this is found via
> 
> scripts/kernel-doc -Wall -none <file>
> 
> I'll run this in the future, but, I have to say, its encouraging me
> to just not write such kdocs entries in first place, no risk of making
> a mistake.
> 
> Paolo, Pablo, what should I do now?

If an updated PR could be resent soon, say within ~1h, I can wait for 
the CI to run on it, merge and delay the net PR after that.

Otherwise, if the fixes in here are urgent, I can pull the series as-is, 
and you could follow-up on nf-next/net-next.

The last resort is just drop this from today's PR.

Please LMK your preference,

Paolo



