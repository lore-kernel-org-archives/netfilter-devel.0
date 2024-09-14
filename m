Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006D56F066;
	Sat, 14 Sep 2024 22:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726351669; cv=none; b=nE1DWyzLt98/PovmKGEGbWy38m2c+FspQ/eKRkx+qN+FQkbueI9jnlI1iX+gau3NGoOKZM9ll00fLm8+VDnsK8CGOBlYOP6hDTky30k66zV/HlF8I+1Fc1+noPtNt46qJvFMqroye77rsuqLJg9AR4uqJ4nu+vhUMb8up2Ltm7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726351669; c=relaxed/simple;
	bh=8UYJTps9ziYwnwbXUxK+LWRqU6OAMrQVi8OKICgzcwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O+G6o6HtWGLbogBGiSMG/KsbFdITkTS68Y4ukJ6ihSPIE2TLvbjjD1iNVEudEM8NZnHLcYaz+Pk1dTLTWq83FeAYRwN9bHBeTrWfiBTA3Bv4K3b9AHx9X2SpSx00nGRARVwr2XrnDdKmJB24lRotorverv3cC4/f4tlldCzCWNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=53302 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1spavX-00CioL-9K; Sun, 15 Sep 2024 00:07:37 +0200
Date: Sun, 15 Sep 2024 00:07:34 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in
 nft_socket_cgroup_subtree_level()
Message-ID: <ZuYJJonibwaFdpab@calendula>
References: <bbc0c4e0-05cc-4f44-8797-2f4b3920a820@stanley.mountain>
 <20240914111940.GA19902@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240914111940.GA19902@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Sat, Sep 14, 2024 at 01:19:40PM +0200, Florian Westphal wrote:
> Dan Carpenter <dan.carpenter@linaro.org> wrote:
> > The cgroup_get_from_path() function never returns NULL, it returns error
> > pointers.  Update the error handling to match.
> 
> Good news, I will retire in the next few years so I don't send shit
> patches anymore.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

This is also my fault, I did not help to catch this error in any way:

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
