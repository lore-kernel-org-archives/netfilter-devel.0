Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3459265CBD
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 21:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745442575; cv=none; b=NqFbNz4fiFPPJ0u22Y+EOBZxTt0dkS2nQJrQIJcogiXT7oGHcoes7KHGWuQcC0aaTc2AXvnFiaMeFTd9TzUj5MFbXGtMzBVHVCoJE3hh032HyTYQTX7wkiINiPaaIMMDihGizPFuLbaBLwVoaKxAW+DwCuLFSL98Ee+CrLr9mek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745442575; c=relaxed/simple;
	bh=jCDRIDdFBJvIPLb+uAuu2KhahngES1miDAt1O1qPk+0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nxxsaAVGenmUoYEAUF2Rnf01X8hz7ln4jYl6BNfG2hbwr91oWTc8uvLOQi8uxBzU+QrHNy/xQlEdHdmdrz0kHBqpF6iuibxPhmrjaFbUnxLIPEp6ViA1/Q9Wzw5KmMbGuTR+ZsXwAMVTuCRpX7TsRdvRf1wus09GGjl4aLsgQz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dhnm6BtD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dhnm6BtD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Rnx1VamXsOuhRlTV0dl3QhkW9okJuyfZSyXKD68YSew=; b=dhnm6BtDUEgywATQYiawXok316
	QcKzUYZGGWpF3e2xggzhHYr0zdLgHSjHGxgXyeqIRL2qn4Uq1UPPpcTDc9Q7rG676sBhm+HInNoDW
	n3q8m7FMKI6hVSCJELs2lUZchJXShCZ05/T/5dHAyWP+1k7xwjFQ5PNnRnDVN38Ri+o+Bjvj/0Bn3
	kCiqonDL3LsBNbTAl4/fKdDTfv4GsnHHeH0Mi0KsmPy8/dHG7GJpWu6WaHleKle/BEEJA0U3Jou61
	4WJtsBVIYL/B1vi+FDlGYFvi2f1iqR4PH9oNn0GyjLUp1+8lFNJWrrO/8LNMIi4UpYy2ftIRpqIIY
	D67Hw82A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u7hLW-000000007bB-1byx
	for netfilter-devel@vger.kernel.org;
	Wed, 23 Apr 2025 23:09:30 +0200
Date: Wed, 23 Apr 2025 23:09:30 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] extensions: icmp: Support info-request/-reply
 type names
Message-ID: <aAlXCkfKsd0f1D1i@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20250328163908.31678-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328163908.31678-1-phil@nwl.cc>

On Fri, Mar 28, 2025 at 05:39:08PM +0100, Phil Sutter wrote:
> The intended side-effect here is that iptables-translate will accept
> them too. In nftables, the names are supported since basically day 1.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
