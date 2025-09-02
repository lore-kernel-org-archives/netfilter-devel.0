Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B298283680
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 10:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756810128; cv=none; b=XKzW8J6EK5CWo/mbA/phiC/wxuhNjseSzI5pDq3uxIa3dtu88hLK3gkBjbY9E15GFBausYV8z6utjPi8F22bvCvw/qZyX0I/mafWJAp49VNIcHgn0SpcPsB5pnoQdp4vaL4FvF27dElYLeJiXNb9LmnC6T4AhhC7DOrUoU3WQMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756810128; c=relaxed/simple;
	bh=tEHH8MsXPFFjYPnMaPvn/iKFEj3djguoXnZZ0cx5ZO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jtRUrZt0yOi9DQH5xftyOpzdnZ6hZEXZCtBXKmSSW58IbmAGT4IpAh1atgBahUADYKW84PxwaFBxWmoKWduG11GvZ8T2K/VZ1cqa78IfVUF3fDarYJU+KKJ7QJHNjHSeaBs5M6HTr0PbiAjMY19IMo5cNwTIF3ZCr5AoHpQ8uNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3CF136046B; Tue,  2 Sep 2025 12:48:36 +0200 (CEST)
Date: Tue, 2 Sep 2025 12:48:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, phil@nwl.cc
Subject: Re: [PATCH nft] gitignore: ignore "tools/nftables.service"
Message-ID: <aLbLe9Z0ALPW_pdh@strlen.de>
References: <20250902100342.4126-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902100342.4126-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> The created nftables.service file in tools directory should not be
> tracked by Git.

ACK, but there is already a patch from Phil in the patchwork backlog.

Phil, please apply your patch to ignore this file, thanks!
