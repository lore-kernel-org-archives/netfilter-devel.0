Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D599027C879;
	Tue, 24 Jun 2025 10:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750759752; cv=none; b=DVT0B+9wly8HHvB/68k/EModxXBjGf4rqXqbH0g426PdPVa6ZFb9aztQCG61IH/V1F+Z+0TOtVBHw7WLz6lnQ9qNQXyrxUNvFA0YzQTv0PAut2g3yCvWoCJkjsGffHbCqFFt/NWm3Wy2IjR85lWRpchxAZVKNGhhxKkaBSweldo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750759752; c=relaxed/simple;
	bh=PNPhwM4paJwVQbDov+E9J9ZuC0PmxKIu8t8tgfnv7ro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJbitUVpVh5X1Ebet4YfV3dPXNLTgZ8mkk+Aw+1hbQdyy+QMnEuzdpCiACUtEr4yx1dNPHaIEvfSrbLGjLehE/IXh2ZChcLRhiifGbWMI8pjfbZi6jNbuGYDgX3+YccB9jwQqb3mmDfSLKoe0cnweaS8J6J9cGlmaWfvRl+eFu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KBIKbQhI; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KBIKbQhI"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-607cc1a2bd8so7816174a12.2;
        Tue, 24 Jun 2025 03:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750759749; x=1751364549; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wR4ge6rguxSsc/ORqRy8r5vdeL5F2ATOq1gnAzeqSHI=;
        b=KBIKbQhILIBtB2xQYK9KAYlbUENEMfP0Xfa0Ia5hPYNRbsaQFrvEgS7CeKM8SfEEFS
         0v5Jjiqxp5JCcfuECLP5UPzaz9fk4qA6JK4KX1FDgWtRIw2tLcPBUkfAvLUOLkNJm1b0
         14zbinvkthQjG7P0hxv1J2u7GIBfY4sgl9r4DP/PsX53rpSnbJnpTV/nHXfWYc6GVTdQ
         YplbIBA3L9R1KrH5TIk41g92PZiH1QK2fj+LrN+lfMoCJXR8dorR/n3fL28Q8pRMPMtK
         1qagIF6bc7+KSlmPRsiXYJlan4Dp0OFr+DGyvpZvKhOFNniHZCPwi2ZUc9mqTZTqtKTA
         TymA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750759749; x=1751364549;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wR4ge6rguxSsc/ORqRy8r5vdeL5F2ATOq1gnAzeqSHI=;
        b=mpH794mHCVRLIP4NAg6CoMHn0hpsIwnNktBi8wCW5MxgmDZ2X3E6v5egv7VFIEm56h
         IfxtpxIQQWoY/UyNN7/Oh7/yGT0Nt+GaosrJabcN/JVeykWC7UHVRdPeje6nJjiE1ytG
         1tZq69nOAXTndmdyNqoIcTUSWABXEQTtBG5GrOD1EOKXOrDrJnTlIBJWcbG/dQGb+lZc
         46jzLKTfXVlvIy0cIjEtk61rUmO8w3Uc17RosrAzjy14hMnOoRd6zclsUheb0ftWwYEp
         +xdWFzC15m8gCsS0fxPpjFsc5GPy/0oT9mtEBF+eOaZJ7GMsB7jZ0+EiI5AjOb8yXNDT
         ZjLA==
X-Forwarded-Encrypted: i=1; AJvYcCUxIKKGmzvX4R0uKhwK42lLCOA0rZ26mkFZAKTyNb6SXIbwHIxPsdn7/ubQi5bEC3QXpmTiO0DQGvELCuyxCmzY@vger.kernel.org, AJvYcCVK7SPT3+AfPxvPv5ybD3rWAMDhsUJL8cKiyKCJmMZcFgLFHKIfFB9Cyl72YkAstQFi+PZV2zI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFiiS+JxXhnAzSYjHGsb2d0n/uBpVkBKg6Sys8fgToOzGKEgzm
	eT1aLuRVgYQf6AUTX7rLMyZTMBWyvLSwJPkCaaQ8Ud1gSVatwFYLjsC0
X-Gm-Gg: ASbGncsvmCbyumPxH60Vn8SX9mtIKq+q6ySZ066lppkUKUwxFMQKjge5vyJJXwgBbxE
	YVbXB54bTaW2NLCwq8+IRtkj3STh4/UMHykOVXlUHshB+ijJkZRFrAn4JvOM9V2+MbrAlC/Ttev
	hNMmVAiamVXqTFt7l995nMeBlfegqGAgSYSRYtir9UU0Q7R4vkElSkwKhC57F4mOoQ2pZlmHf5l
	z8yKsCzu4VgXNHmZE8CyNNH1iBpat6e0aH1LyGbf6+eqvwlXK74+M6spBqNOetykw0G+kZmxxIf
	54j5MyC+MqzhBPoW0S6laixX/BTqONqN11gV36g2LfVPzSao849DQhqR/SsOEi48UlKok0zxNKs
	s6LctEMClgBSsVnMqmxFr0g8stS8/wZ2rjhCB1MicvWZbY9+kYjaccitodSWCSeuT6erNsacTZN
	Z64QZk64yPovwTvwDJgrj/ch0UT6HR4v+DwMyNIAacQV7YW6Q=
X-Google-Smtp-Source: AGHT+IHKFAxaROdqfcGg3d6rDQqJLaE/SJ+Wkg9OhXhAmcXdrKyaPKmVMih7cR0ERStNXIIWPfDKeA==
X-Received: by 2002:a05:6402:2550:b0:607:3344:6ef1 with SMTP id 4fb4d7f45d1cf-60a1cf2e082mr12192488a12.29.1750759748906;
        Tue, 24 Jun 2025 03:09:08 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c2f4857e0sm791758a12.65.2025.06.24.03.09.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 03:09:08 -0700 (PDT)
Message-ID: <4434d7fc-429f-40b4-8b98-6cd52a985fc3@gmail.com>
Date: Tue, 24 Jun 2025 12:09:07 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 nf-next 2/2] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org
References: <20250617065835.23428-1-ericwouds@gmail.com>
 <20250617065835.23428-3-ericwouds@gmail.com> <aFhqUosjt2ptnlOZ@strlen.de>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <aFhqUosjt2ptnlOZ@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/22/25 10:40 PM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>> -	return nft_do_chain(&pkt, priv);
>> +	ret = nft_do_chain(&pkt, priv);
>> +
>> +	if (offset) {
>> +		__skb_push(skb, offset);
>> +		skb_reset_network_header(skb);
>> +		skb->protocol = outer_proto;
>> +	}
> 
> I don't think its a good idea to do this.
> 
> nft_do_chain() can mangle packet in arbitrary ways,
> including making a duplicate, sending icmp/tcp resets in response
> to packet. forwarding the packet to another interface, dropping
> the packet, etc.
> 
> Wouldn't it be enough to set the skb network header if its not
> set yet, without pull (and a need to push later)?

If I replace the pull + skb_reset_network_header with
skb_set_network_header and remove the push, this also works.
I'll change it in the next version of this patch.

However, if I do the same in nf_ct_bridge_pre() (the other patch in this
patch-set), then packets get dropped. I'll need to look into that furter.

