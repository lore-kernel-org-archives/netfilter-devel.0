Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1B018BB89
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 18:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725387452; cv=none; b=DHUpoLEjedYFkqN6tL9uN3ZNcWSN0PMtAALczBG2tkzLk3pLjKQUbedF/Z84ASn/oBmFD2v3xUueVuay+7jqZdx9MZIXs6PGI8V9nD5wjU4o0Op/57zXj3i1z/UjeTgTjqgQelIByMmRjOu/hSHGWSlBmh8HjF3OLjDlAeD6pRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725387452; c=relaxed/simple;
	bh=ijb0Q4HLtra9/ut0jBLoUSKmEpj8Mss/D1slD8s//wQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPn7UmsMVM9oiAC7lwnKMIRgNb/MjcVC7AQNdRpRqyWGoY3P4SIUwXRaI5JxtY/JrJd4dh02JYF+szhul3j+rWwdzVIQ1a2CqZ1NQyPzlZI7W08xxAE9QfAYuRk0wy2BJ4evWegkkkeSa9FP646CsrobsmTQSVP+mbqYJ7Lmsic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=34038 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1slY5j-00Aqr4-Nl; Tue, 03 Sep 2024 20:17:26 +0200
Date: Tue, 3 Sep 2024 20:17:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Priyankar Jain <priyankar.jain@nutanix.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_conntrack v2] conntrack: Add zone filtering
 for conntrack events
Message-ID: <ZtdSsqyBosrzK5Gp@calendula>
References: <20240830090530.99134-1-priyankar.jain@nutanix.com>
 <PH0PR02MB7496D619D1674886AC17798083932@PH0PR02MB7496.namprd02.prod.outlook.com>
 <341f4134-73ec-4860-8c93-ee1e1f4b03d2@nutanix.com>
 <Ztc0gFBjvbMB2IJP@calendula>
 <PH0PR02MB7496E90FEB4D337192D7680B83932@PH0PR02MB7496.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <PH0PR02MB7496E90FEB4D337192D7680B83932@PH0PR02MB7496.namprd02.prod.outlook.com>
X-Spam-Score: -1.9 (-)

On Tue, Sep 03, 2024 at 04:26:05PM +0000, Priyankar Jain wrote:
> Thanks a lot. Do we also have a upcoming release for this library to be available for consumption?

I plan to schedule releases once kernel 6.11 comes out.
