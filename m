Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC93642AB3
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 20:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728764407; cv=none; b=dqQk6J6NJBJQQeauaocOIufOPh1Ld6PiUyEkRRYZ9IDFldcnRr5yiqT9Dz2twpVnVSQGOr0KEkpmTK9JI0k5sC4bSX/Zmd3g7y+0biUE69KKwThDSsrQrUFc9TRKMbt/NvZKWT+rQMWf+f5gR+GTwCaFsr1zMCE4BP9nmdnPV5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728764407; c=relaxed/simple;
	bh=uYUE88S+GNMp+LEd4oADkO0eIzBUOkm5QFu9Hl9omQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eN9eF9hEt/Tzb3/7WpBhnDKHy2BMk5jQuzDmfcSNOccaSD5Dg4IPM2VMUKojL+KVxd6Ld5spQbxSxESGRWs14y2gkkvf4V4kjb5+GHAv9D0PBaV29hZ4ZJS/yQZsgeRl92KX2t0iF61Rv3eRkJzfz3YfuB5IwTA/UBDmA4Kr0d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PdiKWh7H; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PdiKWh7H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8NT2IQaQc0WfD3oXFWbpdCquNp3aDwOXfTLDQUlasJo=; b=PdiKWh7HdQAln11ngyIYamCreC
	iVZgkbS+z0aiTCzAa3wrYK7fmQFpsGB9T+yTOXnHjyBSgDEt/WlX7Rp8WzrOSXldwWDlRlhLp4CzH
	CdSSj6QdwBc4fY6a2b1dCM1wBZ84cnG/NjcYym2D9FLZsLTiJfBAlmtVQjWAYKY3e/VrLb5W6k891
	eT4QHDbKd9rEvx1BDso+GebCRxpQKFy3FOtFK1aP1KLyaw1sK/YYvG7vbefjYfeMqnWYR0Up/jWTf
	ULg9XsTgnmEPWXQH0OeeraoAdjvHPXo/PmiCnJoZPmor/8TJrYQvElncQu+EnujT3q+MYaoYnItH2
	9WizAujA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sziBg-0000000020u-2phF;
	Sat, 12 Oct 2024 21:54:04 +0200
Date: Sat, 12 Oct 2024 21:54:04 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl] build: do not build documentation automatically
Message-ID: <ZwrT3JOmxLigw9gC@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241012171521.33453-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241012171521.33453-1-pablo@netfilter.org>

Hi Pablo,

On Sat, Oct 12, 2024 at 07:15:21PM +0200, Pablo Neira Ayuso wrote:
> Make it option, after this update it is still possible to build the
> documentation on demand via:
> 
>  cd doxygen
>  make

This is rather unelegant in an autotools-project. You probably did
consider setting 'with_doxygen=no' in configure.ac line 48, why did you
choose this way?

Cheers, Phil
