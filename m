Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FC61E0DBB
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Oct 2024 16:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728404853; cv=none; b=PC/Sp48ec4Od5bppL1UTIiE1RBV4/OFLS7z3T5QDsiE0K0zpeYfKcbR31uTdTg+u9wHPOQBUiBAk4BVuA7hqHJ8mrA30+rxbciYOsWpDNlEEFjakzIW2UpWR6IEhq30lKWxwFE//FYQrxUiH3uI/eZYJ0MgVTuDJSUDu69M1d3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728404853; c=relaxed/simple;
	bh=9D6b3XUaw8YnA2Jsa83UArNY0QQv4qma2dRS1XVQoxw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=qeNURy3SaEir9CuipvD+SsrvJQlqy415o41FsBGzqrxnNpbcPV9UFw7BubuFpHm4GuNOyY4u5iI7slAqo8iXCz6n6K+RhTulZ4Ib58wm3sg2wbYbastaYt9Q+YygXaujmsjTTnj0pLgSg/L7eZywEXgMZ2rBc0Cyv3XjnNXwqPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VRpxCObW; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VRpxCObW"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43058268d91so919095e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Oct 2024 09:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728404849; x=1729009649; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sItHhxpPIXd72MNiyn32hhweMW7V+X9aaXj8xxoIYY4=;
        b=VRpxCObWw5vKdFW96Vux3TLCmjTjZ4PF+KTUmk9aHW3LbHUGH1no96uOr8anrVCkQR
         x8nIUIODOeoJHmAm9WUEYslnwZFE+HwZtdNhuceWl+1RHo9iZctgzrQs8/cT+3m4y3pN
         gb30GBeHo8sIJD4PK0KXQDYW+rbXRAXqze4RfEk6YJqs0b2Rgh2OUrevsBWZrcgGm7TH
         hC1yHFNCDSgcfpsIubYKgVVwHXxlnlZSnKf9nJzUaavzDmaadsU2hLfQhbRb5xPV9KS7
         NktuPV46T3WY285gufUKRKcBfJn17wCis1XTbGKp5KIUsKfEt/Z4vJfN+ZX9FZC6SIUk
         be8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728404849; x=1729009649;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sItHhxpPIXd72MNiyn32hhweMW7V+X9aaXj8xxoIYY4=;
        b=YG2bkruygRdM7ug6Ah+VOuyfu1LReiw7CXG7U2K2zX4wuKr1YaczagTKkFIyzl6RIo
         9C4+71pQoNj2PnzKVrFLbGAwyy0s3x0NAEDuybfQCRAu9Tclst8CH7g++dn8ck6r4Idg
         tGs1NgWdBKJcAy1EwlL3XTkYalLDI7tDyUmLLmSrR0VnRy26Io+eCs6rede5mxJ6SACg
         OoAfm+5CHf4y09/gpSj2lRDo7yD8aN9VxRnjet+6LFYybQDyAR8WJZAZMc1zkxb8PD79
         YnRxZsig1NX1tbCzeU6vMfagxCst6s+fKS8dA06JcebVM6djjw0S5v9JXKA8TDWb1emd
         1Pmw==
X-Forwarded-Encrypted: i=1; AJvYcCWFJ3cICy2tKlC1b/JrD0KCg7naPHtOJp/V5MX60ExQD5kIgmjFliTOMnFOKf5EGZ1R79ZwxbwcX3VaRiLX41M=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo67jXN9rqLoKZh8U6V8W4K8H7bl1okyGZ1ek5bUXrlJj3uQC4
	OFysoEPmKBUqaYkiOHmNmvB/R2uti3ORt+d3REfjGBwzDRUFsb/JVxlLl170FQg=
X-Google-Smtp-Source: AGHT+IG2q6AbUmJy8WrBYCM4sA4ArIKovLdTt4+h0mjR49MM+vXd6L19z5ppRqiEvG2PV1qR/CjEeA==
X-Received: by 2002:adf:ee88:0:b0:37d:33a3:de14 with SMTP id ffacd0b85a97d-37d33a3e149mr1375958f8f.7.1728404849301;
        Tue, 08 Oct 2024 09:27:29 -0700 (PDT)
Received: from [10.202.96.10] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0cbd87csm6335519b3a.7.2024.10.08.09.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 09:27:28 -0700 (PDT)
Message-ID: <776f0b5c-7c2d-4668-a29e-38559fc0ee45@suse.com>
Date: Wed, 9 Oct 2024 00:27:24 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Yadan Fan <ydfan@suse.com>
Subject: Re: [PATCH] nf_conntrack_proto_udp: do not accept packets with
 IPS_NAT_CLASH
To: Florian Westphal <fw@strlen.de>, Hannes Reinecke <hare@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org,
 Michal Kubecek <mkubecek@suse.de>
References: <20240930085326.144396-1-hare@kernel.org>
 <20240930092926.GA13391@breakpoint.cc>
X-Mozilla-News-Host: news://nntp.lore.kernel.org
Content-Language: en-US
In-Reply-To: <20240930092926.GA13391@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/24 17:29, Florian Westphal wrote:
> Hannes Reinecke <hare@kernel.org> wrote:
>> Commit c46172147ebb changed the logic when to move to ASSURED if
>> a NAT CLASH is detected. In particular, it moved to ASSURED even
>> if a NAT CLASH had been detected,
> 
> I'm not following.  The code you are removing returns early
> for nat clash case.
> 
> Where does it move to assured if nat clash is detected?
> 
>> However, under high load this caused the timeout to happen too
>> slow causing an IPVS malfunction.
> 
> Can you elaborate?

Hi Florian,

We have a customer who encountered an issue that UDP packets kept in
UNREPLIED in conntrack table when there is large number of UDP packets
sent from their application, the application send packets through 
multiple threads,
it caused NAT clash because the same SNATs were used for multiple 
connections setup,
so that initial packets will be flagged with IPS_NAT_CLASH, and this 
snippet of codes
just makes IPS_NAT_CLASH flagged packets never be marked as ASSURED, 
which caused
all subsequent UDP packets got dropped.

Issue just disappeared after deleting this portion.

Yadan,
SUSE L3

> 
>> This patch revert part of that patch, as for NAT CLASH we
>> should not move to ASSURED at all.
> 
>>   		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
>>   
>> -		/* never set ASSURED for IPS_NAT_CLASH, they time out soon */
>> -		if (unlikely((status & IPS_NAT_CLASH)))
>> -			return NF_ACCEPT;
>> -
>>   		/* Also, more likely to be important, and not a probe */
>>   		if (stream && !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
>>   			nf_conntrack_event_cache(IPCT_ASSURED, ct);
> 
> AFAICS with this patch we now do move to assured unconditionally?
> 
> The changelog and patch seem contradictory to me.
