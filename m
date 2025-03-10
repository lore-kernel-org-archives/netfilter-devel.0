Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6321C6F70
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 10:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741601115; cv=none; b=a1Vjq2vTxm3Dz73tkoUdq7awhl5ejHHkn1mLdqupm6fGwJ5aLiGCrvlj7+x+EXoQljcLC1fK5ELtPZs0w9VuAsAyTPF124X1taiVaqoqI774fh4+eeQWfuKp+uR6JsI54q1TPa67knd/kL9yZbXj8Qt0fKJ34gbDLfQAjAXqdYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741601115; c=relaxed/simple;
	bh=Tm2baTt4TISOSSVS/TNYUvTTcHM63+VAwcCgvKgZdWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BPuXBzKyAQz7lZ5DaRtyMWHbU44j+Wlc4e+WkFxYPcJsXzjzwz6KFoTxGY3i6pxs/Aan1l5f6lwvw2hsken0oKy3RlUQ5gUZnV2B9kyHO1ZhwUa8lMA7yNHcnuAL0BSnsT0YfCnZEzUbnzAXZJbVGSlWB0ypl3XehwP9Vh2N2Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RRofiEnD; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RRofiEnD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RRofiEnD";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RRofiEnD"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id AB4936027B; Mon, 10 Mar 2025 11:05:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741601108;
	bh=evsrExmZdvCegdRwzpOc/F12rajD8y4wJGGof7C5vxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RRofiEnDpwqcgW5FkXz/ZJYZTnDfMl/2X5vDwGGlMFXXHR/fEFmf+5FtA88GAPKkp
	 279RrUtD/y7/NWv5dQlaZTwJ0Bw+5f7SH+qs4Hs3xF3vBQHTb6AbpuNzCgYi/lFyQl
	 wyCV0UvULfkoGV9gvo35NtySrTP99e/RkJaLTKssngHHD455TsW/iIr2SrFdC4o9rE
	 BdPIIaxL+ED4EbWHtTYmrpqlN2rrmbCEiZW0M1qSyPjtN0N70NzAApg925Xvq1LtiM
	 tqqa3e3uaP9/7dg7hCHAM3Vz8KH5LU80WHO90g/UlZeco1YF+PyPKU6YAU0R1I9jSM
	 esFfxhJh41G3A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1273E6026D;
	Mon, 10 Mar 2025 11:05:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741601108;
	bh=evsrExmZdvCegdRwzpOc/F12rajD8y4wJGGof7C5vxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RRofiEnDpwqcgW5FkXz/ZJYZTnDfMl/2X5vDwGGlMFXXHR/fEFmf+5FtA88GAPKkp
	 279RrUtD/y7/NWv5dQlaZTwJ0Bw+5f7SH+qs4Hs3xF3vBQHTb6AbpuNzCgYi/lFyQl
	 wyCV0UvULfkoGV9gvo35NtySrTP99e/RkJaLTKssngHHD455TsW/iIr2SrFdC4o9rE
	 BdPIIaxL+ED4EbWHtTYmrpqlN2rrmbCEiZW0M1qSyPjtN0N70NzAApg925Xvq1LtiM
	 tqqa3e3uaP9/7dg7hCHAM3Vz8KH5LU80WHO90g/UlZeco1YF+PyPKU6YAU0R1I9jSM
	 esFfxhJh41G3A==
Date: Mon, 10 Mar 2025 11:05:05 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Guido Trentalancia <guido@trentalancia.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: Signature for newly released iptables-1.8.11 package
Message-ID: <Z865US_MvJslQ9fW@calendula>
References: <1741365601.5380.19.camel@trentalancia.com>
 <20250307164948.GB255870@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250307164948.GB255870@celephais.dreamlands>

Hi,

On Fri, Mar 07, 2025 at 04:49:48PM +0000, Jeremy Sowden wrote:
> On 2025-03-07, at 17:40:01 +0100, Guido Trentalancia wrote:
> > The newly released iptables version 1.8.11 source package has been
> > signed using a new gpg key 8C5F7146A1757A65E2422A94D70D1A666ACF2B21.
> > 
> > Unfortunately it seems that such key has not been published yet on
> > public keyservers.
> > 
> > Can someone please publish the new gpg key used to sign newer iptables
> > releases ?
> 
> It's here: https://netfilter.org/about.html#gpg.

I just post the new keys again to PGP servers, if it does not show up,
please let me know.

Thanks.
