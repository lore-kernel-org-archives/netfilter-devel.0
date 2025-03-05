Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9520E1FCF68;
	Wed,  5 Mar 2025 22:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741213335; cv=none; b=hqBUz+PoCfAAvjrrofzjC1aPo3lFqHgIJ3VohfgjzQpAJFtFmVFixbwyPQgCAqM8hbPofDMoFbc6yUnY+FpPsl9PTerpVFbR6oJBX/iOidsDNFXDmR+9PO4cEDz/m/q2uGr7UPRPQJUkk0r23fQ1QSfLy84lYzh/LhuuiWAz6Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741213335; c=relaxed/simple;
	bh=wRjrKsPE7fFyDalDzgaEP8nV6yY1K6u+Bq3Htds6dgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lscINuvKe8t9DwrC+egA/aEBn5zaywrVDpIVwAXC2H8E1Cj15qC9U5eScUg8J2cRuQD2hLC6WxSSPh1PwtpxjpToGid9kT7ZEYVnB7LjJC0Kev/YpSaBZaYofr0y/t7czE2/IPJJODKbxMxL8u5RIRvj/unfSZactzJTsvd8P6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dQtvYLin; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dQtvYLin; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dQtvYLin";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dQtvYLin"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id ACE816029C; Wed,  5 Mar 2025 23:22:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741213331;
	bh=LBS8vWq+7dq8qNi+FWZrfL5Q7mKeYMiUIULxIXJ9i7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dQtvYLin7d5TSvk07gYub+8m1PuCMv0p4tF5B2BE9bi/bpqSPqcYEWs6nwSEbJmwk
	 VLdYDrQc1lBOlGsYjMl5B6BU//qmkJwJHGp/V9r2tVkNvlwKy738CXBR2q43HZ39Eb
	 Bxe6WY6WJzCzg1DmnFQ0Q9krOSCkX40IGiCWPiPBrrgIxG5cPUcqXDTno8fcH76FqK
	 NmiTxJdhZna3C94c/2ZgMDgsH6TD2OE5A2HhFsHxF/NSLDTNKPZGM0AXY4/Dwul0Ff
	 50mS8YVlsI+ekQV7ah8jxTP+1w7tjPmg9zSKW4gHPPvKL1Rx8jHCrp7yy2xOmjdbPk
	 gB43mqQ6g2hEA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0A4FF6029B;
	Wed,  5 Mar 2025 23:22:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741213331;
	bh=LBS8vWq+7dq8qNi+FWZrfL5Q7mKeYMiUIULxIXJ9i7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dQtvYLin7d5TSvk07gYub+8m1PuCMv0p4tF5B2BE9bi/bpqSPqcYEWs6nwSEbJmwk
	 VLdYDrQc1lBOlGsYjMl5B6BU//qmkJwJHGp/V9r2tVkNvlwKy738CXBR2q43HZ39Eb
	 Bxe6WY6WJzCzg1DmnFQ0Q9krOSCkX40IGiCWPiPBrrgIxG5cPUcqXDTno8fcH76FqK
	 NmiTxJdhZna3C94c/2ZgMDgsH6TD2OE5A2HhFsHxF/NSLDTNKPZGM0AXY4/Dwul0Ff
	 50mS8YVlsI+ekQV7ah8jxTP+1w7tjPmg9zSKW4gHPPvKL1Rx8jHCrp7yy2xOmjdbPk
	 gB43mqQ6g2hEA==
Date: Wed, 5 Mar 2025 23:22:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Michael Menge <michael.menge@zdv.uni-tuebingen.de>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: nft reset element crashes with error BUG: unhandled op 8
Message-ID: <Z8jOkDx8YhIYKi59@calendula>
References: <20250228151158.Horde.S7bxprjzrKb3P7rZjqTDZz_@webmail.uni-tuebingen.de>
 <20250228142507.GA24116@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250228142507.GA24116@breakpoint.cc>

On Fri, Feb 28, 2025 at 03:25:07PM +0100, Florian Westphal wrote:
> Michael Menge <michael.menge@zdv.uni-tuebingen.de> wrote:
> > i want to use a named set in nftables to to restrict outgoing http(s)
> > connections only to
> > update servers. As the update servers are behind CDNs with multiple changing
> > IPs i need
> > to automatically update the named set.
> > 
> > I discovered that "reset element" was added to the nft command which should
> > enable me to reset
> > the timeout without removing the IPs already in the set, and to keep a clean
> > list of IPs.
> 
> No, you can update existing element timeouts:
> nft add element inet filter updatesv4 {1.2.3.4 timeout 1h expires 1h}
> 
> reset will not affect the timeout, only quota or counters.
> 
> > Fetch list of IPs, Call
> > "nft add element inet filter updatesv4 {a.b.c.d timeout 1h}" and
> > "nft reset element inet filter updatesv4 {a.b.c.d}" for each IP
> > 
> > (I know that i can use multiple IPs, in the add and reset element command)
> > 
> > In my test I triggered the following error:
> > ===
> > [root@mail ~]# nft add element inet filter updatesv4 {1.2.3.4 timeout 1h}
> > [root@mail ~]# nft list set inet filter updatesv4
> > table inet filter {
> > 	set updatesv4 {
> > 		type ipv4_addr
> > 		flags interval,timeout
> > 		elements = { 1.2.3.4 timeout 1h expires 59m53s324ms }
> > 	}
> > }
> > [root@mail ~]# nft reset element inet filter updatesv4 {1.2.3.4}
> > BUG: unhandled op 8
> > nft: evaluate.c:1734: interval_set_eval: Assertion `0' failed.
> > Aborted (core dumped)
> 
> This should be the right fix, I will submit this formally later:
> diff --git a/src/evaluate.c b/src/evaluate.c
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1946,6 +1946,7 @@ static int interval_set_eval(struct eval_ctx *ctx, struct set *set,
>  				 ctx->nft->debug_mask);
>  		break;
>  	case CMD_GET:
> +	case CMD_RESET:
>  		break;
>  	default:
>  		BUG("unhandled op %d\n", ctx->cmd->op);

Patch looks good, would you please merge this upstream?

Thanks.
