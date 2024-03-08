Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8BE548E8
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2024 11:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709897455; cv=none; b=tAzuHcRA9zHkGqSgYpCgSZjMPYLOIYHzZQJb9wHFQZFfNQpChTEu7pn8ec44MrYpkOj78cZiCBQE7mkReDenpeOnyKXpxSZmkW6HDrrvrExsVn6YowcvFZmAuqwIQsVfIRJ3sKIPNvN1fKx1bN4jDQfigYFcfbw6GmTDsq6x7DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709897455; c=relaxed/simple;
	bh=Ouxo6lGr+b4DVr56KhZVaVy19SUQe1QJ4QScqsd6IcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DjjfcnnfHCyk2cYfVkf5e64fdxMUoWhogdD0qSd1UPzUHHxMcfL7sjPTl+nfYMyo6GRNgm+a3vXCv34v9jnqxguftsH47vjDHa4SXbWTMqdLJq+GIU6LvJydijbBeIl4MbkhnUkFTht5UgiZR0Pg/Knpqi3unIUiTZDAFiWXsuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=BSOT7n49; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BSOT7n49"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kR8IgUm6Cn3cOjRAeom74nMAvFaMJTc+Hg3nXchHP+E=; b=BSOT7n49xoXQTpH1q4EuFgRRjY
	rKz1orSlWvfXoLl510ZbR3QDs/rjzUwIC7rW+d97KtQlUMwDIWArDmofKhEUHkecwV68lxE/cSZNw
	KgPOMBVNLYguEQNcAcd8wAtxZzsweDVHnM7lL/CBSlvTScN8sYfckEgrWy+HY9RDma1kdYgy30heJ
	NU/CEHFJu2HgH+9AKS6hix0ErrbfPhRZKaPSzgyfyW64H1rZM8fPYW+xON0KKx8b9NqvtS9ttAOJ+
	dbgrmGEihZI7pm0Sq515TAcv6xpiBCUBjiHMITD9OBDqWN1TgUZsyREtBpM+8DxEf9SdMdV3WXji0
	Cpqq3yAA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riYR5-000000001xq-1noA;
	Fri, 08 Mar 2024 12:30:47 +0100
Date: Fri, 8 Mar 2024 12:30:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: Sriram Rajagopalan <bglsriram@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: iptables-nft: Wrong payload merge of rule filter - "! --sport xx
 ! --dport xx"
Message-ID: <Zer252IUJr07J_eX@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Sriram Rajagopalan <bglsriram@gmail.com>,
	netfilter-devel@vger.kernel.org
References: <CAPtndGDEJVWXcggRkw66YLjhu3QyUjJ5j4YEbvJLj-qbPkQaPg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPtndGDEJVWXcggRkw66YLjhu3QyUjJ5j4YEbvJLj-qbPkQaPg@mail.gmail.com>

Hi Sriram,

On Fri, Mar 08, 2024 at 02:49:38PM +0530, Sriram Rajagopalan wrote:
> iptables-nft based on nftables has an issue with the way the rule
> filter - "! --sport xx ! --dport xx" is wrongly merged and rendered.

I agree with your analysis and the patches look fine. Could you please
submit them formally?

[...]
> % export IPTABLES=/usr/local/sbin/iptables-legacy; sudo $IPTABLES -A
> INPUT -p tcp ! --sport 22 ! --dport 22 -i vm2; echo -e "\n---- Before
> data ----\n"; sudo $IPTABLES -L INPUT -vvvn; sudo python -c "from
> scapy.all import *;
> sendp(Ether(dst='9e:00:fa:a3:c9:48')/IP(src='1.1.1.1',
> dst='2.2.2.2')/TCP(sport=23, dport=22), iface='vm1')"; echo -e "\n----
> After data with either one of tcp sport/dport being 22 ----\n"; sudo
> $IPTABLES -L INPUT -vn; sudo python -c "from scapy.all import *;
> sendp(Ether(dst='9e:00:fa:a3:c9:48')/IP(src='1.1.1.1',
> dst='2.2.2.2')/TCP(sport=23, dport=23), iface='vm1')"; echo -e "\n----
> After data with neither one of tcp sport/dport being 22 ----\n"; sudo
> $IPTABLES -L INPUT -vn; sudo $IPTABLES -D INPUT -p tcp ! --sport 22 !
> --dport 22 -i vm2
> 
> 
> ---- Before data ----
> 
> ip filter INPUT 41
>   [ meta load iifname => reg 1 ]
>   [ cmp eq reg 1 0x00326d76 ]
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ payload load 2b @ transport header + 0 => reg 1 ]
>   [ cmp neq reg 1 0x00001600 ]
>   [ payload load 2b @ transport header + 2 => reg 1 ]
>   [ cmp neq reg 1 0x00001600 ]
>   [ counter pkts 0 bytes 0 ]

You're fibbing here: That netlink debug output can't come from
iptables-legacy. I suspect it actually comes from your patched
iptables-nft or nft too. :)

[...]
> Author: Sriram Rajagopalan <bglsriram@gmail.com>
> Date:   Fri Mar 07 20:09:38 2024 -0800
> 
> iptables: Fixed the issue with combining the payload in case of invert
> filter for tcp src and dst ports
> 
> Signed-off-by: Sriram Rajagopalan <bglsriram@gmail.com>
> Signed-off-by: Sriram Rajagopalan <sriramr@arista.com>

Maybe avoid the double SoB? Apart from that:

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
