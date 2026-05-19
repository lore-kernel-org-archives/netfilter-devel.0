Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7877C3E8684;
	Tue, 19 May 2026 21:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779226201; cv=none; b=XplRe3c/uYRZMN2Lv7vuhmDrmQCoRlfCQabDqGI4tAZTSKyPoy7e+bUI0w+a3/QYlC+92VPR8IWDf0Olp7CX57A2CH75Sf4V+2kEJ2Q/VoEpwtZ+7LD4mnYyra0a5NPYhMTjvIidqCluPhAhntmaxffxNJ5omBarJ6B0e/0hzjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779226201; c=relaxed/simple;
	bh=EcD2YCONTFnotH02ZgeXqKQw1fgyUIwEg+y+t3Ok4yI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C0JthRgoTG2ImrE2eqav9T1Drjc/x9CNXlyFolfW3SIMtBwq90rGp5XmO56wp3+S5pjeb7FeAy8W8JTiOM6uEtb0SHqRpdtHTaZqV4kffpcTsQ2+w+U5XeB6bLX7QaGa2btVHAe/1B/D1rpakxI213BOxAemw8tsF6MLgXky1Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=u8/mvnt8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="u8/mvnt8"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 49B4460275;
	Tue, 19 May 2026 23:29:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779226197;
	bh=kQb5zN9aFB8axAVCCfaEAj6NWYy8k/AJPlln/FER9jI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u8/mvnt8+1k9yJybEzLoQ0jGWTt3pTfJ/mmoAmiSCU3uMa0xrUrkCJS5p2KB9dFPA
	 SNhsAm14qQpU1Fr4a2jALipIqF/pS0dyZi7JrGTFdiQ8XTQBAxTCYsTlfezxoyi32q
	 yCNDEVjxRqMbCRY330lUs1aTGfQTPXK2JN9jPVxgaxcY16aDPgpUihhXR0J+HDVd0t
	 ocpvpNfxrg+njrzFF5jod05rEer9wVGxDyxsVLBEbnbhQfeK5DyOvUt6z0HxXzfTab
	 W8y4JaxcWA2bGf0vVTocxrZRDZDgm8YjZxOB39ZCJNpYPtbqGY7yF7AEi/MVqPHQbk
	 F6SPYkZ6n8AaQ==
Date: Tue, 19 May 2026 23:29:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Muhammad Bilal <meatuni001@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_irc: fix parse_dcc() off-by-one
 OOB read
Message-ID: <agzWUpDy-32yvBcB@chamomile>
References: <20260519212328.28290-1-meatuni001@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260519212328.28290-1-meatuni001@gmail.com>

On Tue, May 19, 2026 at 05:23:28PM -0400, Muhammad Bilal wrote:
> parse_dcc() treats data_end as an inclusive end pointer, but its only
> caller passes data_limit = ib_ptr + datalen, which points one past the
> last valid byte.
> 
> The newline search loop iterates while tmp <= data_end, so when no
> newline is present, *tmp is read at tmp == data_end, one byte beyond
> the region filled by skb_header_pointer().
> 
> irc_buffer is kmalloc'd as MAX_SEARCH_SIZE + 1 bytes and datalen is
> capped at MAX_SEARCH_SIZE, so the stray read does not fault. 

No crash here.

> The byte is uninitialized or stale; if it contains an ASCII digit,
> simple_strtoul will consume it and produce a wrong DCC IP or port in
> the conntrack expectation.  The extra allocation byte is also a
> fragile guard: if the cap or allocation size changes, this becomes a
> real out-of-bounds read.

Other helpers replaced simple_stroul() already which is probably the
way to go.

This is nf-next material.

> Change the loop and its post-loop check to use strict less-than,
> consistent with the caller's exclusive-end convention.  Update the
> function comment accordingly.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
> ---
>  net/netfilter/nf_conntrack_irc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
> index 522183b9a..9a7b8f622 100644
> --- a/net/netfilter/nf_conntrack_irc.c
> +++ b/net/netfilter/nf_conntrack_irc.c
> @@ -59,7 +59,7 @@ static const char *const dccprotos[] = {
>  /* tries to get the ip_addr and port out of a dcc command
>   * return value: -1 on failure, 0 on success
>   *	data		pointer to first byte of DCC command data
> - *	data_end	pointer to last byte of dcc command data
> + *	data_end	one past end of data
>   *	ip		returns parsed ip of dcc command
>   *	port		returns parsed port of dcc command
>   *	ad_beg_p	returns pointer to first byte of addr data
> @@ -77,10 +77,10 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
>  
>  	/* Make sure we have a newline character within the packet boundaries
>  	 * because simple_strtoul parses until the first invalid character. */
> -	for (tmp = data; tmp <= data_end; tmp++)
> +	for (tmp = data; tmp < data_end; tmp++)
>  		if (*tmp == '\n')
>  			break;
> -	if (tmp > data_end || *tmp != '\n')
> +	if (tmp >= data_end || *tmp != '\n')
>  		return -1;
>  
>  	*ad_beg_p = data;
> -- 
> 2.54.0
> 
