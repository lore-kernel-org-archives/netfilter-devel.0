Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83170367B8A
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2026 20:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782334576; cv=none; b=OUkyPaZBXToGgUBLETEXBntgiwqW07NCnkIg9cZQ+SeDlKHtgqu7GjY8h3si7DcwVAa2UdMdFMThycGkUMgC4PReYnPXmKGYeZjjruB0jQesqTZn+jzuX3RRF2WA+w6thE+b6Yc/eMKUyqOa52X8nNY385/izeZl8Ndi18HzSkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782334576; c=relaxed/simple;
	bh=1MWgyQSySZdIpwgNL+3QyVKh4glQePN6hXtuhn2QmYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dQbw6f/4hKCNF1lylrBgLi0KhIUL5OhGWObiswfXJpcuIXYm7feIdNkTdCQMpW51Sh/H2n8yWyVZrB/SNDapAHN5X3fjJBrQFBYEupONNA6MAI1Xsja/GuZWyoEq4Dq3Vhh4TcD7sxw0OLJDiTrgmeYuSe0sVGB/2x9wDgTh/8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A117560491; Wed, 24 Jun 2026 22:56:12 +0200 (CEST)
Date: Wed, 24 Jun 2026 22:56:12 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: netfilter-devel@vger.kernel.org, Seesee <cjc000013@gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: don't leak bad clone into
 future transaction
Message-ID: <ajxEbCY0yNsrsxx6@strlen.de>
References: <20260616191938.2875-1-fw@strlen.de>
 <20260617075123.7a62e22c@elisabeth>
 <ajJUklUUmvafRVi9@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajJUklUUmvafRVi9@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Stefano Brivio <sbrivio@redhat.com> wrote:
> > I can try to get to this in the next few days (I would have some ideas
> > about testing, see below), but I suppose we want a fix quickly if that's
> > really the case so I'm actually fine with this, with one nit, also
> > reported below.
> 
> I don't mind, this can wait if you prefer to undo the state.

Ping.  Are you working on an alternative patch or should I send a v2?
