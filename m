Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794354725;
	b=rcuU1XVGu0nb+/oHXr1Apqky65f+4/ea0NncAxqbK7jzfByVv2C2H7vU2EOq3ALrV52M
	 ntz6B9m0p4D+fz7DEKCd1zo8C783AlcLBLb8km7RarzYr3AK5n2Cf/ybYTgZntEQk9dX1
	 8IMR2qljg06JV+dTiStAC6sOGPWVPHWvBKj63wH4zwvOByFFP1bkBUx4YvZyHZB7NfWj9
	 clTaw4GApGBfNZZr97O0ULSwCr9KSDaFyNpVxv+WJxirju+P+sHU7sbyYKnnDbz7NUuak
	 aph9kMgfWSCtOVlSemX7nmBVfMCompnimpKRg3M0G9MBbEUvqBefDrh3rWlZ4l4Fslw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794354725;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wLvjTcHuWGV0crOVNMpif5xO3sGZrQZ6Vusy8iaG6Zc=;
	b=5abarj0B4O+Zd/gm6mjM1TnoaBs1/iYz3eRikN3O/l/ZG0xfQvznfMMIbUdba29c5QUM
	 qxfqXQ6GOIVmbfm2zO4xs0Poxz8QxAiW1lapkcz6Qx8ya29DFwhVty3YYx5gZPYsNQIcA
	 SxK57DLoMbyhy6V15/h/6GjECYuRqH0dy1RXU/hrXxC43I6kW3NBiZu/ND14uX7MN9mcg
	 ts8PUEx/HXZs2O6DN2uTijP18HB4PrZOhcGRpCJNC/tHGSmV80FN1tHVAt8PuIv2KIRNV
	 OHWZdv8tW5KxSlbCJnWwAoaBT/vTNewVdOecRqBy0Vqieup+tEMkLTi/coxOkqt5j6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FB9606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 23:52:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6FB9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4159F60509; Wed, 11 Nov 2026 00:52:01 +0100 (CET)
Date: Wed, 11 Nov 2026 00:51:59 +0100
From: Florian Westphal <fw@strlen.de>
To: jpeska <jpeska@redhat.com>
Cc: netfilter-devel@vger.kernel.org, fwestpha@redhat.com
Subject: Re: [PATCH nf-next] selftests: netfilter: add UDP flowtable offload
 test
Message-ID: <avOuH_ayOgr5x6DJ@strlen.de>
References: <20261109135137.1770507-1-jpeska@redhat.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109135137.1770507-1-jpeska@redhat.com>

jpeska <jpeska@redhat.com> wrote:
> nft_flowtable.sh offloads only TCP, so the UDP flowtable paths never
> run: the UDP tuple lookup, the UDP checksum update, IPv6 source NAT,
> and nf_ct_acct_update behind the flowtable counter flag.
> 
> Add an echo test for IPv4 and IPv6, with and without masquerade. The
> payload must come back intact, the forward chain must see only the
> handshake, and conntrack must mark the flow OFFLOAD and account every
> datagram.

In case you did not see it yet:

https://sashiko.dev/#/patchset/20261109135137.1770507-1-jpeska%40redhat.com

Wrt. the various CONFIG_* comments:

The kfselftests CAN assume that the kernel has the options defined
in selftests/net/netfilter/config , so there is no need to go above and
beyond and tolerate all kinds of stuff being absent.

exit $ksft_skip instead of exit 1 when its clearly a missing
config option is fine, but if its not easy to tell why something
is failing (e.g. nft -f foo.txt when run on kernel that lacks a
particular nftables module but that module is listed in the config
file -- exit 1, no need to start guessing.

$ksft_skip is only ok if there is no doubt whatsoever that the
failure is because of a missing option/feature.

Wrt to NETIF_F_HW_CSUM comment, I think one could start playing
with ethtool and the checksum features (ethtool -k) to check
different combinations.

Might make sense to integrate this script with nft_flowtable.sh
so that tcp can be easily covered too.  Also nft_flowtable.sh
re-runs itself with random mtu sizes, this is also helpful to spot
any MTU (defrag/refrag) problems.

But up to you.
