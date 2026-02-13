Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497083563FB
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2026 11:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770982694; cv=none; b=Su882atC0PWN311t8bREKtM6hD1IbBZnebdNArY/KL0vR2IkVHylkn19UP+iMbgnSLpLgT/NeRUwVG+daUTzbFn0qisoLyskZs+8vE3HFivI/cZPacsC52rHivEPOkDnL+U8lyzI+LTFXuPcyI/rygtmBICFm71/fHBZZ/kxIAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770982694; c=relaxed/simple;
	bh=v7l9NklavGwZXcyf5xc5Y0qfiduuSdRrVnFRAq3C4ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HKEh3FV1LOeC0zDyafiFf/UJGtyLjAAaX5JLtrCBBq2TaZCIZR7clk6UvbCYX6ypU9/DhmmSBoJEfIsraIMRoKty9k4AiTA1HqPnabLK1EWGRmyQfPVeZINB4RTEF/8SqEb6tmiF7gN7jXydewpESFJQCiX2Z29uSzL9ImQpwtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8D39B608AD; Fri, 13 Feb 2026 12:38:11 +0100 (CET)
Date: Fri, 13 Feb 2026 12:38:11 +0100
From: Florian Westphal <fw@strlen.de>
To: Alan Ross <alan@sleuthco.ai>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] libxtables: refuse to run under file capabilities
Message-ID: <aY8NI2agbGHqM8mA@strlen.de>
References: <CAKgz23F8EKsc2vhVAPyuZgUNA7Zohm0zS6-So+jPJTvCiNikig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgz23F8EKsc2vhVAPyuZgUNA7Zohm0zS6-So+jPJTvCiNikig@mail.gmail.com>

Alan Ross <alan@sleuthco.ai> wrote:
> Extend the existing setuid guard in xtables_init() to also detect
> file capabilities via getauxval(AT_SECURE).

Applied, thanks.

For future submissions, please try to set up git-send-email, the patch
was whitespace damaged and did not apply.

I mangled this locally, so no need to resend this one.
