Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795565904;
	b=5Q82lQBwSLtDDIu7MhMALwacUYIEfYy6e9QkO88+e/0t8N/mIO60JFz2lXIRCcN1rzuC
	 l4CBpzb0qFxOsrgbcxpL0IkoGRJA8vJCGJoCFy2H0mX8ocQ7yz5dRRNQ3mawvzKVHCgkn
	 zXFrXHFDefCvCYEbXw5xAK/iC7uAHA6KCUzTWNLRhIaQgQAhCU9q0URo615Z1lw5si4ds
	 IN1o3SvDooyIVrIoF1ZJz/NrnM7u5vQZKFGCr17fHzr2aaF7HJcUFeNv8oa5M/q7y6CHI
	 nOJ4ydJNJdhJCTY0PX1kCZ1yKQ8Eg2X3SJaPEM867gPyMUJ199duBNESbnyPvzbBp+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795565904;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=Gfqqz9GJQ8t7shdBItIKdBI7RBZz6HgIIAhioWBr/GY=;
	b=PlMYkq/cC4w3WL+MXoyjF7oarWyU9Bi2mB4BuviVhMhW+79Nx5sxu7HLQ8WODlhRTCps
	 w5EfuHnYdlr3EuUmQaS3lj6FMskY2je4tTXFb3xjSPYJvUVRYwhOVh6HT6MCUt5d/jBU6
	 IgLQRE/dy2iW6aRoQong7RHAhi/bRyWccKUtF3GwNt9o3l9gfbWui7dVFA8vQ7Ouzt5Wb
	 nYAKwglvPwuSHNaIxlaoQZY6/52ZZOWxclx2ixnzfK887OhJUaXkwCpx4+A9m7QGe6n1u
	 0ZG5GFW8xtUOuiqttNQl4hUwBi/o/lI6gYSH65ZtIKimG8MWcvc9t2ra5W81Z6PVl9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=pFizVyxR;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id DA2C1606A31E
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 00:18:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA2C1606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=pFizVyxR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795565901;
	bh=Gfqqz9GJQ8t7shdBItIKdBI7RBZz6HgIIAhioWBr/GY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pFizVyxRPpqyTNrhPb+KieoAF3iPSUxgWPcjM7I1A+RfX7Z/tzYTG0IijYz83PYSd
	 5uV3nBvZRmc0w9WYT4CJAdcgNfGUsDD2WOVTjRFpuCuqXZrz8mknxtVnm/VJVzwb29
	 NZaYrkoUVt5Xr0agWlK4k3SI99hA1gTP3/Vukmxl9goJaAoIUVmXo2SuFNOOAOTACt
	 L/7yTzQJCLVj4Fi8CnGiUwsxJa4KcN1j5UTSirEtG1v3A6HCupTu0F57fcc6LjgoO2
	 U+Y+YKOxYE55Ud1Agq1xarPXiSMy5aEL8XL05ukAivyVv5aQdz92IVRpNVZf5YFZOO
	 ryy9G/bkPtp2Q==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6AE0960074;
	Wed, 25 Nov 2026 01:18:21 +0100 (CET)
Date: Wed, 25 Nov 2026 01:18:18 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/7] src: normalize set element with EXPR_MAPPING
Message-ID: <awYpSv50FCy3yFhV@chamomile>
References: <20250905153627.1315405-1-pablo@netfilter.org>
 <20250905153627.1315405-2-pablo@netfilter.org>
 <awXRzNwL7JIR8InP@orbyte.nwl.cc>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <awXRzNwL7JIR8InP@orbyte.nwl.cc>

Hi Phil,

On Tue, Nov 24, 2026 at 07:05:00PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Fri, Sep 05, 2025 at 05:36:21PM +0200, Pablo Neira Ayuso wrote:
> > EXPR_SET_ELEM provides the timeout, expiration, comment and list of
> > statements, this is a shim expression.
> > 
> > Currently, expr_set(x)->expressions can have either:
> > 
> > - EXPR_SET_ELEM
> > 
> >         EXPR_SET_ELEM -> EXPR_VALUE
> > 
> > - EXPR_MAPPING, which contains EXPR_SET_ELEM in the lhs.
> > 
> >                       EXPR_SET_ELEM -> EXPR_VALUE
> >                      /
> > 	EXPR_MAPPING |
> >                      \
> >                       EXPR_VALUE
> > 
> > This patch normalizes the expression for mappings:
> > 
> >                                        EXPR_SET_ELEM -> EXPR_VALUE
> >                                       /
> > 	EXPR_SET_ELEM -> EXPR_MAPPING |
> >                                       \
> >                                        EXPR_VALUE
> > 
> > The previous representation makes it natural for expr_print() to print the
> > timeout, expiration, statements and comments.
> > 
> > 	1.1.1.1 counter packets 1 bytes 564 : 0x00000001,
> > 
> > This patch adds an exception for expr_mapping_print() to stick to the
> > existing representation.
> > 
> > The JSON representation provides this set element information too in the
> > lhs, which is does not really belong there because it is exposing
> > transparently the syntax tree for set elements. A workaround to retain
> > compatibility is included in this patch.
> > 
> > The end goal is to replace EXPR_SET_ELEM by a smaller shim object, to
> > further reduce memory consumption in set elements in userspace.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Git bisect identified this commit as the culprit of a regression I
> noticed: Restoring the following ruleset exposes it:
> 
> | table inet t {
> | 	map m6 {
> | 		typeof numgen inc mod 2000 : ct zone
> | 		elements = { 1 : 1 }
> | 	}
> | }
> 
> When listing, the element shows as '16777216 : 1', whereas:
> 
> | % bc <<< "obase = 16; 16777216"
> | 1000000
> 
> The key seems to be in wrong byte order. It is not just a display issue:
> nft_zones_many.sh kselftest is failing due to it which performs lookups
> in such a set.

Yes, wrong byteorder. TYPE_INTEGER (integer_type) uses
BYTEORDER_INVALID in this case, which is handled as
BYTEORDER_BIG_ENDIAN for historical reasons.

> Can you quickly point at where we lost some byteorder conversion (or got
> an extra one?) by your patch? I guess it missed to adjust a check. I'll
> start digging through the code meanwhile, but tracing expression
> manipulation in eval phase is tedious. :(

Patch:
https://lore.kernel.org/netfilter-devel/20261124235306.1777-1-pablo@netfilter.org/

This rework uncovered this underlying bug.

BTW, nft --debug=netlink does not help to find endianness bugs anymore.

nft --debug=netlink -f /tmp/o 
family 1 m6 t 8
family 1 m6 t 0
        element 00000001 : 0001

This looks right...

... but --debug=mnl uncovers the bug:

|00032|N-|00003|        |len |flags| type|
|00028|N-|00001|        |len |flags| type|
|00012|N-|00001|        |len |flags| type|
|00008|--|00001|        |len |flags| type|
| 00 00 00 01  |        |      data      | <--- 01 00 00 00 !
|00012|N-|00002|        |len |flags| type|
|00006|--|00001|        |len |flags| type|
| 01 00 00 00  |        |      data      |

