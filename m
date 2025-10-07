Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22963C1F;
	Tue,  7 Oct 2025 10:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759831795; cv=none; b=ca9n8hwAlf4evn7ghJ5f0JFjP1PEsi/H+vqu18H8KcdlxCuJWKIcXfjzHDHQtx48s4N4ykWRGlhjmdlR3C7mML0bsQ3iwWXbZLv8/1Ady2bo0DtYGRFPV520305XU46ieKntHWvz0uUyi5gjSEjggTfSjfAvdQLSutpvz5JxbeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759831795; c=relaxed/simple;
	bh=/YdfC2qDowg9aRrKa7/zKK7nYPqnjmB4/Ah4Gm8oGiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iuj+ytFbvXqP/OzY34tYtNf0Lk7e403CehtC3NcvdVBa9lOoKBwNyDAX3bTRniPc0YiyTV6/3Uj60muzTPS3rg+og2bmkQHaUIw6YZRuiFJJB0Rh+apL59jswtpFzixQwWxninm2+oLlnGq09dJL6g5nExuNvXJWRTEEIXXAcJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A1CA5602F8; Tue,  7 Oct 2025 12:09:51 +0200 (CEST)
Date: Tue, 7 Oct 2025 12:09:51 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Felix Fietkau <nbd@nbd.name>,
	Pablo Neira Ayuso <pablo@netfilter.org>, bridge@lists.linux.dev,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v1 nf] bridge: br_vlan_fill_forward_path_pvid: use
 br_vlan_group_rcu()
Message-ID: <aOTm6AUL8qeOw0Sp@strlen.de>
References: <20251007081501.6358-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007081501.6358-1-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> Bug: br_vlan_fill_forward_path_pvid uses br_vlan_group() instead of
> br_vlan_group_rcu(). Correct this bug.

@netdev maintainers:

In case you wish to take this via net tree:

Reviewed-by: Florian Westphal <fw@strlen.de>

Else I will apply this to nf.git and will pass it to -net
in next PR.
