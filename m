Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BF825566;
	Wed,  7 Feb 2024 09:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707299400; cv=none; b=h35NCT1TCMB/3iEjhm23je6b85NJ535RGvKJA5wnC4g3yXgSzPlGM4pnLXx9DAVMBWiRYfwqTRPAzocokDrWISdLRTQGhvtQrpZgCPKe8PIgOIaA7n1sH8bfgY20ofyakRSPFB2H+NfBI2dJ7DdV3BTBBKmY7dJYk42dX8sElqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707299400; c=relaxed/simple;
	bh=wt4ZprwlP8v6zV9OXc1Z0Lh35uAg28FnADGaGyUzur8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B0xj5i459YcSenx46FFJv6B9hNx5QhDnukKmPIH8KFPKDrCXOKHmpM9G3D9rzhbdrbcBsuhvg16yrhrBMNKTGT3rjrNa+tv1wb6H0ZAlQ9B1rwJVSa4HBVxOo06aRm6NG0cAacioFo4cL6wBIScP9ANUdMwU/iWhUfmCa9orfBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=48492 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rXeYx-008edM-3s; Wed, 07 Feb 2024 10:49:53 +0100
Date: Wed, 7 Feb 2024 10:49:50 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	coreteam@netfilter.org, netdev-driver-reviewers@vger.kernel.org,
	Hangbin Liu <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [ANN] net-next is OPEN
Message-ID: <ZcNSPoqQkMBenwue@calendula>
References: <20240122091612.3f1a3e3d@kernel.org>
 <Za98C_rCH8iO_yaK@Laptop-X1>
 <20240123072010.7be8fb83@kernel.org>
 <d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
 <65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
 <20240124082255.7c8f7c55@kernel.org>
 <20240124090123.32672a5b@kernel.org>
 <26616300-dc28-47d1-88bb-1c7247d1699d@kernel.org>
 <ZbFiixyMFpQnxzCH@calendula>
 <7a1014ee-7e1d-4be4-bab2-07ddde8a84b7@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7a1014ee-7e1d-4be4-bab2-07ddde8a84b7@kernel.org>
X-Spam-Score: -1.9 (-)

Hi Matthieu,

On Tue, Feb 06, 2024 at 07:31:44PM +0100, Matthieu Baerts wrote:
[...]
> Good point, I understand it sounds better to use 'iptables-nft' in new
> kselftests. I should have added a bit of background and not just a link
> to this commit: at that time (around ~v6.4), we didn't need to force
> using 'iptables-legacy' on -net or net-next tree. But we needed that
> when testing kernels <= v5.15.
> 
> When validating (old) stable kernels, the recommended practice is
> apparently [1] to use the kselftests from the last stable version, e.g.
> using the kselftests from v6.7.4 when validating kernel v5.15.148. The
> kselftests are then supposed to support older kernels, e.g. by skipping
> some parts if a feature is not available. I didn't know about that
> before, and I don't know if all kselftests devs know about that.

We are sending backports to stable kernels, if one stable kernel
fails, then we have to fix it.

> I don't think that's easy to support old kernels, especially in the
> networking area, where some features/behaviours are not directly exposed
> to the userspace. Some MPTCP kselftests have to look at /proc/kallsyms
> or use other (ugly?) workarounds [2] to predict what we are supposed to
> have, depending on the kernel that is being used. But something has to
> be done, not to have big kselftests, with many different subtests,
> always marked as "failed" when validating new stable releases.

iptables-nft is supported in all of the existing stable kernels.

> Back to the modification to use 'iptables-legacy', maybe a kernel config
> was missing, but the same kselftest, with the same list of kconfig to
> add, was not working with the v5.15 kernel, while everything was OK with
> a v6.4 one. With 'iptables-legacy', the test was running fine on both. I
> will check if maybe an old kconfig option was not missing.

I suspect this is most likely kernel config missing, as it happened to Jakub.

Thanks.
