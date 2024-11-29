Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDED45BEC
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Nov 2024 16:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732897623; cv=none; b=dCgIdw8JERbnXn9ZicsdNx15DAkZx6z2iOoIz/fBUjqynrEK2Ymfmou5jSntiWlptee28OpoHc++Ism7HLAR92u5oYhPDqJr9U+GObfSuFN64cBlptn/gOBn+dW/W+PrLVd8NFICZE7pwYH0rxXsSGa/5nP4oWgDraUOQoEzrW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732897623; c=relaxed/simple;
	bh=g+IIXjxTCSAbALXPbJOz/oDRVPvHzJCZ/iZrH4aIOjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SsV6fHDRzq2JD1j3ywOoGoLkmHfP7C85cBmn2BZv7XiIP0SExjPIQnKtNQOu9WJBntC0uzucL7ZxWkNpwfnFzRYTozP+par4g5q7KFGYJck7kyqsRB7MPfDBKuZPZ4gHIRDAP+xtTulCqpykIfRRbsnNI3RO+L/vKVySJLUvTyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ebUfrXKd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ebUfrXKd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hMm96giuTsDvZSARR8TranKP1k5WK+KqD1yfi0wCYx8=; b=ebUfrXKdOwolqhnA0oInA6ZL8f
	F0g4NNstPk3SphOnlw6nkmx5pdwSLKtvU+TZhObqkHV5p8zT88p48VMjkE2nYgVEYIO35xEBvdtKB
	mEufTZU45yh0CPtCtZurTa3QHm8Aq2gYVAGzmCA8aAPtrzC0peTLu2/DQyD/FFNwlYC9qfsD9ntmZ
	aqfDUJ2RsCbxNU4u7KhZcCjidyt8YXlJvY5yGkIWEyhwlKqKRmrr8n8V4NZboePHcBxYMGyrI2Ro1
	saOD7vkVNzgzW+GEp7ZZiTy9rdqoa+/js5nag7c5My/LywXhlHIcp2y+O2I20CqDFW/5mG8j8+sSg
	9qSK/3SQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tH3pb-000000002id-15gr;
	Fri, 29 Nov 2024 17:26:59 +0100
Date: Fri, 29 Nov 2024 17:26:59 +0100
From: Phil Sutter <phil@nwl.cc>
To: Donald Yandt <donald.yandt@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] mnl: fix basehook comparison
Message-ID: <Z0nrU1Hrq51AAvpO@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Donald Yandt <donald.yandt@gmail.com>,
	netfilter-devel@vger.kernel.org
References: <20241122220449.63682-1-donald.yandt@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241122220449.63682-1-donald.yandt@gmail.com>

On Fri, Nov 22, 2024 at 05:04:49PM -0500, Donald Yandt wrote:
> When comparing two hooks, if both device names are null,
> the comparison should return true, as they are considered equal.
> 
> Signed-off-by: Donald Yandt <donald.yandt@gmail.com>

Patch applied, thanks!
