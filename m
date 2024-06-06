Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88102194C99
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2024 13:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717679232; cv=none; b=i8UCzp+GnQdrvDoFl3AS/yT+feeQWP4eFCIJ4EPhBVf2L8trX1lU0JttijyrR5FyfN6o/TF+AD8skqL8sFF7jldBgGwRUK61Acwi8rIYPhhZXHsM03e8JyXeAH6gNsrxsXmoW+dIkCy/SAE8DxhzJghtmi2jOKCm8uLFqoV06+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717679232; c=relaxed/simple;
	bh=Etq3BFH0SUDQc3u7gbIgGA42LQ02usvZh0xzy0dG8VE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fNS5fPnkLEFS9l5sCHUzJF79+P+/+PgmK1us7rm8ibnmngW9yfBRXVM4isx77sInJAmFc5WAHz0u2WCEQnLt9AMV61yJHsMq0HdGGBSwts9o5iXCEJ/yaczr48BE9Q9D/2wdPBN0GIbTwLM/TgwEXDcvSxvuPIXJodk70lee7RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com; spf=pass smtp.mailfrom=6wind.com; dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b=HVEdj6k8; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=6wind.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="HVEdj6k8"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52b8b7b8698so1204468e87.1
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jun 2024 06:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1717679229; x=1718284029; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=X7/YjkjE87q9fVWLbAbF50WpMhrk7+YRouKRmXLf4ss=;
        b=HVEdj6k8ZweIWXWv63y8axEwQ/cJAkUQd/SjI2vIdYXS41l3wDskJETC+ZbU44KxqX
         oEa6c3TaH/dKrbYTyGAh82e4vKJeWlMGDsRd3UrTqQDpukWtAYkSpPJieuO3iR4JIyC9
         pAAidD/WILy4VhCzKFIDEPtcGnjY05m0F+iw7Xyp/C6awK0mjOyZLimiMP7DxvOiGM4v
         b8HbiKD2b62AwDcJsvkRa8gLg6yIwnAkD8lNihGQGvd2GGOezqloibY8R6FW8ZKO4X1T
         xh/r4zUWeXK8qUFUz/ej63kmrX8RYsExZpmEtcbrsnJEekRPfJkIMt6XpHN3pGsVDkO/
         L8Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717679229; x=1718284029;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X7/YjkjE87q9fVWLbAbF50WpMhrk7+YRouKRmXLf4ss=;
        b=hKsr3LVEC/Ijo6GU/c5TZnshfMKl1YUoawdCU6il/gDH7tHJ8HpHG6KvE83IwqRJJz
         VZf3dGViVcmm/45G/NuphKbk4sFMYtrUvZZ5KcImSAu4uuzp8PpeaJW7rma9PazGE2EB
         iQ3Ne4TPxOJQAn8BxZ8Akse/K/E395ABS1pDEovywYz1R6iDQ8VViOpRXnTL+jITiuGd
         dLy/ms/LQR4rP3dmRx9AJLe2cpR3fdoaRu0/yOrkO3reSvDjCY7qOYmmvp5MOsbJP2yF
         bdjFuaniyXrVYL4Gl3o5xro+XMFT+7JoabLlUhogPxxo9XvIqf2mQOWpnfE3HTtKUXOs
         mD8g==
X-Forwarded-Encrypted: i=1; AJvYcCUKHeyNftSNxAFz8VZMcGoSH5qLxLzm9HiRwNKGLSy/hrut4vLGRePPXNc+gzL7sPbZm1a0px5ccatL77HNmO3wO6D/Lg4U7yrNIiFY2ykJ
X-Gm-Message-State: AOJu0Yw9VNyt9zQphOXlzZTCnp5dXrxXwxCpo7uvDXGkURlklxmWzV2Y
	5eQsijDULF2RPg/xIEpNgl8gnqC+tVjNJK/ooCC9pBGll9VGeGpSXrK8d+OqBt0=
X-Google-Smtp-Source: AGHT+IGLIp8RENe2geB0EOGlL/St+z0m6WGvSCPoo9gsCnSNdlZPwexPjET61pIuui0zOW6sPdb95A==
X-Received: by 2002:a05:6512:b92:b0:529:593f:3f3c with SMTP id 2adb3069b0e04-52bab4f4c6bmr4590296e87.53.1717679228688;
        Thu, 06 Jun 2024 06:07:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:ff33:6de4:d126:4280? ([2a01:e0a:b41:c160:ff33:6de4:d126:4280])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4215c1aad97sm21117195e9.20.2024.06.06.06.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jun 2024 06:07:08 -0700 (PDT)
Message-ID: <9def8383-55ba-407a-af58-838dff2f3e49@6wind.com>
Date: Thu, 6 Jun 2024 15:07:07 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH nf] netfilter: restore default behavior for
 nf_conntrack_events
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, stable@vger.kernel.org
References: <20240604135438.2613064-1-nicolas.dichtel@6wind.com>
 <ZmAn7VcLHsdAI8Xg@strlen.de> <c527582b-05dd-45bf-a9b1-2499b01280ee@6wind.com>
 <ZmCxb2MqzeQPDFZt@calendula> <1eafd4a6-8a7e-48d7-b0a5-6f0f328cf7db@6wind.com>
 <20240606085352.GB4688@breakpoint.cc>
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Language: en-US
Organization: 6WIND
In-Reply-To: <20240606085352.GB4688@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Le 06/06/2024 à 10:53, Florian Westphal a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
>> I understand it's "sad" to keep nf_conntrack_events=1, but this change breaks
>> the backward compatibility. A container migrated to a host with a recent kernel
>> is broken.
>> Usually, in the networking stack, sysctl are added to keep the legacy behavior
>> and enable new systems to use "modern" features. There are a lot of examples :)
> 
> Weeks of work down the drain.  I wonder if we can make any changes aside
> from bug fixes in the future.
The commit doesn't remove the optimization, it only keeps the existing behavior.
Systems that require this optimization, could still turn nf_conntrack_event to 2.
