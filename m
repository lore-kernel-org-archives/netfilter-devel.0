Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795600045;
	b=p8yLiPP/y7b1XmKmWPW3ZEJjA5XpGx7cHMjjnLUTab4aD72qnNv59PRb+DOO2SN3CJro
	 /C9Eanyf045E/w4uy4B2Nh5MEWgbvdp/L/QiVQ4alMk0i+8eeoSTVUij+ecwsKCqgafpm
	 ElpUZEzQWf/Pifuolqv9JQQIDkLyIn2Kn/xs4rjc+0bEif2fsccb/hVo2krry8P+R3G1e
	 PXmgLLPOAv4t5c7iyBrP55NutKP4A43NcB6kBUGtzFJp9YBT5aYIMgKjRpqg90+lNDj/S
	 C4fjo5wFdzuhcG24mDFJfiAB+Ly+91e+wOFQxWUYK+YCGSdgtTttnYFG2Ba7BwqILmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795600045;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=WkQtg4o+HEohpzTCn9QEYPwbpcKVcB7YKdwlB0VCIcs=;
	b=RnfkbwMsiGbsAQ+3nHYRNc68h0xqZ4JedgCbiX37o/t9sZHahpkFNJy7lfic0hxW9ugO
	 EUHgL2Wz1BddkNPsD2vqIS1wnWUOw5BjYF45jhXh9KLgw2OinDHGioCYwTKWkLjcIBtx7
	 NgYHuG3oPG+IAyHXafvtIxLLa7LsP9m+LoIM4eF/Vi7iLkJGl5HZiKc1EY2ZF8q0viLth
	 I7WJHw4yvs10Tkpujs34+UQRIdWnnaGGOAdHinhepnnAM5ZHMyWyNMhdcZHwqtB5SZmbm
	 v88HLxlSR9l27Cg5c0g3RcbRGAdT2xIweoR9O+CuloGvIunOawUlQgdA5WXbEqndxAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UIy13ijw;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b="a4eAb/aA";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70E1606A321
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 09:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D70E1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UIy13ijw;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=a4eAb/aA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795600043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WkQtg4o+HEohpzTCn9QEYPwbpcKVcB7YKdwlB0VCIcs=;
	b=UIy13ijwLuQmepoXKf5jGc2QEGp/ojdQ/3mEvQsgHjW0mabpGlQY74jX1PeLMaYuKHv4RX
	0RR2N5OakRfF+7NF4yQLrfjtZd6whpRRQ6aZb3WrqZtI4qA2M6FkVJEU/vEIki+BIT7V8d
	KS46yRVX7kguo9YIzAp7F0lQ1kVT3QA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-0F-eM3fxM16zM7wkvfzJRg-1; Wed, 25 Nov 2026 09:47:21 +0000
X-MC-Unique: 0F-eM3fxM16zM7wkvfzJRg-1
X-Mimecast-MFC-AGG-ID: 0F-eM3fxM16zM7wkvfzJRg_1795600041
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4901562b819so4053933f8f.3
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 01:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795600041; x=1796204841; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WkQtg4o+HEohpzTCn9QEYPwbpcKVcB7YKdwlB0VCIcs=;
        b=a4eAb/aA4dzc8mr949yEz6mv6g0gUKgp7LbVjljf9qEZhxf6XFdFfRdeaDi/GU/OcW
         yvXl/ePz/IHdI8DyR+xfwPmsRTYNVRsVu7gMEIJPUSdi5AvLs1IkPdMtL1jU3eZs34kf
         kBh9PjoTHAsgTksvn256vf/jwoKmB2kJMYclw9AV78Em7sVtp+e3wsm3uz6r7wjnG4iN
         wSg6kLZRU5aFreTWK8H3dH4mIASY9pCrqbEHnsK5vxL+FTr/jBmHimSgsguojallZxbu
         WHebM3HhM9PDkMJDHY4viG7cgd8Khv9w0BF6X7aGNfVU1PwFk0sY27VpNw48GxfuVIoq
         RTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795600041; x=1796204841;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WkQtg4o+HEohpzTCn9QEYPwbpcKVcB7YKdwlB0VCIcs=;
        b=H6Gh/aa1XecqUdieEetQ+vYWFaRronemFf/fls+TI165cq1VeFzcxVDfZTDSfuQtiZ
         l8mijLd4iMmsTVPl2Mb/R4aHbDPq8HUpgpa4qeCSuob39/+5z5fHtp86Cy7qpPjy5Erl
         GmeEFEVKrQqwRf6qN5/0KCnqdmbYM7TFceRCkksEIyyrpvn6CNMg9MdOzsJFfOFqYZmK
         GTtCuQB6IVABvC2XpvQ8ipJQDSCFnbB2jkKu6I2sR2Y1uzbmbWBPFiAJz9q/UGptKHc1
         wMAg1+xaIUjEj/ac/h5PZdFhX/JIxXumk2cBtfR3HdRY9OXWN1Nx7FvzVG6gj1kTGYUm
         kzlQ==
