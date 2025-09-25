Received: from dragonfly.birch.relay.mailchannels.net (dragonfly.birch.relay.mailchannels.net [23.83.209.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D3731E8B8
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 20:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758832664; cv=pass; b=qNC69/FlkER9LPHJmIdD71tVhUluk6dSBP3cCpPk5UWU1U/SCCcV4a6E+rIOen5G2Z4iWIvgGWY9MFa6eY9/RZZq4rGWoNV9cr7qdFloky+pxV9mGZ6czBWG7nu0RQq0kFKcKMXFO5vtgMBoQZ8G/ciE8mU7IZcFfkH4sKhE410=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758832664; c=relaxed/simple;
	bh=ThYqmhBhQY6doCWOpE+r6bRiGYBtHoWn/7pZetw/bTw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AJxUYpCykxo+poct+a+ZTPgHsCbpJXpWGi8HQabE5r++d7JbygIkhuPxskrIbKEohzw2yuZYfj41cr3i52Qcx4l+RKVctmpjxW5Ws+z+KE0FVJNWAuP9kD37DWGmMaT0dBYs8NAdUsJe3zQRNTv4bNiijAhCqOSKWYN/3Kz9J4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.209.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id DD61D7C24CF;
	Thu, 25 Sep 2025 20:37:35 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-blue-3.trex.outbound.svc.cluster.local [100.112.37.226])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 0ECD67C2433;
	Thu, 25 Sep 2025 20:37:34 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758832655; a=rsa-sha256;
	cv=none;
	b=I+ltoESIZ8Dr/JIrAHnVLbJMxQhmfScn7zFHklb4R3jasxBhnlF38KXPbIOJmocutfQ8A2
	l0fLpeUd54agTSU2Li8Ic6Lbuk9MAZN6FMgpilypSNKzAaMJ+lamjU/+VkQEoD3gTg12DN
	fl9GC14pPAU8E/Fd8ZmR3+uRoiXcyyo/i/SyVta/wJmNzaIvNUI1DymwufZ8dcq5EW+NrC
	hktCXJlAXOsCGa9JirugbzFveOfBoea1PIG7+viKPVx0wKfMZ591imaRB4pF0kdYtuOFAA
	CsqY8VrrmK5CSPCITJIFPjGQ4Cxntj+gP/xrJitXPgMwET/j+uTqRVnjuj1gjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758832655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XwhWFA8xsli417lby4fTshQ8kJOA3zI5fDHo37DunYo=;
	b=52fq7DKJ5oQH4sWjCF1Se2xO041WQctEPDqoxc0jO6B+QB1j9T+w9zBqDRqQWM3xHdGZE3
	n7NnI0O4d6HuouuJ7K/CCtRX94HqIWlIyfsXAwYE/F7ZU6YXjriKShrs3UokhGELR7vnAh
	AR8dv5Dck+WvUCcyNGE6+DXv84Z5McDaImDmRgaBcwY3H3Hf775PK22T5b8Sg0YoQLWOcP
	cGG44wuAo7x5ahYHICr37YRTu28HIiED0GwAeD6amET5/FZ5C3ivFWmCDL2S4/MFQeV5Qt
	6g9qUsEkbc2YUkBav896QnlBAKm8hbopCTHoWcL0Cw9ZvoJ8JiUzX8tPF2JEkQ==
ARC-Authentication-Results: i=1;
	rspamd-598fd7dc44-cxztd;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Shade-Gusty: 54063e9667a8f12e_1758832655737_1684470064
X-MC-Loop-Signature: 1758832655737:154925852
X-MC-Ingress-Time: 1758832655737
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.112.37.226 (trex/7.1.3);
	Thu, 25 Sep 2025 20:37:35 +0000
Received: from [79.127.207.161] (port=64741 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1sid-0000000AebP-2ZBa;
	Thu, 25 Sep 2025 20:37:33 +0000
Message-ID: <3c7ddca7029fa04baa2402d895f3a594a6480a3a.camel@scientia.org>
Subject: Re: nft manpage/wiki issues and improvement ideas
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Date: Thu, 25 Sep 2025 22:37:32 +0200
In-Reply-To: <aNTwsMd8wSe4aKmz@calendula>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
	 <aNTwsMd8wSe4aKmz@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-3 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

On Thu, 2025-09-25 at 09:35 +0200, Pablo Neira Ayuso wrote:
> > 1) Non-documentation issue, could however be a downstream bug:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 # nft describe icmpv6 code
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 payload expression, datatype icmpv6_code=
 (icmpv6 code)
> > (basetype integer), 8 bits
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 # nft describe icmp code
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 payload expression, datatype icmp_code (=
icmp code) (basetype
> > integer), 8 bits
> > =C2=A0=C2=A0=20
> > =C2=A0=C2=A0 produce no (code) output as of at least v1.1.5.
> > =C2=A0=C2=A0 That still worked in older versions.
>=20
> What do you mean by no output?

Well, if I do it with nft v1.0.9 I get:
$ nft describe icmp code
payload expression, datatype icmp_code (icmp code) (basetype integer), 8 bi=
ts

pre-defined symbolic constants (in decimal):
	net-unreachable               	                   0
	host-unreachable              	                   1
	prot-unreachable              	                   2
	port-unreachable              	                   3
	net-prohibited                	                   9
	host-prohibited               	                  10
	admin-prohibited              	                  13
	frag-needed                   	                   4

i.e. the codes are listed.
But on my Debian I merely get:
# nft describe icmp code
payload expression, datatype icmp_code (icmp code) (basetype integer),
8 bits
#

(it does however work on Debian, for describe icmp type).


Cheers,
Chris.
