Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF2B212B3D
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Oct 2025 21:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760305466; cv=none; b=sRHZrjoTV0K7ibSoyUQ42kv4kSfV95+FyFzJsXFeQBk7iW4pvfMp1a+J6mOqcvBErCDhY7GOzYXsWwjj+xXE9Q7f8FgLsiOOoUcKroShejJdDMn5VRNxSJG2KJRBVJe+Cvcwa8J3siejDHDJ+tEKLun8+Nd4m+A3Df45Ea/aJY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760305466; c=relaxed/simple;
	bh=T148w7gwZKp8RVbgiwHOFSo6vRgCICCxuIa2huRaKXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BDVxF7yjjXI4fjxqPM+SrX81NDUZt/VqVYEqRkRpN1bv7Ocn/5/dSwKa3gNw0bQ4dNqfWZSgrl7ilRm/7Kiye4zOTLS85r7c8cB5ukRNmLUqr58hBQt6u/CVaYDMgQudmquwizfBSnEgGcR42BDTA1CQoz14g+G/W17LhvLHnPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7716860329; Sun, 12 Oct 2025 23:44:21 +0200 (CEST)
Date: Sun, 12 Oct 2025 23:44:20 +0200
From: Florian Westphal <fw@strlen.de>
To: "Antoine C." <acalando@free.fr>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: Re: bug report: MAC src + protocol optiomization failing with 802.1Q
 frames
Message-ID: <aOwhNIqlsbmeyTPA@strlen.de>
References: <2093285391.1388199126.1760302786604.JavaMail.root@zimbra62-e11.priv.proxad.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2093285391.1388199126.1760302786604.JavaMail.root@zimbra62-e11.priv.proxad.net>

Antoine C. <acalando@free.fr> wrote:
> Following the mails I sent on the user mailing list, it seems that
> there is a bug occurring with the first rule below (the second is
> fine):
> 
> # nft list table netdev t
> table netdev t {
>         chain c {
>               ether saddr aa:bb:cc:dd:00:38 ip saddr 192.168.140.56 \
> log prefix "--tests 1&2 --"
>               ip saddr 192.168.140.56 ether saddr aa:bb:cc:dd:00:38 \
> log prefix "--tests 2&1 --"
>         }
> }
> 
> It is translated this way:
> netdev t c
>   [ meta load iiftype => reg 1 ]
>   [ cmp eq reg 1 0x00000001 ]
>   [ payload load 8b @ link header + 6 => reg 1 ]
>   [ cmp eq reg 1 0xddccbbaa 0x00083800 ]
>   [ payload load 4b @ network header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x388ca8c0 ]
>   [ log prefix --tests 1&2 -- ]
> 
> The MAC source and the protocol are loaded at the same time
> then checked... but with an 802.1Q packet, it is actually 
> wrong: the ethertype will be 0x8100 and the protocol (here 
> IPv4, 0x0800), will be 4 bytes further. And it that case,
> the second test above will succeed because the protocol 
> is loaded independently.
> 
> I just tested with latest versions of libmnl/libnftnl/nft 
> and I get the same behavior.

The question is what these rules should actually match, there
are no consistent semantics in nftables for bridge and
netdev families: The existing behaviour is undefined resp.
random.

Should "ip saddr 1.2.3.4" match:

Only in classic ethernet case?
In VLAN?
In QinQ?

What about IP packet in a PPPOE frame?
What about other L2 protocols?

Pablo, I can't come up with any good answer for this; I think
an explicit dissector expression is needed to populate l3 and l4
information into nft_pktinfo structure for bridge/netdev families so
"ip saddr" would only ever match plain ethernet (no vlans, no pppoe).

This also means the existing skb->protocol based dependencies
need to die resp. check for offloaded vlan headers.

Whats your take?

This is also related to Eric Woudstras work to add qinq+pppoe
automatching.
