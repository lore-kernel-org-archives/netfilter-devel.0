Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE41C36196B
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 23:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786490353; cv=none; b=nv4d3HTS+QAW/brJpyCwIxuv4fBVD2IP43sF5zItxWBEYYCfFC1QeivLeL2D4X8a+B9EEHAH5VC0Ly8igbDTdMkMGfNE2UPtpwDLaGVWT9uLuoyv/CYZ/xuqIpK83XKL34hx0bF2sufrU/dj7AIAn77UBokieipFYmDWNCgFY6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786490353; c=relaxed/simple;
	bh=InKmnI0Ba9idJtgF+HdWs4qS3HezrgoaJ4WBkzPxx2I=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=OMp0v2H3c1kFgb9+r/eMWHQTzX2jlmUNr3KSqVqQUDLdCNot7kf5VjKyNbOhNT0EjVYire/aDuYpX7WhD2SJN131imE6inKuxN1neYsY5EDn3nxi98VEDVFojjz6nwBt5jbFZQnMusITqoEPCSQkvzEFNSszDu/XV3OUwRzXG2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nZtN5VF1; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nZtN5VF1"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f59f25ec4so104131f8f.2
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 16:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786490350; x=1787095150; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NKWFCfgsTlLlt4GmvjwvhUR2/Nc7HI3joWyPH2vxn8s=;
        b=nZtN5VF1i7qlxG7fzcqF1qenBHyqBEZlZKpJyYVLXxpI75oV8Krel948Cr0sV/6Z61
         TGOpF71VmRn13hg5VCUtYSWOUemT4q6jszezarByCM5R3hrEVDzP2xUoylbbayfgIpLV
         u+ksFEuGdnbd3vWqzcr8kvDkHclMega9iwFErwiw3spt7SmCntGS49H9AuQA/aOsdhpo
         C4Dn7+fk4HbuCsLHpS4zsNraGGJQKji2JBplhEWBKN1xIQ98sqydRQmNdE7pT1Wjj1Tu
         RF5enSM6ArLASKBLcC0iY3mvZsL8g0eCfNkUgvm/IdgxAO/9MQSNM/anYh3MyWxAwvxv
         dGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786490350; x=1787095150;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NKWFCfgsTlLlt4GmvjwvhUR2/Nc7HI3joWyPH2vxn8s=;
        b=WTg1/KPCmsHuIxISIYgrQNW3vlthhWlXKBNgz3rbZmbqEdVaauxl5RCHPuW+3Wy8DM
         A6j01x5R2u2GyZioG3UPbyrsa0SBOpNYAYVPxz5MHaHTVQy4QsWZh6pBEzCqGW92Xuzq
         ycJ1QrISSCoVkB8AlDy2MzsEWXYIV6fvPDNL19u2byGQsES3/i+q9hi5AKVAbl6gp7xx
         9SgSdlknRF8yzW+Hd8Sf7xSuzTZxOH51bV1hDN5laZ40hUQSAO81yf4BQ8wFhbCvK6lS
         H4Yhs6oTAXVX3WlBxqCCYWM1pNc+/J1gkx8046GiUEQ92BqEBUDOzAJlD7l+aTpjaYs7
         d7FA==
X-Forwarded-Encrypted: i=1; AHgh+RrtYec0928pj3zSjkcFkcJRGF+hWLhIXVqNmAeFZf40d5d7l4QfvFiNKn+Pka4g1PObD0xlhDgAK0jHiecrfZM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzikdaL+9xWwroVv2CPMhuQIxONOE+KyxqZsuLUevtkLXwk7grR
	GxO+5h7uDertDNvTFJIpjoQIJ0/n0h6VDUGpfn/5ycP5jkwJvADngB0b
X-Gm-Gg: AR+sD10f/1NgvECazWlSdHFUjFp2lBbSowD7NyhvysAExejVg4SuqXvX0zolSeb0Wa9
	u4iTdYyg0xLpGCDPKkIbEeBWzNHz+MEeDG/93kaodDsd+wMvZ6yqMhxNoLV19pNpDjpw1FB38J4
	4lMZ6Y0R2UpY9Zm0Jg3gmxbuBx9qI5joSezWC4Up4cN1qa6ecwTfFC1eETAnBTsq4Dm7i7Mwizq
	ZUcONkOm4Qh958t/rh2x8lDb0uieYqKoTTRBNbKujLncrGkQRbCY62lVCgJhkfFJn/Y7fogrNeQ
	WA+z1icN5e+te5vIDdeykpVG4xlD23PK14iNksrMxnAZaInyeuffgW/TIe6gCE+dI6yguz+oOHp
	TnRgGXAF1QBh4RzULni3G1YFUUk4doU4kLAdZLnERJJZ+5JtXxGE0N1ZJ39FQiah8jT87G92Wau
	qX50E33zhD/RAlKZf9xphjM3xtOnT15/8SuAPVVUWIlw9M+Rn4RnIdKKI27XYqCQdzyAUGrdxn9
	PQzURDw4vh0S3wqSKaArB89+YlTv5U=
