Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DF018786F;
	Wed, 28 Aug 2024 14:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724854099; cv=none; b=fbsNRQS3sa+V1kTpBBIvPXrgWEi/4b3ZHFlezUloG31Sqnl7rBUwdcV2ZtoP9p/4V4wS/OozGlt5Mwvqb8sA5e5zT3IwsKvJmNM9x+47HqqhPg7N92xBvNKWlPk+sobiCtobYMOacgFazCdA3kpnToHentvG8ekkpElWl76jKys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724854099; c=relaxed/simple;
	bh=ywI3MLxowgahZyW/GIFjgDd7jFOzw4JDC6rxiA4AXzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=naw405DTm2c0DdZI1B6DlJE+qVf2ot6GChAkJ09lwAQVyWL/k0WwHiL1peLXE4VgtNLsdH88xqTVAFUL6v3VFcwKaSkJ+xpk+ROvvUZRMeH5rHBAcBzEs5XaXqthdmwTUeL6ciPpOHIfaI4nO6Nm8tpSO9WTCqgJe/Xga+Q8GfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=52962 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sjJLG-001ZT8-6K; Wed, 28 Aug 2024 16:08:12 +0200
Date: Wed, 28 Aug 2024 16:08:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Echo Nar <echo@lethedata.com>
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: Stateless NAT ICMP Payload Mismatch
Message-ID: <Zs8vSUOWgM5MpLxu@calendula>
References: <CANsOo6on+x7OrWQN5w6Ls5RwcLHKx4Kmrp80-fPxte2LQfcuOQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANsOo6on+x7OrWQN5w6Ls5RwcLHKx4Kmrp80-fPxte2LQfcuOQ@mail.gmail.com>
X-Spam-Score: -1.9 (-)

Hi,

On Tue, Aug 27, 2024 at 03:15:00PM -0500, Echo Nar wrote:
> Is there a way to set up a stateless NAT that updates ICMP payloads
> i.e. destination-unreachable (type 3)?

At quick glance, it should be possible to mangle ICMP payloads with a
userspace nft update only.

Would you file a bugzilla ticket to request this to make sure this
does not get lost?

Thanks.

> With the current rules I have (shown below) I am able to receive ICMP
> destination-unreachable packets but the payload is wrong causing them
> to be dropped by clients. This pretty much breaks traceroute on both
> sides.
> 
> Internal to external:
> IPv4 Header - Src: 192.0.2.2, Dst: 100.64.1.105
> ICMP Type 3 Payload - Src: 203.0.113.100, Dst: 192.0.2.2
> 
> External to internal:
>    IPv4 Header - Src: 203.0.113.100, Dst: 203.0.113.200
>    ICMP Type 3 Payload - Src: 203.0.113.200, Dst: 100.64.1.105
> 
> table ip NAT {
>    chain prerouting {
>       type filter hook prerouting priority raw; policy accept;
>          iif "eth0" ip daddr 203.0.113.100 ip daddr set 100.64.1.105
> notrack return
>    }
> 
>    chain postrouting {
>       type filter hook postrouting priority raw; policy accept;
>          oif "eth0" ip saddr 100.64.1.105 ip saddr set 203.0.113.100
> notrack return
>    }
> }
> 
> As a side note, tc performs ICMP modifications (but doesn't meet my
> needs) which is why I'm thinking nftables should be able to do it as
> well.
> --
> Thanks,
> Echo Nar
> 
