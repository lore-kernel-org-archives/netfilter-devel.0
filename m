Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D06F3D7D82
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779279460; cv=none; b=NwmFSmdBowpP7uqknwIWx2c6bDTyZxFkHDhLokf014ZPP/xpdxyt6PYgZvQRpPL92nzpkVvQCJv4t/3UaraDcW2BiXf+zK8dzxqMJSK3qoa+Us6CxazDewkYwdYbBpvXQM7iOiSwbPDQ4cttsh6Y3dghfUhK5BZGdyGO7MvjPy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779279460; c=relaxed/simple;
	bh=yIabCz2BEUUI51YoOBYPpuyLDXGTJemzSWFTWnHysgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZcmXx41eU70mOY5m/TOBGL6gaOg/ln8b++qjUQH9YBFou+O1hVYSRyfDbKQbdy/isDB91NZ4OqPKxS+WRPzQmH5Qv78oLg9fjPuBh2Sd4lzRhA9RnUjqS7EsDPywZXTzJFANDY3eGoLxKgzCp7/mk8XegNFGctMK3km4DWa4cSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 503E3607BF; Wed, 20 May 2026 14:17:36 +0200 (CEST)
Date: Wed, 20 May 2026 14:17:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Igor Garofano <igorgarofano@gmail.com>, security@kernel.org,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [SECURITY] nft_byteorder: incorrect u32* stride in 64-bit
 byteorder eval leading to firewall bypass
Message-ID: <ag2mXk1L4bL55GV1@strlen.de>
References: <CAOOOOYyfpwO7inyq2wXtpT0kY0s19-n4OZf2MCR62WRi7vzMMg@mail.gmail.com>
 <2026052028-grain-pencil-0d8b@gregkh>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026052028-grain-pencil-0d8b@gregkh>

Greg KH <gregkh@linuxfoundation.org> wrote:
> Can you turn this into a real patch that can be applied so you get full
> credit for resolving this issue?

No need, this code will be removed.  There are no users.
Patch is already pending in patchwork.
