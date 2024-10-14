Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08DF1514EE
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2024 09:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728896661; cv=none; b=f/0Go58HEHJUJgbPLR6ott1q3SqdHgEBE9qyttZoc0NzHXKfPJXxn+flFm9jP4iedBL4TrWaqjvUPwIaZuwKhLnpNL4BacxPtwjC6FHqhLqn1pzzAxmNEv5yPiSJG70skLcuRCsENKN/MueV8XUMDDsIpKUiG+ftKP0blXeWE6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728896661; c=relaxed/simple;
	bh=2jOU330usuvww3RWS1MlyiTgcU1v+A0ukWOWJeQP3SE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lPiIr1m6gPXoLM8HA0W01NCV11m4tJ3mwHoF++EQeg8GK2DfFLzD0tIXJuYOZvvSZzYo+/mZHqTtvfJS0uPqj6wHqsO3A7FsxXWNTS1LzLF+jZIiBa1RnPYy7nH/l5Jc3YYC7Hr+ilvIbLwKndI2H/uOTaoB0H7Qvdfc18QfFTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZC66j30n; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZC66j30n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=H5mZpfsMLcSo1Qhzem5Zmj92TG/1spKP6xDJ+VBIJfM=; b=ZC66j30n795YOaXy66sMMUkgmh
	qcFplu2h+ZRbAZJ96AgkLwbQT7h3tbcNt8GvExHqdrFz8unmQ4mg+X06+eObpiHVgnmyzHnkWKpCM
	IEa2YiLeDYuQg1OM7RnUboCqahfRzmereini5qEYH5iOJmSdAAlqIgBTaeIZbjhGyWdGxSHqMPEPh
	J1Cw39kRbbp8OnsS5J9lrbnsczfwTZyJZlDz7Qr2wpmQb3Ozg6I3oCeFu4+n72336X71Bhl6BAWVu
	/bXFsU8oqEp7Lga7LsrjZp6xlAqSgEmTZWFBWoP9q/ANXmXDxMXj1LreaGST+emIVOdM1Mr0cIdCr
	E9rKP6HA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t0Gzq-0000000065a-1ZNi;
	Mon, 14 Oct 2024 11:04:10 +0200
Date: Mon, 14 Oct 2024 11:04:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl,v2] build: do not build documentation automatically
Message-ID: <ZwzeijvlkY3LYuJT@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241013194118.3608-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241013194118.3608-1-pablo@netfilter.org>

On Sun, Oct 13, 2024 at 09:41:18PM +0200, Pablo Neira Ayuso wrote:
> Make it optional. After this update it is still possible to build the
> documentation via:
> 
> 	./configure --with-doxygen=yes
> 
> if ./configure finds doxygen. Update README to include this information.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Phil Sutter <phil@nwl.cc>
