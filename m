Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96143225408;
	Fri, 20 Mar 2026 08:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773996638; cv=none; b=G7X3CUZYb307HH5g4CdtoA9n2jUa6WgVyY+VVLaKb594zqc7Lo1hHZLkmRt326RVdvNJSvzVXBYh0kF87kWV8FCpSdiN82sbTcq3Dj/9tF/yWf1GmyZsZoRfznWcadgzvCjg57mC4o6ZDhi8V9QMga1R+FhkwebwdsAjGSGb5Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773996638; c=relaxed/simple;
	bh=Md0ZQriycT3zl5n4Dlo8UQv/016v2ha4A/kgOrNf0zM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AGErXxC/5ke4EMoOHDxr+Cs3Orb2oERo/2CfcsI3cGL+yQ7UyDFSerlh5auC/xOPXCvFqwv1TaOO8ccEo2kIHyeF/Vk2JbcxAXnOXnogpGXg917fuohRCWNaQMFmqCVJxhIR2Qd6VdrHdxaNOQyTqMbaaS0boCKla1IBEST+UzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=TSAGSCpn; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="TSAGSCpn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Bhy0kfSAl4r6+x5+hgOlES6rahWlE0XfZ1NrSa+DtO8=; b=TSAGSCpndv2ewT9uSazEilTaGj
	eXVZAAH1YL6ZGryNMFincO+lMFUKj9FUnOCVSfJhI2iQrqz5GXDZVMDEyMEzzxwElBiQT80yvgvJt
	UVcZKsntIaMAARQHIrzb7d+d9PSWl+ajTJq9U+37B+EtcY6Sam2SmsqDVfOyXgbCVaiY=;
Received: from p5b01521c.dip0.t-ipconnect.de ([91.1.82.28] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1w3VYu-007Zzl-0C;
	Fri, 20 Mar 2026 09:50:32 +0100
Message-ID: <eb7ba04a-b688-475c-8247-1e7e62d60ac3@nbd.name>
Date: Fri, 20 Mar 2026 09:50:31 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next,RFC 0/8] netfilter: flowtable bulking
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Qingfang Deng <dqfext@gmail.com>, Pablo Neira Ayuso
 <pablo@netfilter.org>, netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org,
 antony.antony@secunet.com
References: <20260317112917.4170466-1-pablo@netfilter.org>
 <20260319061520.356946-1-dqfext@gmail.com> <abvdyDVJ8OYW52fw@secunet.com>
 <8f71af62-61c5-44f6-98d4-737034c498c6@nbd.name>
 <abzt3maph4VFq3wd@secunet.com>
Content-Language: en-US
From: Felix Fietkau <nbd@nbd.name>
Autocrypt: addr=nbd@nbd.name; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCeMncXpbbWNT2AtoAYICrKyX5R3iMAoMhw
 cL98efvrjdstUfTCP2pfetyN
In-Reply-To: <abzt3maph4VFq3wd@secunet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.03.26 07:49, Steffen Klassert wrote:
> On Thu, Mar 19, 2026 at 01:18:19PM +0100, Felix Fietkau wrote:
>> On 19.03.26 12:28, Steffen Klassert wrote:
>> > On Thu, Mar 19, 2026 at 02:15:17PM +0800, Qingfang Deng wrote:
>> > > Hi Pablo,
>> > > 
>> > > On Tue, 17 Mar 2026 12:29:09 +0100, Pablo Neira Ayuso wrote:
>> > > > Hi,
>> > > >  > Back in 2018 [1], a new fast forwarding combining the flowtable
>> > > and
>> > > > GRO/GSO was proposed, however, "GRO is specialized to optimize the
>> > > > non-forwarding case", so it was considered "counter-intuitive to base a
>> > > > fast forwarding path on top of it".
>> > > >  > Then, Steffen Klassert proposed the idea of adding a new engine
>> > > for the
>> > > > flowtable that operates on the skb list that is provided after the NAPI
>> > > > cycle. The idea is to process this skb list to create bulks grouped by
>> > > > the ethertype, output device, next hop and tos/dscp. Then, add a
>> > > > specialized xmit path that can deal with these skb bulks. Note that GRO
>> > > > needs to be disabled so this new forwarding engine obtains the list of
>> > > > skbs that resulted from the NAPI cycle.
>> > > 
>> > > +Cc: Felix Fietkau
>> > > 
>> > > How does this compare to fraglist GRO with the original flowtable?
>> > 
>> > GRO can only aggregate packets of the same L4 flow. This can
>> > aggregate all packets the are treated  the same by the
>> > forwarding path. Packets need to have the same output device
>> > and next hop, but can be from different L3 and L4 flows.
>> > 
>> > Packet forwarders usually receive many different flows.
>> > GRO might not even kick in if there are not at least
>> > two packets from the same flow on a napi cycle.
>> 
>> Interesting approach! Do you think it might be possible to combine this with
>> GRO by bulking together GRO-combined frames from different flows?
> 
> This depends on how the GRO packets are crafted. If the packets built
> just by adding skb page frags, then yes. If the fraglist pointer is
> used to chain packets, then no (our approach uses the fraglist pointer
> as well). So combining these would require some changes to the GRO
> layer.

On OpenWrt we use fraglist GRO by default for both TCP and UDP.
Maybe the bulking code could take fraglist GRO packets and simply 
convert them to its internal form of bulking batches.
That way the GRO layer doesn't have to be changed, and it shouldn't add 
too much complexity to the bulking code either.

- Felix
