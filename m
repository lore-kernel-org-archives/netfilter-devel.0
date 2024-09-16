Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BE613E41D
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2024 22:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726524778; cv=none; b=XY26Z3Oon3rtyfiYKqCwB0Ma25FiYhL5PJJ17TPoKTjzhMfYsv2ei3wwqmtYzLcj7cLu4+gHX0vaEUCnB58khSYx6sSYNOWYqiDE6ciGfWzzncxNI/nLwk7aZ7R2Zp2qJP16r9hE+aLTsm4IKrAfdaLd6FmCNvnQELmVV7eeHKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726524778; c=relaxed/simple;
	bh=SDQAMNEeLxkwIPRrsh+YU69kBlI5WO9eR4dKTx0gUC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GBOsicdtqmR34GIU4t8Hy22GUdIDVcgq8mUKdcF53rZAi1SWXOUL9ptd3i9tyNgYHVjWFb7SAUMEWOazOuMrPBurzWWL7lJe72a9bm41ebj2DsB+fDjc4NchalGSF+Rqn/iFTMGVVMG5q5Uq0wOsnjGTW9VE6fEHP58OMe/J5go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sqJxk-0008T5-EW; Tue, 17 Sep 2024 00:12:52 +0200
Date: Tue, 17 Sep 2024 00:12:52 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	antonio.ojea.garcia@gmail.com
Subject: Re: [PATCH nft,v3] doc: tproxy is non-terminal in nftables
Message-ID: <20240916221252.GA32490@breakpoint.cc>
References: <20240916213954.647509-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240916213954.647509-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> iptables TPROXY issues NF_ACCEPT while nftables tproxy allows for
> post-processing. Update examples. For more info, see:
> 

LGTM, thanks Pablo!
