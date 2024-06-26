Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21C21591EE;
	Wed, 26 Jun 2024 11:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719401597; cv=none; b=TbIfKNlgFJfx3dkqVu1DTORRqNFAoBUfWHkrCVeAd5lK9zC1kRVxNqWoLJ3YKvuYeUpAdIXMj3UW9SEFgHUyiUmgWa8su7JIAX7fewVmpGlhpgP7tiAe0AC8mDC9kpaalFtJl5bViC6GI07i2lnu22RgO20zDMOiNEi5ixJahuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719401597; c=relaxed/simple;
	bh=sFGGqDcFBJDUr8zcEep9dWtWU5BsEtXW7deZwW+dgJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/54c59MaicUx2AqFEksmnEB4bmU3r7WSyjwHIjlbfFB2S/iEw7NG3M7eyDkmFdO32hEcLmvc50/CQ+ntKMtGcT31l2O4XJ1QI/SNjrCjKRCRAXSkwVrSYE3d/kLLgEpIGU70nyjEgfAI96zplGvMGuOB4eFJY5V12dsQthawgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=41570 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sMQtf-007sDU-8X; Wed, 26 Jun 2024 13:33:09 +0200
Date: Wed, 26 Jun 2024 13:33:06 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lin Ma <linma@zju.edu.cn>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1] netfilter: cttimeout: remove 'l3num' attr
 check
Message-ID: <Znv8cgJbTW6eqtik@calendula>
References: <20240531012847.2390529-1-linma@zju.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240531012847.2390529-1-linma@zju.edu.cn>
X-Spam-Score: -1.9 (-)

On Fri, May 31, 2024 at 09:28:47AM +0800, Lin Ma wrote:
> After commit dd2934a95701 ("netfilter: conntrack: remove l3->l4 mapping
> information"), the attribute of type `CTA_TIMEOUT_L3PROTO` is not used
> any more in function cttimeout_default_set.
> 
> However, the previous commit ea9cf2a55a7b ("netfilter: cttimeout: remove
> set but not used variable 'l3num'") forgot to remove the attribute
> present check when removing the related variable.
> 
> This commit removes that check to ensure consistency.

Applied to nf-next, thanks
