Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB9E1DA5E
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Aug 2024 14:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724424576; cv=none; b=fhJh6OBYA5v0nKQtyDzbD9WZxtTcp3cWMmP0qfHlaWKTan9SKmNuW4rONa0A487VDK7szpFE3GOqtP7csA+qBD66ogzbg5BZHGiHwZ3HoBLCLd83tqbbxEH8NIuCoRDO2ivrbDYRVB/P//ZUamejporx1iM1xUFai7f89H78YYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724424576; c=relaxed/simple;
	bh=Fus7JKMwYePGNRcYG57CX+zik/oUk8uUEHQzcjfEqL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBODAtJWDkr31jabQ4nfYRiJVJEuMyHFSszaHqAa87Uq5FQwKrkVDEwWdQnJBpEuFfrezbfI4yFNk/MVlo/oFlic7i1bXzDlvhOL5fuO4VzDCUAlTMEowJs5Nb0rlbKPRH90OlfUPVcU91xh+VH8bu8OVEbuMaUfmMdHsaXW3i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1shVbR-0001My-1N; Fri, 23 Aug 2024 16:49:25 +0200
Date: Fri, 23 Aug 2024 16:49:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Joshua Lant <joshualant@googlemail.com>
Cc: netfilter-devel@vger.kernel.org, Joshua Lant <joshualant@gmail.com>
Subject: Re: [PATCH] iptables: align xt_CONNMARK with current kernel headers
Message-ID: <20240823144925.GA5102@breakpoint.cc>
References: <20240823092206.396460-1-joshualant@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823092206.396460-1-joshualant@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Joshua Lant <joshualant@googlemail.com> wrote:
> libxt_CONNMARK.c declares enum which is declared in the kernel header.
> Modify the version of the header in the repo's include dir to match the
> current kernel, and remove the enum declaration from xt_CONNMARK.c.

Applied, thanks.
