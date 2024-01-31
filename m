Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9FC12BF0E
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jan 2024 17:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706720544; cv=none; b=I5lcqA35s4mVMvQzIvryCgSD2N4UzdPrVQ+BIWQv6LcxbcVItwCNt967TnlkJk93Ys8v92EFkaRp4PfO/d+s1hlJ50q8MAJm7DeifTsG8ow0Vs56xhrSWGFabm2DOWvWn4K7qsa/COWD6UYNNeJphMtx4fYJEDvvCaZr2jYYhBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706720544; c=relaxed/simple;
	bh=0EjKDtpNghb8Nr3ijSJttYTadUBUMyunwy+f9nWJGbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ADq/TDhUjCU5XEmWkBaoVsKl82kggpD4aFoYK/pdYEAwLQEaIdB9Ey4cVeyEACJKm6rUz/ufDqqlBZopNmyFbMvi4skRbXRAHY79erj4GgRqxgjMSCCVHHfBEXqbh/oazDl9PTpoUZpqw/yflvh+VmRAQvLZSFkLcSi7IpWh24Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=C/qXhUlB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="C/qXhUlB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=p9a1efk2BLGs8uf6+yuVx4QnUX3PjzZtG074Xpw+n3w=; b=C/qXhUlBYaTHfzj4iWto7Abuu8
	HSYWBIvexQDnCLmy/DdrRqjbDhB9Ktjcr6ySMRqx5uMylYw6+RM4LauqIep4bjLjXA3dmqazuj5JW
	tIAJXrw7HBfKUFgPqvqqEuaJpcteo+n8aqMy3cJ/qhUgvruEGJQjn60PMtQUSzWMvHDPCXeaRaWsa
	usJBaIIogStwYcoU7GlNLdB8TCh2kqnwXlrgp7qRTs5HXKxY8PGu/bQ/eIFuB3A4EHCuT7JilXAAg
	xRwLXyHtKIo4ua8qOl4Nyh/p/FtJhj997u9m08CZrR5QeLI7nnEPIW5x4DAR+MPVij9WiP3U+0jRB
	V6Q2wmqA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVDye-0000000005n-2HsW;
	Wed, 31 Jan 2024 18:02:20 +0100
Date: Wed, 31 Jan 2024 18:02:20 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] json: Support sets' auto-merge option
Message-ID: <Zbp9HHYkbqNXqALm@orbyte.nwl.cc>
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

Patch applied after adding the missing nfbz link.
