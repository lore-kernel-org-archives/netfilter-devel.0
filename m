Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C6F32C92B;
	Wed, 19 Nov 2025 23:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763594093; cv=none; b=G7+cs31rYtRVg4vLCMr35T8QMx7Z3HKnoKy0AWDGK02hcYTcaFZtX4z5d9LgkI8s6MQPmBYuu5l0M1OKp53Waabjy6YkuHaR0vMVd43remTTjiRJtZGLWFMSre3XfihfK105PuG2S1AULNoY8gccCWF2OL5d/GSOI7DjEGolm4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763594093; c=relaxed/simple;
	bh=GHAt7j3+39V1Ggijq6zlZisj89G5F7F6alC2XGpNv1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lc1hw9o2yTysah0vImUVaI8yHmhsNMNEb4H+8ngsqVAGbPd+0/JfnvfZ84xTFgfgXcay0QHx4pQa5VilTHl5JSQqhm6ca3B7ry/+Cm4895tSShb6V2T0V8/tuGIep1q6NjYKoMM2siOVOAGnOCBIdCcYVrnPLoyttuiN3mXTIWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EbDyxSJG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EbDyxSJG"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0DB246026B;
	Thu, 20 Nov 2025 00:14:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763594089;
	bh=Y45S3lR4iKjKGcl+z8yZ+7WFG4SmwPeg2GBJ/4/cvoM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EbDyxSJG9lQVzmgH6OUTpxyIdFUtop9slDxeQk8uXSC47jEBeIB6Zj8DC2XhglDsm
	 56jM8HlwsZnP8WoVsT6+048w6bf0QWEICp3xIv6u5cB8lwWm2VhRDx2CiFRICmufDQ
	 aIIBiSfrDqjG1gCAYBXLQL4a92bmzG9uNBTNdjXjIcQ8SkE8GSV0vw+zmzwm4KFdWE
	 EymDrt1d/5l+1gk6HfJJVc5o6HNxTSkNe6WVONp0RwkxZSZrW1mUz57mRqs/+O5FvT
	 0/xZL0yRSSHb+5IVhlfTQUxGD61V8Rb6pMU1P8dac/Z3eyO6MgDJzCVv1rxXw7SMcz
	 CWxrR0L4nAwdQ==
Date: Thu, 20 Nov 2025 00:14:46 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Phil Sutter <phil@nwl.cc>, Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: Re: Soft lock-ups caused by iptables
Message-ID: <aR5PZvdjpvGD2mIS@calendula>
References: <20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aR3ZFSOawH-y_A3q@orbyte.nwl.cc>
 <20251119222940.GA5070@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251119222940.GA5070@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>

On Wed, Nov 19, 2025 at 02:29:40PM -0800, Hamza Mahfooz wrote:
> On Wed, Nov 19, 2025 at 03:49:57PM +0100, Phil Sutter wrote:
> > Nftables ruleset validation code was refactored in v6.10 with commit
> > cff3bd012a95 ("netfilter: nf_tables: prefer nft_chain_validate"). This
> > is also present in v5.15.184, so in order to estimate whether a bug is
> > "new" or "old", better really use old kernels not recent minor releases
> > of old major ones. :)
> 
> FWIW I tried to repro this on v6.6.45 as well and it also suffers from
> this issue.

This example ruleset does not restore, it is missing ipsets.
