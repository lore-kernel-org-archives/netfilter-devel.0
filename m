Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AC61632DD
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Jan 2026 12:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768567152; cv=none; b=VHllHEvP6FYEYhpEU0LdcSkuHmyACed/1mWMzWb+KYWg3JlfSUv81Nx13GmM2DQuvHcxGMeomQREnMa9uIg6tfksnOG41F1zj91sXEj/TgZ13CElf+2HS71q2YcEHtu2voJ/HjbnLugBkY1MjFb7EnuHe9AxGF9DC/m8jBSmQLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768567152; c=relaxed/simple;
	bh=dzR2UVJ20uwn3WbZjKz5bpMCkY7E+Yi26RGmMhdrKKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l9ROJVEGQJ+DfPtDOVpO5XcF3J6WPJgg/ObR2yjCp7vdPsALk4tFZOQe+QBwDetbiM5iv5SyZXrp3Tx9ynp4aEfygyLXAcwyxJpNQOXkXYYeSuqgDcEYt2IN3lr8ngeDkDhccyuTGJhlzricrdlWdyCiTveMkUVWTBWUx9QomFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qlJAtmIG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qlJAtmIG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dzR2UVJ20uwn3WbZjKz5bpMCkY7E+Yi26RGmMhdrKKE=; b=qlJAtmIGvSqF6SPdc3P06Wtsk9
	bptMbKKvAAYUlAhXSme5Y/7HzjqQi+xlFsv4yaIAV1bYinyVw2nJ2T2vBeSC8P6l4coHZ5FRSON8L
	RenRU/wQ8C/IYw/F9v+Doy+h2yxQXbPdM3q9+wL08jqeUDHoIEFASCYA7+GCXNM2nC8P0EmWMB+O7
	EvQVGCcelS5gT8uf2LN6cn7RKqo/fTE0kPki4Gf2M4snTAJNNZ7LD8hvYJIMEQL/SZ9YXH8n3NBb8
	Eg5p5VNhlvPNGoXJuhJh/CcQLCtpcH13XOybi5P0Ych+XVE2Qnx0vIKyZCsiQRCGyilB2HoS4z9po
	59UgXpXw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vgj6T-000000000aR-23jh;
	Fri, 16 Jan 2026 13:39:01 +0100
Date: Fri, 16 Jan 2026 13:39:01 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4] parser_json: support handle for rule
 positioning without breaking other objects
Message-ID: <aWoxZQc-h93Y_xyN@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251113203041.419595-1-knecht.alexandre@gmail.com>
 <aRcnt9F7N5WiV-zi@orbyte.nwl.cc>
 <aRcwa_ZsBrvKFEci@strlen.de>
 <aWe16oO_R-GwM_Af@orbyte.nwl.cc>
 <CAHAB8WzKr9rehUKWSZAPWZq_3QnLGbh2Py88WXpV9sE3_V3MZw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHAB8WzKr9rehUKWSZAPWZq_3QnLGbh2Py88WXpV9sE3_V3MZw@mail.gmail.com>

Hi Alexandre,

On Thu, Jan 15, 2026 at 09:23:22PM +0100, Alexandre Knecht wrote:
> I'm deeply sorry for the delay, had a loss in my family, plus a
> truckload of tasks to achieve at the end of year at work, I have the
> patch nearly ready, need to review and retest it and I should push it
> this weekend during my spare time.

My condolences. Just take your time, there are more important things in
life than software (hardware e.g. ;). I merely wanted to check with you
that next steps are clear. If you wish, I can also take over from here
on but you sound like you don't want to hand it over yet. :)

Cheers, Phil
