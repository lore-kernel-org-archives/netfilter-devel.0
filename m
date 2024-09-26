Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8895672
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 15:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727363729; cv=none; b=UCUGE9IwYuVOc8JZDc7zCjTYePjfoYUTvMRWk9X6DbkHONr0XN3k0T9BeCA/mf/2IQRzqdCYRXrGhBQHuN2N4PIe3cgsTBq882H9sYv9j/HoHuza0cDaKA8V1bc1rD8BVuqw5D+s0AwWXwzigqrZGp4u3scs+XDJ4CAaSM/Vtvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727363729; c=relaxed/simple;
	bh=9cvQNaNgqiDxx41m5uNC6bUrwiXHfntt1OSmnL135No=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=brwU4hJMBOqsWjHSW/jZW9xWA4ZPgPPpuvXDjW5l15dQp5gsfeTcXRauzifMmjs/URE7e7OPqRZ3f1wJ8uTmy1KDU28HDRiZN9OKxc9ywfYjaOq5XIEDkmI34xjbfvRLX9GNde+sFRq/UnHvRACelQWWEiyIrGQKB+tj5tz+r9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=34710 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1stqDC-001gef-5b; Thu, 26 Sep 2024 17:15:24 +0200
Date: Thu, 26 Sep 2024 17:15:21 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
Message-ID: <ZvV6iR90zjrW5os0@calendula>
References: <20240925180120.4759-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240925180120.4759-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Wed, Sep 25, 2024 at 08:01:20PM +0200, Phil Sutter wrote:
> Fix the comment which incorrectly defines it as NLA_U32.

Applied, thanks
