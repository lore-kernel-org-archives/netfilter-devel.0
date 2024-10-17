Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315451FBC89;
	Thu, 17 Oct 2024 18:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190376; cv=none; b=VvNvuRyfa53aaWGWuFJoZNAP7o0QPCgsj50YzPsrRssF8dJyvP4+kdDgGP9QRiAmOGf6g5eW2zKk3zOtqAcQYI2wUKP5+Vtgnjjqhlk81zQUAijadWMdKHZ5B3GTvXNv98/cCtWFeV8iBTJvWzOT6fiz7587T58A72mNyxtHCPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190376; c=relaxed/simple;
	bh=FxmywgkNUlS99u+UKR5DQby5kzi44L1odyhv89Zm1SU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aemz0/NQCOEMW16h2YaGaJfkv4o6JgP6ffaJOE5O7B7mZsGOs7QdOLXavJm2nGfXDFC+LiMcRPFGr3su81UErRSo8adnyd35pBwN9/5V7mX8cOgdQRj+1YXTUdP3z2QCAG6y8d/tos8/ZPdqh1hDgF1qFh0uK8Um8DGCxNSArqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=none smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=N5VrXGkg; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="N5VrXGkg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=pXm+8IBFvz1ujYC5/BdUieoeB4O8UBo9KmKYceLh5ts=; b=N5VrXGkgAWFovrbKgWzKyOBDom
	d46SQYNLOSfMSOWuHmaIHAObkvJwCWdni6bSN1N8KpOLojafzKd21+7Ys++FKchnkzKicr/jZeVOE
	AB5cuhC6sIIQGfik6tREtlG4yFK3VUEAilMGd9OUAz7A0au20F+kOiUsxFf7OBUtPyU4=;
Received: from p4ff13b65.dip0.t-ipconnect.de ([79.241.59.101] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1t1VP4-00AwP2-1f;
	Thu, 17 Oct 2024 20:39:18 +0200
Message-ID: <b78b8659-d89d-4fd4-b922-f3c24b705deb@nbd.name>
Date: Thu, 17 Oct 2024 20:39:17 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 net-next 00/12] bridge-fastpath and related
 improvements
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Eric Woudstra <ericwouds@gmail.com>,
 Nikolay Aleksandrov <razor@blackwall.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Roopa Prabhu <roopa@nvidia.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Jiri Pirko <jiri@resnulli.us>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20241013185509.4430-1-ericwouds@gmail.com>
 <9f9f3cf0-7a78-40f1-b8d5-f06a2d428210@blackwall.org>
 <a07cadd3-a8ff-4d1c-9dca-27a5dba907c3@gmail.com>
 <0b0a92f2-2e80-429c-8fcd-d4dc162e6e1f@nbd.name>
 <137aa23a-db21-43c2-8fb0-608cfe221356@gmail.com>
 <a7ab80d5-ff49-4277-ba73-db46547a8a8e@nbd.name>
 <d7d48102-4c52-4161-a21c-4d5b42539fbb@gmail.com>
 <b5739f78-9cd5-4fd0-ae63-d80a5a37aaf0@nbd.name> <ZxEFdX1uoBYSFhBF@calendula>
 <eb9006ae-4ded-4249-ad0e-cf5b3d97a4cb@nbd.name> <ZxFS7XBgFXsqUlkO@calendula>
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
In-Reply-To: <ZxFS7XBgFXsqUlkO@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.10.24 20:09, Pablo Neira Ayuso wrote:
> On Thu, Oct 17, 2024 at 07:06:51PM +0200, Felix Fietkau wrote:
>> On 17.10.24 14:39, Pablo Neira Ayuso wrote:
>> > On Thu, Oct 17, 2024 at 11:17:09AM +0200, Felix Fietkau wrote:
>> > [...]
>> > > By the way, based on some reports that I received, I do believe that the
>> > > existing forwarding fastpath also doesn't handle roaming properly.
>> > > I just didn't have the time to properly look into that yet.
>> > 
>> > I think it should work for the existing forwarding fastpath.
>> > 
>> > - If computer roams from different port, packets follow classic path,
>> >    then new flow entry is created. The flow old entry expires after 30
>> >    seconds.
>> > - If route is stale, flow entry is also removed.
>> > 
>> > Maybe I am missing another possible scenario?
>> 
>> I'm mainly talking about the scenario where a computer moves to a different
>> switch port on L2 only, so all routes remain the same.
>> 
>> I haven't fully analyzed the issue, but I did find a few potential issues
>> with what you're describing.
>> 
>> 1. Since one direction remains the same when a computer roams, a new flow
>> entry would probably fail to be added because of an existing entry in the
>> flow hash table.
> 
> I don't think so, hash includes iifidx.

I'm talking about the side where the input ifindex remains the same, but 
the output interface doesn't.

>> 2. Even with that out of the way, the MTK hardware offload currently does
>> not support matching the incoming switch/ethernet port.
>> So even if we manage to add an updated entry, the old entry could still be
>> kept alive by the hardware.
> 
> OK, that means probably driver needs to address the lack of iifidx in
> the matching by dealling with more than one single flow entry to point
> to one single hardware entry (refcounting?).

If we have multiple colliding entries, I think a more reasonable 
behavior would be allowing the newer flow to override the older one.

>> The issues I found probably wouldn't cause connection hangs in pure L3
>> software flow offload, since it will use the bridge device for xmit instead
>> of its members. But since hardware offload needs to redirect traffic to
>> individual bridge ports, it could cause connection hangs with stale flow
>> entries.
> 
> I would not expect a hang, packets will just flow over classic path
> for a little while for the computer that is roaming until the new flow
> entry is added.

If the hardware still handles traffic, but redirects it to the wrong 
destination port, the connection will hang.

- Felix

