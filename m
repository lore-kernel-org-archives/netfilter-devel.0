Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE2D20296C
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 10:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748429859; cv=none; b=n/f8ukIIbiR0yV2mIabkPQvZQ2pXw64u+pkoHHrgViOhoSGyaZ1ZN6+8KoerlAO89NRN7xI3DOMZC7Oo+9Z3cj2ozHML79n2lR95dvV3+ye0mPwLMkUOrDgthpgAjH3/mZpMY0BOnK/4F3uRrcJkH2EJ8fCFVQSGNqdak7Wkbw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748429859; c=relaxed/simple;
	bh=AzDriKPsR3UCh/M9HL08/etZcPHycTLP8p6r7sZ9xMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=omoKXBpfIw04mbdoNI+n88dW2kORTbveDRQI5fAzB0YR4v9cj4R7Th9vJS9NvmXae6h7Znz6ZUq505mEMQVvJDpyAvHrZ+7t1+csKNKFWFtIL3iPnFWShWF7rp/QkXoPRSo6j6HvteovcvIKnxuKT4kp9O4dFnKFy5jPytPAEQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E8012603F8; Wed, 28 May 2025 12:57:34 +0200 (CEST)
Date: Wed, 28 May 2025 12:56:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Slavko <linux@slavino.sk>
Subject: Re: [PATCH ulogd2 v2 0/4] Add support for logging ARP packets
Message-ID: <aDbr-BLP6vVMWF6s@strlen.de>
References: <20250526171904.1733009-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250526171904.1733009-1-jeremy@azazel.net>

Jeremy Sowden <jeremy@azazel.net> wrote:
> Hithero, ulogd has only fully supported handling ARP headers that are present
> in `AF_BRIDGE` packets.  This patch-set adds support for handling ARP packets
> in their own right.

Unless someone else has anything else to add I intend to apply this
series later this week.
