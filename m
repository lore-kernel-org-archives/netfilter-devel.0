Received: from mx1.secunet.com (mx1.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D318137CD42;
	Thu, 19 Mar 2026 11:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.96.220.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773919697; cv=none; b=qfYB646TlHV9k7PmqcDxcYNtfU0Ov9l0O1s9SBx7L2m+ChpCeFA0cWJizrQ4qzebgTctg0RHnz3GY7AnZfK5xfYD7+9uI5USvDGmlcKSmdELj80v6kaGdWc5wNRvyRh5WGQ7BIyD8pqGoTiFba+CcMnsAhRnwncA/F2bCk3hTe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773919697; c=relaxed/simple;
	bh=aOqzJJ5YRI8E/VLa+ga5+6EnThOkbGiIHCc4MREh6VU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XdKAgrFjmlpYiTm7JFa3AtHoKzEQGSbmQNwUeVHdtP8LIjDSGAZ0eQEBwqgEOiHSA2oPMdFtU+r7iDOxRd5XGIubzm7J7q6EX7nOmj4Np4UXkJR2f5FNYgpz21R05c/lRcUdlGSO58emjn1C7DYQeSRoldzERsv0jw5xrEQvFEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com; spf=pass smtp.mailfrom=secunet.com; dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b=QMCWqbyj; arc=none smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=secunet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b="QMCWqbyj"
Received: from localhost (localhost [127.0.0.1])
	by mx1.secunet.com (Postfix) with ESMTP id 827CA207D8;
	Thu, 19 Mar 2026 12:28:10 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from mx1.secunet.com ([127.0.0.1])
 by localhost (mx1.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RtnoKNRB0nW1; Thu, 19 Mar 2026 12:28:10 +0100 (CET)
Received: from EXCH-01.secunet.de (rl1.secunet.de [10.32.0.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.secunet.com (Postfix) with ESMTPS id EDB6B20719;
	Thu, 19 Mar 2026 12:28:09 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.secunet.com EDB6B20719
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secunet.com;
	s=202301; t=1773919690;
	bh=FpPcf2zYVlX/bAnS7l+22UDVIe0i1TfwB7L5FW7b2BI=;
	h=Date:From:To:CC:Subject:References:In-Reply-To:From;
	b=QMCWqbyjItPB2BayX276S7x5X/pNTZTAHZKGm4X60WAb0Lg2jn5n9Js0p1z4LpeQC
	 xihU7ImvtmK9d/QHyZBADE84ooOsNX5vR0cYUKdg7jnMNzQX4YocDN5qVic8jdixrx
	 P2VtDcSc5jb/ZLSwdpcnXJaW7LkKsefQeY5e3mq6YqNMbNvgXtoW34MYziWlRlze68
	 /QVJ+ro9tEXQYo5dHfAvvt0vWjf9zQHnxY9XG7MrSBdVheU5GrnRWlqU26jDty8tjy
	 7SexsYO7rxjzB+cFrQe4+UibNBF40WEmIfyD/R90mtnlLxM85d1SwqcxlrllPrn6K0
	 4WYZktOBDTN3g==
Received: from secunet.com (10.182.7.193) by EXCH-01.secunet.de (10.32.0.171)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 19 Mar
 2026 12:28:09 +0100
Received: (nullmailer pid 3250698 invoked by uid 1000);
	Thu, 19 Mar 2026 11:28:08 -0000
Date: Thu, 19 Mar 2026 12:28:08 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Qingfang Deng <dqfext@gmail.com>
CC: Pablo Neira Ayuso <pablo@netfilter.org>,
	<netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
	<netdev@vger.kernel.org>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <fw@strlen.de>, <horms@kernel.org>,
	<antony.antony@secunet.com>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next,RFC 0/8] netfilter: flowtable bulking
Message-ID: <abvdyDVJ8OYW52fw@secunet.com>
References: <20260317112917.4170466-1-pablo@netfilter.org>
 <20260319061520.356946-1-dqfext@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260319061520.356946-1-dqfext@gmail.com>
X-ClientProxiedBy: EXCH-03.secunet.de (10.32.0.183) To EXCH-01.secunet.de
 (10.32.0.171)

On Thu, Mar 19, 2026 at 02:15:17PM +0800, Qingfang Deng wrote:
> Hi Pablo,
> 
> On Tue, 17 Mar 2026 12:29:09 +0100, Pablo Neira Ayuso wrote:
> > Hi,
> >  
> > Back in 2018 [1], a new fast forwarding combining the flowtable and
> > GRO/GSO was proposed, however, "GRO is specialized to optimize the
> > non-forwarding case", so it was considered "counter-intuitive to base a
> > fast forwarding path on top of it".
> >  
> > Then, Steffen Klassert proposed the idea of adding a new engine for the
> > flowtable that operates on the skb list that is provided after the NAPI
> > cycle. The idea is to process this skb list to create bulks grouped by
> > the ethertype, output device, next hop and tos/dscp. Then, add a
> > specialized xmit path that can deal with these skb bulks. Note that GRO
> > needs to be disabled so this new forwarding engine obtains the list of
> > skbs that resulted from the NAPI cycle.
> 
> +Cc: Felix Fietkau
> 
> How does this compare to fraglist GRO with the original flowtable?

GRO can only aggregate packets of the same L4 flow. This can
aggregate all packets the are treated  the same by the
forwarding path. Packets need to have the same output device
and next hop, but can be from different L3 and L4 flows.

Packet forwarders usually receive many different flows.
GRO might not even kick in if there are not at least
two packets from the same flow on a napi cycle.
