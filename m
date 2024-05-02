Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ED81BC58
	for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2024 23:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714691126; cv=none; b=YbRo/8w9uGNPJgEoqIrqRI7MhAsibqrOyyEDHpqWM2/Gyxr85EbjFhjWNbAWscjCMoJfBMpJwMhFP7vlHaW7IJCMSw1ABI9tCx4UMgGsBWFPB/cR3+a7QFQh5WMUPKeMA6Lr2r1tJi+vGgKcNyvFIR8+dAAg/yIc71ZL5Mcz1VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714691126; c=relaxed/simple;
	bh=Bh6nC9YjsJr3KDvKfTl+JfP7R7Z5k0hT7K4pBn86bTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IMvDvKfpYzwJ4PwGGDpMSk09Kj8XSM+qxFspnXcHELkxESu6rLpZJuNGpF2WW1aaECEBid5zb2AWFCxvDDKECf3B/cf1STkfS84RH6t4Dh8Qa6wEL9MOlyvuCO0XfImSt2tx5q1a+sava8mza3amdE13e2g8YVcfCXEbQj9Mw0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fn8XTXdO; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fn8XTXdO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FfukOnwLlx5HQ7lKE1rfaK5kDhs9Q6wr6AOrhbejijw=; b=fn8XTXdOLXpYSDnMi64HrSf3xE
	XeOyyVFkALJ8Fmor5Ujdv334AaIF5uLWv7IXv1MZqjIwQAMCW3hv85ziWDs47z96wXkYoHOnpLIcr
	tcR2e4g5wCV8LrtiPXDXaiUfZKlJU/ZjhKHgbeDDpybjwq3AP4FA54/LkTjctZRrGXA84G81ayh0h
	3vAOEAtv9/N8c45MgKdSwzwlcNesxKl9CFFWHPwXBe9f7pPkg6cqAds7wtDSwNRwBI2hyHuFOVEWh
	6ZvIorryjj1SFkzy9AfN6KarWujuIBDqS7qVyC/u5Qo26FsHu/NMXwqGb3KWOYlOIrvIGwXfuuRG3
	hSuCUw9g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s2fUJ-000000003AB-3eWw;
	Fri, 03 May 2024 01:05:15 +0200
Date: Fri, 3 May 2024 01:05:15 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnetfilter_conntrack PATCH] conntrack: bsf: Do not return -1
 on failure
Message-ID: <ZjQcK6bn1yvWdXRg@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240426144420.12208-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240426144420.12208-1-phil@nwl.cc>

On Fri, Apr 26, 2024 at 04:44:20PM +0200, Phil Sutter wrote:
> Return values of the filter add functions are used to update an array
> cursor, so sanely return 0 in error case.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
