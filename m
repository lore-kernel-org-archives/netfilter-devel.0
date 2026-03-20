Received: from mx1.secunet.com (mx1.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB1432E69A;
	Fri, 20 Mar 2026 09:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.96.220.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773997261; cv=none; b=NAHSstYAukzq2gVR+M8kX+K/QAMF4BteQHbhYElTrZ0KwN8qBP0bL0rFaDsInNQpH45PoR/x0WFua1/ZjhUGHpDntV7eCLBru1kYVpdu1C3S95ycDUF5GivBEPZnm87dvYk4VXqtBMzWvSgAhf8oJEli5S5S8ukX9eC2fGoR3+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773997261; c=relaxed/simple;
	bh=yWRqGYW9henWppQGr9spTjFkIAhOjEclxFIFQGNTv2I=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=txndargZjOLibgYPyFh+lCrWMsOXaCx6yFe7NroQlaBnI/2O7WkG2Ug/DAtHl6pIQvg9g2U++parA8tcqxDWlleoG1Sky3CLKwypRXnal2s68ze8ANmmQQjHbr8g7LCePSvTZ3KGqD/WGseVokx/Xbpf2Ej8MHtxB186+twDyak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com; spf=pass smtp.mailfrom=secunet.com; dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b=L8rWMyDt; arc=none smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=secunet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b="L8rWMyDt"
Received: from localhost (localhost [127.0.0.1])
	by mx1.secunet.com (Postfix) with ESMTP id 6F319206B0;
	Fri, 20 Mar 2026 10:00:57 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from mx1.secunet.com ([127.0.0.1])
 by localhost (mx1.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tDlXtIxFloLA; Fri, 20 Mar 2026 10:00:56 +0100 (CET)
Received: from EXCH-01.secunet.de (rl1.secunet.de [10.32.0.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.secunet.com (Postfix) with ESMTPS id B463A207D8;
	Fri, 20 Mar 2026 10:00:56 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.secunet.com B463A207D8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secunet.com;
	s=202301; t=1773997256;
	bh=Ih6XIm9zWH43Qd9VtL3P4SQdRfzxnZNZPdBnUvpieIo=;
	h=Date:From:To:CC:Subject:References:In-Reply-To:From;
	b=L8rWMyDtQcDUesINgwa8XvHp4PHW1Z3dBlRjPEhi3H3XILaEoTtJcfT7EBHz23XgN
	 ic90OYzqM1/8UpsVHx4sl84mMeS95vJ/lU+fy/vraNlDyvF54NoFEnfCw9jCW0hMJ/
	 kOnhEcQXg9mvLyQI5oVteiQHeYEuv7x9Hvm0LgqWqYfP3qPSg+rVqZb7AU774Tr5jm
	 ljeOSdqSRD6Cp36btVibHqGQUT/N1VUbt1g1o1oyQwBQI1x6BKEZN5SfQk5wzoldYj
	 czXTSu/STqrKzetcmI2+A931NQi0uMHnK6N9ahhQ52663UwMCCAHHxoCQe2rbirfqq
	 LXRMoQeUy5HDQ==
Received: from secunet.com (10.182.7.193) by EXCH-01.secunet.de (10.32.0.171)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 20 Mar
 2026 10:00:56 +0100
Received: (nullmailer pid 647907 invoked by uid 1000);
	Fri, 20 Mar 2026 09:00:55 -0000
Date: Fri, 20 Mar 2026 10:00:55 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Felix Fietkau <nbd@nbd.name>
CC: Qingfang Deng <dqfext@gmail.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
	<netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
	<netdev@vger.kernel.org>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <fw@strlen.de>, <horms@kernel.org>,
	<antony.antony@secunet.com>
Subject: Re: [PATCH net-next,RFC 0/8] netfilter: flowtable bulking
Message-ID: <ab0Mx1DpXmz4UvRq@secunet.com>
References: <20260317112917.4170466-1-pablo@netfilter.org>
 <20260319061520.356946-1-dqfext@gmail.com>
 <abvdyDVJ8OYW52fw@secunet.com>
 <8f71af62-61c5-44f6-98d4-737034c498c6@nbd.name>
 <abzt3maph4VFq3wd@secunet.com>
 <eb7ba04a-b688-475c-8247-1e7e62d60ac3@nbd.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <eb7ba04a-b688-475c-8247-1e7e62d60ac3@nbd.name>
X-ClientProxiedBy: EXCH-02.secunet.de (10.32.0.172) To EXCH-01.secunet.de
 (10.32.0.171)

On Fri, Mar 20, 2026 at 09:50:31AM +0100, Felix Fietkau wrote:
> On 20.03.26 07:49, Steffen Klassert wrote:
> > On Thu, Mar 19, 2026 at 01:18:19PM +0100, Felix Fietkau wrote:
> > > On 19.03.26 12:28, Steffen Klassert wrote:
> > > > On Thu, Mar 19, 2026 at 02:15:17PM +0800, Qingfang Deng wrote:
> > > > > Hi Pablo,
> > > > > > > On Tue, 17 Mar 2026 12:29:09 +0100, Pablo Neira Ayuso wrote:
> > > > > > Hi,
> > > > > >  > Back in 2018 [1], a new fast forwarding combining the flowtable
> > > > > and
> > > > > > GRO/GSO was proposed, however, "GRO is specialized to optimize the
> > > > > > non-forwarding case", so it was considered "counter-intuitive to base a
> > > > > > fast forwarding path on top of it".
> > > > > >  > Then, Steffen Klassert proposed the idea of adding a new engine
> > > > > for the
> > > > > > flowtable that operates on the skb list that is provided after the NAPI
> > > > > > cycle. The idea is to process this skb list to create bulks grouped by
> > > > > > the ethertype, output device, next hop and tos/dscp. Then, add a
> > > > > > specialized xmit path that can deal with these skb bulks. Note that GRO
> > > > > > needs to be disabled so this new forwarding engine obtains the list of
> > > > > > skbs that resulted from the NAPI cycle.
> > > > > > > +Cc: Felix Fietkau
> > > > > > > How does this compare to fraglist GRO with the original
> > > flowtable?
> > > > > GRO can only aggregate packets of the same L4 flow. This can
> > > > aggregate all packets the are treated  the same by the
> > > > forwarding path. Packets need to have the same output device
> > > > and next hop, but can be from different L3 and L4 flows.
> > > > > Packet forwarders usually receive many different flows.
> > > > GRO might not even kick in if there are not at least
> > > > two packets from the same flow on a napi cycle.
> > > 
> > > Interesting approach! Do you think it might be possible to combine this with
> > > GRO by bulking together GRO-combined frames from different flows?
> > 
> > This depends on how the GRO packets are crafted. If the packets built
> > just by adding skb page frags, then yes. If the fraglist pointer is
> > used to chain packets, then no (our approach uses the fraglist pointer
> > as well). So combining these would require some changes to the GRO
> > layer.
> 
> On OpenWrt we use fraglist GRO by default for both TCP and UDP.
> Maybe the bulking code could take fraglist GRO packets and simply convert
> them to its internal form of bulking batches.

This is possible, but would run the bulking logic two times
in the forwarding path.

The problem is the standard GRO. This also use the fraglist pointer if
MAX_SKB_FRAGS is reached. Converting this back is complicated. That would
not be a forwarding fastpath anymore.
