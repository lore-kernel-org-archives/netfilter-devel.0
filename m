Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBF019D8B4
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2024 12:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726750281; cv=none; b=Y10hRbZGPu+svqepGAtV4bKou8voryZC98YsA7HFvN4UGzQo7e/1IXA1It+yKa+bjgqmFPIYC7f6Jb9jPzYcL6XVHi3zVBHwf1X+7LdAr7b4c3ozBfFUGz9d81j2Hg6frqx+8lw60WiTPKuN3omnLZhOOPysC4Cknv4QHZXgVOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726750281; c=relaxed/simple;
	bh=+ip6B0aWabBFAWcA/DlH70cyQxbGlsl8lrWUesJijHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pEyUMNaP2C4InShOVGL1OFs790AxlyOc0dWuaXDWfVG1vjG9E2AnzLqUkyZUY2cxVcjsWcFWepEIvNUb3EysGEPvd6Oun72qosqFXO7bxOtXsoxOqGg1g15oxfmSnm+Pq13B8wDqfdPk/KZPEt+BL7TwyRv6l8YADK7ZAYNKjek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=53070 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1srGct-003MBb-3l; Thu, 19 Sep 2024 14:51:17 +0200
Date: Thu, 19 Sep 2024 14:51:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2] selftests: netfilter: Avoid hanging ipvs.sh
Message-ID: <ZuweQpi-ngVxtWRK@calendula>
References: <20240919124000.24079-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240919124000.24079-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Thu, Sep 19, 2024 at 02:40:00PM +0200, Phil Sutter wrote:
> If the client can't reach the server, the latter remains listening
> forever. Kill it after 5s of waiting.

This looks more similar to what I have seen.

I have to admit I am still learning the common idioms that are used in
selftest.

Applied, thanks.
