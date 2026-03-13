Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793DF37700F
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 23:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773444995; cv=none; b=sUgYtOG8AcaQ3dCZDJpbu/XBclVZqqVMPiAJR03LMEq1pjRU8s4nGMItXkXd0ACzIW9QzfTgV7QyMUpveCfHWdGotVXu/vsneuhDiOo1e4dkDzq5/FxI3ivc4eY5GcM32oqBknjjkX8CxX7v3Qbx+SWKYNWmVz2Qtjx/gAJKSgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773444995; c=relaxed/simple;
	bh=+q0VMR03pp8CRm8FRKMF14MNaOXSfbcYZGlG3EN6I/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Do0sIv58tj1+3yKsWheE53Y7kTdJqbpKS7BcWaJ1BvRLPybnuuIZEaU0SZgkOxR56vpJtlYxjPmXWoz9EVD8V5x/yieZNHwus66muMkoI5LbpxgIO1KbY96yIXMuXTtK+PQdjoQx48k400Ko44yp7s0CcZbRyrI2snPhy734nE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 88BA860910; Sat, 14 Mar 2026 00:36:31 +0100 (CET)
Date: Sat, 14 Mar 2026 00:36:33 +0100
From: Florian Westphal <fw@strlen.de>
To: Jenny Guanni Qu <qguanni@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org, klaudia@vidocsecurity.com,
	dawid@vidocsecurity.com
Subject: Re: [PATCH v2] netfilter: nf_conntrack_sip: add bounds-checked port
 parsing helper
Message-ID: <abSfgVpCQcFWwNEs@strlen.de>
References: <20260313195256.2783257-1-qguanni@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313195256.2783257-1-qguanni@gmail.com>

Jenny Guanni Qu <qguanni@gmail.com> wrote:
> +	/* reached limit while parsing port */
> +	if (dptr >= limit)
> +		return false;
> +
> +	if (port) {
> +		if (p < 1024 || p > 65535)
> +			return false;
> +		*port = htons(p);
> +	}

I like the port range check, but should we make this universal?

	if (p < 1024 || p > 65535)
		return false;
	if (port)
		*port = htons(p);

?
