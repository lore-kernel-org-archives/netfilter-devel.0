Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620E5352FF3
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2025 15:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757606255; cv=none; b=Ftmy+0d52W6VDM3eK7LvPXosaoytQT/TGPQq+MLIksfHXshDPHpAsGnN1DR6iIND/SjNCCZX+YFajgX6sYk8nHh5WTGPEBOQj7s4Y2yuw0tGYnYLleG9z1EFcUYNiiYLtJaG1tqIZPc50cCGx89ZK5hKcja+BiBYpDGuy1qQHHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757606255; c=relaxed/simple;
	bh=UkiOyYtR6bZprTrFkS+tbLhcn1RdZRiM/YmY6xZS5x8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DNBxl0lytJGz1Gxdb/iYeRX7ZjZBozAB+HqJv2JMhdJANi/9WQUetRg8XocbntpvNLx3zAg+ZvGzv8yzLhkI+fyk/7fqVobqHueg+umxev59P5D/BBGf29XwbWJOaHaYjvljMf4bg1YqPHviSSde9or3u6X2uKQKXI3AemzE6+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=AdzCKX/w; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="AdzCKX/w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Lnm9aafU6DnsDJzhQzulo3ZgrYYPGbGxbtNQXWy0Gfw=; b=AdzCKX/wrwIfASsxF5jKJv4wR4
	DLnG3HD+UAzFvFDNFp3bK8PdFDyyvb5UZqOcN+x9sxpG0Il87NW1SDvzuUn/nnLEguiyrc/mpbnhU
	wNFcde9gIKq9oBsuBGZcJVHdvN3qoBBzZMOCy0T9WqlH5TgaDvg0qwhzs8kqleKcpCKPhxgLPcDSz
	eL8Ju9QO2Ybt2DaWIY0f3oL8nKxQH+HgP/mF9FYQXhNlXNs5mP+1rzVlQJxDQNKxOHXT7onTa0VTt
	ql1IXXT/pQF3qLuIbPcPTQZXXbPoyZ8WkhJBp+Ol0ppeeX2WJN1F9LrxdqEfl6WVjH+P7sOp4TjiO
	+vTi5lyA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uwjfr-0000000070g-3xKe;
	Thu, 11 Sep 2025 17:57:28 +0200
Date: Thu, 11 Sep 2025 17:57:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl RFC] data_reg: Improve data reg value printing
Message-ID: <aMLxZ6J-LHVm4KxX@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250911141503.17828-1-phil@nwl.cc>
 <aMLdxyxGNYsSP5c2@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMLdxyxGNYsSP5c2@strlen.de>

On Thu, Sep 11, 2025 at 04:33:58PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > The old code printing each field with data as u32 value is problematic
> > in two ways:
> > 
> > A) Field values are printed in host byte order which may not be correct
> >    and output for identical data will divert between machines of
> >    different Endianness.
> > 
> > B) The actual data length is not clearly readable from given output.
> > 
> > This patch won't entirely fix for (A) given that data may be in host
> > byte order but it solves for the common case of matching against packet
> > data.
> 
> Can you provide an example diff and a diffstat for the expected fallout in
> nftables?

Getting a diffstat is tedious: tests/py will create .got files, but
copying them to their name with that suffix dropped will remove
unproblematic payloads. OTOH dropping all stored payload files upfront
will cause a mess due to needed per-family payload records.

Here's some stats though after running tests/py in standard syntax only:

|% find . -name \*.got | wc -l
|123
|% find . -name \*.got | \
|	while read f; do diff "$f" "${f%.got}"; done | \
|	grep '^>' | \
|	wc -l
|7821

Here are some sample diffs:

| # meta length 1000
| ip test-ip4 input
|   [ meta load len => reg 1 ]
|-  [ cmp eq reg 1 0x000003e8 ]
|+  [ cmp eq reg 1 0xe8030000 ]
| 
| # meta length 22
| ip test-ip4 input
|   [ meta load len => reg 1 ]
|-  [ cmp eq reg 1 0x00000016 ]
|+  [ cmp eq reg 1 0x16000000 ]

The above is noise, data is in host byte order. Ranges are not, though:

| # meta length 33-45
| ip test-ip4 input
|   [ meta load len => reg 1 ]
|   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
|-  [ range eq reg 1 0x21000000 0x2d000000 ]
|+  [ range eq reg 1 0x00000021 0x0000002d ]

Sets are "special", also due to another patch which cleans up output for
them:

