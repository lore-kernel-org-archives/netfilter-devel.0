Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A143E8462;
	Tue, 27 May 2025 08:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748335179; cv=none; b=LcaxI5ahkG4JUWA3/Ca67bom2sYSvTCh19BgMjhoPfcRgnpZNBM/yYwRl2p3leD5wF15A/Qe4BT31Hoae/TdHtlsWZzA4CmaNwe3zQWEZl5luwIKML6sHjIP3jetpXKyTW1hp27VDSPGyfv/JpqCBWF48/5UoOwAlRkwJxjEs+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748335179; c=relaxed/simple;
	bh=Re3Yx7JTF1c4kme+WYkagTZehdSNECJd6NR0+FrhHEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EpvGkT7MNqsecr2A+rUv0xfsafIiwxbZXY7tAlnOa8Zcs1bL5Cz7lhjJHaXd0rFQbtk9w39mv1WSGJKIKiVnPQXhF8lcKg9NjLEJBM3zapHLQmQ+dqwfTwINNLDQ7dcM7TMl2ZEUxv8VP8TEyCB1Y1+MjA/AqlUC8GIOBc6siq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=um1qFVVn; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aLKZ/u4z; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="um1qFVVn";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aLKZ/u4z"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 136D260265; Tue, 27 May 2025 10:39:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748335169;
	bh=ciYO4DJNid9E6dHNDc6tQsQnGaxiAdeOt4weTE9QMMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=um1qFVVnL8MIieJYPllb8fqzzWWjwqyV+Toj3Vvoc9gXiy+eiP0ShjZe2kybRevoi
	 P26K+PoSP+RbKYIyN4IvVVxcEubI0iHov3itWz0mQUlHsNmu6jg4OF8W6qS+NsfHUp
	 Jv7EjYYQooCdQE8DCG/ysAkKDqXuM5KWBCRaV8KiI2xev6Nw/vlMY4oKa/gUn8qmG6
	 Bjlq9nCqoHHc7ee3aNMM4wE1cmfAGQnUUTU/fdRt5OpUVo9/BgXEZ82Au/HxplPoBf
	 Z3DK21LjU5n61aOmc2s9VHh4JKdeqBmFkgagl9T/8cPNBDc6vHa4q/HATzMR4FLAKp
	 kwHZCqORnjPXg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 80EDD60263;
	Tue, 27 May 2025 10:39:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748335163;
	bh=ciYO4DJNid9E6dHNDc6tQsQnGaxiAdeOt4weTE9QMMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aLKZ/u4zeVeUhuo54aQ9QbX/zSBxX6da+IkAtXTyY1A6j6C+oDdQwQv9hLVaytYa+
	 JpPWSfEhKYCKC1io5oUeB8kB7jiPy141IxWeTjZ/9S5rGgwtE94HZxrkgEaXfoxcCl
	 i+iW4rQlc41UL87zQGS7KT8knEO+ZN4qJyTFsDC79xZHm2b6qjvkmF/06Zcg9j90tS
	 B0b8XR0Rm0Lu9YOeLOc7jcNv2JAt/XLmiRmQ1HVYtrqxSgZW/pXMQB4FTESA4TumTu
	 kHpqk06v0P7WdhhsuCJltK7Zkx/6mFoOg59X43UjhjzVsyJLna20fG40DtBsbEdKmE
	 uVmRnVeBjC6ww==
Date: Tue, 27 May 2025 10:39:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	edumazet@google.com, fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net-next 26/26] selftests: netfilter: Torture nftables
 netdev hooks
Message-ID: <aDV6OA2G99L4Xvuk@calendula>
References: <20250523132712.458507-1-pablo@netfilter.org>
 <20250523132712.458507-27-pablo@netfilter.org>
 <12b16f0b-8ba8-4077-9a13-0bc514e1cd44@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <12b16f0b-8ba8-4077-9a13-0bc514e1cd44@redhat.com>

Hi Paolo,

On Tue, May 27, 2025 at 09:17:30AM +0200, Paolo Abeni wrote:
> On 5/23/25 3:27 PM, Pablo Neira Ayuso wrote:
> > +ip netns exec $nsr nft -f - <<EOF
> > +table ip t {
> > +	flowtable ft_wild {
> > +		hook ingress priority 0
> > +		devices = { wild* }
> > +	}
> > +}
> > +EOF
> 
> The above is causing CI failures:
> 
> # selftests: net/netfilter: nft_interface_stress.sh
> # /dev/stdin:4:15-19: Error: syntax error, unexpected string with a
> trailing asterisk, expecting string or quoted string or '$'
> # devices = { wild* }
> #             ^^^^^
> not ok 1 selftests: net/netfilter: nft_interface_stress.sh # exit=1
> 
> For some reasons (likely PEBKAC here...) I did not catch that before
> merging the PR, please try to follow-up soon. Thanks,

This needs userspace updates in libnftnl and nftables.

I am looking at the best way to address this.

Q: is CI getting a fresh clone from netfilter git repositories?

Thanks.
