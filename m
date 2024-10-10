Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A9D1BE86F
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 11:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728558683; cv=none; b=GhG/Qc0ybHyr4ezfHLCZTQo1R3bl5FBWovR4U23z6qAI/Mx85eLYCw3g7wsfmwQ45kvGojR2LHTUlMdd0/EIjXqyNiHlBwrrIdnlufXOgf8MWgOKeCkKM85AaDsEqP8P0SXjMUyGtTOmsS914NqeOjF+jzWVKlmpKiYpGI84XME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728558683; c=relaxed/simple;
	bh=o7IbsV8dylo0DqvCTlAmi71UtXd2b2Wz+sRenj+c4ik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rMsXfwPcuAw09Yciae3GlU+3F9+QZHhiTDNHys5X7DsE2DDUb83sSPDr4/PbGxYoQycGLQqo9N8PxH/zHIU5Sa5nqVwo4hzqRRiluo/xlszXiSjxGvY/y3Uj54oNduInZZokqYJ387STjB/KUSATLmOsjEGz4L0wml8g88wgyxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cF6+9nO+; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cF6+9nO+"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-37d41894a32so502550f8f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 04:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728558680; x=1729163480; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pj084TxEUBCtkebrhLItrb8eMC+iySDPMO5qLZMCJy8=;
        b=cF6+9nO+h1cJVliIfu7VG1TXbWBu69thgYgOMLNF0VFBXKep+g8xd/LxJpTGeYzFSi
         N9Q0zfaoI5zovwat/Sqlta0XUotqtcy4DyCPK1u05WF1TiRaiQ94qdh96OcEPeP+MuYv
         Zk10BXkW1Wj03Iykc16PugS1JyirCQkV5ErZ3+d1mMEM1lLYzy6Jt/ZUnpJgvgCMI5pR
         +mZtYOxZIgnDduHzbryHsr5f/hn1IZMmjjDblSWms56QMg+sM6d4MQTCo2IhAXqQ7sZQ
         lHCSKce1HeIpNl7jYgekFmU9Nb/d0FWwPlFN/yTBR3ZfF2CfqmVT9RDHdffxsBsCK2LZ
         ZsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728558680; x=1729163480;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pj084TxEUBCtkebrhLItrb8eMC+iySDPMO5qLZMCJy8=;
        b=xHlwTFAY/9P0BF1gQrCDkMbROS+JNf/O5JqhOEV7LmNOxvL27H0BZKzfh+RVPiVj5+
         i60qmWk8VluLPvQ5r4V97woQHla12/ZikLxZ1IqwpT1xlzd34I54qv2sbLpFFBSrHqC1
         8Tak6+mzWCPquFEt3p/WHck7JwbVTGOJdyJ1AoXdVe+scuH6bLEkFjB+HKtzlh0VYqc2
         BDv2GR2lOl5mkJQQkOc80EebpuyNBECOT1Ua7+8Kb0IyLiGPxfdbp9yFmDPQ05x94Y4d
         oWEkbSmz3y/aitXXi8ek2iZww2C4TzpILraH06UmMAYHQaEPjnDueZAHD+Vxv94TrWvw
         q63A==
X-Forwarded-Encrypted: i=1; AJvYcCXaFSj3QKtaeibz/CTV582n9feipXMK6NiYARLA8QBhJvFm0e8f7xZA4mT0VwzqFOaJuNaOxVWn2tcwzALngiE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCXMbtsOfIwAJm1RDo03i4cBasRYyACPEgeA1hxKuHeBHF10Vf
	lfFnX7t5ck9SIG9moxewftCr0qf/tvmDT45QaLQEeBwteYd3JJUXrLPCo2WjQcU=
X-Google-Smtp-Source: AGHT+IGFcpGSj3fyXg0OM+eoZ1SokyGRjRn/y2uZRlAa4M0Rr9RImyGRJONGFcLhHHZv9+AKcDMzaw==
X-Received: by 2002:adf:ee82:0:b0:37d:4660:c027 with SMTP id ffacd0b85a97d-37d481d2633mr2359261f8f.24.1728558679904;
        Thu, 10 Oct 2024 04:11:19 -0700 (PDT)
Received: from [10.202.96.10] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8bad3379sm7742455ad.22.2024.10.10.04.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 04:11:18 -0700 (PDT)
Message-ID: <67704d32-d61c-41ec-93ec-95db02b46be7@suse.com>
Date: Thu, 10 Oct 2024 19:11:15 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nf_conntrack_proto_udp: do not accept packets with
 IPS_NAT_CLASH
To: Florian Westphal <fw@strlen.de>
Cc: Hannes Reinecke <hare@kernel.org>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>,
 netfilter-devel@vger.kernel.org, Michal Kubecek <mkubecek@suse.de>
References: <20240930085326.144396-1-hare@kernel.org>
 <20240930092926.GA13391@breakpoint.cc>
 <776f0b5c-7c2d-4668-a29e-38559fc0ee45@suse.com>
 <20241008164517.GA15971@breakpoint.cc>
Content-Language: en-US
From: Yadan Fan <ydfan@suse.com>
In-Reply-To: <20241008164517.GA15971@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 00:45, Florian Westphal wrote:
> Yadan Fan <ydfan@suse.com> wrote:
>> On 9/30/24 17:29, Florian Westphal wrote:
>>> Hannes Reinecke <hare@kernel.org> wrote:
>>>> Commit c46172147ebb changed the logic when to move to ASSURED if
>>>> a NAT CLASH is detected. In particular, it moved to ASSURED even
>>>> if a NAT CLASH had been detected,
>>>
>>> I'm not following.  The code you are removing returns early
>>> for nat clash case.
>>>
>>> Where does it move to assured if nat clash is detected?
>>>
>>>> However, under high load this caused the timeout to happen too
>>>> slow causing an IPVS malfunction.
>>>
>>> Can you elaborate?
>>
>> Hi Florian,
>>
>> We have a customer who encountered an issue that UDP packets kept in
>> UNREPLIED in conntrack table when there is large number of UDP packets
>> sent from their application, the application send packets through multiple
>> threads,
>> it caused NAT clash because the same SNATs were used for multiple
>> connections setup,
>> so that initial packets will be flagged with IPS_NAT_CLASH, and this snippet
>> of codes
>> just makes IPS_NAT_CLASH flagged packets never be marked as ASSURED, which
>> caused
>> all subsequent UDP packets got dropped.
> 
> I think the only thing remaining is to rewrite the commit message to
> say that not setting assured will drop NAT_CLASH replies in case server
> is very busy and early_drop logic kicks in.

Thanks, I will submit a new patch with the new commit message
continuing the work from Hannes.
