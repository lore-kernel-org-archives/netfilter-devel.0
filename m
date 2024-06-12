Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA0D43144
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2024 20:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718225112; cv=none; b=SVAOYcnSa/bFQAgsTSYGC1yClvB3XvRGqrbpRjK4XOV92ZU1nuB51ejVC981H5ZEwGEkCW7K+dK3xIxXFc5VAj4kIKfSe9ww7ITR5gWw/K82WCf/w1rASFn+pabVhL/1NfrUlzigkqPgMfHiO0Up2OU8lzLzXzcimImugS6scpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718225112; c=relaxed/simple;
	bh=eWUDMb6gTBOBCIy0sZshidWvkSNw8SaZSqNWmQe8JCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHmhRN2fxbDNa+hWAE6Sg6KGJPR/qI3ZsRwL+a39mmV1Ob6uOTSYEzHfpPInjQCQtNUNQDg0MmYymYS97H8Hz7gtz/u3E703xPHtRDjutkRRz8KzMRzu5En/MAJT/GqZ1+mvOhTxIgobi6KYM6HaKuojDl5b1q/tyL0OvoFRJZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=D+0eNiT3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="D+0eNiT3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SmGmPCnMeYkSH7v3+xa/2o8JBlHIuPEn07tZ3J4jvO4=; b=D+0eNiT30jAG/Yx+3muDV689Jn
	d213WWIDZAXMYQbkord9Ua+LxX456GQ4l2sRXa2atlY7fgkDAHAlrisNfVE8Hf6el0ELW34f/QWUd
	CDPSzoQ9Q8SX8OuHQAclvsPLtC37GKUv/UrvvXyE6y6CvdvgYA1ia688BZzxHO/ETyZpSCjTpXAzn
	3LGADcbiDKoDYghpcGMMY7JHqUsOSt7WLpjJl+pOKmSAmyrC/Ocpew/J9p6btJvAg1ogC+9WAcQzL
	+RITTH2fEqRHTlcfVnoRZSiKPh6VsZsAYpBQoVajR1P39QVvm7cGyrnbj+QtYPJS30eZL2McZIEdS
	e7u0mzxw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sHUqC-000000001rV-3nI7;
	Wed, 12 Jun 2024 22:45:08 +0200
Date: Wed, 12 Jun 2024 22:45:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Michael Estner <michaelestner@web.de>
Subject: Re: [iptables PATCH] ebtables: Include 'bitmask' value when
 comparing rules
Message-ID: <ZmoI1A0yInMvCBh0@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	Michael Estner <michaelestner@web.de>
References: <20240612124109.19837-3-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612124109.19837-3-phil@nwl.cc>

On Wed, Jun 12, 2024 at 02:41:09PM +0200, Phil Sutter wrote:
> The former FIXME comment pointed at the fact that struct ebt_entry does
> not have a 'flags' field (unlike struct ipt_ip). In fact, ebt_entry's
> equivalent is 'bitmask' field. Comparing that instead is the right
> thing to do, even though it does not seem to make a difference in
> practice: No rule options alter just the bitmask value, nor is it
> possible to fill an associated field with default values (e.g. all-zero
> MAC and mask).
> 
> Since the situation described above might change and there is a slight
> performance improvement in some cases (e.g. comparing rules differing
> only by specified/omitted source/dest MAC address), add the check
> anyway.
> 
> Suggested-by: Michael Estner <michaelestner@web.de>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Also applied.
