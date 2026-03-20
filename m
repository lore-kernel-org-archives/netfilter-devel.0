Received: from mx1.secunet.com (mx1.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918EC355F32;
	Fri, 20 Mar 2026 06:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.96.220.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773989350; cv=none; b=panihDYxh/vmWBFJttvqqUcVGhvBP4An4IqA8yKOdwAGgmYVBxUA6291Xi4j7IORm/hgyggShNQgtYUDLZZgd+vIzW9pz2YSraWVBpiPZVDafVaXJg8eWVkK4/Y68CX4VqLs740aC7S+XJmfUzCFqszO5ODuvCL+xw/+vQYBaLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773989350; c=relaxed/simple;
	bh=/0GIbIMZQIRMYEZhdjs4h4IPbDXFCX/nNCbIPnzfQUI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BuEVVdg1p5W/hGA3d1xuBVRZc/WfWAJRncnQOz6fhjuN9stelXpfQ1U9x5KN7PYLmpZcjN7P2htay2pG0wJyrkQ4jJfmfry2GrzRQdbT5Uofm5ceMRdOZ8Y+ydMzWa9gFaMf3wtDxCnluQZluZYWJF41zjl8zsyvm3i4hqSSuIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com; spf=pass smtp.mailfrom=secunet.com; dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b=wL3tdiGI; arc=none smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=secunet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b="wL3tdiGI"
Received: from localhost (localhost [127.0.0.1])
	by mx1.secunet.com (Postfix) with ESMTP id 009EE20851;
	Fri, 20 Mar 2026 07:49:05 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from mx1.secunet.com ([127.0.0.1])
 by localhost (mx1.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u_tVBpO8pBpe; Fri, 20 Mar 2026 07:49:04 +0100 (CET)
Received: from EXCH-01.secunet.de (rl1.secunet.de [10.32.0.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.secunet.com (Postfix) with ESMTPS id 51F4220826;
	Fri, 20 Mar 2026 07:49:04 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.secunet.com 51F4220826
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secunet.com;
	s=202301; t=1773989344;
	bh=r5SUTevA8Yh+GfkoAHaWh+6lNEe5selD4w2ly6R8puI=;
	h=Date:From:To:CC:Subject:References:In-Reply-To:From;
	b=wL3tdiGI5GWsTIHl+Mf9YB1JacAM8pT/rgklzxqomhyq6ySgqLoEt7ZmXw8oXj5JJ
	 II2N0lV5iX9omWJFMxRNDpzK/XChG/AcmXrQp+ISl+DZF/0e7jSmh4KEa0tlq4uhWI
	 6eXmBOT/uQuZxC0gd77s2/Zv9IZH4tnU5Kl8/sWXpbN80ZeAdnYaVGUYxKj/FY6LUo
	 4c+ehKBOAB0xdHEc1DqO53h9sXyFQGbJ5wApFOca/Cizbm768YUIgEel6kfvS8Dqi5
	 QH9C71UoitPrD1riCTI3StBI4axTayCOrmRvXl/w/Nr6gCgRcV83zbBIEpMEnoQNCV
	 qhNOfoQ2fe8Pw==
Received: from secunet.com (10.182.7.193) by EXCH-01.secunet.de (10.32.0.171)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 20 Mar
 2026 07:49:03 +0100
Received: (nullmailer pid 580119 invoked by uid 1000);
	Fri, 20 Mar 2026 06:49:02 -0000
Date: Fri, 20 Mar 2026 07:49:02 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Felix Fietkau <nbd@nbd.name>
CC: Qingfang Deng <dqfext@gmail.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
	<netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
	<netdev@vger.kernel.org>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <fw@strlen.de>, <horms@kernel.org>,
	<antony.antony@secunet.com>
Subject: Re: [PATCH net-next,RFC 0/8] netfilter: flowtable bulking
Message-ID: <abzt3maph4VFq3wd@secunet.com>
References: <20260317112917.4170466-1-pablo@netfilter.org>
 <20260319061520.356946-1-dqfext@gmail.com>
 <abvdyDVJ8OYW52fw@secunet.com>
 <8f71af62-61c5-44f6-98d4-737034c498c6@nbd.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8f71af62-61c5-44f6-98d4-737034c498c6@nbd.name>
X-ClientProxiedBy: EXCH-03.secunet.de (10.32.0.183) To EXCH-01.secunet.de
 (10.32.0.171)

On Thu, Mar 19, 2026 at 01:18:19PM +0100, Felix Fietkau wrote:
> On 19.03.26 12:28, Steffen Klassert wrote:
> > On Thu, Mar 19, 2026 at 02:15:17PM +0800, Qingfang Deng wrote:
> > > Hi Pablo,
> > > 
> > > On Tue, 17 Mar 2026 12:29:09 +0100, Pablo Neira Ayuso wrote:
> > > > Hi,
> > > >  > Back in 2018 [1], a new fast forwarding combining the flowtable
> > > and
> > > > GRO/GSO was proposed, however, "GRO is specialized to optimize the
> > > > non-forwarding case", so it was considered "counter-intuitive to base a
> > > > fast forwarding path on top of it".
> > > >  > Then, Steffen Klassert proposed the idea of adding a new engine
> > > for the
> > > > flowtable that operates on the skb list that is provided after the NAPI
> > > > cycle. The idea is to process this skb list to create bulks grouped by
> > > > the ethertype, output device, next hop and tos/dscp. Then, add a
> > > > specialized xmit path that can deal with these skb bulks. Note that GRO
> > > > needs to be disabled so this new forwarding engine obtains the list of
> > > > skbs that resulted from the NAPI cycle.
> > > 
> > > +Cc: Felix Fietkau
> > > 
> > > How does this compare to fraglist GRO with the original flowtable?
> > 
> > GRO can only aggregate packets of the same L4 flow. This can
> > aggregate all packets the are treated  the same by the
> > forwarding path. Packets need to have the same output device
> > and next hop, but can be from different L3 and L4 flows.
> > 
> > Packet forwarders usually receive many different flows.
> > GRO might not even kick in if there are not at least
> > two packets from the same flow on a napi cycle.
> 
> Interesting approach! Do you think it might be possible to combine this with
> GRO by bulking together GRO-combined frames from different flows?

This depends on how the GRO packets are crafted. If the packets built
just by adding skb page frags, then yes. If the fraglist pointer is
used to chain packets, then no (our approach uses the fraglist pointer
as well). So combining these would require some changes to the GRO
layer.

> I think it would be unfortunate if you have to choose between decent
> forwarding throughput and decent local rx throughput.

Would be nice if we could tune for both cases, but sometimes it
needs a decision for which use case it should be tuned.