X-Forwarded-Encrypted: i=1; AL+hErGINi2Ayvx+UZDMsreooyH1reKaVK2uf5PEOVOu63doR5rMOvsJBpdBYFXSpqX8pXS0rH2tWQ7OPPm15FD6u2c=@vger.kernel.org
X-Gm-Message-State: APuU4Z/jVSnIeSE+EYtIKyCkaaVte7PvAt8uNvOzrvjcSARxzxRkqKFz
	mEqoOQXBhfygEFQp0aFmfr/zMoKpe1WfTpqPn16q/BGFGbqp3kcO/Sk0bjVG3a7m/Zx0Odx74qU
	XNB5OdINRYMRgaWYtzNngsfrhr9MPMx3nmRQYSrca5IFBEuR2E5ltRx2AYHH+jvwLnjcnmg==
X-Gm-Gg: AZFdTZd3mObabp2uVezr1XhYCsNFIcxfsmuZdFYES8a4FT/UUghjBFXz9BvSD7/oh8o
	4TOYsvFzwln0LbskgWHQvL+K8otABCfh7Qa00GCJ8HBg0Jhzbz1QeXT8M8Ig99aOk5y0/zw8CTF
	uUGZ7QvDTCt8kIjG2r69AdH8/RM6/ZsFVez0n5oAhDrrC2tgVNppiCIAGoAucelVFpiH8pugYt6
	tCjoh1gCXD1yLu18H8swyHHTonXPofCUThOr4Vzo82aeI5vwhG9fKo61g3/qmA7M0Oh3Y76wKPi
	jwnft+o8Y3CzlQuyj0IkShSrlmks4SsEiPcPI2M2Yp9t1z+l+fJT3t2eEyoPhS+cgBe01szB41v
	KZVxcZUZpqQFe/pRF+jMVJowaDfg+O5QCWaF7JM8MS8Y81q6ngkr81ahDf085GLanUtDNPmTPvu
	cX4vxxyWF8AYI8E/JayDfdtP0vsae9MwQcuemwv+fRg0Xl
X-Received: by 2002:a05:6000:29d6:b0:491:fd47:5e02 with SMTP id ffacd0b85a97d-4abb2ce4db9mr21688040f8f.22.1795600040566;
        Wed, 25 Nov 2026 01:47:20 -0800 (PST)
X-Received: by 2002:a05:6000:29d6:b0:491:fd47:5e02 with SMTP id ffacd0b85a97d-4abb2ce4db9mr21687997f8f.22.1795600039986;
        Wed, 25 Nov 2026 01:47:19 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110c3csm32143693f8f.36.2026.11.25.01.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 01:47:19 -0800 (PST)
Message-ID: <3e2585ec-00dc-4884-84be-51162a4d782a@redhat.com>
Date: Wed, 25 Nov 2026 10:47:17 +0100
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
Subject: Re: [PATCH net v4 0/2] ipv6: Honor suppress_prefixlength in
 fib6_lookup()
To: Ido Schimmel <idosch@nvidia.com>, Leonard Lausen <leonard@lausen.nl>,
 kuba@kernel.org
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 Shuah Khan <shuah@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261117110813.9894-2-leonard@lausen.nl>
 <20261124162628.GA3992049@shredder>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261124162628.GA3992049@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/24/26 17:26, Ido Schimmel wrote:
> On Tue, Nov 17, 2026 at 11:08:10AM +0000, Leonard Lausen wrote:
>> This revision removes the cached-exception patch and its PMTU test, as
>> requested. The series fixes the nftables regression introduced by
>> 1c32b24c234b and leaves dst-based prefix suppression unchanged. The
>> cached-exception work is deferred to net-next after the fib6_lookup()
>> fix is present there. Interface-group suppression also remains deferred.
>>
>> Patch 1 makes fib6_lookup() honor suppress_prefixlength while preserving
>> terminal reject results, including blackhole nexthop objects. Patch 2
>> adds six checks to nft_fib.sh using its existing fixture.
> 
> Paolo / Jakub, do you know why this is marked as "Rejected" in
> patchwork? What changes are requested?
Thanks for the head-up.

I think Jakub changed the state, I'm unsure why. I'll re-evaluate
this series ASAP (nowadays can't be very soon).

/P

