Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D6C355F5C
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 14:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787841356; cv=none; b=Vlk8tloT5rW2nSp8IWGfRy6QO9DCl9VRR+XDVOpQV1bP7wJhWLiO73A+WIzTadXLC+z5xj6Sjpdr1Lidm9vCLyDw5uwMSWxSFMnN7ZubRGHWk0y7l2a4vB8YqjWyBYaP1095qNQh9mm5uOY6CP1D685Bn1w994zj6f2BbsYQTkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787841356; c=relaxed/simple;
	bh=OvCuE3tKhuByh3bh7M7tAUdCId7sWjvotChThY107eQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s3NdtkuGget3wYT92iP0T1S56ryfbTI7egj7GX06jzgN6cUD6urrvyRYoHYY57bCMcJTEKSYtVuBWXrivvp86+297bJiMB0DR2K52IcVYlVA6KAyDvWOEebe0t5D7/nTC84cdKQMDHTOhRkXjfztYrwRac0mCy/IxKFreNmjaps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall.org header.i=@blackwall.org header.b=O8ZuG4JY; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall.org header.i=@blackwall.org header.b="O8ZuG4JY"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2533d83e3bso223758366b.2
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 07:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall.org; s=google; t=1787841353; x=1788446153; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BKzWbSJH9JlleRjv6GcxliujufDL4y1EreMLQdzQ5Js=;
        b=O8ZuG4JYk/T88A/KhRbMbOoCTWH30TPfEzzBHbskre3HDhnFEEAExjlSCNRs4iw+p3
         pMCzMI6ZqVuaVFQdb2DwIe4PFg25/1Hv62p8iwVS8nA5yXwCR59wEuG4MtZwsD0y6q3+
         fbSi2sj9OHOSdQWKteCkHmAZHUCNq/KPZqMrN/5MJRjRQLsYYOuPz9GB6BHQBq60q+HY
         otc5Xdrq3VIcL/LPkpYFk29nU6/E4ppOvlHAE3cLm2XF41Rc6hTt3NunTaMbMEM/vHUq
         MAonY2TFLKWX3iAqpNTbW/eEqHN3Scxbs+zoTHsYTFTLo/hAQXNQzmcfmPF9qlfOo6M1
         UFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787841353; x=1788446153;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BKzWbSJH9JlleRjv6GcxliujufDL4y1EreMLQdzQ5Js=;
        b=jnaEb3EDshzBUvAbJikKa9JT4/hmCbSoFbav2vg4obFvDt5v0X3603wXP8+XWoXo43
         Tb0JRaOgD8Zsgri3bQDy25H44I3oPfLQuQX5dUefaNksWYHpvZu8VRmNqUTAmgcvtxgA
         8vHU1F5kdIoyiM+k5FT/5QSN+0TWjAGe138eVvuHBcw/XKEpq7AoF4DR3C/2LzfZKaTJ
         b6yUz+io8Aq5/D8b4AJROJSlZBXTk8t2muUy7elhA6IYQ1c8sIIysg5dwXYCqepbPmS8
         tsBXoc3535qrRQNWzew3tnDkqrFBxCIkWAeKUtHl7pF3TFOI+E2cN6JiZ7t/hvZ2WnJC
         ziAA==
X-Forwarded-Encrypted: i=1; AHgh+RrbzEdkP0epuCiSqkHTiBQnGjI5wSOu2zQGZ5jHtj8mGyH39BQOeljV15eMRWf52iLgnuz9VVavN14FiV3EOQs=@vger.kernel.org
X-Gm-Message-State: AFuF++kjODO1uphBnQXwx745HbhrnVfQF9srh9tXYmuzTvg6It0bOW8Y
	o/Fm8khjtAVcWpybph13W3JISIAxjIit5sOn1PCOsucBXe+52/sXAcXB5J7wNKcYjGA=
X-Gm-Gg: AR+sD13XjucHpUwgfPyZSEnqNXtAEX4IU4JNiPESSxXUvlk0MuTMtH9gz5QcDMPezIr
	XJFkulRAGov5SKmo7TVay6P5hl21ZAVpaPnzGtD6/KHO5OHwtBZwlXL9rYic5kSpeXgAybB9X9O
	8W29NbeMvXRrrbSP7uCxyqcHpLq6CA6ZsY9FFPg/ydrBC9vuvk6lO6Bhx73xa2exjoGrIzwGYq/
	DvYQGfEBNFQYzuegmbsPemt/4FIHcViY5o3E6DHnudZh2WAqAXtzC/pXyFi3cruKp4LUQPZ5b2H
	THw9UbOnfTer4/9Ok4afuOGULobnJM3wPoHSep4MCvTQ/jKhchIT22zfEFxXX4Pl0D6VPCHS1L/
	7aeA14KLX/jjP+nTM3Pq4wQTRGoNYO1TAGLuWeK90oxqy1vDdDkYoeejCz8aVyY3/wMGYTpmSZn
	RAWoiwLazGbfyrBOJXRnuJfheTGjJv3l0hr1A67Hm4Rga96wdfpVPckUH6yPOb8Q96jaHn90NZ2
	9tjygZbd4BYVyqfqKM=
X-Received: by 2002:a17:907:c08c:b0:c21:752f:c44e with SMTP id a640c23a62f3a-c250bc0f7e6mr1797816966b.16.1787841352449;
        Thu, 27 Aug 2026 07:35:52 -0700 (PDT)
Received: from [192.168.0.161] (78-154-15-182.ip.btc-net.bg. [78.154.15.182])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a5d62dfsm738498266b.4.2026.08.27.07.35.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2026 07:35:51 -0700 (PDT)
Message-ID: <ddf53430-f3ce-4ca8-aacd-3fd8ffc81091@blackwall.org>
Date: Thu, 27 Aug 2026 17:35:50 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] net/bridge: out-of-bounds in br_forward()
Content-Language: en-US, bg
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: bridge@lists.linux.dev, netdev@vger.kernel.org,
 Pablo Neira Ayuso <pablo@netfilter.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Sabrina Dubroca <sd@queasysnail.net>, Phil Sutter <phil@nwl.cc>,
 Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org
References: <fai12uKS5302YnCQV4E3zlDqcsAS5aGcMutS@bugs.sh>
 <apBJyKJ7zs4kUmpd@strlen.de>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <apBJyKJ7zs4kUmpd@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/08/2026 17:29, Florian Westphal wrote:
> co <co+63bad23bb3b4cd85@bugs.sh> wrote:
>> We found a bug reachable in:
>>
>>      path    net/bridge/netfilter
>>      crash   out-of-bounds in br_forward()
>>      commit  7b5344954050 ("Merge tag 'nf-26-08-10' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf")
> 
> I'm looking into these reports, I think this is the same
> underlying bug as the other report; a variant of
> 
> ccb9fd4b8753 ("netfilter: revalidate bridge ports")
> 
> That bug uses nfnetlink_queue for RCU escape, the other two reports
> use defrag engine.
> 
> And sure, its br_netfilter again -- I think we will have to consider
> removing it even though it will break existing setups.
> 

+10

> As a compromise, I suggest to reject br_netfilter in user namespaces,
> i.e. call_iptables cannot be enabled anymore unless you have
> CAP_NET_ADMIN in init net.

+1000 :)

I absolutely agree on both counts.