X-Received: by 2002:a05:6000:4006:b0:47f:9266:9bde with SMTP id ffacd0b85a97d-48152b15f62mr542628f8f.4.1786490349894;
        Tue, 11 Aug 2026 16:19:09 -0700 (PDT)
Received: from [127.0.0.1] ([193.252.113.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48150d4e260sm2094006f8f.17.2026.08.11.16.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 16:19:09 -0700 (PDT)
From: Alexandre Ferrieux <alexandre.ferrieux@gmail.com>
X-Google-Original-From: Alexandre Ferrieux <alexandre.ferrieux@orange.com>
Message-ID: <64228e38-b619-4836-aa41-1594567db082@orange.com>
Date: Wed, 12 Aug 2026 01:19:07 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] netfilter: nf_dup_netdev: scrub duplicates to
 preserve the direct path
To: Alexandre Ferrieux <alexandre.ferrieux@gmail.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
 edumazet@google.com, netdev@vger.kernel.org
References: <20260804201150.16364-1-alexandre.ferrieux@orange.com>
 <anLzQeYulW2CQItC@chamomile>
 <7b7fbe75-1531-49f9-8134-033c34fa13cb@orange.com>
Content-Language: fr, en-US
Organization: Orange
In-Reply-To: <7b7fbe75-1531-49f9-8134-033c34fa13cb@orange.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

>> On Tue, Aug 04, 2026 at 10:11:50PM +0200, Alexandre Ferrieux wrote:
>>>
>>> In other words, the "dup" path has the potential to wreak havoc
>>> in the direct path as a consequence of secondary link failures. This
>>> is very bad behavior for a monitoring tool, which is the most
>>> obvious application of 'dup'.
>>
>> Can you describe your use-case a bit and how it breaks?
> Sure:
> 
>  - assume hosts A.eth0 and B.eth0 have active production traffic (say TCP)
>  - assume we have a monitoring tool on A that dups eth0's egress to some other
> interface $MON
> 
>     nft add chain netdev ta ch '{type filter hook egress device "eth0" priority
> filter ; policy accept ; }'
>     nft add rule netdev ta ch dup to $MON
> 
>  - assume something goes wrong on $MON generating link failures. In my case it
> was a GRETAP with L3 destination suddenly unreachable.
> 
>  - The next A->B packet goes through normally, but its duplicate hits
> ipv4_link_failure(), hence the dst (which is B) is expired.
> 
>  - As a result, (say) TCP disruptions occur. The thermometer killed the patient :)
> 
> Note: as a straightforward repro, you can simply witness "noise" in simple ping
> sessions, with ghost unreach reports muxed with normal measurement:
> 
>     ip link add gre1 type gretap remote 192.168.1.99 ;# on the LAN, nonexistent
> IP => will generate link failures
>     ip link set dev gre1 up
>     nft add table netdev ta
>     nft add chain netdev ta ch '{type filter hook egress device "eth0" priority
> filter ; policy accept ; }'
>     nft add rule netdev ta ch counter dup to gre1
>     ping -n 8.8.8.8
>  =>
>     PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
>     64 bytes from 8.8.8.8: icmp_seq=1 ttl=115 time=19.9 ms
>     64 bytes from 8.8.8.8: icmp_seq=2 ttl=115 time=12.8 ms
>     64 bytes from 8.8.8.8: icmp_seq=3 ttl=115 time=36.0 ms
>     64 bytes from 8.8.8.8: icmp_seq=4 ttl=115 time=30.3 ms
>     From 192.168.1.13 icmp_seq=5 Destination Host Unreachable
>     64 bytes from 8.8.8.8: icmp_seq=5 ttl=115 time=31.0 ms
>     From 192.168.1.13 icmp_seq=6 Destination Host Unreachable
>     64 bytes from 8.8.8.8: icmp_seq=6 ttl=115 time=38.0 ms
>     From 192.168.1.13 icmp_seq=7 Destination Host Unreachable
>     64 bytes from 8.8.8.8: icmp_seq=7 ttl=115 time=36.8 ms
>     From 192.168.1.13 icmp_seq=8 Destination Host Unreachable
>     64 bytes from 8.8.8.8: icmp_seq=8 ttl=115 time=23.5 ms
>     ^C
> 
> 
>>
>>> This patch fixes all similar scenarii by calling skb_scrub_pkt()
>>> on the clone, severing its link to precious direct-path state.
>>
>> This patch is targetted at the net tree, but nf.git is preferred.
> Okay, will retarget :)
> 
>> As for the conntrack and dst, you have to explain what it breaks on
>> your end.
> Dst as shown above. Conntrack is more speculation, but my take is that in any
> case the dup path should *never* have any kind of retroaction on the observed
> path, so any "complex state" attached to the direct path should be absolutely
> isolated from "whatever happens on the dup path". Am I mistaken ?
What do you think ? Is the description of the problem satisfactory ? Is the
proposed solution acceptable ?

-Alex
