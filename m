Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F136D1A7
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Sep 2025 10:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758970067; cv=none; b=ImmtI2XqzWpN49qlqKTuwu82H4zNnaHVonfMzDm42N5oQSZ1NZbIsPRWLuIqMTOiXkyYCM7c3ubxueteGn65w0c6XztYyRs/UAOEQJJJbrrBZHXRsQ9YqI3CmulqUCQ3OxHh07CWcsUtjchOIuYaBo8Xid0WcnEsxDW58ZQh+mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758970067; c=relaxed/simple;
	bh=P1RVv0+kqVqYPsf64XH+bNoV11gPGUz+iLtAHC9Dn14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zl4ryVGfDW0BZsgHa2E4DxvHA8vKT2yfs+JpzjxFxRPwkKm78qlKG62Xcnw4lpevenGLqj/h7I4mfT23VSSbNHHNSvU3GGbgfaxeThMwUfw89ddqJvpFDi2EofOp5dfG9YR81qLGht8fIrFOlRK1ZFOkPk7cHe9IQFgpstimtIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F25CA605E6; Sat, 27 Sep 2025 12:47:42 +0200 (CEST)
Date: Sat, 27 Sep 2025 12:47:27 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [TEST] nf_nat_edemux.sh flakes
Message-ID: <aNfAv4Nkq_j9FlJS@strlen.de>
References: <20250926163318.40d1a502@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926163318.40d1a502@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> nf_nat_edemux.sh started flaking in NIPA quite a bit more around a week ago.
> 
> https://netdev.bots.linux.dev/contest.html?pass=0&test=nf-nat-edemux-sh&ld_cnt=400

Weird, I don't recall changes in nat engine.
I'll have a look sometime next week.
