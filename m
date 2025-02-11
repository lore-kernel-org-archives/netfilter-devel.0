Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE6F25291B;
	Tue, 11 Feb 2025 16:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739291745; cv=none; b=cxK3lbHjZ0YjQvppftbSASS2apXm+RMZdJiGbXPOdgCUrM1VMqCoBiFJtxnjFMFRQV6nv7t6UjUCOzLtskQEep9nWk1lTJyO2EgRtOU84xjplSbHxnJdmorla1tU8BpRxkXwYcloaXenqKQy/zLGvY2atdmwtaVb6+WWnMhy6hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739291745; c=relaxed/simple;
	bh=b0ktKhICDViwNI9nds4vgA/sl9rP+Pr4YC+CAbIiiOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h2wJ3/CrN5WlggQ4r2UhSOJQbWTplVtfqOwfvmx5NSzE3YUpBX10AkKhRb5gAP0NufqedgWjR9moXcykSnfvbFh0isELqV2u0nbQcbaVMtAd1V1fO/kQmSqOinVv/dLkeOmZyAeT7upN1ta7Un/9/8KgL3pHsq9w0Wnq0VIljMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J4nJC9Q7; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4nJC9Q7"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ab7483b9bf7so848874966b.3;
        Tue, 11 Feb 2025 08:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739291741; x=1739896541; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mIIV8i2tvb8tBK+tEU2BRevQmqyOqUAI4Z6TbcBV6q0=;
        b=J4nJC9Q74YM7YHSNJVA0vjCiRaP5bVk1lZj1iD4Zn2E/AynWLQhHhOFWSBdeUCpG8s
         t0jFioEeaKmhDXAumqQ8v/rxKK8CLbwBK/f7xnJSYUMV7CSo0rmqHpMD/jzmjIUWMgqX
         4U4vBAGFtLwJqDrRUHGLWqgXb2TrKwTq9iRY0UkTYxUVk34MA3qxITZVaoSN3U7ZpiVS
         unA6055JkRfa7WrfsGN2uR9Vz7l0raD+92QIGRzItewC2YnF5dCdWkjBHXaqG9jSyJUN
         Nmo6Z/kDTznAe4gnn5sTjBiR/HU1g94vq39ac2HE/wWeMspkVUEu11N1irmV0GjM4MQP
         RrVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739291741; x=1739896541;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mIIV8i2tvb8tBK+tEU2BRevQmqyOqUAI4Z6TbcBV6q0=;
        b=Vxw9vCDeVuXApUJznbrVsOFnDrWU+/A1VbaemjNp4v8RcfBIogd+yKxjzdvvm1+A62
         lc+vzak/HKnNP4HJScoSC1Eg94GI02GG3l+NCnKmxH1dQYr5/lLTmOQf1cPzpEJpMdvV
         e5Dh0PptEJcjmM9NlnE++oh/wytEcFh8bFGfD5OrI/aFYBmPnf63dpaf2DqlkTmybYDi
         8uyzmvSHN0o9Br2Djo3w9josDrnBdEBrJDYpEqvW8zWl1FL4GW1sLpdaILw7urwuUGm5
         hTpT14slgYsetGNkwHFbfI+1Jbyhxs4WuNjzXtrNYkQNbXmBij6MbTZtS8rwDIz7DGNj
         LIUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZswbCplyCQCpEX34H93idPbhfXcd8QSGGV+orKkXA8umf61kydkYBo9h8TGvVpUifVyeV6cUj@vger.kernel.org, AJvYcCV1z5OjfIYaCjk5+9g9ZZjlYh91GeT5hnZa/4s0KGdeiuKCJlYDUGMPNRxdS+AEVPToLuQZhB02hVOI9v0=@vger.kernel.org, AJvYcCXdj5IIt6N2j/NAZYzl9KVgyTUw2txHqR32ASAeUKf2x8zzwRuX6AOKy4ja38O1LoV5C+GIaOlqhxFxWBiPx65l@vger.kernel.org
