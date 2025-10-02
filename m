Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D6A309DA5
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Oct 2025 10:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759399805; cv=none; b=uOqEu/vSgQPTCJn0EMplKVklRFfLnBcMroZF/goi0aFwzj57o4vhN9GQieTZA9x/+QMA7Ad3Bm5sbZ+GCHnjL2z/d63ujBuqi7nqdXKpajxXruHgmX5KwoHAXg4aKQWcsOE1smZlnv82VHWyHAEn8T5J52kWRXxlFyM/Di7Cgqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759399805; c=relaxed/simple;
	bh=sEyL1PNm0TGm1sjpd2hF2gjtbaJdksw31TICdgCtYPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VG+CQ4tR4C7puwxdnD6kciG/sgEASphtquTENQaaYDadRAuUDv0nQXc5uCm8aNdblyhhCQzDHBje419E5+q4dbyAijUFnuV+ve5fIBYES8g794izSHA2dwdMmQL/wej8I3wTcRtfwWnmgFZn7GkXrucmGqrd2ZpVb4SXiLNXhjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B24726032B; Thu,  2 Oct 2025 12:10:00 +0200 (CEST)
Date: Thu, 2 Oct 2025 12:10:00 +0200
From: Florian Westphal <fw@strlen.de>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
Message-ID: <aN5PeGA1yLdlxuea@strlen.de>
References: <20251001211503.2120993-1-nickgarlis@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001211503.2120993-1-nickgarlis@gmail.com>

Nikolaos Gkarlis <nickgarlis@gmail.com> wrote:
> I have tested this change with my userspace application and it
> seems to resolve the "problem". However, I am not sure if there
> is a suitable place to add a regression test, since AFAIK nft
> userspace does not currently use this feature. I would be happy
> to contribute a test if you could point me to the right place.

You could add a nfnetlink selftest to:
tools/testing/selftests/net/netfilter


