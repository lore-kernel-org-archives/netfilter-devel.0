Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F0F18CC1F
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 10:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724150325; cv=none; b=E6oMMrkSN+O0EHmWgWSinnbjuh7eBIRnp5Ej9Yplq+N2Qzj7hYq8oVH0SSpI7KkJmoYq+Ujgq2eqTQDSyL8DjDdWazzbhpXfvHRqS/XfwUj6sTi8nCy1fNIZ7WvFqT6AQbB5x6/A3NE6x3uvgO+HZuz3TcpNgoMNWA46EL7/cv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724150325; c=relaxed/simple;
	bh=7Rz5+XU79Lw5HGV1WS/VbJtTdhQPx6bKEoDfygtmybg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iFbL+eseA7B+leDhH+UoyWemr5roqoe9PacbO5z0jR2lu4ZL7qkEsQJ0QVHSPuDQufOVjL4BWFrnsPuc7y0wOTGf+bLHJyG6oojPz5QnODmmgmrn7JyX9+2dS7+WS19dANkf7x6PmWOJH1AMxXDwTlH2r+nz0L7gGp8Bs6EuzvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48988 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sgMG6-006i84-7z; Tue, 20 Aug 2024 12:38:40 +0200
Date: Tue, 20 Aug 2024 12:38:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: nf_tables: reject loads from
Message-ID: <ZsRyLRCRLTbG07LX@calendula>
References: <20240820095619.6273-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240820095619.6273-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Tue, Aug 20, 2024 at 11:56:11AM +0200, Florian Westphal wrote:
> Reject rules where a load occurs from a register that has not seen a store
> early in the same rule.
> 
> At the moment this is allowed, interpreter has to memset() the registers
> to avoid  leaking stack information to userspace.
> 
> Detect and reject this from transaction phase instead.

Applied to nf-next, thanks
