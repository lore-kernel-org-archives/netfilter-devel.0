Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DF23749F2
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 11:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474342; cv=none; b=R7r7WwTg1OqGZGY5n4BBLyZdboKpu82iJLUVqwe1VAAq/UkYZ4hJhgiPhXEnLG3ALqlVVuPFnOjTQVBy1U9WgbU0bwI0dG/2cEsF/FvTGmF8UMaOQRZ3u9yZV0Sd29XiY/qyzHNAtqx3MpwMv2mpRebrlX7P6pkkPxxOKjXjyeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474342; c=relaxed/simple;
	bh=4ZPwkkIJ/NnWVuLOYt7j0WZGdzSsiiUExhBrTdyiVeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aEQ0DBv00FVOh/k38en2p1z+PbA2PHSlUks2NJ31f09wIeLf3XI8CHyBllpNI717DpgKkDqJ4lWIfbEM4x+vRir01I9Rlupr0qFkdZob+x0yH9Ce6NzqHiTiA40E2s4KfD/gOchWqrQj9QbsxrMHIBRq4Tlw6oDZBwVk+BtBxoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rx0mBJj8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rx0mBJj8"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7162260591;
	Fri, 26 Jun 2026 13:45:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782474339;
	bh=vwKPjY1i8YmzSINWiUS3vYaF+PfyPopJIZtv/OYCAB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rx0mBJj8rn5Imy+UOULAc14WxdiExWK6agQNFLiiA2bdQg8TuqBgyjz55gNIbMGXO
	 YPMu4baXre108pP6Mh1ESJigF0QU1L9S42+Fk5R0M0J8bosyUEKQjONLpnFfCZFmBy
	 LUbdsk0SxPJXou9PtyKpMgYsBiZ/e3mcSr4xXkCGn86hJqHhvifTfkFjTwcStfnVgb
	 8KlJRFZwIMKoOy6zfbcGfuWSlBcMs/RzJSo0Z21FViCJWpTAmZ1viUdDFdDC65ie7A
	 Whf8CXWw4cbQdAHJHj3LoNBfpgknBJYlazs4RQes/sZ9C17VhT2cednokBnIvdtwdX
	 6JM9YSWYDIRFA==
Date: Fri, 26 Jun 2026 13:45:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: PrittSpadeLord <pritt1999@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] minor spelling and grammar fixes in doc
Message-ID: <aj5mYeKqJkJBmpin@chamomile>
References: <20260620083719.115461-1-pritt1999@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260620083719.115461-1-pritt1999@gmail.com>

Hi,

Thanks for your patch.

Can I get a real name for your Signed-off-by: ?

