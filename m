Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1749A202963;
	Wed,  8 Jul 2026 09:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783504064; cv=none; b=F3ZtpQ1GZpf0X+nUZhxWKeVXJ6cVtidLBH1CskL6eoSpg+scFI4k1IO3mk/m7KbzYx9Ndh7nV5PZDMNUs8LI0+qoIDSCck0TNOMNJf7fcPg8IXWGk3EJvdx22cqSdWj5eErbkdp4p5iX78sIeghsJiwV15DaEONh76GZXOTeNuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783504064; c=relaxed/simple;
	bh=2UgdhvCGhKgRQkmJRc96GJIV6llQ7T3t1zDzDxlGnZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u1aj0g4EBI1Sxlqc1pILG8xJvBboX8ceQB9nKyiibTQc4ytIHEAlEEtgIYWH8NxCJEp9veHxsmYEW4+fssCIeAg2/Kb+p7qMPCNmoBoOx33qk7tq9Dpt2zGgJvi1MSoITz+CB3STz3VzZ4wWNMd0g2bDta1e+Q+3ZCrpJVPYRMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=q8b2I+IS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="q8b2I+IS"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 2976560193;
	Wed,  8 Jul 2026 11:47:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783504061;
	bh=2UgdhvCGhKgRQkmJRc96GJIV6llQ7T3t1zDzDxlGnZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q8b2I+IS6HDoQPBSTyVBsFQKp5IoijQCkAoyHVuUPhJN5svd8ODqibHf/SJsjJo+N
	 iHlgcBdTWp0pBBy2kjA7lTZG10La17/cvipw1Y/1tRXTVsXAynfmsX/Zo1YvyujVqr
	 fkOfrO4mRzdxVZN+AI1H7D8Pa9BDqQpYBkDUQJVh/4fdcH+EwVeT5neTr/UqpkTrRN
	 llplN2oyn+NkdNmzLH/IRaCDo3X0M//FWM7LcvMxfVbt+0sb7UDk57LfK7WPhU7f3n
	 nnsKBCpLli81YGBeMGTTeEn/DJl+zETx/GjiImTx3xDG5gv+MBUgn02JWPTvVBpqs4
	 2E4hpf6MRQ2Mg==
Date: Wed, 8 Jul 2026 11:47:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Krishna Kumar <krikku@gmail.com>,
	Martin Karsten <mkarsten@uwaterloo.ca>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, bridge@lists.linux.dev
Subject: Re: [PATCH v12 nf-next 0/7] netfilter: Add bridge-fastpath
Message-ID: <ak4culZgTe8CNSva@chamomile>
References: <20260707091045.967678-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260707091045.967678-1-ericwouds@gmail.com>

Hi Eric,

On Tue, Jul 07, 2026 at 11:10:38AM +0200, Eric Woudstra wrote:
> This patchset makes it possible to set up a software fastpath between
> bridged interfaces. One patch adds the flow rule for the hardware
> fastpath. This creates the possibility to have a hardware offloaded
> fastpath between bridged interfaces. More patches are added to solve
> issues found with the existing code.

Thanks for your series.

I posted an alternative series, including one of your patches for the
bridge vlan filtering support (which is still untested on my side):

https://lore.kernel.org/netfilter-devel/20260708093250.1187068-1-pablo@netfilter.org/T/#m270aedab59bf39f1bc4452d1d8d739a2b1b0bc45