| # meta length { 33, 55, 67, 88}
|-__set%d test-ip4 3
|-__set%d test-ip4 0
|-       element 00000021  : 0 [end]     element 00000037  : 0 [end]     element 00000043  : 0 [end]     element 00000058  : 0 [end]
|+       element 21000000        element 37000000        element 43000000        element 58000000 
| ip test-ip4 input
|   [ meta load len => reg 1 ]
|   [ lookup reg 1 set __set%d ]
 
Said patch drops that pointless [end] marker and drops the colon for
non-maps as well as flags if zero (otherwise prints "flags NN" to
separate them from element data). Set definitions are lost in the test
suite runner filter since d477eada4f271 ("tests/py: clean up set backend
support fallout").

But now for some better examples:

| # meta protocol ip
| ip test-ip4 input
|   [ meta load protocol => reg 1 ]
|-  [ cmp eq reg 1 0x00000008 ]
|+  [ cmp eq reg 1 0x0800 ]
|
| # meta l4proto 22
| ip test-ip4 input
|   [ meta load l4proto => reg 1 ]
|-  [ cmp eq reg 1 0x00000016 ]
|+  [ cmp eq reg 1 0x16 ]


Obviously, 'meta protocol' is two bytes and 'meta l4proto' just one.

Strings are much nicer:

| # meta iifname "dummy0"
| ip test-ip4 input
|   [ meta load iifname => reg 1 ]
|-  [ cmp eq reg 1 0x6d6d7564 0x00003079 0x00000000 0x00000000 ]
|+  [ cmp eq reg 1 0x64756d6d 0x79300000 0x00000000 0x00000000 ]

Packet payload is the actual sales pitch for this patch:

| # ip6 saddr 1234:1234:1234::
| inet test-inet input
|   [ meta load nfproto => reg 1 ]
|-  [ cmp eq reg 1 0x0000000a ]
|+  [ cmp eq reg 1 0x0a ]
|   [ payload load 16b @ network header + 8 => reg 1 ]
|-  [ cmp eq reg 1 0x34123412 0x00003412 0x00000000 0x00000000 ]
|+  [ cmp eq reg 1 0x12341234 0x12340000 0x00000000 0x00000000 ]
|
| # ip6 nexthdr 33-44
| inet test-inet input
|   [ meta load nfproto => reg 1 ]
|-  [ cmp eq reg 1 0x0000000a ]
|+  [ cmp eq reg 1 0x0a ]
|   [ payload load 1b @ network header + 6 => reg 1 ]
|-  [ range eq reg 1 0x00000021 0x0000002c ]
|+  [ range eq reg 1 0x21 0x2c ]
|
| # ip6 length != 233
| inet test-inet input
|   [ meta load nfproto => reg 1 ]
|-  [ cmp eq reg 1 0x0000000a ]
|+  [ cmp eq reg 1 0x0a ]
|   [ payload load 2b @ network header + 4 => reg 1 ]
|-  [ cmp neq reg 1 0x0000e900 ]
|+  [ cmp neq reg 1 0x00e9 ]

The combination of network byte order and correct lengths fits perfectly
and even works on Big Endian hosts. Ethernet addresses are 6B:

| # ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept
| ip test-ip input
|   [ meta load iiftype => reg 1 ]
|-  [ cmp eq reg 1 0x00000001 ]
|+  [ cmp eq reg 1 0x0100 ]
|   [ payload load 6b @ link header + 6 => reg 1 ]
|-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
|+  [ cmp eq reg 1 0x000f540c 0x1104 ]
|   [ payload load 4b @ network header + 16 => reg 1 ]
|-  [ cmp eq reg 1 0x04030201 ]
|+  [ cmp eq reg 1 0x01020304 ]
|   [ immediate reg 0 accept ]

The value separating into 4B chunks and the 0x prefix is rather
disturbing here, maybe we should drop at least the prefix entirely (set
elements don't have it, either).


> > Fixing for (B) is crucial to see what's happening beneath the bonnet.
> > The new output will show exactly what is used e.g. by a cmp expression.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > This change will affect practically all stored payload dumps in nftables
> > test suite. I have an alternative version which prints "full" reg fields
> > as before and uses the byte-by-byte printing only for the remainder (if
> > any). This would largely reduce the churn in stored payload dumps, but
> > also make this less useful.
> 
> I think that if we want it then one big code-churn commit would be
> better than multiple smaller ones.

ACK. Hence why I also decided to do some cleanup of set element debug
output - the imminent bulk change is a good occasion.

> The inability to see the width of the compare operation is bad
> for debugging so I would prefer to change it.

As mentioned, we could decide to leave full data fields or at least data
regs of size N*4 alone to reduce churn. But interpreting values becomes
even harder due to the mix of host byte order and "Big Endian".

Cheers, Phil
