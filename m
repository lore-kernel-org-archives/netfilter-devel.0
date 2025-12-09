Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7281D219A86
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Dec 2025 16:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765296267; cv=none; b=q/m8SDDlEVuxmL6qDhDPeYrYwoB2baoBeiBq91xyjDwiiJLZkTEx1MzTMw5eAfcH6lOkr61mXNIZNVrhi7eNMI2on7m4ya1o/S5ycaDXnDv8ddreFg31sHfSzotpHChvlkNmhIWRK1Lxye4xRL9dViONE8Y4En8xwE2PE9UpoGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765296267; c=relaxed/simple;
	bh=GyCBy47qoMh5maWIDouS95BXRgOT0dWSevdRRz0577E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WmJTB/og1bkMFwW2LMARwg5HwZOS/83JemYRtd4wOqoGVev6/wi7OA2yyHeDFZdZZz+FUjPCkOTn3XTAUb7jg/VZcYn7K1Yr54s9rqYVLE6re+yTByvJLaXNallQA9eT0wim4kuw4IVXB3DAGcAObNlUI1CTJQXvQLBWHeZey00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A326F6033B; Tue, 09 Dec 2025 17:04:15 +0100 (CET)
Date: Tue, 9 Dec 2025 17:04:10 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Eric Garver <e@erig.me>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] src: Implement ip {s,d}addr6 expressions
Message-ID: <aThIerDrhFoaCiJB@strlen.de>
References: <20251209154048.26338-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209154048.26338-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> These are pseudo payload expressions which represent an IPv4 packet's
> source or destination address as an IPv4-mapped IPv6 address as
> described in RFC4291 section 2.5.5.2[1]. It helps sharing ruleset
> elements like IP address-based sets/maps between rules for IPv4 and IPv6
> traffic.

OK, but why do we need a new keyword for this?

> +ip saddr6 ::ffff:1.2.3.4;ok
> +ip daddr6 ::ffff:1.2.3.4;ok
> +ip saddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee };ok
> +ip daddr6 { ::ffff:1.2.3.4, feed::c0:ff:ee };ok
> +ip saddr6 ::ffff:1.2.3.4 ip daddr 5.6.7.8;ok

None of these examples make sense to me.  How is this useful?

> --- a/tests/py/ip/ip.t.payload
> +++ b/tests/py/ip/ip.t.payload
> @@ -413,6 +413,40 @@ ip test-ip4 input
>    [ bitwise reg 1 = ( reg 1 & 0xffff0000 ) ^ 0x00000000 ]
>    [ cmp eq reg 1 0xffff0000 ]
>  
> +# ip saddr6 ::ffff:1.2.3.4
> +ip test-ip4 input
> +  [ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
> +  [ payload load 4b @ network header + 12 => reg 11 ]
> +  [ cmp eq reg 1 0x00000000 0x00000000 0x0000ffff 0x01020304 ]

Its just a more expensive way to express 'ip saddr 1.2.3.4'?
What would be useful is:

set s {
	typeof ip6 saddr
	...
}

nft add element inet t s { 1.2.3.4 }

... which makes nft autotranslate to '::ffff:1.2.3.4', combined
with

add rule inet t c ip saddr @s ...

... where, instead of rejecting this for the wrong size, autopads
the lookup, i.e.

[ immediate reg 1 0x00000000 0x00000000 0x0000ffff ]
[ payload load 4b @ network header + 12 => reg 11 ]
[ lookup ...

