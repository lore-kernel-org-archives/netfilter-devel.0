Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A476418660F
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 16:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730997718; cv=none; b=ZYGRxycQA+9izbcJKjlnLuuTrz9PBtXzv47bykTOLpeouCdtpmKVxeuunWivI6L47iNd3gyw2PijxjROW/cyKtrL4MWWKN6JcctL/RBHZmrJTwJyjQig317rJViwjYe5YEsNgw0zJjKI18rwoNJZU9yd+UuZF0vyl3+cwiEMXy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730997718; c=relaxed/simple;
	bh=74QIWeIElJYLPBNAPY25M2s5z6ve+dNtXDK5N38yO10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=blc+23eEzUWKwhrsF93koKvymFk8dGvuK6LJhiHR0yqPwBFHFEvuTytoPqTyKa7p6qNykUyhJqIR/f2rpaD+tgeBCuEP3PN8AzEgjNPpwSBKayo7AnPWTGCiPl902LMe7Q0lOGjPWCD2QYzVY5rJdYneiJoWPhjlCaQntbx2ZX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VasrSRTR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VasrSRTR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cyEmMbsoQVGfukrztlUGXtTBerOrT3R1V9FFgpI4s0o=; b=VasrSRTRPnn+lxJzNkLu5Vw9yc
	p0mXpU03fm5QB/e4isJENIsqo6g6HlqZDQJd8YF/mrfqtJZCi+TqWXHmwElw1yfMAdpfixP2lxvmM
	nEpu4Y+Q4HeSJZAj6O+sDr4SCF4i0fJt+Iv4B8kbJ+zUdcULR35DvFjF4JP69sQxofKDbOQY31FZW
	cksYHmHFYovRktf0HLVXz1MIuLsbAPRt+T9PvPVnFcMWqJFwiyshUjbucPPjKXK7Lgnvx8dTc45Ei
	VesMm3uP09K8pUnTLzd3T1Jwo1QJwybwAXW2aJOlbXda73uLhrhXyv0IXiOtXgkEyuQC5a4B/PDzG
	Gyb1JdJg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t95Zz-000000005Hl-00is;
	Thu, 07 Nov 2024 17:41:55 +0100
Date: Thu, 7 Nov 2024 17:41:54 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [iptables PATCH] libxtables: Hide xtables_strtoul_base() symbol
Message-ID: <Zyzt0rvjJX5-V6xL@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <ZyzYApZKx79g8jqm@calendula>
 <20241107161233.22665-1-phil@nwl.cc>
 <Zyzs8NAsIeq-ZmHy@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zyzs8NAsIeq-ZmHy@calendula>

On Thu, Nov 07, 2024 at 05:38:08PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 07, 2024 at 05:12:33PM +0100, Phil Sutter wrote:
> > There are no external users, no need to promote it in xtables.h.
> > 
> > Fixes: 1af6984c57cce ("libxtables: Introduce xtables_strtoul_base()")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Patch applied, thanks!
