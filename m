Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792762001;
	b=vfD0jY6M/Lm43ZszRwSbNDMZPJFHRH84XwSoS5bOD8aE0CHSUWxhGZtp7nbdea3G4gdR
	 TLX6EkFQMv0Qe1XnNugkLC219O8I4Qp/MntW6ROjM6EzfnELdCQkLEwXo+W35URRjhiOg
	 BbbXA9NTHvm4hyMB862dLMh2ML1oXDEgwtq5QLUSuWlTNXmpLQCAezUNO/8bLs6i5BENI
	 fYe/sUtFscFili+mUMffrdYRrnF3aWH9FEGB5FwE3sO5uhsXGt+GDr5O/9BImtWe9bBLv
	 gRLHfNQ7aekHYnQpNaGMqTzFRLs5aNzN4xVO2sXYh31Pwhy/bJYCM33bVKUiWMbjtqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792762001;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WtRNiZLJCnraYg9H3m1/2nQfOsSShWLJuMiWhF+0Dpk=;
	b=RNI9O50ZXqS6MChHAZuE79Ygc9DHHmN3Bw25GlN78Vr8O4vHca19OzC4iSZIZCkwCroX
	 TkuZf5do8LRe894BGklulvMBtGoBirXiD0+PEDDU1bYSF/iOCUe24sDnoOS/bNgC4A9Ke
	 vdYWQonA2dgQGONdYMHIaprpHCXvO4MjIkWYUjRt1768A+0LF6163bysDoQqqrAMVpXYR
	 TMKxTeYGbaK9EjVTO0Cu5tLekdyeszSQsdZELACYgGJ2RrQ1gWAg8ZNxTCBOE3Wj0lmNi
	 10J9Iyb50O4o5Kyoz6wSu9KBD1FEKG7WCLnEVkT2pNpPPh80kfVGmur7G6fUFHK0FcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=MnALm25J;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEF0606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 13:26:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BEF0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=MnALm25J
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WtRNiZLJCnraYg9H3m1/2nQfOsSShWLJuMiWhF+0Dpk=; b=MnALm25JFV0epIGw9lUc5oDxPS
	BGV6ujtD7oDRgPfLExbFmi9i4z7ou+SvJ8svaUoaUVEOtiOnO7p4Y+ap4SCwpf4LhH8J/Ce51X+Qa
	jj34XsM/ASlf174DykTXmc2q53xBSdj1ZXdVo5RmIAk6B3FaaLKY+T9T+k4FLZwCeqhZS91/x/suR
	JDkUrd++cSvtATRj/CZg8ThsPpEkmvpcqE/U2y/R7ArgWMSMYSU7OvCyD6BA8l09q13meB4aFdBqp
	ZB1Mzpsq4rChSpGHpZkpkjegCI6Be2RHJYKkd3LwgWEbS36uZ09OEi03nuKQh+QpK4bCfTCtWSaAu
	WpWhpiTg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xKFI6-000000002iK-22Cm
	for netfilter-devel@vger.kernel.org;
	Fri, 23 Oct 2026 15:26:38 +0200
Date: Fri, 23 Oct 2026 15:26:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix for spurious fail in
 maps/typeof_maps_add_delete
Message-ID: <attgjloxT80PCoq0@orbyte.nwl.cc>
References: <20261023103603.1048380-1-phil@nwl.cc>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023103603.1048380-1-phil@nwl.cc>

On Fri, Oct 23, 2026 at 12:36:03PM +0200, Phil Sutter wrote:
> Testing on a (probably slow) aarch64 machine yielded dump failure since
> ruleset listing had '# count 1' appended to map size statement. The 3s
> delay supposedly wasn't long enough for the element to be reapped after
> disabling.
> 
> The test itself seems to perform all desired ruleset checks though, so
> just drop the stored dumps to avoid this problem.
> 
> Fixes: a8260c056a69a ("tests: add dynmap datapath add/delete test case")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
