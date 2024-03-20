Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19622628D
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 11:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710935603; cv=none; b=Lq7mwDKk1DEftYMXA5MAU7y6IOXQUxJwZcp9wpjAhn+8+OrlIp5KopNqhO2RFz+XS9Phy1m0uJPX+nXa7rUaT3uGL2q4p/nZk/gNiSWAka3sEg8bbnyWY0L04v0Zp0GmgJbrQFpWcoxZh3oA/J377fh4fYEVVvsYDQsgLmbW2Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710935603; c=relaxed/simple;
	bh=8kfyF1aZVLAXxNtd8hDuxWBfOS2VWFn25Gj7fvcfRx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mN4x7RlY+Nc/cX0l2SA6jCKRzurkgXcf1Aqq0pzPWxpZvgeZ2nBriN3vi/YAMwBCFaRP/Iir4oR4Q+rhlY8utCwfQI+mhnw+/36UD90oiYOe9Cykii+LyEUNMBCfI9X6K2dwamWxWubjyofUxsClZpqCpLGCbX2Idl36SoN3nvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Jc+bvg9r; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Jc+bvg9r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8kfyF1aZVLAXxNtd8hDuxWBfOS2VWFn25Gj7fvcfRx0=; b=Jc+bvg9rhzE3SEqf0vOrTveyyv
	gAXhcx9hZBcWZcDHgxTKcTwMhdndY7+qFExxYc1ojMM1D4iR7o/WK23V2P/15BuXu2GbdHtD+sNLH
	RWN6+eRd0bL/LM6ti/tUliIdZJCuCWW8L2lpso9NMeZ3KV/TlPiqlp23zgRRCyMaiehb/1u/aqAGV
	f271Np7h4i1mroKLOA0illtF3eNDmXbGl4Mwh5D/r8x3e6zo2RzfhT1jNa4TAcUPdKW8tNsiHhVgt
	a1gOKvUiz/+JDOK1GFhHamuE5UU3ICgSLIR02l+Zvp8O1vCCeyOtuSOKn9L18GsioAyJDFqswxSCz
	eSrarzUw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmuVS-000000001m1-00W0;
	Wed, 20 Mar 2024 12:53:18 +0100
Date: Wed, 20 Mar 2024 12:53:17 +0100
From: Phil Sutter <phil@nwl.cc>
To: Sriram Rajagopalan <bglsriram@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] iptables: Fixed the issue with combining the payload in
 case of invert filter for tcp src and dst ports
Message-ID: <ZfrOLXWorg9QwFVn@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Sriram Rajagopalan <bglsriram@gmail.com>,
	netfilter-devel@vger.kernel.org
References: <CAPtndGC29Zc6K8V3v4LStfrcnvdCNNfTmjP-Ma9dM+21f1069w@mail.gmail.com>
 <ZfnAGWIgPfiS5i9G@orbyte.nwl.cc>
 <CAPtndGD29xG1koLq68BBuQricfg1FWh2QideLydphZ-OUsL0=w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPtndGD29xG1koLq68BBuQricfg1FWh2QideLydphZ-OUsL0=w@mail.gmail.com>

On Wed, Mar 20, 2024 at 06:14:54AM +0530, Sriram Rajagopalan wrote:
> Thanks a lot.

You're welcome! Just please check your mailer, ideally use
'git send-email' to avoid such problems in future.

Cheers, Phil
