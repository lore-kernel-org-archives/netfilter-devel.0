Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A314133B97B;
	Thu, 23 Jul 2026 15:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784821150; cv=none; b=fyusZIT0ZH6D7VD3D6bVqMFrdv/jnjVBVvgnldEeP8/z1U36exSdXCUcrGYuTysvOG+7elgHxMs3eSBgbDu5A487FN54G8HD7Sw+Tf5cd+cpsmuKeMHTCS7mWRhFq50R71SDFD1IN2FEKNdhKdvXtpkwigyYf+15WRjXSISm/xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784821150; c=relaxed/simple;
	bh=Kbvnhhex1XPhMur8ro3UlqwyX9TaYjvR952TUJBnnJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQrXOY5E0ZbJts3L6fUP7h7CFnsSDw7/PE8khFlMqIWrGzPYTNQ1PErclcWPyNG6Lc0a7P69bUdiNLBimbkElhIxnLJDulDT104OuT5WRa/H7+wgu133pHRJlqrWZWw4x4VdGae11l/ATGeOG4GsaKdbK6UYmuOp9E/HhHC3AFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DTKnaItv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DTKnaItv"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8047660194;
	Thu, 23 Jul 2026 17:39:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784821144;
	bh=8BlkqnvCtkhFsBoY+3pDrLLjU7ZZ8T5kbqf3qGsfHwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DTKnaItvBJe5GTPi4UlG7Bj7geoSY2+JwLzYcOsVBdn6rWt0MSgREPCn8Jr/14tf5
	 AiQJSvVSC4oe6Bn1HF8Ooac+1d7hp2RATZBp8XfJKiqM4DFBk7lXX4tlwKCBAQAw2g
	 RrEOmZ1XkAWrynDvaxbdHm6OOLLtZZZNlHLFVi+43HB+33HCzmFx5SvfEu/mv31Hs4
	 6vvkiiHQbX6PLV4HWrnlD+WTjwmIE0up/xcSZx8zqjxr58FvSjge0iSXJhGstkLqli
	 +OEjRyAxBWJW7hs9ejkfc1GgeE7Ift45jljooqfgCyS87lzmKpXRtWFaK3DJSJxjvN
	 HG9tl+rm4sAyQ==
Date: Thu, 23 Jul 2026 17:39:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net 09/13] ipvs: fix the checksum validations
Message-ID: <amI1logAep3vSkfF@chamomile>
References: <20260722211420.153933-1-pablo@netfilter.org>
 <20260722211420.153933-10-pablo@netfilter.org>
 <20260723070845.7855a0f1@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260723070845.7855a0f1@kernel.org>

Hi,

On Thu, Jul 23, 2026 at 07:08:45AM -0700, Jakub Kicinski wrote:
> On Wed, 22 Jul 2026 23:14:16 +0200 Pablo Neira Ayuso wrote:
> > +/**
> > + * ip_vs_checksum_common_check - validate checksum for TCP/UDP/ICMP
> > + */
> 
> this not-really-kdoc comment causes a bunch of new warnings,
> and this file was previously warning free. Which in turn
> makes our AI reviewer ignore the series. Could you respin?

Yes, I can drop the patches that have the kdoc issues and respin.
