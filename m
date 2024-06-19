Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E208775817
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 11:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718795294; cv=none; b=XbTVSPQAOY4AzTBy+eQWP7m+ix/i4EBj3wOtf0CXb2Wrz73TSDXT0Rwff/RBf4BYDyuiSdDL/YOJM/sWAR2s+FPZm0x5WFUK/kdMzLUqNyY9Qsq3tBMG5MZE2QMvZc3BfM8XqHLS5wp/6BIUOrY1YRSMNAPNgUKNjBVVOvLweKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718795294; c=relaxed/simple;
	bh=acU2pY/d4T23B18vyuUOaTG5JmhaIDibcJU4wcnW4fw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=smgsaeMA7UmQTp3gKfqCSjyvvkH3N/36cjT6B7uOELs93A15i6fAI0oca4LQXbzd1fF6rMqCrvfkKDT1uGhH4oA7WlkRMWisjKrZRl23N0sAOHYS1jO76Vi9IJG5eP7agydOWEBbF9s1s5Xz1MR5n66AYEeeqQRqOThcLtOyZqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=37988 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sJtAd-00Ew2s-9r; Wed, 19 Jun 2024 13:08:09 +0200
Date: Wed, 19 Jun 2024 13:08:06 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: pda Pfeil Daniel <pda@keba.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] conntrackd: helpers/rpc: Don't add expectation table
 entry for portmap port
Message-ID: <ZnK8Fj52_8cIgKp9@calendula>
References: <DUZPR07MB9841A3D8BEF10EB04F33636BCD172@DUZPR07MB9841.eurprd07.prod.outlook.com>
 <ZnK6821kYBYzqRZZ@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZnK6821kYBYzqRZZ@calendula>
X-Spam-Score: -1.9 (-)

On Wed, Jun 19, 2024 at 01:03:20PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 25, 2024 at 12:13:11PM +0000, pda Pfeil Daniel wrote:
> > After an RPC call to portmap using the portmap program number (100000),
> > subsequent RPC calls are not handled correctly by connection tracking.
> > This results in client connections to ports specified in RPC replies
> > failing to operate.
> 
> Applied, thanks

Wait, program 100000 usually runs on the portmapper port
(tcp,udp/111), which is the one where you install the helper to add
expectations:

   100000    2   tcp    111  portmapper
   100000    2   udp    111  portmapper

How is this working?
