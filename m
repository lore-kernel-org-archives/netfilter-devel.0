Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE74149DFD
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 22:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707344964; cv=none; b=i/CUaOjcyTj83eXNu5t8jZ0FkUgb1YJzUz4GUNTeFo9jkcJTzeEgqoqHBJqYiYL8I+FRm99SsoRvz+spvWG6RKVHxNn23mLmwC2IdNKddWdScKdkqzpMtK8C5fZZgmtzZkOJ1e2X3BmqpbBZr1vQtx9aoLWfBWjcF5me2+2VgVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707344964; c=relaxed/simple;
	bh=2JqAeZn+dGfO9l+tt/i6wyC27jD0Ph66RH71+VGXv7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nuVN2KyJxS75NlmHw7udH8JJoZkdF7QJ9iegsZkCJUQ/d5T1q56gy5S0CgIu99cHwSQ1016f/P4R6tDoX6q7Ia5AjSGtyu7KBQE26yJNynmSPPrUaMVuKK9WB5r1HBSs9vBR2Su6tmbvWALY1f14V86STi+OmyNiTpJqOwwrRtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=54296 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rXqPn-009NIr-2x; Wed, 07 Feb 2024 23:29:13 +0100
Date: Wed, 7 Feb 2024 23:29:09 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Kyle Swenson <kyle.swenson@est.tech>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"fw@strlen.de" <fw@strlen.de>
Subject: Re: [RFC PATCH v2 1/1] netfilter: nat: restore default DNAT behavior
Message-ID: <ZcQENZu3gcCb6AKC@calendula>
References: <20240129211227.815253-1-kyle.swenson@est.tech>
 <20240129211227.815253-2-kyle.swenson@est.tech>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240129211227.815253-2-kyle.swenson@est.tech>
X-Spam-Score: -1.9 (-)

On Mon, Jan 29, 2024 at 09:12:54PM +0000, Kyle Swenson wrote:
> When a DNAT rule is configured via iptables with different port ranges,
> 
> iptables -t nat -A PREROUTING -p tcp -d 10.0.0.2 -m tcp --dport 32000:32010
> -j DNAT --to-destination 192.168.0.10:21000-21010
> 
> we seem to be DNATing to some random port on the LAN side. While this is
> expected if --random is passed to the iptables command, it is not
> expected without passing --random.  The expected behavior (and the
> observed behavior in v4.4) is the traffic will be DNAT'd to
> 192.168.0.10:21000 unless there is a tuple collision with that
> destination.  In that case, we expect the traffic to be instead DNAT'd
> to 192.168.0.10:21001, so on so forth until the end of the range.
> 
> This patch is a naive attempt to restore the behavior seen in v4.4.  I'm
> hopeful folks will point out problems and regressions this could cause
> elsewhere, since I've little experience in the net tree.

Would you post this without RFC tag and add provide a Fixes: tag.

Thanks.
