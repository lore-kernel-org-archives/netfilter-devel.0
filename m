Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF3A1F5854;
	Tue, 15 Oct 2024 19:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729021511; cv=none; b=u/q6URYJJ7JonsTK039+PdeVuMF6eE0g/ckcGyvijxcrZKz82bMfREXsnUEuLNVnhlPKQ6l7BARQA6w0h4oJ/c/89OobT3NmQn+rQf6PkJkHZ/JN/pRbAb7p8yADsS017CXT5mhmC7XxULU7sztHMSp8gZ0EYf+A57pKbxWq+Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729021511; c=relaxed/simple;
	bh=Jxw4wtlEr6vIs5MfVc+/KOu5i1arbajJ5xkHL+jGtOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J0bwyjJgFiqjXzdhadv9lxijemKeO6Y7I0OE7XCaF3IHExtLsrT93SAU1m3byjTsvTCApT9ZYRSgfguax/CoaIBtMXAJY5L8JDd0T+koMWWPipIosJNJ6j+p5soc983/P7WHqEXLmaDr3QgsATUVsKagxeP0LR9ZGe9TVVrVwqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=none smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=q0UQPzEo; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="q0UQPzEo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bwhtgi8DcQyDJ8FWIikvDQQ5XGGnfVqxrzGDPV+2pkY=; b=q0UQPzEohGuorgdFB4IwQpx1yq
	GxIVNS6g41P3QuqbKLt22y2lwrJpodiLo3mk1Nfrqv1Pvurq6zvOI6tXrm3k0Jw0mz0PZJ2QosunQ
	lE8xR87+5HHebNwe5uSRwkWAYPaWlOsY9QT8x5IZqBTh+xQKQeojq94bdj/swJAkyv9k=;
Received: from p54ae9bfc.dip0.t-ipconnect.de ([84.174.155.252] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1t0nTR-009Kvt-0i;
	Tue, 15 Oct 2024 21:44:53 +0200
Message-ID: <a7ab80d5-ff49-4277-ba73-db46547a8a8e@nbd.name>
Date: Tue, 15 Oct 2024 21:44:52 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 net-next 00/12] bridge-fastpath and related
 improvements
To: Eric Woudstra <ericwouds@gmail.com>,
 Nikolay Aleksandrov <razor@blackwall.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Roopa Prabhu <roopa@nvidia.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Jiri Pirko <jiri@resnulli.us>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20241013185509.4430-1-ericwouds@gmail.com>
 <9f9f3cf0-7a78-40f1-b8d5-f06a2d428210@blackwall.org>
 <a07cadd3-a8ff-4d1c-9dca-27a5dba907c3@gmail.com>
 <0b0a92f2-2e80-429c-8fcd-d4dc162e6e1f@nbd.name>
 <137aa23a-db21-43c2-8fb0-608cfe221356@gmail.com>
From: Felix Fietkau <nbd@nbd.name>
Content-Language: en-US
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
In-Reply-To: <137aa23a-db21-43c2-8fb0-608cfe221356@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15.10.24 15:32, Eric Woudstra wrote:
> 
> 
> On 10/15/24 2:16 PM, Felix Fietkau wrote:
>> Hi Eric,
>> 
>> On 14.10.24 20:29, Eric Woudstra wrote:
>>> It would be no problem for me to change the subject and body, if you
>>> think that is better.
>>>
>>> The thing is, these patches actually make it possible to set up a fully
>>> functional software fastpath between bridged interfaces. Only after the
>>> software fastpath is set up and functional, it can be offloaded, which
>>> happens to by my personal motivation to write this patch-set.
>>>
>>> If the offload flag is set in the flowtable, the software fastpath will
>>> be offloaded. But in this patch-set, there is nothing that changes
>>> anything there, the existing code is used unchanged.
>> 
>> FWIW, a while back, I also wanted to add a software fast path for the
>> bridge layer to the kernel, also with the intention of using it for
>> hardware offload. It wasn't accepted back then, because (if I remember
>> correctly) people didn't want any extra complexity in the network stack
>> to make the bridge layer faster.
> 
> Hello Felix,
> 
> I think this patch-set is a clear showcase it is not very complex at
> all. The core of making it possible only consists a few patches. Half of
> this patch-set involves improvements that also apply to the
> forward-fastpath.

It's definitely an interesting approach. How does it deal with devices 
roaming from one bridge port to another? I couldn't find that in the code.

>> Because of that, I created this piece of software:
>> https://github.com/nbd168/bridger
>> 
>> It uses an eBPF TC classifier for discovering flows and handling the
>> software fast path, and also creates hardware offload rules for flows.
>> With that, hardware offloading for bridged LAN->WLAN flows is fully
>> supported on MediaTek hardware with upstream kernels.
>> 
>> - Felix
> 
> Thanks, I've seen that already. Nice piece of software, but I'm not
> running openwrt. I would like to see a solution implemented in the
> kernel, so any operating system can use it.

Makes sense. By the way, bridger can easily be built for non-OpenWrt 
systems too. The only library that's actually needed is libubox - that 
one is small and can be linked in statically. ubus support is fully 
optional and not necessary for standard cases.

- Felix
