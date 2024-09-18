Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06724188A07;
	Wed, 18 Sep 2024 11:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726658020; cv=none; b=U4gychSMgwIQVCO4weB4BCuW/5/4pQrhkee/De5zHXogvYDM1q2+6hm4MLco33BOgZZKT93nBAsge0WN2lIal76dfltmLERkGqSZUplgJXuPZTGaJF6N/do/liVrXtm/b8QrLl3alRODLFs5XwViHWMBT6SGl/Bm6K0OjU2Og5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726658020; c=relaxed/simple;
	bh=C1xZ4FanfkuTbNx0464dR570gk0nKR3LFi1tRGMyDGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kbi4JURaw3gIZzyVilZhni+N7HLaotCMmdO0x4sYZVsXh/9QvU5tJyDZjVEPkoY+UhNbKDMV/nCKWhyX3qMdttRuXTkTCrW4sMT565E1MQJuXE/vEoXB82cGXhXmA1kStFJF3ti0o/MC3IXZKPw1jgW72vKRAOGlLtBdInvQxao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=40992 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sqsck-001KJt-K5; Wed, 18 Sep 2024 13:13:32 +0200
Date: Wed, 18 Sep 2024 13:13:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Breno Leitao <leitao@debian.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, rbc@meta.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY
 selectable
Message-ID: <Zuq12avxPonafdvv@calendula>
References: <20240909084620.3155679-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240909084620.3155679-1-leitao@debian.org>
X-Spam-Score: -1.8 (-)

On Mon, Sep 09, 2024 at 01:46:17AM -0700, Breno Leitao wrote:
> These two patches make IP_NF_IPTABLES_LEGACY and IP6_NF_IPTABLES_LEGACY
> Kconfigs user selectable, avoiding creating an extra dependency by
> enabling some other config that would select IP{6}_NF_IPTABLES_LEGACY.

This needs a v6. There is also:

BRIDGE_NF_EBTABLES_LEGACY

We have more copy and paste in the bridge.

Would you submit a single patch covering this too?
