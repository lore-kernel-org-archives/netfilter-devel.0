Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AEB1D6C6C
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 08:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724230098; cv=none; b=mXPeZlv9H46Jc7J+rT+VHRnzaVkNNpVl2g/MQo1H/OIidJ+MAq678TZeazFfbRDnKJIdRZfAX6mRFY5iQrSLzQTH3ihTR1ofxiLvUuEFSIOA1QF8qAYVRIpOC1O1KKyqvG2syKhNV3HKjkOS5HN54XvE92yDk2qQp2JxkQJJzkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724230098; c=relaxed/simple;
	bh=GGidKl5g9ecKCHn0XgCHAXRp8NNl6rortN5249wqClY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFCRD7TAFrJx3RZ1qnXRO+YvHxJ97GhwLwAnE6dICJFGTK+H3QeIu8uqYY1+UKVqXX1ioBU7GxX8U/BYiWXMnO/0jks4mtlzojW+B4CWUwcqihmLz01KPyHNMDHsaKbMQ2ByIU3hNuSln/kjhIucyX4E7IyLP2g3Z3HDkxcHGTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56976 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sgh0j-0081Cu-Tz; Wed, 21 Aug 2024 10:48:11 +0200
Date: Wed, 21 Aug 2024 10:48:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/2 nft] mnl: query netdevices for in/egress hooks
Message-ID: <ZsWpyDFdYzUzUf7w@calendula>
References: <20240820221230.7014-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240820221230.7014-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Wed, Aug 21, 2024 at 12:12:25AM +0200, Florian Westphal wrote:
> This patchset adds a new iterator helper that allows to query
> the existing interface cache.
> 
> Then it extends 'list hooks' to automatically query all active
> interface for netdev hooks.
> 
> This is done for 'list hooks' and 'list hooks netdev'.
> If a device name is given, only that device is queried.

series LGTM, thanks Florian
