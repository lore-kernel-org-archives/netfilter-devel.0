Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C3914A0B8
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 11:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724325834; cv=none; b=H/UOrxGFkQ4Gg89VaJvPE+NyWfjAd4OWiiNOgidDN7wYyT/+nvUW/CYclS2sgpazaxerG2hvPE2l10k6DLe6kYC7iQuM41xMgap//ma5hJbkFF5y93+K07c4ihLS5jM5aFUbIgyO2WbKRUb2phppnoa94mBp9Z/5X+G0QLZIglQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724325834; c=relaxed/simple;
	bh=3eN0zutdhepQMGG9zDd7lDdEZnMVlsNHIeQniDdyE+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AIZqzuVVrfn/Z/rOPxBy1Rqg2GYGUAgItJ/ed1NW+h7QkCyxw1yJ/++vQq2R88NbpOyQ8REuf8v3OxYuY6mxOYWCYyE5KlZb4yxuBJUIAXiphkxeuaRv8yi9ImUNTVFelV03DINxLpewsN8Z02ylVYGtr8UYDYwBDoRryJ3A9Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sh5ul-0005dN-Jh; Thu, 22 Aug 2024 13:23:39 +0200
Date: Thu, 22 Aug 2024 13:23:39 +0200
From: Florian Westphal <fw@strlen.de>
To: Breno Leitao <leitao@debian.org>
Cc: fw@strlen.de, rbc@meta.com, netfilter-devel@vger.kernel.org
Subject: Re: netfilter: Kconfig: IP6_NF_IPTABLES_LEGACY old =y behaviour
 question
Message-ID: <20240822112339.GA21472@breakpoint.cc>
References: <Zsb+YHrLklrTCrly@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zsb+YHrLklrTCrly@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Breno Leitao <leitao@debian.org> wrote:
> Hello Florian,
> 
> I am rebasing my workflow in into a new kernel, and I have a question
> that you might be able to help me. It is related to
> IP6_NF_IPTABLES_LEGACY Kconfig, and the change in a9525c7f6219cee9
> ("netfilter: xtables: allow xtables-nft only builds").
> 
> In my kernel before this change, I used to have ip6_tables "module" as
> builtin (CONFIG_IP6_NF_IPTABLES=y), and all the other dependencies as
> modules, such as IP6_NF_FILTER=m, IP6_NF_MANGLE=m, IP6_NF_RAW=m.
> 
> After the mentioned commit above, I am not able to have ip6_tables set
> as a builtin (=y) anymore, give that it is a "hidden" configuration, and
> the only way is to change some of the selectable dependencies
> (IP6_NF_RAW for insntance) to be a built-in (=y).
> 
> That said, do you know if I can keep the ip6_tables as builtin without
> changing any of the selectable dependencies configuration. In other
> words, is it possible to keep the old behaviour (ip6_table builtin and
> the dependenceis as modules) with the new IP6_NF_IPTABLES_LEGACY
> configuration?

No.  But why would you need it?
ip6_tables.c is only relevant for the various tables.

You could make a patch for nf-next that exposes those symbols as per description
in a9525c7f6219cee9284c0031c5930e8d41384677, i.e. with 'depends on'
change.

