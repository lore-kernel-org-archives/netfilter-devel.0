Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229FC7D3F4;
	Fri, 15 Nov 2024 10:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731667829; cv=none; b=YhQXCegxa7/Peg2/pJXJ6Ql3uy24PolVQhQN9UN2LpqSoFs5hmRsqJ7JgCdAk9l8N5DtrAIR+DXmq9vcIr7fVjmBOcNSJK67fR3rOJNCR+WFrBnLXVTYmRlQNdbXXp9+gR7cMZPko1ub5wchE8tkxupwoBb92ZSbElz/PzEq+4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731667829; c=relaxed/simple;
	bh=x0CWtasQEIdKAsOZNSmh38GuBVPzMRgtao7o+kBapb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehIHZfBfazXDvAjhRFb7OjFmzXaHuttyEbWYNSiOx7rbm8k5cM4SDZiYwE2/ce15SPNWcVR+TOX/BTXZqs+ZqnwgY5syxB2BUdKwOqJIAgKMEXz/wcpfXwEtmxq4i15u78PA5fosF/JdXGlFLNPTvdKTkrWm0e4i/yQYzyEN+Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=42698 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tBtu5-007bCY-Ik; Fri, 15 Nov 2024 11:50:20 +0100
Date: Fri, 15 Nov 2024 11:50:15 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Guillaume Nault <gnault@redhat.com>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, coreteam@netfilter.org,
	netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH nf-next 0/5] netfilter: Prepare netfilter to future
 .flowi4_tos conversion.
Message-ID: <ZzcnZ8XvumIbR5mf@calendula>
References: <cover.1731599482.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1731599482.git.gnault@redhat.com>
X-Spam-Score: -1.9 (-)

On Thu, Nov 14, 2024 at 05:03:16PM +0100, Guillaume Nault wrote:
> There are multiple occasions where Netfilter code needs to perform
> route lookups and initialise struct flowi4. As we're in the process of
> converting the .flowi4_tos field to dscp_t, we need to convert the
> users so that they have a dscp_t value at hand, rather than a __u8.
> 
> All netfilter users get the DSCP (TOS) value from IPv4 packet headers.
> So we just need to use the new ip4h_dscp() helper to get a dscp_t
> variable.
> 
> Converting .flowi4_tos to dscp_t will allow to detect regressions where
> ECN bits are mistakenly treated as DSCP when doing route lookups.

Series applied, thanks
