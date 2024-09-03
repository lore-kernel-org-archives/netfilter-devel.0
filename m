Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B284188598
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 16:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725379723; cv=none; b=bYgQN+wCR348h8TukPzMi5UB9d6jpp/qMUdbrClSthgt6uRFeTAIsrAbRShEwDiWcK8/LqdF58BwiW7H/S9Mbz9t8p3PMpothb+ZfOVAEH7Xypi1J5ub5m9GHQbZOQ1S/nVm03rqod0egSW7/ZOHOGgI98pUyQ2d2eBovEyyh6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725379723; c=relaxed/simple;
	bh=FzUzHCOjYT+rsl+FJMaj9qgQeRoP/DyEAct48ZXP8RM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QdPTepsNmOql7b+0j3Thc1Tw8jgmB3UMpLpGGmKVsX+2u1NvRxKqpgdqk5aE6XXQj0SpAwAQ4L2sk75/VWdka+f8lF2dLOrIURO3JhDXEaidz3suhXLHZWmDr+0XyrBCZMBmSpSkrNp56IVONgjvWaSAhis9s9dQy68j7MRv60I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=39260 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1slW53-00AiAH-JQ; Tue, 03 Sep 2024 18:08:35 +0200
Date: Tue, 3 Sep 2024 18:08:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Priyankar Jain <priyankar.jain@nutanix.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_conntrack v2] conntrack: Add zone filtering
 for conntrack events
Message-ID: <Ztc0gFBjvbMB2IJP@calendula>
References: <20240830090530.99134-1-priyankar.jain@nutanix.com>
 <PH0PR02MB7496D619D1674886AC17798083932@PH0PR02MB7496.namprd02.prod.outlook.com>
 <341f4134-73ec-4860-8c93-ee1e1f4b03d2@nutanix.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <341f4134-73ec-4860-8c93-ee1e1f4b03d2@nutanix.com>
X-Spam-Score: -1.9 (-)

On Tue, Sep 03, 2024 at 09:37:33PM +0530, Priyankar Jain wrote:
> Hi,
> 
> Ping for review.

Applied, thanks
