Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AAE18E1A
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 15:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726242893; cv=none; b=f8MlLcSIVnJOFzD2lZITUNjyoV69TZCBokxIW1Pbf//SKvNh655digyoRic5j/5YZyADT0oE0ysR2a1naMPoAvMpkqFlunpl2k67J+0YTyt1fCIuYalXJb0BG5kl+tVKRcPv+KpDiXAnomNCVJ4MHS9loMK2gjvnJSuXACvTa+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726242893; c=relaxed/simple;
	bh=eevw2M0j8AJ7zQS4c77h5k9jkCVBDImQJVDcAAmozj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kMIoTPu7j+9Vu9Y4X/QfvVFeE06JlqpY6VxJDRRq7KNZQf3hyZbW+arek6Zfbyb6z2z4SDWCwsCK2/8tQvLSzx6TQagfVGFRtU5fAUWCSk7XKpKR88eTMZXRvFwD9Q2sLnz0TFs0BgrKlvJwg6mKwAO+6HAwtcV95tIah7JjVGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sp8dF-0006fm-4R; Fri, 13 Sep 2024 17:54:49 +0200
Date: Fri, 13 Sep 2024 17:54:49 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] extensions: TPROXY: Fix for translation being
 non-terminal
Message-ID: <20240913155449.GA25571@breakpoint.cc>
References: <20240913145748.32436-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240913145748.32436-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> nftables users have to explicitly add a verdict: xt_TPROXY's
> tproxy_tg4() returns NF_ACCEPT if a socket was found and assigned,
> NF_DROP otherwise.

Thanks Phil, lgtm!
