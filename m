Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6117CF3F;
	Wed, 24 Jan 2024 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706122843; cv=none; b=Bxj+51LY7A1efEtL8XcxVBf0zsnXTpVpr4L68S2qhvAWVQPDrYxXh/dp3UtKi6qzZwan4wM5vtUSeGXA6EsXM9tolhvE5nxh2gmsx1JdV1CFCZi158NuoNahh7ZDwyRBKzZtfLuz7RUpFI3RsxsDD5RK1IGf4NvoET1euViG/GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706122843; c=relaxed/simple;
	bh=1a0dqgS5c7cs18SxgZIobtpEAw0oYgFxSnOCBXW3YuE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c+d14EbjbnkoaGAYU+IuOt1MZ4c6f/jRbKZONXeFlPEq4SXLxQ2RoXAxti0+tT0IQiIkScM+Jp4XYlUtvh2KSz4fo/V0XhGm+cFMhwgqkHXOn9pvMcp2tP/SZh9plpePvPa3XB25ZdGIsrH2Dnhs1LiTPIAOKWjP6QGjBIzDxuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ebut8+cX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ebut8+cX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925D3C43394;
	Wed, 24 Jan 2024 19:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706122843;
	bh=1a0dqgS5c7cs18SxgZIobtpEAw0oYgFxSnOCBXW3YuE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ebut8+cXPCCEej+utPPrhAy0XaABkJGRFWCBZxnTbN7Jyhsk9aBm/rDVFv7IUoukx
	 JxR1mb9c5w5SQ4/2Na+nRXmJKSOdBH3WIYRGYSubEn5vHPqsad5rt5oZSaToazkFll
	 v/BH+QbywYilkEoMULvOHWuW3isSjV99Li8My/VDwClaLYfYSp88X1hkb+6sALVXOB
	 NymhhT+CpUVLNHiNgGcflbDPrmSJCysemE1l4wjTyYr2ebdqx3TL/IgXk04FtMH1pj
	 qRftt0tdQHOzJYmY6nV8ft+g5OGgc+f75l2uT1G6c0QGPKa6HwF/6rfY2ahL+0R3PH
	 WtPPkhf6D0rDA==
Date: Wed, 24 Jan 2024 11:00:41 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, David Ahern
 <dsahern@kernel.org>, Hangbin Liu <liuhangbin@gmail.com>,
 netdev@vger.kernel.org, netdev-driver-reviewers@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [ANN] net-next is OPEN
Message-ID: <20240124110041.14191da7@kernel.org>
In-Reply-To: <26616300-dc28-47d1-88bb-1c7247d1699d@kernel.org>
References: <20240122091612.3f1a3e3d@kernel.org>
	<Za98C_rCH8iO_yaK@Laptop-X1>
	<20240123072010.7be8fb83@kernel.org>
	<d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
	<65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
	<20240124082255.7c8f7c55@kernel.org>
	<20240124090123.32672a5b@kernel.org>
	<26616300-dc28-47d1-88bb-1c7247d1699d@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 Jan 2024 18:35:14 +0000 (GMT) Matthieu Baerts wrote:
> > Ah, BTW, a major source of failures seems to be that iptables is
> > mapping to nftables on the executor. And either nftables doesn't
> > support the functionality the tests expect or we're missing configs :(
> > E.g. the TTL module.  
> 
> I don't know if it is the same issue, but for MPTCP, we use
> 'iptables-legacy' if available.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=0c4cd3f86a400

Great! Thanks for the pointer. I installed the packages now,
so folks should be able to fix up their scripts.
