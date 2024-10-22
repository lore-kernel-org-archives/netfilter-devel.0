Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD12C140E38
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2024 11:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729596134; cv=none; b=drWAMvGxLT7qEVSsoK6Wv7nQbP6hNgpf6oPGhbdizCpnRQAqjMRD0JURiCMWd4fURYQkhWhuQVP9aL+tMWPfABeoCGwsM5XAkuWbETKua/vmcJG6KKq2dtZLDtk8Ue7UoJV1sMsnAMVC2P6ZwzHb/9OAGvPD1iWaInYTeHRHVak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729596134; c=relaxed/simple;
	bh=rZTPhZf43arJdj4S9a1/rAgYmLiFz7MwApIAjYWGGJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gnzozP3MMbz0MCL+xQxOcWZSO0LOFMXpmgxCPu8ABGmOKCGvV7I5u89iW301H7FVu+OkblX1T9WSu9wTQTB8cSd5tAT/ytcGzXwGNTeyBrTnlC6Z/5fRwwf6AQWpIj0vvHUHVHJ0HvkAZCHV5YV09zKfvMfJrTMirZ4Oe21/OBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=IZUMCHVy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="IZUMCHVy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/O8QybhE1SoGofL/+PAI/lNgdRwH/diUGKaW+AIrDQs=; b=IZUMCHVystL4nZ66qSjtMIO4XU
	w7MqQq4f/ZPwW1eS8dYQLQy6ARkCYUNnnJG9rayHe23BkYDRqOAvKCxgWsWP+l4SJqD7JI72Xcl+0
	LTSdOk1NwAO+tHo2Z3vTkrPlfFy9F5fJhZDmaPH8927m6ABMzW8eMmswJWf26BfrgDLANIHWzVkqU
	r/Sh6NKDx8or/BCWxEjypAjJApWMoSEUiVMEFmXQ2sKVt1mnYuf6eN3F7LwAmEzhbsCbgFnmUZtwT
	jySgmkUtLNXkM0T9PZk/j/1xTfF5NQ+DEEwMxIUfQG39Qg8rr6nhF0T1kiCT4mZH2VE3qJIgl/2ll
	Xp2P2u6A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3Cxf-000000005Cf-17u6;
	Tue, 22 Oct 2024 13:22:03 +0200
Date: Tue, 22 Oct 2024 13:22:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v5 00/18] Dynamic hook interface binding
Message-ID: <ZxeK2yu1NYyIAczQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20240926095643.8801-1-phil@nwl.cc>
 <20241021130544.GA15761@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021130544.GA15761@breakpoint.cc>

Hi Florian,

On Mon, Oct 21, 2024 at 03:05:44PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> 
> I started to review this, I would suggest to apply the first 10 patches
> for the next net-next PR so that its exposed to wider audience.

Maybe worth noting that patches 7, 8 and 9 are rather pointless if not
followed up by the remaining ones. Patch 10 OTOH may apply to HEAD by
itself.

Should I prepare a series with just patches 1-6 and 10 for nf-next?

Thanks, Phil
