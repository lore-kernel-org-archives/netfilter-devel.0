Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7162F2A
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2024 23:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145399; cv=none; b=vAzDz4c+p8dNiNigBPmShxWMXxe1FZIPWNZyHCzVImYcJu4FzPACztQcpCyL2nbjrLpzUm71tDohsybZ/w+geddDmtgywncVdBcywO1gR93tz7txua6ZhYANioPVeGVG2W82GLTot+xystTp6G2DS1lIZV15qVfOCyie+Fe5MkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145399; c=relaxed/simple;
	bh=8Fy5cp+Dw6rgT2q8UFivrl7EeTNXgfPZIp9/goJdPDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbWbFI0BPKk+C2u8n5Rvg+wokiEEntbTxZ99YdVjMAdW1INfhVY6xEAeGnRylbM0rkKlJwk9MwEOyL5dj6Mtvl5NGm8sLNbKkuKyl66u7Bl6V++ROnJ5S1jZAuedlIw0J2TGSqK/T5LbyeLQ4tXIYWNhCCH8skTKwDQ2YXmn+o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=37338 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tDu8n-006UYU-Jw; Thu, 21 Nov 2024 00:29:47 +0100
Date: Thu, 21 Nov 2024 00:29:44 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] debug: include kernel set information on cache
 fill
Message-ID: <Zz5w6NPQ2XsJrpHG@calendula>
References: <20241120100221.11001-1-fw@strlen.de>
 <20241120100221.11001-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241120100221.11001-2-fw@strlen.de>
X-Spam-Score: -1.9 (-)

Hi Florian,

On Wed, Nov 20, 2024 at 11:02:16AM +0100, Florian Westphal wrote:
> Honor --debug=netlink flag also when doing initial set dump
> from the kernel.
> 
> With recent libnftnl update this will include the chosen
> set backend name that is used by the kernel.
> 
> Because set names are scoped by table and protocol family,
> also include the family protocol number.
> 
> Dumping this information breaks tests/py as the recorded
> debug output no longer matches, this is fixed in previous
> change.

table ip x {
        set y {
                type ipv4_addr
                size 256        # count 128
                ...

We have to exposed the number of elements counter. I think this can be
exposed if set declaration provides size (or default size is used).

And update nftables manpage:

"When listing the set, the element count is larger than the listed
number of elements for sets: the number of elements in the set is
updated when elements added/deleted to the set and periodically when
the garbage collector evicts the timed out elements."

P.S: Yes, I changed my mind on this :)
