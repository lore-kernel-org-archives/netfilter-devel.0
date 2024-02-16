Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA4C134751;
	Fri, 16 Feb 2024 15:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097904; cv=none; b=A4U/fUAZkwz8YlImfoiN3si/ucRBilQw6C+ePEb6he92vNpockkGuCwtJ4XDi+aabai3qT7cD04t5k4jL1GvJez83DUVgx6HQJl+2rxOM9HYkdXJV+Vbjv+neh8D1iG5Qfx2zZatTdohuFC02Hrr4MQCaBZGI6T0u8OtUOViVvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097904; c=relaxed/simple;
	bh=v/umiByrbo+UMHmoZPas/+iyEgbA76j9zUbPB2HafrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tEhMhNrSx0exhbPldMR0vmsMq7ZK9z4gjleFNQ/cEdMJ3U+/uxnylzto/0+0fMcHGC9ueU5dSn5eP2FayZJkCD0Fi9qjKFu9xgLptnPxjXDOAJcafv1FMBEiGCGbOJL302w1OQsgJrNsypq12WwGccJGuZQjoO6A1u7t3O/k2Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=38106 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rb0Hy-004Gjh-Uo; Fri, 16 Feb 2024 16:38:13 +0100
Date: Fri, 16 Feb 2024 16:38:10 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	coreteam@netfilter.org, netdev-driver-reviewers@vger.kernel.org,
	Hangbin Liu <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [ANN] net-next is OPEN
Message-ID: <Zc+BYmrv/0pRKY+w@calendula>
References: <20240123072010.7be8fb83@kernel.org>
 <d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
 <65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
 <20240124082255.7c8f7c55@kernel.org>
 <20240124090123.32672a5b@kernel.org>
 <26616300-dc28-47d1-88bb-1c7247d1699d@kernel.org>
 <ZbFiixyMFpQnxzCH@calendula>
 <7a1014ee-7e1d-4be4-bab2-07ddde8a84b7@kernel.org>
 <ZcNSPoqQkMBenwue@calendula>
 <51bdbaab-a611-4f4d-aa8c-e004102220f3@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51bdbaab-a611-4f4d-aa8c-e004102220f3@kernel.org>
X-Spam-Score: -1.9 (-)

Hi,

Sorry for taking a while.

On Wed, Feb 07, 2024 at 12:33:44PM +0100, Matthieu Baerts wrote:
> Hi Pablo,
> 
> Thank you for your reply!
> 
> On 07/02/2024 10:49, Pablo Neira Ayuso wrote:
> > Hi Matthieu,
> > 
> > On Tue, Feb 06, 2024 at 07:31:44PM +0100, Matthieu Baerts wrote:
> > [...]
> >> Good point, I understand it sounds better to use 'iptables-nft' in new
> >> kselftests. I should have added a bit of background and not just a link
> >> to this commit: at that time (around ~v6.4), we didn't need to force
> >> using 'iptables-legacy' on -net or net-next tree. But we needed that
> >> when testing kernels <= v5.15.
> >>
> >> When validating (old) stable kernels, the recommended practice is
> >> apparently [1] to use the kselftests from the last stable version, e.g.
> >> using the kselftests from v6.7.4 when validating kernel v5.15.148. The
> >> kselftests are then supposed to support older kernels, e.g. by skipping
> >> some parts if a feature is not available. I didn't know about that
> >> before, and I don't know if all kselftests devs know about that.
> > 
> > We are sending backports to stable kernels, if one stable kernel
> > fails, then we have to fix it.
> 
> Do you validate stable kernels by running the kselftests from the same
> version (e.g. both from v5.15.x) or by using the kselftests from the
> last stable one (e.g. kernel v5.15.148 validated using the kselftests
> from v6.7.4)?

We have kselftests, but nftables/tests/shell probe for kernel
capabilities then it runs tests according to what the kernel
supports, this includes packet and control plane path tests. For
iptables, there are iptables-tests.py for the control plane path.

> >> I don't think that's easy to support old kernels, especially in the
> >> networking area, where some features/behaviours are not directly exposed
> >> to the userspace. Some MPTCP kselftests have to look at /proc/kallsyms
> >> or use other (ugly?) workarounds [2] to predict what we are supposed to
> >> have, depending on the kernel that is being used. But something has to
> >> be done, not to have big kselftests, with many different subtests,
> >> always marked as "failed" when validating new stable releases.
> > 
> > iptables-nft is supported in all of the existing stable kernels.
> 
> OK, then we should not have had the bug we had. I thought we were using
> features that were not supported in v5.15.

I don't think so, iptables-nft supports the same features as
iptables-legacy.

> >> Back to the modification to use 'iptables-legacy', maybe a kernel config
> >> was missing, but the same kselftest, with the same list of kconfig to
> >> add, was not working with the v5.15 kernel, while everything was OK with
> >> a v6.4 one. With 'iptables-legacy', the test was running fine on both. I
> >> will check if maybe an old kconfig option was not missing.
> > 
> > I suspect this is most likely kernel config missing, as it happened to Jakub.
> 
> Probably, yes. I just retried by testing a v5.15.148 kernel using the
> kselftests from the net-next tree and forcing iptables-nft: I no longer
> have the issue I had one year ago. Not sure why, we already had
> NFT_COMPAT=m back then. Maybe because we recently added IP_NF_FILTER and
> similar, because we noticed some CI didn't have them?
> Anyway, I will then switch back to iptables-nft. Thanks for the suggestion!

Thanks. If you experience any issue, report back to netfilter-devel@
