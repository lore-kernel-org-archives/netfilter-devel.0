Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4B533B6CB
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 12:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786623170; cv=none; b=PVCX6DBOv9b8R83mGOprN5VAhGs1tMzlV/DoIDG6DKNcVjKqq22tpVCrpV5Rk8zhUN08KsOZaZ8YcS/GK7TWKV1U1z+uFSCY9k2MBPG1P1ioDX6RKYEBsnYbt77rcjd6P7IsPZs2koo3QBv7qdPD0aCcojejcwit3GAGXrYTLiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786623170; c=relaxed/simple;
	bh=pJiH90pC6G852CxScH90Z5oQ6waqX/vt+hwOQD+qx/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rtnpLgopvcR/SyyA3xuOKXcObzSBgknurlv1LRKDkWsEhZ1o9MwOnHgd+PeDENfWtKkx/hG4PWD1issl6e079kU/gnqGfcFY6fiy/pWAALbSDFLscEMU7xL4XJxYA09/7npdhQFPL3xB0Awl4wTew25iLie8rq6xlE5mUR9y598=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=AASTSI8q; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="AASTSI8q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BqYAjnuyOeFoU9PnJ5hjyw+PKpjd5h8rK8sETmVUIJU=; b=AASTSI8q9WSrBTXvXI3cR08CYH
	12v0kb0MiDqwDbJiV/vCCYYmX6mbpa1uoinmE0XolTi7oseP6m/g83jehl7WgTBKNgWOloWq6m16o
	R1XYblqnOmo2jhBIU61QSuyYMKav0MHR8eCqxgYCbEmpeOZyaZNI6knJa0S8HCX26fqVFkhlE1DE9
	pLtQhm9+uQUUslE7E/DRyB30zsDoxHqyL4On6MpK7Gbcl/NpM4ba3qkDWBIMv9cwc6HFFngzGJ1Uo
	XX80dHJATKmUVRVfnGOZTc51OJEIGv565AYqsnwlgUKpT3oKnK88VIndWbnYxhtVyWr7P+VgSywlX
	5i7qWSAg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wuUIg-000000004E5-1lqN;
	Thu, 13 Aug 2026 14:12:46 +0200
Date: Thu, 13 Aug 2026 14:12:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Avinash Duduskar <avinash.duduskar@gmail.com>
Subject: Re: [nft PATCH 0/2] tests: shell: Keep dumps with numeric protocol
 values
Message-ID: <an20vo1H68LVrCw_@orbyte.nwl.cc>
References: <20260813114556.2685869-1-phil@nwl.cc>
 <an2x1tOQN99iCI8L@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an2x1tOQN99iCI8L@chamomile>

Hi Pablo,

On Thu, Aug 13, 2026 at 02:00:22PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 13, 2026 at 01:45:54PM +0200, Phil Sutter wrote:
> > Adjust the test wrapper to create dumps with --numeric-protocol option
> > (patch 1) and update all dumps (patch 2).
> 
> Is this to make it consistent through different distros due to
> different definitions in /etc/services?

Yes, but it's about /etc/protocols. See Avinash's attempt at eliminating
an actual problem there (and my response to it):

https://lore.kernel.org/netfilter-devel/20260808013327.2766739-1-avinash.duduskar@gmail.com/

Thanks, Phil
