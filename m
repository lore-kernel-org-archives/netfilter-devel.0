Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFAC283121
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 17:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770139291; cv=none; b=JiDgtxm3WUEEGDmAKPX7mwxsprU32NCBlf/+0qoGV2vlkiulkiM01Srxfa/d6TfaMY8LspgsLCMGwKZ0crczzaxn5GkxRWQ0AcFdX/udQ/3dNwvvwC/8eM0cSxuqSieO5OZJnceHWYtPKuDA5XVeEVgcpJLIgYssSod8GJ18JeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770139291; c=relaxed/simple;
	bh=7fP1EugHgZ1ZcSlLkTkXjrdHtwEQFN2+bffURWUNa/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfOT/WS/iuIbOiu9WnJNvjZ58uz3jx+W6lmEhtBV+OX7pLwIbYtOfDtn6l4UjJAvfV3TSj9sK/3c7jzusXCWB9iJenb+J3r2scpqQAJQDYhSERNeLoLuUWyBDbQ9WVrkh33KQeAYyUjjo8RWSXPFIdUa60iVw6VtMda8VSoW+9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=f21gMZtd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="f21gMZtd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HtxEnyrcddsTrghePdoF2q95pBXDvBdkpivz3szyKT0=; b=f21gMZtdAXBkqmCtdyiHw5IeCd
	1XyHRJmeS8o902gdYKsCf4XhbSiqu0wkvsQhkuf3tHclHL6Eb5Ql2IoYUQiNHG9KT+Q8qY6sOWzg8
	eD8pKy3oeQhlK/BGK5aV8/iV+QxlS8fygfDMSZGVTsUtcUFEqzFeTappAN7OsG0Fpio1blpWGNRK/
	6xbd7aCyDUshxyCyuCIGu7WQyhjCFkRC5zAHe045L6nmAz51nYUbwjKAIhOv1FtterkcaCsyhBNl/
	R1TEZeZGW+uQByY5RYqOivKUswsX9CAsnNakRcuQbfKvrqydivpncnP7RcR/ZWakwV3GrI6rniRQ/
	GqpHul+A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vnK5f-000000004Ip-2jVL;
	Tue, 03 Feb 2026 18:21:27 +0100
Date: Tue, 3 Feb 2026 18:21:27 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH] tests: py: Adjust payloads to changed userdata
 printing
Message-ID: <aYIul8PJ9vlRa_UZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20260129140746.10140-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129140746.10140-1-phil@nwl.cc>

On Thu, Jan 29, 2026 at 03:07:46PM +0100, Phil Sutter wrote:
> libnftnl no longer prints userdata content but merely its size and a sum
> of all bytes.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
