Received: from mail.bugwerft.de (mail.bugwerft.de [46.23.86.59])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ACCF128806
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 13:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.23.86.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709818482; cv=none; b=FiN7CggFDl9B4ADpPGIgITj5o1Y+qLVQmz+jLmJ4NOyoTX128qpUDhjtTwaefXRyMeSuWOjAXUWGMe+/k0Vg/iyPaTamWipkEC2FEGjGqVfPL4T21wIumYEL1wOkgKpE7JRrRvmXP0+hmXNvzVjJrzaIdWBSDGMvOI4fkdZ6fi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709818482; c=relaxed/simple;
	bh=yRq1ox96SHfKuU111fdrrNG1Xo6sLpVgPDYNrCzkF0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NUMu1A4noPYAErJTA1fiFWB6p0STzJ42rtxzxZ+O67pTWaBWAyqTK+hggxwZTgLqJp1440yJBNegKRChNhbk1Cbhrk2IZsZv+1C/6KnE+gt40qEPU1Sw2tZJwLnenm7swhKHNOIZbHtCzuv3IxKNtVC9MdVXHWhTKsZGVV6zLtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zonque.org; spf=pass smtp.mailfrom=zonque.org; arc=none smtp.client-ip=46.23.86.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zonque.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zonque.org
Received: from [192.168.100.26] (unknown [62.214.9.170])
	by mail.bugwerft.de (Postfix) with ESMTPSA id 11EF2281561;
	Thu,  7 Mar 2024 13:34:39 +0000 (UTC)
Message-ID: <07000633-1191-445d-b894-8a1d8b0c9044@zonque.org>
Date: Thu, 7 Mar 2024 14:34:38 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Issues with netdev egress hooks
Content-Language: en-US
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
References: <ba22c8bd-4fff-40e5-81c3-50538b8c70b5@zonque.org>
 <ZeizUwnSTfN3pkB-@calendula>
From: Daniel Mack <daniel@zonque.org>
In-Reply-To: <ZeizUwnSTfN3pkB-@calendula>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Pablo,

Thanks a lot for your reply.

On 3/6/24 19:17, Pablo Neira Ayuso wrote:
> On Wed, Mar 06, 2024 at 04:43:02PM +0100, Daniel Mack wrote:
>> Hi,
>>
>> I am using the NFT egress hook in a netdev table with 'set' statements
>> to adjust the source MAC and IP addresses before duplicating packets to
>> another interface:
>>
>> table netdev dummy {
>>   chain egress {
>>     type filter hook egress device "dummy" priority 0;
>>     ether type ip ether saddr set 01:02:03:04:05:06 ip saddr set 1.1.1.1
>> dup to "eth0"
>>   }
>> }
> 
> Is this a dummy device created via: ip link add dummy type dummy or
> just a coincidence?

Yes, it's a dummy device. I'm using the egress netdev hook here because
it is executed before the device's .ndo_start_xmit() is called.

>> The modification of the sender's MAC address works fine. However, the
>> adjustment of the source IP is applied at the wrong offset. The octets
>> in the raw packet that are being modified are 13 and 14, which would be
>> the correct offset within an IP header, but it seems that the prefixed
>> Ethernet header is not taken into account.
>>
>> For the same reason, attempting to filter based on any details beyond
>> the Ethernet header also fails. The following rule does not match any
>> packets, even though there is a significant amount of UDP traffic:
>>
>> table netdev dummy {
>>   chain egress {
>>     type filter hook egress device "dummy" priority 0;
>>     ether type ip ip protocol udp dup to "eth0"
>>   }
>> }
>>
>> At this point, I'm not sure where to start digging to be honest and
>> would appreciate any guidance on how to resolve this issue.
> 
> I guess you are running a kernel with
> 
> commit 0ae8e4cca78781401b17721bfb72718fdf7b4912
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Thu Dec 14 11:50:12 2023 +0100
> 
>     netfilter: nf_tables: set transport offset from mac header for netdev/egress
> 
> so this is a different bug?

Interesting, I did in fact run a 6.4 production kernel when I tried
this, and that didn't have that patch applied. Sorry for that oversight.

On 6.7, what I see is different but still broken:

This rules does the right thing and patches the source MAC correctly:

table netdev dummy {
  chain egress {
    type filter hook egress device dummy priority 0;
    ether saddr set 1:2:3:4:5:6 dup to eth0
  }
}

Whereas trying to patch the IP source addr leads to no packets being
forwarded at all anymore:

table netdev dummy {
  chain egress {
    type filter hook egress device dummy priority 0;
    ip saddr set 1.1.1.1 dup to eth0
  }
}

Interestingly, ether type filtering is also broken now, the following
also doesn't match any packets:

table netdev dummy {
  chain egress {
    type filter hook egress device dummy priority 0;
    ether type ip dup to eth0
  }
}

I browsed through the patches since 6.7 and couldn't find anything that
is related. Did I miss anything?


Best regards,
Daniel

