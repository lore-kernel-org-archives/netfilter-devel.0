Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712CB32F77A;
	Tue,  2 Sep 2025 08:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756803520; cv=none; b=pGA4AzrKE/gYCrISg+FIwV+rhYShjgp4VHBxDsvLA8uctv4Fz2hJWGhvIQZckI+qA3UCokEXZGqia+lkMoSvsvc9YxNk2IGOI6gAGcXN0lnf1+P45Oe4RD0/wNHC5+E+RplaCrRAsfYF7NXTQU7l7u1GLD3wPS+RO9p9Y/l01Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756803520; c=relaxed/simple;
	bh=dizvaM5uk2SJgstG2UirBvrVwGWAlHlo4y3eTJfrs5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cKU+WphEtuqVztGZSprEFdgQDyAMvscmAujDWES5DIY2ArXDEMICRrolargnKLyiNlKGEIUhehIdZ5oCNCpwUwBtvcQfsKhSCxCwakeKAss4Rh5K66LMTjt6rwjKTq/XBTFgvk2oVJ18N84jmOQmvnA1RNRL+6qQF73dJFzoQmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PtflrD5S; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PtflrD5S"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6188b72b7caso5353104a12.2;
        Tue, 02 Sep 2025 01:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756803517; x=1757408317; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4dCGUyt+U1QgwMoGg5yBau3t/Jwvtm0t7+SYOZenbnU=;
        b=PtflrD5SjxD91+V8r5r/cc06ePDheYkZOs8ETrOeEzH6YwnTsZETOiGqZeWHDRRz9e
         b0KyRR9yXM2NWHwhCLQI62T5DY/LTu9NB9frD9iX/p5JeEkwC8aQn2mMsQeNQTVWL+qS
         gx5yI2EhFBo4+D7cQMaw7GT+mwUAOOFkLHVY2ibqte7ImMlFICW7U4zDd7t6DSXovVN6
         qD9CSzJT+5RLgs0snzWSkbfT2agpMLPTYXcy32YeBGFTRF7on39972ibsibqnt+eZn1U
         Nq1C+9q36PUXSiGZqoNHHT9QjFdv2yZya0M+BPCkGY6/blp1+27bT/wC1xXEhjzxfSCu
         IMPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756803517; x=1757408317;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4dCGUyt+U1QgwMoGg5yBau3t/Jwvtm0t7+SYOZenbnU=;
        b=i0Fehs+n1XGEPK1bec7Evq4kFzSg6LGOZjMT1r0GSoEklCtnVEBdaig2u5DpV6cKq/
         v/dDHCQkrhyifrhO6IQV5a/z9s8brxRD+OWtzS1WlhK7pKDMnK+ux3dMSj9MfC2COT8D
         RRJIKCxdbibhipgfYjdBN3Y3T2j/UCRsgmcqleqzeZBuW+/rIBoVAxvZvZzcDn1fJuk1
         9yfE83mcqMT5Ahzi8Otiq3YdZGye67crqyLEH/Gbhf1Pbo00QR9TiAAWdB7jGw/punhi
         oZr3QU/XZFCp+G4aeUHX/snr2A2rwlwQumJSu/EXEq8sWW8ivgi8xOjQK05HBvHwK4NV
         HpTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEi56QNSrk3XTpZqzMS7r94UJns5Grx3xxBE3jF2aG0CxwT2dPhHMFQbzeyH95p8k5aPdFM60=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0OwWkjaZFERRP57MTg6yqvoFLuDU+Hqbt2+a2EEN+lwqCH582
	7e2CSlDlB0ZQ1MpMhRO2kYFA38IsEKCuExZTs06yBAfNIXnghpbNE2ex81eOMuKO
X-Gm-Gg: ASbGncvmovCKnK0t86y9pGhCmavP5joPZIDtWiBMX1eOo4GeyUeSO3zlchmM5HFm8Rt
	lg7S5ToSfIkY+s9nUjsPNFCJrBFAWf1RR9heQEZAeaMqcoZ+zum18R7kMVasGZG7fc7dSsDeUDy
	VCj4WqXslm5nA0VBm7i/okoXKwUUW5K1nOt3FZ8okOBUU9Y07zu0Sf53NbNA5hkGC9Fi+1wDlhK
	YBDIyI5M9qD3JHdy/VJvZ3AcIzcorCKA3PiXsYL/O/0H0k0BI+gaOsqOWNwwQvUNAOxVwk+QP/8
	Th/5YX3i/DoeFJeMei7MyCK5JUahPUt92px2kCFWU/m0vzVkjsgvCY53+IzCWLFwW5ZXFmPqqZS
	CjwRC14Jbj/nzgsgvHStwyV9bMOM7J8p6JAt3gtpgvjP7uRBUsDfz+fBUi5YJ+qW4XxgrElKiji
	k7FhRmZyOBmrEPP27/4/krR1lgwUA2d2SelFJUW4zOFXi+DHXAh/4NHGKgDHNt5n19+gsi5r4rX
	91GenZYkTzlBu+NnZb7w/JAtG8WLt80
X-Google-Smtp-Source: AGHT+IE8fBIeXLjARXQ6XXgP0mt5QaZ7s4jK/a/+B0S9yuq5XhkUWOZAWDjHcpck8qGCj4MzG+me0A==
X-Received: by 2002:a17:907:fdc1:b0:afe:b878:a175 with SMTP id a640c23a62f3a-b01d97a0c24mr1150988066b.46.1756803516509;
        Tue, 02 Sep 2025 01:58:36 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b042fcae867sm404456166b.58.2025.09.02.01.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:58:36 -0700 (PDT)
Message-ID: <0452a9ce-72f4-41c1-b71a-a444d490fd97@gmail.com>
Date: Tue, 2 Sep 2025 10:58:35 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 nf-next 0/3] flow offload teardown when layer 2 roaming
To: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Nikolay Aleksandrov <razor@blackwall.org>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <20250617070007.23812-1-ericwouds@gmail.com>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
X-Priority: 5 (Lowest)
In-Reply-To: <20250617070007.23812-1-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/17/25 9:00 AM, Eric Woudstra wrote:
> This patch-set can be reviewed separately from my submissions concerning
> the bridge-fastpath.
> 
> In case of a bridge in the forward-fastpath or bridge-fastpath the fdb is
> used to create the tuple. In case of roaming at layer 2 level, for example
> 802.11r, the destination device is changed in the fdb. The destination
> device of a direct transmitting tuple is no longer valid and traffic is
> send to the wrong destination. Also the hardware offloaded fastpath is not
> valid anymore.
> 
> This flowentry needs to be torn down asap. Also make sure that the flow
> entry is not being used, when marked for teardown.
> 
> Changes in v3:
> - static nf_flow_table_switchdev_nb.
> 
> Changes in v2:
> - Unchanged, only tags RFC net-next to PATCH nf-next.
> 
> Eric Woudstra (3):
>   netfilter: flow: Add bridge_vid member
>   netfilter: nf_flow_table_core: teardown direct xmit when destination
>     changed
>   netfilter: nf_flow_table_ip: don't follow fastpath when marked
>     teardown
> 
>  include/net/netfilter/nf_flow_table.h |  2 +
>  net/netfilter/nf_flow_table_core.c    | 66 +++++++++++++++++++++++++++
>  net/netfilter/nf_flow_table_ip.c      |  6 +++
>  net/netfilter/nft_flow_offload.c      |  3 ++
>  4 files changed, 77 insertions(+)
> 

What is the status of this patch-set? Is it still being considered to be
applied? Should I re-submit it? Anything I can do, please let me know.

