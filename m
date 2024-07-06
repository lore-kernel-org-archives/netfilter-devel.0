Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE1E28F0;
	Sat,  6 Jul 2024 17:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720285499; cv=none; b=ISOItmxlBdyKv4urbDkJ2/ntH2jmo8C3ZYeDih8WavaSaKcSyQCX1PkcqAIPVPmreji7lGby8bXutOV7Qi5OLRYI2VpqkzNALJgwlUiZ9zAuJe7occd+4XHFeeUdGnsxddqU1w3PcFOjl3QvVrLgoxVwtk4/mjF2uyXpGcrfWFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720285499; c=relaxed/simple;
	bh=tSXKmsPv+GpC3DWA8iCt2AuIh4ctCnpFh4lXAzCRhMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTxoY9e0RmGHHmLsWmZXDKBbrReTIu6J0xidy//juEZIWoiJztVx/Qzy99NheNaAlfy4AMzoBHIowtH1pU4ABWxHgu709qW4b3tIvQx0RFqaYnYjx0cI0J76pVpvfn/vR3x2nrbcu4f+aZCUdizuNF+FcteE1pK9w7F4/eL0MbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sQ8pt-00022J-0Z; Sat, 06 Jul 2024 19:04:33 +0200
Date: Sat, 6 Jul 2024 19:04:32 +0200
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>, yyxRoy <yyxroy22@gmail.com>,
	pablo@netfilter.org, gregkh@linuxfoundation.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, yyxRoy <979093444@qq.com>
Subject: Re: [PATCH] netfilter: conntrack: tcp: do not lower timeout to CLOSE
 for in-window RSTs
Message-ID: <20240706170432.GA7766@breakpoint.cc>
References: <20240705040013.29860-1-979093444@qq.com>
 <20240705094333.GB30758@breakpoint.cc>
 <1173262c-a471-683f-9e00-abc8192c9ca8@blackhole.kfki.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173262c-a471-683f-9e00-abc8192c9ca8@blackhole.kfki.hu>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> I fully agree with Florian: conntrack plays the role of a middle box and 
> cannot absolutely know the right seq/ack numbers of the client/server 
> sides. Add NAT on top of that and there are a couple of ways to attack a 
> given traffic. I don't see a way by which the checkings/parameters could 
> be tightened without blocking real traffic.

I forgot about TCP timestamps, which we do not track at the moment.

But then there is a slight caveat: if one side exits, RST won't
carry timestamp option, so even keeping track of timestamps will help
:-(
