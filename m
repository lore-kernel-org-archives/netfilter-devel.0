Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255FD78F2E
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 22:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769553963; cv=none; b=T2e7VYgvCtl495zf/Du53zgAgZW/rrKLPhZ4xVbWpSJI7RT9UTD7TD78eRsbOuq+BWLfKRp0O0rFaRjIweDZMyDKwVNDFr9jDL0Oohw9fMiB4OFQjvcSchE6HrIyuvObTq+3mA0HPt1vDiSFvSAL+JPogLpmybBwbisH8iWRcl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769553963; c=relaxed/simple;
	bh=IvLnRxv/okl6XNkXE1G8Q2V9l/oMGAN8pWOCWwFW51o=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ozERMJycPl90yZ7BBVjWEccqs+x8DRH92IaR92lzV9aW5Z0oFYscvJbRSKrBMBLlotyLEsyaxa0TZCXjV6uniJGaO6ttZbwJFM3L1RVmbXYj+jZQyjc1daCBOWitnmSAs3aotcPJJhBy6xiuf8dmuaXOQqUl8a8SMMDTjhdIUWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=K1oImKHR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="K1oImKHR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=x9B8ks4yptPrMxpVbhgWcFma0zzXiwQ8/LrfQOTBePk=; b=K1oImKHRJTEfw0rjFcjqErdPMo
	nRSaVEI7z5+zrfcnxeU834awdKXWdfOr28UaxwkxZMZt2oGuvuey4qNxCJT4aSOmWLS1JT+9+AqtH
	0Etp4SJZwS9X+Qkg6XMSxjKjs556rAsEzkgLgXU6DTlIzf5V6GTIahnMhbPtwhL7WSX7MOAnjLce9
	3a+5zG5cjoudunkhBvQDD7XwawKOK6lQW6VwOiA/xpCbqmumr0beKttYUbyoP4baiPqfsFfc+MR/e
	Uw/9Pq4GtDegn33xOF0pfeNAeQR+nfa3xkPopVIpt5nsQzOFPRiLXgnJ3WJvqyvNWBzkOPB2aRztq
	Po56poQg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vkrot-0000000037w-2qWJ
	for netfilter-devel@vger.kernel.org;
	Tue, 27 Jan 2026 23:45:59 +0100
Date: Tue, 27 Jan 2026 23:45:59 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] Makefile.am: Drop pointless per-project AM_CPPFLAGS
Message-ID: <aXlAJ4dHytHTQTOA@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20260127223036.32299-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127223036.32299-1-phil@nwl.cc>

On Tue, Jan 27, 2026 at 11:30:36PM +0100, Phil Sutter wrote:
> These are redundant, the common AM_CPPFLAGS variable has it already.
> 
> Fixes: c96e0a17f3699 ("build: no recursive make for "examples/Makefile.am"")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
