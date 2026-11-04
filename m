Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793790669;
	b=VEjJ564kww4C/RhJKjOi6aird69QJMmFKki6DfNW6VU9UNnzEY76s6DsUNt1EWOCYqtJ
	 K+T6msxXlrTYpb6HbGHzcSkX7N43CLi8pKUfhG0TV1YlL8JGNdBeKoIp2wBgrjSacoxYx
	 mj6SAAg/qne9K0dpdclKseEX6OA2X/uGJGmxho6Ch2m6H+9DInZbM+s5IPWy+dlD4IVrt
	 xN5gF7xcqxplTo5zV8FRaZxsDizjg8eN8l5OEqwHknDTETegOiAPOYlKQy1cLi7Cfzo1b
	 yFUPN5thicj5fWAfB+fZYR84pDOvkApjvXEkKX2PmN4siS108ZKjJywH1qodck6NmYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793790669;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=9bpe+w93KCs6RumM+fitofSNa2WDiA+xQdUVmGR1mdI=;
	b=oc8ZaZpUeCURP9P2WnywA3MQC024pgE09QYFZfr7sV79MCfp1oHasC1MOdxNwXKpAey4
	 abjFR4TajEwZEOReVr+qrUK5vmMPUkIeQjqPrkr3CCwZYhAApx+GIxeUznt+IhJiTkFNb
	 9+3diXObt7AaRlm+gQ46MM+VxHOEhqXN6P7zOBc4dDCnC8+xmZqyZK7sP4jH6+JF0pXZ9
	 WsNuallaU5XSvlvejFHG7XNbphc2/dJ2ak7zvrRBlYoScEbsYRkIHVVxdg5xzcqqORDh+
	 6xPyJid8WTTbxULHuDGyyZlzrr2nJjJWiqszq2hNG6mZX2KCgwC+h0NnYiZCqFakt+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=g7zfL8+O;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CAF54606A326
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2026 11:11:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAF54606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=g7zfL8+O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793790666;
	bh=9bpe+w93KCs6RumM+fitofSNa2WDiA+xQdUVmGR1mdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g7zfL8+O+1jQaw4OBjuIHtLW5bp9tSrH8rRVDIc/lnRwej7lYgvj++H1kBoz7h+VJ
	 OJehqzHODv2AMXLmFVlU9JZA2BzvBpcLYUM2zHcCeBtI1PY56enmfZGBu32Cdtkz+K
	 3dlh0GDURgy6Of5AQaxH/+yQoI+rJiMx+pjtVR3UpI51yjjxicKd/g7tGdoJ7I94G1
	 EifxNaZcx8TaYMJrdNzzrRL2D56LLh8atdPV57IUC52/36S6uJCgEXXa0UFsG7IB3p
	 Q4CIHU1tscwv3UZyqQ4478UGO2fi/+7Y83T12gxoMXhEeKNmZKmJhs4lPdu+Wnytfp
	 0ryT7bElWWmFg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6353360056;
	Wed,  4 Nov 2026 12:11:06 +0100 (CET)
Date: Wed, 4 Nov 2026 12:11:03 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: xelra <xelra@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>
Subject: Re: [nft] 1.1.7: limit rate without burst breaks later tokens
Message-ID: <ausSx0uJvqau0txv@chamomile>
References: <VPAY0CnKhCaOKYE6oo_AU7sR5MaGIGzyPkXi00RlaucbyN78KYBqK73XfyJ-yyXQENIvvXeFJq_fNrYbJuW8LcqZvZyf4J3kr66jvsojxCU=@protonmail.com>
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
In-Reply-To: <VPAY0CnKhCaOKYE6oo_AU7sR5MaGIGzyPkXi00RlaucbyN78KYBqK73XfyJ-yyXQENIvvXeFJq_fNrYbJuW8LcqZvZyf4J3kr66jvsojxCU=@protonmail.com>

On Tue, Nov 03, 2026 at 08:58:25PM +0000, xelra wrote:
> Hi,
> 
> nftables 1.1.7 fails to parse a rule with a "limit rate" that has no
> "burst", followed by "reject with tcp reset" and anything after it:
> 
>   $ cat repro.nft
>   table inet t {
>     chain c {
>       tcp dport 1 limit rate 5/second reject with tcp reset comment "x"
>     }
>   }
>   $ nft -c -f repro.nft
>   repro.nft:3:59-59: Error: syntax error, unexpected junk
> 
> Column 59 is the "c" of "comment", which the error lists among the
> tokens it expected.
> 
> Without the comment, the next statement fails instead, at "lo" in
> "iif lo accept", even when it's on the next line. The rule parses fine
> with an explicit "burst 5 packets", without the limit, or with an icmpx
> reject instead of the tcp reset.

The scanner updates are bringing issues.

I would suggest a revert of these patches, and make a new release.

Then go back to the whiteboard to see if the scanner can be improved
in a different way.

Unless Phil prefers to go ahead a explore something in the opposite
direction and refine what is already in the tree.

> JUNK for a plain word means the scanner is in SCANSTATE_RATE there,
> the only exclusive start condition. My guess from reading
> scanner_pop_start_cond(): without a burst, bison's lookahead after the
> rate is scanned while SCANSTATE_RATE is active and pushes its own
> scope, so the rate and limit pops are deferred via flex_state_pop. The
> push/pop pairs of TCP and CMD_RESET in "reject with tcp reset" then use
> up that count, and the scanner falls back into SCANSTATE_RATE.
> 
> 1.1.6 parses all of the above. Bisecting points to 9d105581b5f1
> ("scanner: Introduce SCANSTATE_RATE"), and current master
> (07be13393b00) fails the same way. The fix already in 1.1.7, "scanner:
> Accept all statements' first words in all scopes", doesn't cover this
> case.
> 
> Workaround: an explicit burst, or the limit on a jump and the reject in
> its own chain.
> 
> 
