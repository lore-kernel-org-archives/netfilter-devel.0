Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2793376B5
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.252.153.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756829496; cv=none; b=pD+DVMlhOd/89nW6MCYtJ9RA7DObgSA3SIKpe+e4YIFXPRUza/j4LtZ/D7slyFQXuj++MetjCOBdMd8oxk0ppcw/NE+1jerNwBIhOpbzCMp505sV4+pccpbYHnC9zV27M12zFVu8xRP7gU9czVTilJZHo+yokNagXI9RqW1JwWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756829496; c=relaxed/simple;
	bh=4d0AIXbn51jNxXc/sikLdP3pmLb8cLqMgEe7dJmVw4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GZYs7jvFErNXtOMEkyLr5P/98mFWUlFEXlLkBJwg6fZGGYCYKsqOF9wPhG5+jzckQ6GX/0kyWMSOVArPU7qJV/rK+8LWqOvZ5sDvsuFkub1jE8HnXyqFxr7dlPCO2EiJFy8gKx4a5aDARKhpaK9UvYQCZcU6qGEFY02TllFa6to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net; spf=pass smtp.mailfrom=riseup.net; dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b=bhou4dmH; arc=none smtp.client-ip=198.252.153.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riseup.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="bhou4dmH"
Received: from fews03-sea.riseup.net (fews03-sea-pn.riseup.net [10.0.1.153])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1.riseup.net (Postfix) with ESMTPS id 4cGVw639sFzDrt3;
	Tue,  2 Sep 2025 16:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riseup.net; s=squak;
	t=1756829166; bh=x92ApYFDj+uPEDawu5pDA0pI4X3j3cEZpQWsL08TTGA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bhou4dmH4ia2DtYHIAJL5BpEbulsIVDvaHBbIRaUbWkbousyjru861+1eh2NcAhTY
	 0zlQl2rR2FJEFftle7REf77tpD+G32fMN3NLjDJfNAtzx/iBPNHo5QOlkOKusxhuHi
	 W2VNDReltI6SfpWP+7+cXfHKM+TzC9DxEEpDmPjw=
X-Riseup-User-ID: 21AB682050F19790B071652FF1F38A3D28029310C5FE7B5B9F654C340886061C
Received: from [127.0.0.1] (localhost [127.0.0.1])
	 by fews03-sea.riseup.net (Postfix) with ESMTPSA id 4cGVvg6Y8nz1ytj;
	Tue,  2 Sep 2025 16:05:35 +0000 (UTC)
Message-ID: <787566b5-e372-4116-9e47-27e3bf885cf6@riseup.net>
Date: Tue, 2 Sep 2025 18:05:33 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH nf-next] netfilter: nft_meta_bridge: introduce
 NFT_META_BRI_IIFHWADDR support
To: Pablo Neira Ayuso <pablo@netfilter.org>,
 Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
References: <20250902112808.5139-1-fmancera@suse.de>
 <aLbeVpmjrPCPUiYH@strlen.de> <aLcBOhmSNhXrCLIh@calendula>
 <e2c78075-e3b7-4124-a530-54652910a2d5@suse.de> <aLcUJ5U0LWW_-Vo8@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <ffmancera@riseup.net>
In-Reply-To: <aLcUJ5U0LWW_-Vo8@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/2/25 5:58 PM, Pablo Neira Ayuso wrote:
> On Tue, Sep 02, 2025 at 05:34:02PM +0200, Fernando Fernandez Mancera wrote:
>>
>>
>> On 9/2/25 4:37 PM, Pablo Neira Ayuso wrote:
>>> On Tue, Sep 02, 2025 at 02:08:54PM +0200, Florian Westphal wrote:
>>>> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>>>> Expose the input bridge interface ethernet address so it can be used to
>>>>> redirect the packet to the receiving physical device for processing.
>>>>>
>>>>> Tested with nft command line tool.
>>>>>
>>>>> table bridge nat {
>>>>> 	chain PREROUTING {
>>>>> 		type filter hook prerouting priority 0; policy accept;
>>>>> 		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr accept
>>>>> 	}
>>>>> }
>>>>>
>>>>> Joint work with Pablo Neira.
>>>>
>>>> Sorry for crashing the party.
>>>>
>>>> Can you check if its enough to use the mac address of the port (rather
>>>> than the bridge address)?
>>>>
>>>> i.e. add veth0,1 to br0 like this:
>>>>
>>>>           br0
>>>> a -> [ veth0|veth1 ] -> b
>>>>
>>>> Then check br0 address.
>>>> If br0 has address of veth1, then try to redirect
>>>> redirect by setting a rule like 'ether daddr set <*veth0 address*>
>>>>
>>>> AFAICS the bridge FDB should treat this as local, just as if one would
>>>> have used the bridges mac address.
>>>
>>
>> You are right Florian, I have tested this on the following setup.
>>
>> 1. ping from veth0_a on netns_a to veth1_b on netns_b
>>
>>                       +----br0----+
>>                       |           |
>> veth0_a------------veth0      veth1--------veth1_b
>> (192.168.10.10/24)                     (192.168.10.20/24)
>>
>> Using the MAC of the port, the packet is consumed by the bridge too and not
>> forwarded. So, no need for it to be the MAC address of the bridge itself..
> 
> Thanks for confirming.
> 
> But this is going to be a bit strange from usability point of view?
> 
> It is easier to explain to users that by setting the br0 mac address
> (as we do now) packets are passed up to the local stack.
> 


That is a good point. I also do not have a different use-case for iifhwdr..

> Maybe both can be added? But I don't have a use-case for iifhwdr apart
> from this scenario.
> 

I guess it won't hurt to implement ibrhwdr now and in the future, if 
needed, implement iifhwdr although they share a use-case? To be honest, 
I was not aware of this detail and I knew about using the bridge mac 
address before.

What do you think Florian?
