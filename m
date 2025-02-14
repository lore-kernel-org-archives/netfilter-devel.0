Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EE627540E
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Feb 2025 07:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739517624; cv=none; b=s4YeApjhv+8yr6fAn+27Xvik+qYtER8MXHxjwdQPM4zO9fGa9etSM0aAWi/q8WJc6LKVwxBO0co8HSa9QCLXXY4wwDAjZWvxTom8L1sWnJwMhnsqSRUFqPsU+4ZyxZ4WTIwuSHm151Yyi0wToFczZZgMkgrQZu88fIVOlX8m9E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739517624; c=relaxed/simple;
	bh=IAnSPXHE+mKJ5EcqZCRDg1W4WQtBtYl46AXPnvt+uts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eoitCukbbRxaSqavR0bIX34pJ3q2Dr8lYBolpBSFEXQ28AhYRw1N/xhkcKc4U+Sz9RkhAkfTJls+nSQucq+g1yUmYDLpnwSXYlyxl1p9xX9FAsL/RWqBbLA5pmeJNSL9H8vzPE9hLa5ChGgu0QBn/uiNuhoPG2M1al70WjblI6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tipzo-0002dz-K9; Fri, 14 Feb 2025 08:20:20 +0100
Date: Fri, 14 Feb 2025 08:20:20 +0100
From: Florian Westphal <fw@strlen.de>
To: Sunny73Cr <Sunny73Cr@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: payload expressions, netlink debug output
Message-ID: <20250214072020.GB9861@breakpoint.cc>
References: <iUf9BfY67Kl_ry63O6gOxJ2YHKmO-OFslzCRzfWVOxIe15iVlUV2G07XiT0qu5bsF9vvyrDRT4TQODjt2ksTfpiv1-nYlhgG5ryzcidhdug=@protonmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <iUf9BfY67Kl_ry63O6gOxJ2YHKmO-OFslzCRzfWVOxIe15iVlUV2G07XiT0qu5bsF9vvyrDRT4TQODjt2ksTfpiv1-nYlhgG5ryzcidhdug=@protonmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sunny73Cr <Sunny73Cr@protonmail.com> wrote:
> It appears that the incorrect register is accepted when data is modified.
> 
> Running Debian 12.9.
> 
> /etc/nftables.conf:
> 
> #!/usr/sbin/nft -f
> flush ruleset
> table inet filter {
>  chain output {
>   type filter hook output priority filter;
> 
>   @ih,0,128 set 0 \
>   accept;
>  }
> }
> 
> output (viewable with /usr/sbin/nft -d all -f /etc/nftables.conf):
> 
> [ immediate reg 1 0x00000000 0x00000000 0x00000000 0x00000000 ]
> [ payload write reg 1 => 16b @ inner header + 0 csum_type 0 csum_off 0 csum_flags 0x1 ]
> [ immediate reg 0 accept ]
> 
> If reg 1 was modified, I believe it should be reg 1 that is accepted.

No, never.  reg0 is the verdict register.
"immediate reg 1 0x0000...." means we store 0 in reg 1.
"immediate reg 0 accept" means we store "accept" in reg 0.

Those are stores, not loads.
