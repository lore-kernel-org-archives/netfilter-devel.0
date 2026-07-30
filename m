Received: from mail-wr2-f1.google.com (mail-wr2-f1.google.com [74.125.225.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF783366DD3
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 16:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428786; cv=none; b=AzuB+lwSRNjSE5fjj3C7oaKQO4y0//hWjRJapfAdy92y86H7CR1Y0F8So0uNC1EpzWatdnBTkQZA/s90lolPcMv1nxj+YfHXYP4IfC+0o9PXP/BA5aVY9xeecw9nix4aaONsJu+1+Qg3U9YApXetLRiJr4hZmgCwom/O4NWE3iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428786; c=relaxed/simple;
	bh=9dMgWJFvABTymvqJzPUQmneXocLq3GU7ftvZU3fO5Vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p0TS3hDD/YYMZdW2O5r8x0WQ020T5cydvYzrmmEVlYrEvnhn8R7dJVt5dnwGjKpDCgVTVa+nEtNQlZNROFZbMfRKNzjQuhzHyOF4YdzjrkgatoOpSxd9d5KgSNVUMk3SMwYRjseGNr+74GuxgeifJ+cgC81uWsgdAWSzTqRl83I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr2-f1.google.com with SMTP id ffacd0b85a97d-47033972bfaso641049f8f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 09:26:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428783; x=1786033583;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s6V6Xan2pBW6erYth4zu34CZXWTMnLayAG+4Owt8uEU=;
        b=Zqy4WkD3jujC+xdpswdtM4cAQFDH+FsI/0ZeZcsHev/R/FpTtXgdqhR2seZHQBTE4g
         i/PCyEglWvrg+O8UtqKEnc1SYtfgGUKw3hObAazJE6tcfyfQ+dNOdYXWE5P6vrI0SO2t
         q8raPsvnRRJ9ZMGtd5wdMU1PQEi7Y8v2ATtiKtJuoHCsb6CPssB6VKgc6GulG/KSOkX3
         8zk8kDpjL2ZpKJoU+6C8uC3ebYCGS7zt/Xq+L03dw5XmSDwfho0GT+PMMxdvXmiOYpGD
         iZ6GCY6NLcAg32nitLZMLWCADnyv6m2616VPgth0S+hh31aTqfau1zQvSZuLOBfyanaC
         tKAg==
X-Forwarded-Encrypted: i=1; AHgh+RprW8ayr3BRTgau9GR3IkERin/ACYPkzL7ZkQUDWz6eYzdVyNMErQCHOxCfmWePVKvHvxpDYEte4i1y8jbcDek=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5plOTZI3JMIpIxklQq48mzUwcVuva7KM4pLEujVIYGR26ZSvk
	5MtGxhv3OvMAtbW0gTU20yx/qL0VQ84Xaywi/26hB5Lh/sxsfFrjcYfF
X-Gm-Gg: AR+sD13ioh85ADX6vjzFwqOc6R7895f4uqU704qZLBf5rarmU7zkxLRtZflet6FttoP
	22KWB43Va+/aubUcfS4kNBedrRrCULg3XbCynH8PfBQWzTt0uw39Riv7kImF/8esJ8o5VlcM1im
	AtsQQKKQ3AR6sY7P+znC/Y89XONtCxfXH1QO7573rpwW3E8xrJr+cXO0MtzHkK9DD2CnZNnMs/L
	/oT7EB2CehSHoR6cYmM4g9GNjvXZCe4OkNhfr+mFyGAI6mt/Vadl0yFF0rzEPbpnSFLvzmiq4YM
	71XW0PH5H1C8Jr/9Bw09pJ4CCewBuVMOY6ssD2MsunlDMZH383hcZzY2ToF8aeg1d0CPAblMUTV
	dkq/4ZJSoK25znwlMh7oadpqIz42tNT2o1l+3IZfy8MYmo3ojMbrnMi1aqDXqLM8HFvyHPKSZ2V
	UdEUWvzoPCZMS8rtHH09PXE4lsXleSUUHtqcC+EzKd8fZJsNCa7N7iro2GM8p4GWt4ViBPf8gE6
	ZJEvyLmx3j+wvVGSUyIQrIVZQ==
X-Received: by 2002:a05:6000:43c5:10b0:47f:7fd1:9602 with SMTP id ffacd0b85a97d-47fc80c0df1mr3940525f8f.11.1785428782846;
        Thu, 30 Jul 2026 09:26:22 -0700 (PDT)
Received: from [192.168.88.241] (78-80-108-129.customers.tmcz.cz. [78.80.108.129])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc8934ba3sm6793670f8f.27.2026.07.30.09.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 09:26:22 -0700 (PDT)
Message-ID: <445ea2b4-5efb-4d88-94f2-d79a89c7155e@ovn.org>
Date: Thu, 30 Jul 2026 18:26:21 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Backport request: "netfilter: nf_conntrack_expect: restore helper
 propagation via expectation"
To: Greg KH <greg@kroah.com>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Ilya Maximets <i.maximets@ovn.org>, stable@vger.kernel.org,
 netfilter-devel@vger.kernel.org
References: <ee95f6ac-181e-4315-a2ae-e4d1388c5e69@ovn.org>
 <amqHu5H6xu02Izo8@chamomile> <2026073054-certainty-reapply-a613@gregkh>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <2026073054-certainty-reapply-a613@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/30/26 4:09 PM, Greg KH wrote:
> On Thu, Jul 30, 2026 at 01:07:39AM +0200, Pablo Neira Ayuso wrote:
>> On Wed, Jul 29, 2026 at 11:38:17PM +0200, Ilya Maximets wrote:
>>> Hi.  The mentioned commit dcb0f9aefdd604d36710fda53c25bd7cf4a3e37a
>>> was backported to 7.0, but not further, while two commits it is fixing
>>> were backported down to 6.1.
>>>
>>> Admittedly, the patch is not very important as far as functionality
>>> goes (at least for FTP), but the issue does change the user visible
>>> behavior and that makes all the FTP system tests in openvswitch
>>> project (in userspace) to fail.  This makes it harder to validate OVS
>>> on kernels below 7.0 and makes it unnecessarily harder to validate
>>> changes for the openvswitch kernel module on stable kernels.
>>>
>>> So, it would be really nice to have the fix backported to the same
>>> branches where the commits it fixes were (6.1).
>>>
>>> AFAICT, cherry-pick works without conflicts down to 6.6.  For 6.1
>>> there is a minor conflict, 6.1.y has the extra debug message:
>>>
>>> diff --cc net/netfilter/nf_conntrack_core.c
>>> index f5c466ea1e7d,8ba5b22a1eef..000000000000
>>> --- a/net/netfilter/nf_conntrack_core.c
>>> +++ b/net/netfilter/nf_conntrack_core.c
>>> @@@ -1800,8 -1811,8 +1800,10 @@@ init_conntrack(struct net *net, struct 
>>>   		spin_lock_bh(&nf_conntrack_expect_lock);
>>>   		exp = nf_ct_find_expectation(net, zone, tuple, !tmpl || nf_ct_is_confirmed(tmpl));
>>>   		if (exp) {
>>> + 			struct nf_conntrack_helper *assign_helper;
>>> + 
>>>  +			pr_debug("expectation arrives ct=%p exp=%p\n",
>>>  +				 ct, exp);
>>>   			/* Welcome, Mr. Bond.  We've been expecting you... */
>>>   			__set_bit(IPS_EXPECTED_BIT, &ct->status);
>>>   			/* exp->master safe, refcnt bumped in nf_ct_find_expectation */
>>> ---
>>>
>>> WDYT?
>>
>> I am fine with getting dcb0f9aefdd604d36710fda53c25bd7cf4a3e37a into
>> -stable release < 7.0 if that is what you mean.
>>
> 
> Great, can someone send us properly backported/tested patches to apply?
If that works, once my testing is done, I can send two patches - one for
6.18.y that should be applicable down to 6.6 (I'm running tests on all
intermediate supported versions at the moment) and one for 6.1 with the
conflict resolution above.

Best regards, Ilya Maximets.
