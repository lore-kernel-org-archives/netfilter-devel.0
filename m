Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C2539526B;
	Thu,  5 Mar 2026 12:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772713296; cv=none; b=m+GBgF/IlIfWztlzXHERJ+rvn3zBwzRq/cfZ/90MrrxYmKKYp3UP2QZ1SWdkVpP5Yt3HFmIAZ3mvpyUim2AQxhKj2Bl/diQDnYAvyZ4tLGw+O/z2kmLG4lODop63ALZNy8ZQsnMufOBmvzqC9F3WNuEWf3xllNWOSgzkzkmf/nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772713296; c=relaxed/simple;
	bh=B++kwL9qW9Y1aMebrog81g5Kd4wTLanIfhS5NVvUd7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ArYp0fsSovF/1VfkKlGwOD56TQ2g5Dm5/F/ipKiy2cc0R6LF16EoTxKf8OKYGFD+fE1IFreJqXuibtAPFN8ybSf7nzF08dfq4YGLhAaukO8JKLnGv9iY3/oRb9mG05zqxx/kqYUBIY68BM6Pvb4O70XKkidH2kGGN4dPpl2Du8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 90AD760298; Thu, 05 Mar 2026 13:21:31 +0100 (CET)
Date: Thu, 5 Mar 2026 13:21:31 +0100
From: Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net 0/4] netfilter: updates for net
Message-ID: <aal1SzxYWyGNCWrj@strlen.de>
References: <20260304172940.24948-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304172940.24948-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> 1) Fix a bug with vlan headers in the flowtable infrastructure.
>    Existing code uses skb_vlan_push() helper, but that helper
>    requires skb->data to point to the MAC header, which isn't the
>    case for flowtables.  Switch to a new helper, modeled on the
>    existing PPPoE helper. From Eric Woudstra. This bug was added
>    in v6.19-rc1.

Please toss this MR, I will create a new one in a few minutes,
axing this fix from the series.
