Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D6536AB72;
	Thu, 28 May 2026 22:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780008786; cv=none; b=Ydl0Vob1k0eQzMXoM8NgGklshqj1zKWh36TGvAwlCTjklesyJ2NeHUKxkxLXvbXxk0tmwXX+Ysp9msea40l1JHYYGQoXZCXUP3mHRFpj2kQPiXidYL1xTmjPeaQ3uYT+qYZxsLQn6Ggsudn4AxfXam8sxIpOvpe7xe+7aN8ca3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780008786; c=relaxed/simple;
	bh=AhuAPVaPaQGOxSzGgaHNAOwveixT0A/Knj2vyT/l0Hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aTZK3noF3zadBpPmwupzj2pEsR63wFlw1O23jp6slhiUtZklQeFe1MhA0ZfmwUUKw307GpsLIDNYq1elgl7TCJfEijCXa063aU3t0hEfGry96YpJI1qu7cPt700Zk36X8hdVpuy7x3w35KGCe8Gc8LGUWnd9190OhyCBMv+eT54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FGLSNehr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FGLSNehr"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5681B6017D;
	Fri, 29 May 2026 00:52:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780008774;
	bh=bAlfTf2oEy05xYzodjipDm0M/QAhLIN//tb3oLLz4tQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FGLSNehr1/oxR07+FsIhnqhDHdoflRJDL+VXXjEJBlSi/sSwoG4YaEoODqq+zNgAY
	 bEXUBAkbxKhefN1Zz4u1jsKZBztXMcs3EF5VUj0pRam/wOf1YaB60hQ8JU2QNgjz3N
	 9CDlgmAS0GTknFu63/echigOGPK4Rjj1W0uOB8GYCW3GIvkY76Qmrnt147ykRMOggu
	 VXGPQ539KlgObCOQfb4v9kLdtOcv4ljeNhpm/N1WiPKhnM7jL1rCjbqwaGFOolVJ8r
	 4VB72s3/304gbl1LlhFzum6apK9uupcg2brPgGhhZJXwh0ZqWoGcfrnqy7y0mzNh1M
	 NQv7x03DO1UIg==
Date: Fri, 29 May 2026 00:52:52 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Kacper Kokot <kacper.kokot.44@gmail.com>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fmancera@suse.de,
	fw@strlen.de, david.laight.linux@gmail.com,
	Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: TCPMSS: fix dropped packets when MSS
 option is unaligned
Message-ID: <ahjHRB0Ohn7fpd-o@chamomile>
References: <20260528204020.7ae744ab@pumpkin>
 <20260528223412.27311-1-kacper.kokot.44@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260528223412.27311-1-kacper.kokot.44@gmail.com>

Hi,

On Thu, May 28, 2026 at 11:34:11PM +0100, Kacper Kokot wrote:
> Padding TCP options with NOPs is optional, so it is legal to send an
> MSS option that is not aligned to a word boundary and therefore not
> aligned for checksum calculation. The current TCPMSS target is not
> robust to this: when the MSS option is unaligned it produces an
> invalid checksum, and the packet is dropped.

Yes, but how many stacks do this?

> This has not been observed in any real environment.

... then why is this a fix?

> Senders place the MSS at the beginning of the options block, where
> it is naturally aligned, but the spec allows unaligned options and
> the kernel shouldn't silently drop legal packets.

This is questionably a "clean packet".

And "the kernel is not silently dropping anything, it is policy that
would drop it", and there are mechanisms to track what rule is
dropping this packet.

> When the changed word is not aligned, the modified bytes straddle two
> checksum words, and using the standard incremental update helper
> (which assumes alignment) produces an invalid checksum:
> 
>     | w1     | w2     |
> OLD |  a  b  |  c  d  |
> NEW |  a  b' |  c' d  |
> 
> Since b' and c' sit across w1 and w2, we could compute the incremental
> checksum in two operations by recalculating w1 and then w2:
> 
>     C' = C - w1 + w1' - w2 + w2'
> 
> But working it out:
> 
>     C' = C - w1 - w2 + w1' + w2'
>        = C - (a * 2^8 + b)  - (c * 2^8 + d)
>            + (a * 2^8 + b') + (c' * 2^8 + d)
>        = C + 2^8 * (a - a + c' - c) + (b' - b + d - d)
>        = C + 2^8 * (c' - c) + (b' - b)
>        = C - (2^8 * c + b) + (2^8 * c' + b')
> 
> So an unaligned incremental checksum can be done in a single operation
> by byteswapping the changed bytes before passing them to the helper.
> This patch implements that trick for unaligned MSS option updates.

If this is a fix as the title specify, there no Fixes: tag?

To me, this qualifies as an enhancement, if anything.

Maybe more correct subject is:

  "netfilter: TCPMSS: handle packets with unaligned MSS option"

since this mangling unaligned MSS has never been supported this far.

Thanks

> Signed-off-by: Kacper Kokot <kacper.kokot.44@gmail.com>
> ---
> I decided to go with the get_unaligned_be16 suggestion because
> it's idiomatic and it produces shorter assembly on x86-64
> (6 instructions vs 9). SYN processing is a cold path so
> I didn't look into it further.
> 
> v2:
>  - Use get_unaligned_be16 (Fernando's suggestion)
>  - Fix alignment check expression (David)
>  - Mention it's a theoretical bug in the commit message
>  - Drop cc stable, the bug is only theoretical
>
>  net/netfilter/xt_TCPMSS.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
> index 80e1634bc51f..32c87a520361 100644
> --- a/net/netfilter/xt_TCPMSS.c
> +++ b/net/netfilter/xt_TCPMSS.c
> @ -117,8 +117,9 @@ tcpmss_mangle_packet(struct sk_buff *skb,
>  	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
>  		if (opt[i] == TCPOPT_MSS && opt[i+1] == TCPOLEN_MSS) {
>  			u_int16_t oldmss;
> +			u16 csum_oldmss, csum_newmss;
>  
> -			oldmss = (opt[i+2] << 8) | opt[i+3];
> +			oldmss = get_unaligned_be16(&opt[i+2]);
>  
>  			/* Never increase MSS, even when setting it, as
>  			 * doing so results in problems for hosts that rely
> @@ -130,8 +131,19 @@ tcpmss_mangle_packet(struct sk_buff *skb,
>  			opt[i+2] = (newmss & 0xff00) >> 8;
>  			opt[i+3] = newmss & 0x00ff;
>  
> +			csum_oldmss = htons(oldmss);
> +			csum_newmss = htons(newmss);
> +
> +			/* MSS may be unaligned; fix up the incremental checksum
> +			 * to avoid an invalid checksum and a dropped packet.
> +			 */
> +			if (((char *)&opt[i + 2] - (char *)tcph) & 0x1) {
> +				csum_oldmss = swab16(csum_oldmss);
> +				csum_newmss = swab16(csum_newmss);
> +			}
> +
>  			inet_proto_csum_replace2(&tcph->check, skb,
> -						 htons(oldmss), htons(newmss),
> +						 csum_oldmss, csum_newmss,
>  						 false);
>  			return 0;
>  		}
> -- 
> 2.43.0
> 
