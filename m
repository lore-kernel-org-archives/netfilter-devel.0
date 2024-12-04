Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CB71B4157
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Dec 2024 14:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733323218; cv=none; b=CUZ18I+j+kIiZUXopFjHpJkG/ec/LmKEEfIpQv0hJNLX6eEbYmugLMdTZZS60HMMM1bu3K3b4CxcuE7Ay0TglLwIWspVfdvqAjXNJsoE1WFHS3KNuyKHfGVQTnTXkMB3tgmph+nc30vtWmwE7nkNTKqx8cLuchldf2S/OiWpvR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733323218; c=relaxed/simple;
	bh=kA6/vDj0v80jgoZ4uAMMfLMjjjJQJJxlgtsZqawgSbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6wE/fRk4ypVmVmUm12cfeaOulmVYUR1WWnYK5+xrGekUUYCAMeMw6I7ZdE28CqS4Lgln4qzWnl0t4bFNSj0s76KWhLvLufw1N60z4Mog4RRaZLvbpe6H4XbbUCB8zJJpYAhw8SpVccP5bLDlCEhHTSwUq8RDHuo6gMKl6Wow20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=41894 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tIqXx-009BTr-Pa; Wed, 04 Dec 2024 15:40:12 +0100
Date: Wed, 4 Dec 2024 15:40:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] ipset: core: Hold module reference while requesting a
 module
Message-ID: <Z1BpyKOvjuODOEnP@calendula>
References: <20241129153038.9436-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241129153038.9436-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Fri, Nov 29, 2024 at 04:30:38PM +0100, Phil Sutter wrote:
> User space may unload ip_set.ko while it is itself requesting a set type
> backend module, leading to a kernel crash. The race condition may be
> provoked by inserting an mdelay() right after the nfnl_unlock()
> call.

Applied, thanks
