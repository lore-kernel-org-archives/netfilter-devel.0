Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DBD2135CE
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 15:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756480128; cv=none; b=bUt2pOS2vPJez/1A62kp3G9LPEPgH4hrq4EYnc7JwO9BXYqOUttCp2ZGdVZJEouPt3vO4dxqoUWOY/wezKl+esQUByyuldK6SbPf4jCgluEU2368JJf1ZYAua0ltYfRV8+7kFl/nLpEBeQS1jZC6qhb4OEy0NWcVq0Yw4U99flE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756480128; c=relaxed/simple;
	bh=Mc7hCGw7yVTs6FJ0ivNxYT4XeCggXFdsZzW4ltVsDvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MLUYwFQVhf4BEDH7tNiAlyH3zDW+cesIezVyKlI/e7NxYK82xafDTjlDLDKhgTGcZ2Y0JefBSQ8+GKPddmZCsz+HRMC60Hg19tVXG0MVECGPkligRkCrKE5ybQ7dEx1BMIj0JPgDXet4mvSWK2VuPd41Y3lUYbxVqeu/zzZztGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0BAC260298; Fri, 29 Aug 2025 17:08:44 +0200 (CEST)
Date: Fri, 29 Aug 2025 17:08:43 +0200
From: Florian Westphal <fw@strlen.de>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH] netfilter: nft_ct: reject ambiguous conntrack
 expressions in inet tables
Message-ID: <aLHCe9QAViNEtwPi@strlen.de>
References: <20250829065011.12936-1-nickgarlis@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829065011.12936-1-nickgarlis@gmail.com>

Nikolaos Gkarlis <nickgarlis@gmail.com> wrote:
> The kernel accepts netlink messages using the legacy NFT_CT_SRC,
> NFT_CT_DST keys in inet tables, creating ambiguous conntrack expressions
> that cannot be properly evaluated during packet processing.
> 
> When NFPROTO_INET is used with NFT_CT_SRC, NFT_CT_DST the register size
> calculation defaults to IPv6 (16 bytes) regardless of the actual packet
> family.
> 
> This causes two issues:
> 1. For IPv4 packets, only 4 bytes contain valid address data while 12
>    bytes contain uninitialized memory during comparison.
> 2. nft userspace cannot properly display these rules ([invalid type]).
> 
> The bug is not reproducible through standard nft commands, which
> properly use NFT_CT_SRC_IP(6), NFT_CT_DST_IP(6) keys instead.

It breaks nftables .py tests:

tests/py/nft-test.py
inet/rt.t: OK
inet/ct.t: ERROR: line 7: add rule inet test-inet input meta nfproto ipv4 ct original saddr 1.2.3.4: This rule should not have failed.
inet/ct.t: OK
