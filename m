Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6055984D13
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 11:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718795008; cv=none; b=GxKcrY+qOxlmOVEOM8re/pB4merRiQeT9roHBCjxxcqUXUXB3fuYoIHgR6o62/nbJcgLze+mLvSDpL2CjfuaedMxThOsh4o1PiMocy+ZBmplIBx0nXVfsaQDCLqLQr32ykVMs7KE/38doarG64Jlms84lM5+k/MZ31FjypxsPsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718795008; c=relaxed/simple;
	bh=EkhqZ16MTxnVMp532/QYd+Liz08N0pl/QhR4gmIAj2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGOPKIu+3nfLvyo5vBvGcednw8vipzKpWzYg0lvisBHKQ8388LCR3ap+Al5zrs8yGsTiqFFQP8NwPyDWPpa0EpRRiGp3KPdZTHyigTUCV0a2gFxP5EYHT+8UFBF4DHV81WbOzLxEADYQtpOQAwY0zrDZMONihoK39Ut8b0cyUWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=57760 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sJt5y-00EvpJ-19; Wed, 19 Jun 2024 13:03:20 +0200
Date: Wed, 19 Jun 2024 13:03:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: pda Pfeil Daniel <pda@keba.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] conntrackd: helpers/rpc: Don't add expectation table
 entry for portmap port
Message-ID: <ZnK6821kYBYzqRZZ@calendula>
References: <DUZPR07MB9841A3D8BEF10EB04F33636BCD172@DUZPR07MB9841.eurprd07.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DUZPR07MB9841A3D8BEF10EB04F33636BCD172@DUZPR07MB9841.eurprd07.prod.outlook.com>
X-Spam-Score: -1.9 (-)

On Thu, Apr 25, 2024 at 12:13:11PM +0000, pda Pfeil Daniel wrote:
> After an RPC call to portmap using the portmap program number (100000),
> subsequent RPC calls are not handled correctly by connection tracking.
> This results in client connections to ports specified in RPC replies
> failing to operate.

Applied, thanks
