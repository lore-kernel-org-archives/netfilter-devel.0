Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864DE1AD279;
	Tue,  3 Sep 2024 08:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725353005; cv=none; b=DIw2CiCWL4DOW03uaI/uxgOrgMctHGXtebcjYz3WmTcfEohJSNsxvI0i/6wX8zzxcisBU+GdmZg8SqxCZxAqqgFHW9cpsE/inVzcJTZ+wIgoPnPCzInVZX/eoMK2zs034yi24rdVMu6bwEfTkFK1zYmoyusnTiKUQihV7TCULYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725353005; c=relaxed/simple;
	bh=Xuy2HUNfgRNuCD4ox3iGoJmQhmA2/OC/svb6UmB9IE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tjGea+qCwwfhH2UNCkq3eq0QCWM2uvnUqO5lO4AtAiYlB9prra7xJ69+P34MzWiuUW+HEvVk3icd6rqE9ZJtzazpmxvNmpnmg0sUlfzavt1maFUG3Yg6b15ZNLQuyQI5cuIfE6wi2Tp7dt2pq4tAdk9wamXSQanoEtkNLMG8W2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=55560 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1slP88-00AF0Y-MU; Tue, 03 Sep 2024 10:43:18 +0200
Date: Tue, 3 Sep 2024 10:43:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Shen Lichuan <shenlichuan@vivo.com>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Subject: Re: [PATCH v1] netfilter: conntrack: Convert to use ERR_CAST()
Message-ID: <ZtbMI8I55GUb12im@calendula>
References: <20240828110651.56431-1-shenlichuan@vivo.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240828110651.56431-1-shenlichuan@vivo.com>
X-Spam-Score: -1.9 (-)

On Wed, Aug 28, 2024 at 07:06:51PM +0800, Shen Lichuan wrote:
> Use the ERR_CAST macro to clearly indicate that this is a pointer 
> to an error value and that a type conversion was performed.

Applied, thanks
