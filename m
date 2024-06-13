Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDBF1369B0;
	Thu, 13 Jun 2024 06:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718261012; cv=none; b=fhdrgF39HdvdSTencvVlXeo9P9fQF/YXXGiGONhnUKSbeNPMExNqcyxhmGq4ozYm8h62UA928ytOSMRN1CfjoJgotO0ezP1Ir/4wOKMc5/NZBNk9l60ntP8QL23ppU6D4RER1oKuRry2kFhqSgX40oIOm5Bh9CbU5a/N09INZZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718261012; c=relaxed/simple;
	bh=HFyfhrSCC8w1gEa6POnbTKj5OCXkvDuLOTxjQZltnHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KZKvN4aNodO5JzAL33q7DfQTDC/mnmu/d8Xnd9iLXZdg2wKrXe6CMqCKQj/pmdSRgp5Y0trvrOsa7lm8myoiNuJmm4kVK+dxKoF0hDdGsxmKf5FeONAuSLRUXnY0gyLbtnhSBZlvwiRQ7+6MYZn8vqVGTGLjFATUUIq22kcsy0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jaOpNcF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jaOpNcF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F493C2BBFC;
	Thu, 13 Jun 2024 06:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718261012;
	bh=HFyfhrSCC8w1gEa6POnbTKj5OCXkvDuLOTxjQZltnHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jaOpNcF5CkuAVNQLw24V/PCXh/FRGI7yf9vBKU3pPamivQTs3L1R3VXUKawbm8d3e
	 C38dI30WZXiOqdbEHi8Zc4Hf0olfTQn6AtNFQ1MDQ7pqsabDLQ30QG29xrzLd6D1GO
	 MjE4P5MYT5MEnulV6MRRBfO+Qb849nEP+mKwylVg=
Date: Thu, 13 Jun 2024 08:43:27 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,4.19.x 00/40] Netfilter fixes for -stable
Message-ID: <2024061314-smilingly-gravel-4a5f@gregkh>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>

On Thu, Jun 13, 2024 at 03:01:29AM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This round includes pending -stable backport fixes for 4.19.
> 
> This large batch includes dependency patches and fixes which are
> already present in -stable kernels >= 5.4.x but not in 4.19.x.

Wonderful!  Thanks for all of these, now queued up.

greg k-h
