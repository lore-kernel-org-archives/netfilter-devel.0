Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB7412B157;
	Mon, 26 Feb 2024 15:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708961477; cv=none; b=Fb4IVUSlRg1g3kPOK51BPYnYOxidaA8cpxjF6cjjnnc/fw/MZkqKSyUVzLDpUCRBG3b0P1Z0coJ3fLOfHBQa7UUm5XbZWigdsZXXCFytaL5kHDTA4+Q22uZGKugqitjowTm9ZxRHpjymwIpWSsxRw1tz4cPeEn829blBceUGW2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708961477; c=relaxed/simple;
	bh=Fi2I6JWdoxNsLOZPWDvOCoChddUq4ZOZqj4K5cnTqfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lBiPrmVzXl8vmygHIat2cg0ke/Gfyp4dHFz0WjKWKUMxuuKsK1P+K/ObxMhb0BhVZ0ye1oq36CORpsYRCECcCTWCbS3i00K0Ffv+ujZrvGmwX7h2ApmK2RGSpNIWGd18aS0xIcJL9TsVkVGOu8yhY4j+b/UDnhv0NEdM450MRyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=40758 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1recwZ-001VQn-BZ; Mon, 26 Feb 2024 16:31:05 +0100
Date: Mon, 26 Feb 2024 16:31:01 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH net] netlink: validate length of NLA_{BE16,BE32} types
Message-ID: <Zdyutaij0JRDY8g1@calendula>
References: <20240225225845.45555-1-pablo@netfilter.org>
 <20240226071806.50c45890@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240226071806.50c45890@kernel.org>
X-Spam-Score: -1.9 (-)

On Mon, Feb 26, 2024 at 07:18:06AM -0800, Jakub Kicinski wrote:
> On Sun, 25 Feb 2024 23:58:45 +0100 Pablo Neira Ayuso wrote:
> > Fixes: ecaf75ffd5f5 ("netlink: introduce bigendian integer types")
> > Reported-by: syzbot+3f497b07aa3baf2fb4d0@syzkaller.appspotmail.com
> > Reported-by: xingwei lee <xrivendell7@gmail.com>
> 
> Florian already fixes it, commit 9a0d18853c28 ("netlink: add nla be16/32
> types to minlen array") in net.

Indeed, he told me, I overlook this fix, thanks.
