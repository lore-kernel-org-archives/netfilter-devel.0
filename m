Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E7237147
	for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 16:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716482744; cv=none; b=R4UMCaAleyIH6c+fmgDX+nA7DxWqo5+b7GKfWHR8bA+dGR9L4BP1aOVUWEKV+qm2GECBugfcrp3yC+SXqDY1gmPFWNG+2PQU89BJS/2IwZRYUIdkRPL5JxAZmqeHfx6SX3vjvQlKiL2LZe4UsxxjOy+Mx8ZjkAY1m9+x5JlvUbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716482744; c=relaxed/simple;
	bh=IM3zxHBTFatLoUXmdXOvtEIofKolIN4pStuB65QxbNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y1N77GjlM/1D4xqB4tN6MWSnjLqPD6XCEWMN/1kM9FDE0zonYCG9VLJp9UwEEFXPmw/pdBUsHVOQCMawYxsA3OyqlC61FykfAnMEunhe2Jqh5cQ6jSibX2OrKLSALjeMZ8J3odw9Gi8Skeh7TSQZpxEjThjSONWk7aUmVr5oYuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=QzL3F6RJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="QzL3F6RJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IM3zxHBTFatLoUXmdXOvtEIofKolIN4pStuB65QxbNU=; b=QzL3F6RJ3diPUUyOKJj7T+YsqY
	TT7N8bNRMtvgr5ZqJzOn+WEocEnDciUcQa4tgANWz1Hrxsu3mq889RZLjNEdL4D7OO+aIJsnVfCDs
	UEnKDbmmftJOyG9L4iLKJhHiTlzqSdBwXggSUxqHRAuMv1ntnRnCbSskTpKdZwekaB8nBgPvAxEhc
	AC36WwB54GY8+Wsb2bMSBB0S7bmgbcKr80ISgMsVNadvZl1uX563e32I1i+gk7/wxEFqm+EzKM2xu
	NjTX8eY5SekBFRTVXjwuRxVAwX0qNoBlJq1yyjd3dWIzFGABZWCmDvkCfW7uHM7o7g3U0EanmHcz5
	iLIXZl8w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sABZN-000000000Mm-3osX;
	Thu, 23 May 2024 18:45:33 +0200
Date: Thu, 23 May 2024 18:45:33 +0200
From: Phil Sutter <phil@nwl.cc>
To: Michael Estner <michaelestner@web.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] iptables: cleanup FIXME
Message-ID: <Zk9yrd8Ji1xAcblw@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Michael Estner <michaelestner@web.de>,
	netfilter-devel@vger.kernel.org
References: <20240523145058.747280-1-michaelestner@web.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523145058.747280-1-michaelestner@web.de>

On Thu, May 23, 2024 at 04:50:58PM +0200, Michael Estner wrote:
> Remove obsolet FIXME since struct ebt_entry has no flags var.
> Update the debug output.

It never had, but there's bitmask and I wonder if it should compare
those values instead.

Cheers, Phil
