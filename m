Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792577848;
	b=uOQBHiIvdmfkB0ULJOv7x1tZ9DWvrytcT7wf5VuEgt8beIXghDZqhm+3LlOQmL/2WDdY
	 m8H5s428REsviLXDPVT4nvP/X6ef0HX+phvZNjz9nEshaXTh504jsMVkRa/atkD6OO1x2
	 mWn2NULuo690wHumAW9pxm6/HWKwx4iBcVl9gtwHZ6sQf4nUusvysUthJhSESilnna9/s
	 ief/qU3uEEsa+uBEXF0gUfMzqzKEinBjwIdYW70xsgrKNBc6URx43E+cp1/NojNmeSXKJ
	 5jMTWf5lSP+o5bJOxJJGbm/zkz8LKewX2uHtC8riAHgZgseCW+svi3QDuJQhHRDdGeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792577848;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=PoZ70lGPOlD/1FOjGhMRQJO20juXBS3beq2u8QBnU78=;
	b=MsU0qrfI3oeUgdaf3SsPvYgHSsvTz1IbZwdIP++27lBv8SK8Xuvw39IjYuqsYVpnYFLV
	 8k7IY+YjkZHXjiQ0JRBak29/cZLZqCRCkM58IK0XnsQmGpxIOeXE71n3aGPM6WxxVEdlN
	 CJvPVmwvUbkuf9PhxGehUdtgmYCf5YW/lrg6rCouXb1DByVRuF1o0+iUzeY/aISduasAo
	 5dVToqDww++mqrRPAdqs2EENxaQ9awK9T8nsG9Zco7mXmElZIzSvXGFceWDUTkplzjH/1
	 NxVW2DEN4kDIHu7xRHJJ93Voztm4M4av5ZsD8BIQXF7o9QUhyPUuO9B3WYkX3joiiMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=DpPjvaaV;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E507606A323
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 10:17:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E507606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=DpPjvaaV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PoZ70lGPOlD/1FOjGhMRQJO20juXBS3beq2u8QBnU78=; b=DpPjvaaVvJJIY8w3boul+r2zPi
	afdk0ZhZkqkp1LAcdEVMwZ+OArDalKJEeTjp73KbzaLFu1dXLu/HQYsvm5hzI9YfJrgrUDdYbyZhz
	6WkcxCkND+wrVMfcIVsXYSBWiQJNsn1rRkCWTchwkx21HQlbHo3SKmOC/HOoa2owkffezt9DKD5pZ
	JIAS1UKSemA7LK9XHLN7rD1J4fGr58g68McRf5TEPEJMqVsveW2UTodufbG3vfwMRe8F9pIH5QhmI
	uVLqfF69Nz7j23AkB75HV8AeevdsRP49uCp8VakaU3AfQ5jRwXjzoGiQu+sdlWwTZAFVEE5k6Qt3g
	ifgf91/g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xJTNt-000000001LC-1re4;
	Wed, 21 Oct 2026 12:17:25 +0200
Date: Wed, 21 Oct 2026 12:17:25 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Balazs Gulacsi <m2gulbal@gmail.com>
Subject: Re: [iptables PATCH] extensions: libxt_conntrack: Fail on
 untranslatable state match
Message-ID: <atiRNbVh-1ELNyDX@orbyte.nwl.cc>
References: <20261008182605.257290-1-phil@nwl.cc>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008182605.257290-1-phil@nwl.cc>

On Thu, Oct 08, 2026 at 08:23:51PM +0200, Phil Sutter wrote:
> Iptables' conntrack match supports combined matching on ct->state bits
> as well as the NAT bits in ct->status. The kernel extension matches if
> any of the bits is set, i.e. '-m conntrack --ctstate NEW,DNAT' matches
> packets in either NEW state or DNAT status or both. Therefore,
> translating this sample match into 'ct status dnat ct state new' is
> wrong: The nftables rule matches only if both statements match.
> 
> The only way to achieve this in nftables seems to be by duplicating the
> rule which is not feasible within the xlate infrastructure. So instead
> just abort the translation.
> 
> This is a partial revert of commit 1a13277f88099 ("extensions:
> libxt_conntrack: Fix for ignored ctstates in translation") which turned
> an incomplete translation into an incorrect one.
> 
> Cc: Balazs Gulacsi <m2gulbal@gmail.com>
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1826
> Fixes: 26ec09bf6b9b6 ("extensions: libxt_conntrack: provide translation for DNAT and SNAT --ctstate")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
