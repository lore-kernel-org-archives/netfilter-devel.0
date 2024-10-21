Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33D01E3DD5;
	Mon, 21 Oct 2024 09:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729504622; cv=none; b=MnRZd3sKh80TD0Po09eWNy3d6W8CRVvJ3g/vs6GL7cuw4F+pgLBAaFO2hEGvdjYGszB2Wb1sUYzXwohxOh9ia8ghw5LYRQ3IGPWUj7C+qf9b3XZJkxnYurXkk2qeZEItZMfKOYiwnVLWwJuFGNQVLkfAZCq7Y6XlaQBD5hK75Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729504622; c=relaxed/simple;
	bh=WApnRZSRYctn0BYrd8y444R3i2EGibb+k3MCB64f7cc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OaHu+6vFPL+xYmvbzSThZExSdNICxMqNLhQFLndLoUL9tZMaPjSLqrexWAdzjbhDIBQsi50xCPKAZdS3tRloI10EhIE/jbUMnb8LBqtTH+9WbCgojEc2eEnTYZeYiHAsNwF12fMZHxSxMjPke5Png+A58kjkIxEsFHAeiN/F1KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=47138 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t2p9c-009qLe-UA; Mon, 21 Oct 2024 11:56:50 +0200
Date: Mon, 21 Oct 2024 11:56:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net 0/2] Netfilter fixes for net (v2)
Message-ID: <ZxYlX1XW43OhdrPg@calendula>
References: <20241021094536.81487-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241021094536.81487-1-pablo@netfilter.org>
X-Spam-Score: -1.7 (-)

Apologies for incomplete cover letter sentence, see below.

On Mon, Oct 21, 2024 at 11:45:34AM +0200, Pablo Neira Ayuso wrote:
[...]
> Hi,
> 
> This patchset contains Netfilter fixes for net:
> 
> 1) syzkaller managed to triger UaF due to missing reference on netns in
>    bpf infrastructure, from Florian Westphal.
> 
> 2) Fix incorrect conversion from NFPROTO_UNSPEC to NFPROTO_{IPV4,IPV6}
>    in the following xtables targets: MARK and NFLOG. Moreover, add
>    missing
            ^
     missing THIS_MODULE reference to TRACE target.
