Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3553603E0
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Mar 2026 17:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772989526; cv=none; b=G+HIBU3yqHSNx1/5MFUTrEynWzH9j+k+cK6SghWEbYWtFDFmgjTwaxVirFgGfYi/ZIXSYGJsKnYlKcl33nDNfuV0H10hPw2SKc/NihZNu8FU6Gjq+hbbX5Fc8fjfVS379o3uyFdTmTM7gLe58TAXL7ADjtr15H13sLrFv6o6IRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772989526; c=relaxed/simple;
	bh=v49yOQ53XMkTaQ6yxtnflPBHw58ow/j5RZh/zeGlnQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uasg9pEY7s9bOGf3Ruf+G0kikJVHHiGdGEkjfEEgm+3EBr9iN76Gy/SNRxm5ymbjw1eOXixKgDpY907RjWhIG+zMW6fneyVcQlHXjPhOwPCpnzxBcYCWzE48vDp2yM50Qtzak1PscUBDBIvTFa8H30n15SBAtdhdslBnjTO7np8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sv0t/VYQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sv0t/VYQ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C15B2602B1;
	Sun,  8 Mar 2026 18:05:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772989510;
	bh=FlUlR5mfZo7ppJdrAtNs6+dPdak6YJdviyv6eDeOg8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sv0t/VYQ6jWNqaOrz12bEwml8T2TsanCu9E9TWjpr3Yqur693gijJCcgabwy5pzop
	 02cAdqJ/wLdr+KCR/OVW0BbRbgeyZyPwTk8VQfukAso6QbAAeJpNZkZ19pYSujdGtl
	 LyHHm9WT4IU7m6OJyIyTVwTeT7EmREYdKsbEXoDxasOmhLhCaMIaoWBWTRlS53H2QM
	 i6GF4zTu4y1diyU5j2aJoNjKy+gyuor1vvz5vxE5ra/D86FpNtv1jXpdl5mRv+fuEe
	 pi9mR/v84RIU0Z5s/OEA8aqhgdQVUBARFH2fye0JCOJ6YqHEKGaYF5by25QJbKtWT+
	 wlBk7KXvyFcFQ==
Date: Sun, 8 Mar 2026 18:05:07 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Dull <monderasdor@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH v3] netfilter: guard option walkers against 1-byte tail
 reads
Message-ID: <aa2sQ7XhMGV7nPC2@chamomile>
References: <20260307184553.1779-1-monderasdor@gmail.com>
 <20260308155212.1437-1-monderasdor@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260308155212.1437-1-monderasdor@gmail.com>

On Sun, Mar 08, 2026 at 05:52:11PM +0200, David Dull wrote:
> When the last byte of options is a non-single-byte option kind, walkers
> that advance with i += op[i + 1] ? : 1 can read op[i + 1] past the end
> of the option area.
> 
> Handle single-byte options first, then check that a length byte is still
> available before reading op[i + 1] in xt_tcpudp and xt_dccp option
> walkers.
> 
> Fixes: 2e4e6a17af35 ("[NETFILTER] x_tables: Abstraction layer for {ip,ip6,arp}_tables")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Dull <monderasdor@gmail.com>
> ---
>  net/netfilter/xt_dccp.c   | 8 ++++++--
>  net/netfilter/xt_tcpudp.c | 8 ++++++--
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
> index e5a13ecbe6..7f9e2d5c1b 100644
> --- a/net/netfilter/xt_dccp.c
> +++ b/net/netfilter/xt_dccp.c
> @@ -62,10 +62,14 @@ dccp_find_option(u_int8_t option,
>  			return true;
>  		}
>  
> -		if (op[i] < 2 || i == optlen - 1)
> +		if (op[i] < 2) {
>  			i++;
> -		else
> +			continue;
> +		}
> +
> +		if (i + 1 >= optlen)
> +			break;
> +
>  			i += op[i + 1] ? : 1;

This indent is wrong, I posted this patch:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260308112510.2958551-1-pablo@netfilter.org/
