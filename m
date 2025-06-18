Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A4C21CFF7
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Jun 2025 22:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285021; cv=none; b=Fy/WLSdPGqNOEUOa3sw5aaBmekhGbC8mqK7XR685CDgJQePY6hHvtnyKuk5RPzDtTWIJIreEAI8IzQbwwUBdjyiErVjT2mqfymWvPQYm4EXl+mWUfgl0GuMF8L0RIp5naXiDUM9LEqtYpnNgOlICS+twUtHqQ5AR31pRrlQ4DXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285021; c=relaxed/simple;
	bh=I+xjLTzDpMkhGAovz9p2Ih1tlWq3AYW2PbrCfbjCn64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sG+7ExwmmCQKmEE7621f7UG4Cqglasmq/GzX55lbeanmpa9fALge7Mo3PjgCS/++trJ53zC20VvMXxiF/bsVRZ/nb0lJNLQ5bdIZgCx5OacpZ4tqfOx3F8s6MQHt38pgYkD6l9OSoRSrHQl4VDb1/So2r0OQGw96MDnxV9waG8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2D221612C3; Thu, 19 Jun 2025 00:16:50 +0200 (CEST)
Date: Thu, 19 Jun 2025 00:16:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Heiss <c.heiss@proxmox.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools v2 0/2] conntrack: introduce --labelmap
 option to specify connlabel.conf path
Message-ID: <aFM6w6-koGXYTuOp@strlen.de>
References: <20250617104837.939280-1-c.heiss@proxmox.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617104837.939280-1-c.heiss@proxmox.com>

Christoph Heiss <c.heiss@proxmox.com> wrote:
> Enables specifying a path to a connlabel.conf to load instead of the
> default one at /etc/xtables/connlabel.conf.
> 
> nfct_labelmap_new() already allows supplying a custom path to load
> labels from, so it just needs to be passed in there.
> 
> First patch is preparatory only; to make --labelmap
> position-independent.
> 
> v1: https://lore.kernel.org/netfilter-devel/20250613102742.409820-1-c.heiss@proxmox.com/
> 
> Changes v1 -> v2:
>   * introduced preparatory patch moving label merging after arg parsing
>   * removed redundant `if` around free() call
>   * abort if --labelmap is specified multiple times

Changes look good to me, thanks.

I intend to apply this series in the next few days unless someone else
beats me to it (or has change requess).
