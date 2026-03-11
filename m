Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0643CF02D
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 09:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773222022; cv=none; b=ay+2MDiB8YnkPwQVw8hf2OLz2HuTFvCxhWcTRtssWl48ESSz9oSRvAUvEnsDGMSsjcUzIaYsPv5yaB1K31waRIUmRbw01n2E4wQ/9YpYl0KbHpds6lPNlF3cw85bnDZ0KMQbCCLaOLd/48VA3FTPZlymIWT80ZDvonDVPk+i41s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773222022; c=relaxed/simple;
	bh=F9U4A2sO+LsxEV7ef9fPJq87KSfrE1LCXkqV/ECxIL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NVdHfYxc2vMpVmmKYD3ByuUugrdcUssxd5kFciwfDi2Pv7rhw95mCIiqWdXMXV+r4dxzXWN50faVoAMcVWE6AC5uRvKH/ClQildvKrWJldkPW1/AhJDikVotjRD/FZHvVfEl/UqFrlps+L1/gxFKMJtPvdSYlFPehsSpX04hAn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WVKt56OX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WVKt56OX"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D273C602B4;
	Wed, 11 Mar 2026 10:40:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773222019;
	bh=F9U4A2sO+LsxEV7ef9fPJq87KSfrE1LCXkqV/ECxIL0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WVKt56OXy5TydpG/rYBd3EgeY7jpiGLfQ0SUU0CS0OM/MCbJxRtt/25b+JbI2bQwf
	 CrUa3D+w0IirFrZiwWghWiueSKPC5k8Je6U97poQ1yhL49TrmFwT4U8qmDWOVfJY1w
	 PtXTPmGRdpihD0ewuRcKnDYQaGvGlP0YmXPIQ/+SrrZuR8x4T9KBoaOZ5ElZfgh54w
	 /CzQfLRqLaF9YvhjKi01pBF6Q7G/obADsTZIXTRZmKo9wH/x44+lN+KYruu0h5FZNv
	 OnILdFI7ZD0EHfVP9q0DXAW80idl5jy6LzA6p//40zwU9+LWD80Q9bD/XZ0UPMgOy2
	 Am7v7q51fAsXw==
Date: Wed, 11 Mar 2026 10:40:17 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 5/5] cache: Filter for table when listing flowtables
Message-ID: <abE4ge1u8M7CHoVc@chamomile>
References: <20260310231115.25638-1-phil@nwl.cc>
 <20260310231115.25638-6-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260310231115.25638-6-phil@nwl.cc>

On Wed, Mar 11, 2026 at 12:11:15AM +0100, Phil Sutter wrote:
> Respect an optionally specified table name to filter listed flowtables
> to by populating the filter accordingly.

Fixes: a1a6b0a5c3c4 ("cache: finer grain cache population for list commands")

> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
