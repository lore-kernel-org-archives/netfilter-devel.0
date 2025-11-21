Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865992D77EA;
	Fri, 21 Nov 2025 20:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763758776; cv=none; b=oGU3BeFdXeZo7ahQzfyFsMrdcdmw+uIALt3c45Fk0Bkww2PellFDNSzATDxl7qb3QMW2oV/lbA37y5k0egu4w4NTefSN/VhBC3xv+Bgxq4qecMkv6eCFZAZfSqCIwpMjUjy6mwACGTPeSNInuP6P6zgznDl5oSp7X8I9RcpQZUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763758776; c=relaxed/simple;
	bh=0nonkJxFsZX+AnPKp8fkGyGFPFrLIomP6rhf8mOLMPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q0hTCxEJMoNjwRR72WF+tAmL4FmENrGhwNvGGmuB1cBX0Y3BufnMK1IhYxru5z162V1OmiIOWPDjwURbaK1qIYXR7LDjm99QWLXYPxXYvI6bpWi/j6Nhu+w6shP/AKK8qBkIlry+/OZLeURDuTN8at6LRga29VT6qtd/LhB1/A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=dogAOetS; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="dogAOetS"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 1982B2120704; Fri, 21 Nov 2025 12:59:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1982B2120704
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1763758775;
	bh=UJQ1JkgN/Q2PMt20vZ0iqGog9QKdheDUj+FPtHedvx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dogAOetShnB/8CkWe484WcB4dJAkTxj9Lz9tAoiIG445F20h/WR0eQaBY/X4zQDtP
	 W920SDHnIYWtVIHw29auNf2PQ/lIG/8UDstPF/FGr6X+3X76i/j1UKyUuo5YrCMhJ2
	 pMSuCEcXr4nI8dqUa52x0O1OmX2TsicxTj1PGZt8=
Date: Fri, 21 Nov 2025 12:59:35 -0800
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: Soft lock-ups caused by iptables
Message-ID: <20251121205935.GA31175@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aR3ZFSOawH-y_A3q@orbyte.nwl.cc>
 <aR3pNvwbvqj_mDu4@strlen.de>
 <aR4Ildw_PYHPAkPo@orbyte.nwl.cc>
 <aR5ObjGO4SaD3GkX@calendula>
 <aR7grVC-kLg76kvE@strlen.de>
 <20251120203836.GA31922@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aR-DEpU5rSz_VWy5@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR-DEpU5rSz_VWy5@calendula>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, Nov 20, 2025 at 10:07:30PM +0100, Pablo Neira Ayuso wrote:
> Could you also give a try to this small patch:
> 
> https://lore.kernel.org/netfilter-devel/aR27zHy5Mp4x-rrL@strlen.de/T/#mc6b8e6b02a4a46a62f443912d8122c8529df0c88
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20251119124205.124376-1-pablo@netfilter.org/
> (patchwork.ozlabs.org is a bit slow today)

The issue is still reproducible with that patch applied (the stack trace
doesn't seem to be any different as well).
