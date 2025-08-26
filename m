Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0872A2F60D5
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 21:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756242477; cv=none; b=n1M9cu4aash0gn4vP/LKPnezajoPbbh4UNX8y7mBf33JD5xwLacIkfSOGo5ZeFjbiwskFYCWZgsZTy9hnjmoIewojEYmyaGDlpEEsVUEgaGifo67ChQ5eK0r1gx7PvgfO/EM7PQVxS1Uh8NNoaVVui7M/3xZWmKwxr3Q0ZeyMsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756242477; c=relaxed/simple;
	bh=OD1vgJ1leWk/A2+XjcpJobmgDkQ05eH4kljDyjTpxvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxOHzyCq3oR0uBmSQuXI35a2bGtvWl9wwKhpGIe0p7v27PSrAzqxBYJts1r96LtZXHs/UlgpEGqZpWBrOqJkS9UukQ7KbeN2ZGBXD07ASk7aQVjNu/EHPZKbF+cDUN881mK+o69M7kcwOl+2x179LOGQXagwRmkplE8HLgjxn2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gbRdds1g; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gbRdds1g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uv4+CgXwoIm2uXDn4TdRn7QNQKXbO2CP+kXot2RXMkA=; b=gbRdds1gHT2IB9jxZlay+lY+bm
	hglV/l7YRbmZw9FDeu5XgyaKmexl8UDKvcuO4briF95bvQhRIm/rliy07pDUKrE2zjDvDS3UefFU5
	a54n+0/QRKofLfi+MBjBVL0erTJaRlybAXwvwBovwNZxbJtDSoyUYPOaHFkSIRodKx1PeYvOK2Wxs
	eqVZVVZ5vVaFq/BvThMvw0upz0HGmRWPhmE0fbfca1fQt9uOcuz06xY0iJxBu4CJUnawdX6BQOu9u
	fPGAR8Bu0zt+DGnc1RNZe7WP6+flsJOJhEjgZSkKnYl0wbNukiKWFXWsXUf9Lx4W52A4UpfjeElJs
	l1ui5sdw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ur0tU-000000008NI-37Wa;
	Tue, 26 Aug 2025 23:07:52 +0200
Date: Tue, 26 Aug 2025 23:07:52 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] Makefile: Fix for 'make distcheck'
Message-ID: <aK4iKKoikzRgiTJq@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250826170643.3362-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826170643.3362-1-phil@nwl.cc>

On Tue, Aug 26, 2025 at 07:06:43PM +0200, Phil Sutter wrote:
> Make sure the files in tools/ are added to the tarball and that the
> created nftables.service file is removed upon 'make clean'.
> 
> Fixes: c4b17cf830510 ("tools: add a systemd unit for static rulesets")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