On Sat, Jun 20, 2026 at 02:07:17PM +0530, PrittSpadeLord wrote:
> Signed-off-by: PrittSpadeLord <pritt1999@gmail.com>
> ---
>  doc/nft.txt                | 8 ++++----
>  doc/payload-expression.txt | 8 ++++----
>  doc/statements.txt         | 2 +-
>  3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/doc/nft.txt b/doc/nft.txt
> index cee92c2b..0f37782c 100644
> --- a/doc/nft.txt
> +++ b/doc/nft.txt
> @@ -592,7 +592,7 @@ This is a summary of how the ruleset is evaluated.
>  * For each hook, the attached chains are evaluated in order of their priorities.
>    Chains with lower priority values are evaluated before those with higher ones.
>    The order of chains with the same priority value is undefined.
> -* An *accept* verdict (including an implict one via the base chain’s policy)
> +* An *accept* verdict (including an implicit one via the base chain’s policy)
>    ends the evaluation of the current base chain.
>    It is not relevant if the *accept* verdict is issued in the base chain itself
>    or a regular chain called from the base chain.
> @@ -601,7 +601,7 @@ This is a summary of how the ruleset is evaluated.
>    chain policy issues a *drop* verdict.
>    All this applies to verdict-like statements that imply *accept*,
>    for example the NAT statements.
> -* A *drop* verdict (including an implict one via the base chain’s policy)
> +* A *drop* verdict (including an implicit one via the base chain’s policy)
>    immediately ends the evaluation of the whole ruleset.
>    No further chains of any hook are consulted.
>    It is therefore not possible to have a *drop*
> @@ -611,7 +611,7 @@ This is a summary of how the ruleset is evaluated.
>    Thus, if any base chain uses drop as its policy, the same base chain (or a
>    regular chain directly or indirectly called by it) must contain at least one
>    matching *accept* rule or the packet will be dropped.
> -* Given the semantics of *accept*/*drop* and only with respect to the utlimate
> +* Given the semantics of *accept*/*drop* and only with respect to the ultimate
>    decision of whether a packet is accepted or dropped, the ordering of the
>    various base chains per hook via their priorities matters only in so far, as
>    any of them modifies the packet or its meta data and that has an influence on
> @@ -767,7 +767,7 @@ Without this flag, *1.2.3.2* can not be added and *1.2.3.5* is inserted as a new
>  Equality of a value with a set is given if the value matches exactly one value
>  in the set (which for intervals means that it’s contained in any of them).
>  See <<BITMASK_TYPE>> for the subtle differences between syntactically similarly
> -looking equiality checks of sets and bitmasks.
> +looking equality checks of sets and bitmasks.
>  
>  MAPS
>  -----
> diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
> index 817b7a3c..ceccfdaa 100644
> --- a/doc/payload-expression.txt
> +++ b/doc/payload-expression.txt
> @@ -594,7 +594,7 @@ GENEVE HEADER EXPRESSION
>  *geneve* *udp* {*sport* | *dport* | *length* | *checksum*}
>  
>  The geneve expression is used to match on the geneve header fields. The geneve
> -header encapsulates a ethernet frame within a *udp* packet. This expression
> +header encapsulates an ethernet frame within a *udp* packet. This expression
>  requires that you restrict the matching to *udp* packets (usually at
>  port 6081 according to IANA-assigned ports).
>  
> @@ -647,7 +647,7 @@ VXLAN HEADER EXPRESSION
>  *vxlan* *udp* {*sport* | *dport* | *length* | *checksum*}
>  
>  The vxlan expression is used to match on the vxlan header fields. The vxlan
> -header encapsulates a ethernet frame within a *udp* packet. This expression
> +header encapsulates an ethernet frame within a *udp* packet. This expression
>  requires that you restrict the matching to *udp* packets (usually at
>  port 4789 according to IANA-assigned ports).
>  
> @@ -707,7 +707,7 @@ inet filter input meta l4proto {tcp, udp} th dport { 53, 80 }
>  it is more convenient, but like the raw expression notation no
>  dependencies are created or checked. It is the users responsibility
>  to restrict matching to those header types that have a notion of ports.
> -Otherwise, rules using raw expressions will errnously match unrelated
> +Otherwise, rules using raw expressions will erroneously match unrelated
>  packets, e.g. mis-interpreting ESP packets SPI field as a port.
>  
>  .Rewrite arp packet target hardware address if target protocol address matches a given address
> @@ -935,4 +935,4 @@ ct_id|
>  --------------------
>  nft add set filter ssh_flood '{ type ipv4_addr; flags dynamic; }'
>  nft add rule filter input ct state new tcp dport 22 add @ssh_flood '{ ip saddr ct count over 2 }' reject
> ---------------------
> +--------------------
> \ No newline at end of file
> diff --git a/doc/statements.txt b/doc/statements.txt
> index 8f96bf6b..7f7b5e60 100644
> --- a/doc/statements.txt
> +++ b/doc/statements.txt
> @@ -795,7 +795,7 @@ unsigned integer (16 bit)
>  |==================
>  |Flag | Description
>  |bypass |
> -Let packets go through if userspace application cannot back off. Before using
> +Let packets go through if the userspace application cannot back off. Before using
>  this flag, read libnetfilter_queue documentation for performance tuning recommendations.
>  |fanout |
>  Distribute packets between several queues.
> -- 
> 2.54.0
> 
> 
