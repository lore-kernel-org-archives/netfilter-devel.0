Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E753DDDCB
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 12:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280222; cv=none; b=dzJTp9A5aH1G1G0t24IPPLBCbgenQ05/qHT3REb3fmw45j7e2I2MgIaVn4MDPo1jcXf5YI1n40dHPT4d3Ps18IAZ7thJ0dv24yaUGHqZQQEif1Mhrn3CiSmZw8/pElZ6a8EVHv8pmBITNHBWrE9vel+suf1rD8e9U7r1gGUMpm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280222; c=relaxed/simple;
	bh=Vyed2tYaveYCEKlYKEZ6e7+IZT3MVXC1GVL6Bz/bO8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fG3+jCW1/7irhqrkW7vXbNdLWJipFcXKyaRNmDT3gmgMu6HIdQmDg1uDe537RA3dQ3fi4pv6P3rSMcC+JqnaI4MK6L1d8mwM9MZACV5zNVWuh3FP5VMYcTA+efOjkniJPw2XL28/J7zGTWH9Fs7RDJfXm2qEq96TF5yKkWp8XK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9T6pZaE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9T6pZaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2014D1F00894;
	Wed, 20 May 2026 12:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779280220;
	bh=/bCznaWvWSKo/e5ITZme/13Vdy8sDSVQosgruBsqaoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=o9T6pZaEtiyPIZh4bJY6Gcl+O3ALvq/3eAfVuAglvjCowT0YgB63+NeFHuJqThCTi
	 Of1ZphmYGvddHgu+AO4nmu3ZAKEcSZSA0nEgFkeQLcWti+9e6wpQ30AuqrSkqeyk1y
	 OTDp5WAaov0L+RVbgp9gm1Psa7RBk6EVm8PplOL0=
Date: Wed, 20 May 2026 14:30:23 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Florian Westphal <fw@strlen.de>
Cc: Igor Garofano <igorgarofano@gmail.com>, security@kernel.org,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [SECURITY] nft_byteorder: incorrect u32* stride in 64-bit
 byteorder eval leading to firewall bypass
Message-ID: <2026052017-showroom-shortcut-6384@gregkh>
References: <CAOOOOYyfpwO7inyq2wXtpT0kY0s19-n4OZf2MCR62WRi7vzMMg@mail.gmail.com>
 <2026052028-grain-pencil-0d8b@gregkh>
 <ag2mXk1L4bL55GV1@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag2mXk1L4bL55GV1@strlen.de>

On Wed, May 20, 2026 at 02:17:34PM +0200, Florian Westphal wrote:
> Greg KH <gregkh@linuxfoundation.org> wrote:
> > Can you turn this into a real patch that can be applied so you get full
> > credit for resolving this issue?
> 
> No need, this code will be removed.  There are no users.
> Patch is already pending in patchwork.

Great, that's even better!
