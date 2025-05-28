Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3492F286889;
	Wed, 28 May 2025 13:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748437836; cv=none; b=kFO8H+H9oEcmLDv7Gyc0wTfu0AC/c2yju9459Vnu/S47iq4OnON5yfQUGCkbYdtktnhP3WqXSHgxdlSTE3Hz8gxfo4tIEYH5XALVRsbroRIeqfB/+gmxUHsBfGB+o914GKO45xqPD3aP2S4Wyp6a4D+2Al4Yq9Gy2wi9UbP5M28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748437836; c=relaxed/simple;
	bh=5gw9lFZJbt318WQjHz4/WwLts5uGrE1i3Hhu6mIN18M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kiqmeUmneWN/zeH3//YcTJ5zFo75ZPN5yq/hcsSjgwJf3qaGRZ+LoKYpBdeAFRkNAJ93SZL3tmK56pQ/eDtC2ARp7k8TJMCNLecCAf46TvQwqk1JJ/RyNx80045mNv2C5HnFohkgd60i/Fl3geA+ovAdw/9amVp5bJ0IrqqP530=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1E2A86042D; Wed, 28 May 2025 15:10:32 +0200 (CEST)
Date: Wed, 28 May 2025 15:09:54 +0200
From: Florian Westphal <fw@strlen.de>
To: ying chen <yc1082463@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [bug report, linux 6.15-rc4] A large number of connections in
 the SYN_SENT state caused the nf_conntrack table to be full.
Message-ID: <aDcLIh2lPkAWOVCI@strlen.de>
References: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN2Y7hxscai7JuC0fPE8DZ3QOPzO_KsE_AMCuyeTYRQQW_mA2w@mail.gmail.com>

ying chen <yc1082463@gmail.com> wrote:
> Hello all,
> 
> I encountered an "nf_conntrack: table full" warning on Linux 6.15-rc4.
> Running cat /proc/net/nf_conntrack showed a large number of
> connections in the SYN_SENT state.
> As is well known, if we attempt to connect to a non-existent port, the
> system will respond with an RST and then delete the conntrack entry.
> However, when we frequently connect to non-existent ports, the
> conntrack entries are not deleted, eventually causing the nf_conntrack
> table to fill up.

Yes, what do you expect to happen?
