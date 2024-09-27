Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C65E157E91
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Sep 2024 11:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727438257; cv=none; b=iEihyeKe1dIyvCQHJOLzTBfh1LHISuef1itxhhngAE1hAJswoD8kfmfKYIKN8f/M5/suNohZFDsldhW8X7e1KOdmhF6hzPORBRzr/w1MAFRHoTQPAL5vM9fVxJLBodSKDE/DE+qeEXl+m8abnmIKl1i69IfCwWNHgg/U+Ofgmn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727438257; c=relaxed/simple;
	bh=zczYp7kkRVXXN0PJlFg1A+QtXcHz8Tk5TK8WgA4tfFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mRXu0BxGbPqdKfx565sDqZ+Tnpu2wCj0cw1yy2I3IEj1Mbe28fJOa7sbmhACPRj82MUkMtzhHIpD4m2/I/XJhmVhc6wsBCOvRWqn56T1/l6QfVlux/X7lCvIRFokwemTYiy0KJrKbmkODZTKzxIVvXpyi04BB5CmGl4OUxFgIqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=40644 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1su9bE-002vqa-6x; Fri, 27 Sep 2024 13:57:30 +0200
Date: Fri, 27 Sep 2024 13:57:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] selftests: netfilter: Fix nft_audit.sh for newer nft
 binaries
Message-ID: <ZvadpqJbJgLJ4Sd7@calendula>
References: <20240926165631.28107-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240926165631.28107-1-phil@nwl.cc>
X-Spam-Score: -1.8 (-)

On Thu, Sep 26, 2024 at 06:56:31PM +0200, Phil Sutter wrote:
> As a side-effect of nftables' commit dbff26bfba833 ("cache: consolidate
> reset command"), audit logs changed when more objects were reset than
> fit into a single netlink message.
> 
> Since the objects' distribution in netlink messages is not relevant,
> implement a summarizing function which combines repeated audit logs into
> a single one with summed up 'entries=' value.

Thanks for adjusting this, this is now in nf.git
