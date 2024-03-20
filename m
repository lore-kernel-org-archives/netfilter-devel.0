Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DAF21100
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 20:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710967538; cv=none; b=SUNXgzsmT1c9ROPXIb1CzCSHvvIAjxHw59l6GBIhmwjS1v/lKwNmYP7flxuKZ6jH2P5UMRL78xzAN2wmbXwk2BtDFi98jHDuBM6oE6zzxc9dm/gUqR8UenSdsklOiaMobPtkL7v3j9YOHFA4efOI714gSno+B/pAAWl2+HCsYmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710967538; c=relaxed/simple;
	bh=ON982NmFWUbWf7IRG0x+yaOV93u7a3CJVL+0zDufxRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/J2joWkVweQCBUSFdnbemXDP/ltKybznm2W9yXuio3j8WGpMAfa0ExRsIiY2tdJufBz4GT8fVQE0LDMUWzJdKHndWnyRQdWsOsw/MtvoR2B5h7bzqoEv8qNpx9FwTph9y0IQ6r0zS27y9NJP3PFPG4r7A+/2jsmEgpXcCMicbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PGfati5t; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PGfati5t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aZzz4ZZo+j5UXaSXTegPJeyQloESZWtID/umLecNEo4=; b=PGfati5toVqWSDqvXqH55LD+JV
	UojNFzSRcf89CKt8nF9MgD9rJEH96Xvs31cri+9K0GCuBXm+BWH8xqL7KnZuvkPz++5yRJ28XmfTV
	vxzVmVNn3nbEzBZ0gEd5GZJjRT/r2SGiLG5nTMTbA26DAZIGL4lfcLt3kTmLzH0VBkz9by2PSFAlz
	1wxmv1cBBlQwyPzlpdNDjmucpM2MIsejX6npU7qCFv8VfuMBHltZelpFlbuzpuSjA2Nwhs7HZYUz1
	bNX0bZevvHVR0vCkthIyPepyCajv1IFun0MF4Q7xvY8yVGGvoaLqD2MLL6YHB5mA1DpmFLvEvP1aV
	Zz0x8HBQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rn2oX-000000007io-3lfp;
	Wed, 20 Mar 2024 21:45:33 +0100
Date: Wed, 20 Mar 2024 21:45:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] netlink_delinearize: restore binop syntax when
 listing ruleset for flags
Message-ID: <ZftK7coQPu9teaE1@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240319110337.42486-1-pablo@netfilter.org>
 <Zfsl-JagV67u9tNG@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zfsl-JagV67u9tNG@calendula>

On Wed, Mar 20, 2024 at 07:07:52PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 19, 2024 at 12:03:37PM +0100, Pablo Neira Ayuso wrote:
> > c3d57114f119 ("parser_bison: add shortcut syntax for matching flags
> > without binary operations") provides a similar syntax to iptables using
> > a prefix representation for flag matching.
> > 
> > Restore original representation using binop when listing the ruleset.
> > The parser still accepts the prefix notation for backward compatibility.
> 
> Amended tests, which were not correctly updated and I pushed it out.
> 
> @Phil: Sorry, this clashes with your recent updates to make more
> compact representation of flags in json, you have to rebase.

No problem, thanks for the heads-up!
