Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446FD1E878
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jan 2024 16:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706719465; cv=none; b=fmMLBQjhZ2XyvQuSy0gBp4LlZCeaLUsv1v2zlK4cy1Qd2BR0ZcNYsq5Nz+rzqeu7gaXEWGut1rURKLqjY1Y+RZKO5hu9UNhRH9X1KW1MhrjiiWdYrmzysJgkqvP41bmA4C6CBgXVH3LJIUhqL1gXq/GnjCYCKqq96JaBg3lVz5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706719465; c=relaxed/simple;
	bh=gmTB5yi6GgBf71GMfZKKIyha0VGA6ZKaigL76n9WkWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nhk9AIkXD+kaKn7bQPAtC/NgGVZ1kAgPUMPKfZjO8QFmFXzKOnXWzhnMKrlHcjRrQ/TZaXU7N6S7OE/VWYq2QNFAVy4e2rj8phA1nUKBt8mh+e1YPSZZ41rpC9sr6r89GLRJiHU5U3VAO35xbKQa+VFL2nopTuRA8oZL25NNdq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=K2C2ni47; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="K2C2ni47"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AX2D2NixJaBoQPdmsjCcPIUTKwSBfQAYOypOFPjoVL8=; b=K2C2ni47ADxgReAIShVcOTS2zj
	YYjGAeGZ4l/jVDNpGCHzQxESB5XNaxPwBBheYGTGKLkRMf7FIeqz1+C+p0MMsKiDKt0+Y9NXk0QnD
	zpIMzJslfmAq/4xaViJS00g1Gq/gaOfya+xqxFRkN+w2+BX4jlv5yA7SfpU7IOqmgdx9MZgYfCICi
	xLlYeMqyaBMNzWm5cxG/S8l2EDM7BE989iEiyxRaJ+PwhnAHkWMLGn0LsV3krlBclfDhM/fVFDoVo
	/lBz2H0z5ldjuq2/Z681K7H2nn7tsKeJNhbcb52g9juyjdXPHicu3EBQz6DVVZnoCEOGOMphNUO34
	B4pJUdvg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVDhF-000000008Bi-1n50;
	Wed, 31 Jan 2024 17:44:21 +0100
Date: Wed, 31 Jan 2024 17:44:21 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] json: Support sets' auto-merge option
Message-ID: <Zbp45egHf4vNATqM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240131164120.5208-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240131164120.5208-1-phil@nwl.cc>

On Wed, Jan 31, 2024 at 05:41:20PM +0100, Phil Sutter wrote:
> If enabled, list the option as additional attribute with boolean value.
> 
> Fixes: e70354f53e9f6 ("libnftables: Implement JSON output support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1734

