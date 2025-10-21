Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEC84CB5B;
	Tue, 21 Oct 2025 14:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761057352; cv=none; b=jDPIGlEbJIgb/2T838696Ozxby2AKBq2lUbd7X9IfRzEDqn/zdiGKW9fUcQVm8W/ZYuPm8fA/Z+bXoaghZiavq+HZXlioPr5Zsp2JIAd4y+gBzFdROyKw2iMwjVLx+EXZoMAoj+86ZTP0onO0cKLZ7sn7rhU+pq5j4oRlBp2yPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761057352; c=relaxed/simple;
	bh=hrZnjjo9UXVkwT4UCnJ37NiJduUzf7wEutnz76Qqsc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LNrHjqRrRUcg+ylOWNahJT1VnjSj4G/03dZ7EPb2/EUgVHd7CouunEghTGgIRkcX873t/v0D6ugl65rDdSmWejFM8yfTrAgMUS+oN2kHt17uxl2aEqwh21ow1GvgR6K4GNgDdH6XQZQ6Pjmn3Tr+HQhJtc0TL4yDXYB0tQFSc+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E8D3261117; Tue, 21 Oct 2025 16:35:47 +0200 (CEST)
Date: Tue, 21 Oct 2025 16:35:47 +0200
From: Florian Westphal <fw@strlen.de>
To: Andrii Melnychenko <a.melnychenko@vyos.io>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/1] nf_conntrack_ftp: Added nfct_seqadj_ext_add().
Message-ID: <aPeaQ3BnCRLQ1wNm@strlen.de>
References: <20251021133918.500380-1-a.melnychenko@vyos.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021133918.500380-1-a.melnychenko@vyos.io>

Andrii Melnychenko <a.melnychenko@vyos.io> wrote:
> There is an issue with FTP SNAT/DNAT. When the PASV/EPSV message is altered
> The sequence adjustment is required, and there is an issue that seqadj is
> not set up at that moment.
> 
> During the patch v2 discussion, it was decided to implement the fix
> in the nft_ct. Apparently, missed seqadj is the issue of nft nat helpers.
> The current fix would set up the seqadj extension for all NAT'ed conntrack
> helpers.
> 
> The easiest way to reproduce this issue is with PASV mode.
> Topoloy:
> ```
>  +-------------------+     +----------------------------------+
>  | FTP: 192.168.13.2 | <-> | NAT: 192.168.13.3, 192.168.100.1 |
>  +-------------------+     +----------------------------------+
>                                      |
>                          +-----------------------+
>                          | Client: 192.168.100.2 |
>                          +-----------------------+
> ```
> 
> nft ruleset:
> ```
> nft flush ruleset
> sudo nft add table inet ftp_nat
> sudo nft add ct helper inet ftp_nat ftp_helper { type \"ftp\" protocol tcp\; }
> sudo nft add chain inet ftp_nat prerouting { type filter hook prerouting priority 0 \; policy accept \; }
> sudo nft add rule inet ftp_nat prerouting tcp dport 21 ct state new ct helper set "ftp_helper"
> nft add table ip nat
> nft add chain ip nat prerouting { type nat hook prerouting priority dstnat \; policy accept \; }
> nft add chain ip nat postrouting { type nat hook postrouting priority srcnat \; policy accept \; }
> nft add rule ip nat prerouting tcp dport 21 dnat ip prefix to ip daddr map { 192.168.100.1 : 192.168.13.2/32 }
> nft add rule ip nat postrouting tcp sport 21 snat ip prefix to ip saddr map { 192.168.13.2 : 192.168.100.1/32 }
> 
> # nft -s list ruleset
> table inet ftp_nat {
>         ct helper ftp_helper {
>                 type "ftp" protocol tcp
>                 l3proto inet
>         }
> 
>         chain prerouting {
>                 type filter hook prerouting priority filter; policy accept;
>                 tcp dport 21 ct state new ct helper set "ftp_helper"
>         }
> }
> table ip nat {
>         chain prerouting {
>                 type nat hook prerouting priority dstnat; policy accept;
>                 tcp dport 21 dnat ip prefix to ip daddr map { 192.168.100.1 : 192.168.13.2/32 }
>         }
> 
>         chain postrouting {
>                 type nat hook postrouting priority srcnat; policy accept;
>                 tcp sport 21 snat ip prefix to ip saddr map { 192.168.13.2 : 192.168.100.1/32 }
>         }
> }
> 

Any chance you'd be willing to turn this into a selftest for
tools/testing/selftests/net/netfilter ?

I think it would add value.
Not a hard requirement of course.
