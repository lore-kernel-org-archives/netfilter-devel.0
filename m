Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B964172BCE;
	Mon, 19 Aug 2024 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724084919; cv=none; b=W33rJPB6HCVOty0q3Us1lep0V5UvjryJxZ3a3457gq8GHY7BnOQPl/a8Yx5P5p8jKZytjJnhYG4Br6p83hDWQe0bkryMj70n5xeDprFSjjL1PYXVRCWo/54/Qf0LWRlPYY9Clfay71I2r8ki4S5pCrdvr4GUr+9yg0kgkFczzck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724084919; c=relaxed/simple;
	bh=KYYQvY0gMnNpUWFsz5ATlASlLCWU/6XNOcg3yzCPTkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abDFV+/0uprKxPkgkqYCe9YMcLNdWIv4QBNCOog3TJV8pj2tJg9V83ij4ZVG4llonr9MUoEFXnNEraoWjgyTwg48mXu7GlOrr50uSRSUzkeWJWFBdfvNfa47+2/Df6IbmPDVD+6UxPFZdbOS7FClNCSlw8r2ggOCNSwBhtPwlKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=57848 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sg5F8-005ZJq-VL; Mon, 19 Aug 2024 18:28:32 +0200
Date: Mon, 19 Aug 2024 18:28:30 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	network dev <netdev@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, davem@davemloft.net,
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>, Pravin B Shelar <pshelar@ovn.org>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH nf-next] netfilter: move nf_ct_netns_get out of
 nf_conncount_init
Message-ID: <ZsNyrrtYRxO1EgaU@calendula>
References: <7380c37e2d58a93164b7f2212c90cd23f9d910f8.1721268584.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7380c37e2d58a93164b7f2212c90cd23f9d910f8.1721268584.git.lucien.xin@gmail.com>
X-Spam-Score: -1.8 (-)

On Wed, Jul 17, 2024 at 10:09:44PM -0400, Xin Long wrote:
> This patch is to move nf_ct_netns_get() out of nf_conncount_init()
> and let the consumers of nf_conncount decide if they want to turn
> on netfilter conntrack.
> 
> It makes nf_conncount more flexible to be used in other places and
> avoids netfilter conntrack turned on when using it in openvswitch
> conntrack.

Applied nf-next, thanks
