Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8691DF74F
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 11:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165352; cv=none; b=PPuD4OR15wpyYvz2vxOjO+YXKPNUg7uGNgXrJV00HfQCplg0D4Rr/UuVbDbI3pUMWuH7W2fDib0q2MX1EplLb28meCQJ2MVsbASjWZ3yPD+GVWNtgZedvhErKViN9s8nAPkZcd8LHmR497X+Ap304tGS6XzbCI2asuTIJQSQ/8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165352; c=relaxed/simple;
	bh=iejtWqcEb1k1k8JZ3cHC8k9PKvgp2qA+M8F6SvGFQ9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTqBnBDBN2tuwN0YKeGIK9g7IY+3YuwjDm9upuEqf/bVfQZ7GGgiqza3OorsmihPWydrC/dBR9b3LIlWAcH77ThIDi0Pfrum3SbaaZAZ6TCn4Yaqnb9LO1FMEJ5jrs7RQ+i3NuuTxpMTOUrFymCDNF/N/G+malW56htwBOM8jQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6F8A0608DB; Tue, 14 Apr 2026 13:15:49 +0200 (CEST)
Date: Tue, 14 Apr 2026 13:15:49 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_osf: restrict it to ipv6
Message-ID: <ad4h5fol7EZclLyP@strlen.de>
References: <20260414110811.6178-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414110811.6178-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This expression only supports for ipv4, restrict it.

:-O

Acked-by: Florian Westphal <fw@strlen.de>
