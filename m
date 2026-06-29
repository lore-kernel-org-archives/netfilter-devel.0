Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121BE401A3F;
	Mon, 29 Jun 2026 12:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782737786; cv=none; b=uL0YmEXA2wfz7atilBlFhSCobVmUbTvnan5rI0aAw7bkUZ9aM5qaAuof8+cghkNNkohfWbr8KKxUouGjyR3zzEI2R7HzCBeyv4Ego2EhIMo6Oy5kWn7wVDm4PFVAwFPvCRHOA9HhuCZgBmlItZsOokYIxRUxMLehBFE55h8e0/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782737786; c=relaxed/simple;
	bh=vD5i8Uu5BLJ1HYu/zfIpvv/0OUhlqGC5AVzWeeEMFhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W9kUmZYgaBgz66kK2lacrgmOVsg1O+tz92KhgjoCx2SqR6Vp8mJBfa7U4Z8rCHBq2Wm+1scKgaDxxcoRjpOM+KZkEc4XQhHR0putALlVn+sGZ/GS67PiS0JLJACBfTKzt+OLoF3bvqM0a7g6G2taxGSobbSUqYg+HP6CGWn67/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C98976032C; Mon, 29 Jun 2026 14:56:16 +0200 (CEST)
Date: Mon, 29 Jun 2026 14:56:16 +0200
From: Florian Westphal <fw@strlen.de>
To: Daniel Pawlik <pawlik.dan@gmail.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, andrew+netdev@lunn.ch, razor@blackwall.org,
	idosch@nvidia.com, matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com, bridge@lists.linux.dev,
	coreteam@netfilter.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, rchen14b@gmail.com,
	lorenzo@kernel.org
Subject: Re: [PATCH 0/5] netfilter: nf_flow_table_path: L2 bridge offload
Message-ID: <akJrZpkuM2GkOqWA@strlen.de>
References: <20260629123253.1912621-1-pawlik.dan@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629123253.1912621-1-pawlik.dan@gmail.com>

Daniel Pawlik <pawlik.dan@gmail.com> wrote:
> -----------------------------
> 1. Load kmod-br-netfilter so that bridged IP traffic traverses the
>    netfilter forward chain.

Ouch.  br_netfilter should die.  Really.  Its a gross hack, never
use this thing...

> 2. Enable netfilter hooks on the bridge:
>      echo 1 > /sys/class/net/<br>/bridge/nf_call_iptables
>      echo 1 > /sys/class/net/<br>/bridge/nf_call_ip6tables
>
> 3. Register bridge member interfaces in the nft flowtable:
>      table inet filter {
>          flowtable f {
>              hook ingress priority filter
>              devices = { eth0, wlan0 }
>          }

I think that bridge flowtable should use 'table bridge ...', not
use the br_netfilter compat hacks.

Sorry.

Are you aware of Eric Woudstras bridge flowtable patches?
https://lore.kernel.org/netfilter-devel/20250408142802.96101-5-ericwouds@gmail.com/
