Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0BE1A3026
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2024 16:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725295278; cv=none; b=kaEq20kJD/LLKzPgPRkc//6RMPgjoLdjXcI5Xqel30EB0J8JBzY53yc20Xu1gTcQ+RlIBpVqS+RZ/6J/wBFWTM373YDI0zAfyS9aHhDwC50fLFdO3sFjMRdxN1QBeh1elYZMpXMQhLJpAvaaEpyQvztEoEcJnuiPZdyjGFarc3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725295278; c=relaxed/simple;
	bh=buiA11RXDC/dNafgPiKoI8qCSzyQp3IizPaigA6bdd0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lT1lwMLaqaOuAX99Mv+QeQ3a24xMRaWRDfBpnXoLaBznMVqnQRcxyJzybGNUtJfHguOIuGbqNF+uRw+cofBy331uFfA5cbAiRB1fLDCDF5uS045HS3yExE4AUed9Itn8w0SqdN5th3nwOQ796GEA/t1keVLpKDUBMV9JATQfLXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=41848 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1slA72-009HkY-Ly
	for netfilter-devel@vger.kernel.org; Mon, 02 Sep 2024 18:41:10 +0200
Date: Mon, 2 Sep 2024 18:41:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: extend coverage for meta l4proto
 netdev/egress matching
Message-ID: <ZtXqo5NSP8_Wfpb_@calendula>
References: <20240826190242.176214-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240826190242.176214-1-pablo@netfilter.org>
X-Spam-Score: -1.9 (-)

On Mon, Aug 26, 2024 at 09:02:42PM +0200, Pablo Neira Ayuso wrote:
> Extend coverage to match on small UDP packets from netdev/egress.
> 
> While at it, cover bridge/input and bridge/output hooks too.

Pushed out this.