X-Gm-Message-State: AOJu0YyHkoLsyXElnhWEpBcbZMiP2Cnd9YkDt8gmZF+FQ4BsGTl1TrP4
	VhHzf5W+C3e9sWyzF2aoxJQflOzTJPPQbHzxMpNQ0hUFT5RkFPQv
X-Gm-Gg: ASbGncuWSWZkDJqydqCSUBRYbb/pRGBlSFky/xyUBruvMxh0R1dP5fY5gL7TNszG+O8
	7kFFyJ6Ezx/f6FvcwzgvDAFxWs3K2hNPjpVp2fdM9aYZtJAWveeIR/yvMtyqPkeW/ttbKGnnDGm
	kBITqKyazITinrqUIqvttPy6icz/7auXZWjOLUM5uN3EzClY75XKnynHxNYkQM76Y0bvHfC97+g
	xQFAPEYAVbH2puA/SdO6IWr447vGVXmQtWsSlKj6eUtUrj+/souH3e5FpSaQWq3gFVtF151p1CL
	wgDLcvuHY36yUnlSaJHBLb5g95g/5vT5qlUBiycxdxQydjnsq2wgnq2WuQDS96SCvQDeorMTlxt
	uarPZpD0Kr0ZrV/71dg1BFV5PnH2FNw5MMGLNLIH/IbcoTnzIR+Dfd5/aeEStzmvDRA==
X-Google-Smtp-Source: AGHT+IEaE5wrrlIY6nl8fC2Lf84LvPSm2KRFTGEbR5fKUB08K5dstyn+LuQpM8Wzz6vHlCpVh97tIA==
X-Received: by 2002:a17:907:72c5:b0:ab7:c284:7245 with SMTP id a640c23a62f3a-ab7c284dcb7mr766174866b.18.1739291740484;
        Tue, 11 Feb 2025 08:35:40 -0800 (PST)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7bf9ae406sm445655466b.82.2025.02.11.08.35.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 08:35:40 -0800 (PST)
Message-ID: <1aa60578-ba4c-458b-b020-cff59b119bdc@gmail.com>
Date: Tue, 11 Feb 2025 17:35:38 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 net-next 05/14] bridge: Add filling forward path from
 port to port
To: Nikolay Aleksandrov <razor@blackwall.org>,
 Vladimir Oltean <olteanv@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>,
 Jiri Pirko <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>,
 Roopa Prabhu <roopa@nvidia.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Joe Damato <jdamato@fastly.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20250209111034.241571-1-ericwouds@gmail.com>
 <20250209111034.241571-6-ericwouds@gmail.com>
 <20250211132832.aiy6ocvqppoqkd65@skbuf>
 <91d709aa-2414-4fb4-b3e1-94e0e330d33c@blackwall.org>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <91d709aa-2414-4fb4-b3e1-94e0e330d33c@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/11/25 5:00 PM, Nikolay Aleksandrov wrote:
> On 2/11/25 15:28, Vladimir Oltean wrote:
>> On Sun, Feb 09, 2025 at 12:10:25PM +0100, Eric Woudstra wrote:
>>> @@ -1453,7 +1454,10 @@ void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
>>>  	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
>>>  		return;
>>>  
>>> -	vg = br_vlan_group(br);
>>> +	if (p)
>>> +		vg = nbp_vlan_group(p);
>>> +	else
>>> +		vg = br_vlan_group(br);
>>>  
>>>  	if (idx >= 0 &&
>>>  	    ctx->vlan[idx].proto == br->vlan_proto) {
>>
>> I think the original usage of br_vlan_group() here was incorrect, and so
>> is the new usage of nbp_vlan_group(). They should be br_vlan_group_rcu()
>> and nbp_vlan_group_rcu().
>>
> 
> Oops, right. Nice catch!
> 

Hi Nikolay,

I gather that I can include your Acked-by also in the corrected patch.

