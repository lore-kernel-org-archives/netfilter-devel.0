Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50EB5646E
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2024 11:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709898305; cv=none; b=QZakAmcqweU9oM46UO8He4EMWGJ+UN/fYYucxKbETngXR1nAjV0+XDm/VA4mCJ8psRiSjYIvzfn4iaEwBUht8jf8oBkGj9IaOisRSe4JPIBULVECSp0MayMr290PhB2zuqWbkZ/RpUp3EXJ3Hh/+Gn0TOs6eYub31TL2GGEPhak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709898305; c=relaxed/simple;
	bh=P92q2lrHjhTi3Jah/dDT5uWddYUNOtSkzbRSH17NbwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jjsd6LmmqHvItpnXEUZrR7Rx33vLPQsiMOcDgkHOIUHpoYM57GFwA7c8PxmTvHHkV0Ds1WpMCONt/plmqXPR+f1wiL/nBq7M2kyqTjKtAlDGcx035yeEFXczTYapdoT9edpDQDaa1Ec5GBEfkYqVNU1mFWOLVkLHxF7lEOiCeIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EMc8hX81; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EMc8hX81"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FL1wt8EzEe5VGyuotaGABpcz+TUV6sHKCNovj/uOTvA=; b=EMc8hX811WnuIXl6gH/3N2RIOU
	0ZGxesJ8D7CkbObpxtqXp/tCsqJvh7gGBNuXZuG5jcAmYn7B+kdcr4S+2CCgFuQS7OhFLl1ozuESx
	L93sSnVOhAcHJWz4dyEQj/cMvWh+0R5yRG5OH3+4IgjEdoononR6N7TfKtlgz7ug7GZ0aSdgC++dP
	40Ua2liIb/tjBD+yU4twOON6YnxJBlXa2sdzxFalBcI8m9Dhxk++6lzXSAaSBndojYF2ZIpVms62n
	lWYzxxr8oN83DZrCLz3G9/70Z0Z7LZ1Rlo4ZtY+e5W7w7ZTPB6tQljL/EMUFDYk+lskUaPhyu3k40
	KKFEwfGg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riYeq-000000002Bt-2mrP;
	Fri, 08 Mar 2024 12:45:00 +0100
Date: Fri, 8 Mar 2024 12:45:00 +0100
From: Phil Sutter <phil@nwl.cc>
To: Neels Hofmeyr <nhofmeyr@sysmocom.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [RFC nftables PATCH]: fix a2x: ERROR: missing --destination-dir:
 ./doc
Message-ID: <Zer6PPF7baeTqT9-@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Neels Hofmeyr <nhofmeyr@sysmocom.de>,
	netfilter-devel@vger.kernel.org
References: <ZepTs5Rj0bXqQvSo@my.box>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZepTs5Rj0bXqQvSo@my.box>

On Fri, Mar 08, 2024 at 12:54:27AM +0100, Neels Hofmeyr wrote:
> Since recently, I'm getting this build error from nftables, quite definitely
> because I am building in a separate directory, and not in the source tree
> itself.
> 
> 	  GEN      doc/nft.8
> 	  GEN      doc/libnftables-json.5
> 	  GEN      doc/libnftables.3
> 	a2x: ERROR: missing --destination-dir: ./doc
> 
> 	make[2]: *** [Makefile:1922: doc/nft.8] Error 1
> 
> May I suggest attached patch.

Patch applied after adding "Makefile:" prefix and your SoB.

Thanks, Phil
