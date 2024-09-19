Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699CB1D540
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2024 12:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726747376; cv=none; b=hMfIWiD93mw33iiQs4J0rORuHGTUAxVKSecdUzi+eYWXeWFgle/WPoyeaJqgXuci4yTPyAUal7SGhwGN0KKNCN2kGCwK/e3jUGobUhVqonuvlELMhQ+gu4SSTIKMr1fANaA74BuynGCKeDlZvGk/rUIAlvtCVjvv+DxSpP8wpwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726747376; c=relaxed/simple;
	bh=/R4651gb/hNRViHE9aP3E16nf+C1dzfgO7SmLLyeVJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uFuDJJhZFhrOrzQggWl4X3PVDbFwFFiirOb99MVsS36pDasl2tPgv7j5FeZOKdyt2s5LSGkwLe2+sTioYkBvOdCq4DvUMNgZNigl9g0hRjAZE8dhpL76HebiOUl+VA51xN5Ui7piZe9PNhisUvkS1QvA4HnvC3+XJp07A5ae4zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=53740 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1srFs0-003Ilu-Va; Thu, 19 Sep 2024 14:02:50 +0200
Date: Thu, 19 Sep 2024 14:02:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] selftests: netfilter: Avoid hanging ipvs.sh
Message-ID: <ZuwS6KD5ObBEaNY6@calendula>
References: <20240919104356.20298-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240919104356.20298-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Thu, Sep 19, 2024 at 12:43:56PM +0200, Phil Sutter wrote:
> If the client can't reach the server, the latter remains listening
> forever. Kill it after 3s of waiting.

Applied to nf.git, thanks
