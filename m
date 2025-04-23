Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693532561A3
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 21:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745442589; cv=none; b=IqB85LVZ14yLs+W8ggRcVswon9dbUCkaTM8dSpYdjkfqRgZXQz8dCFeJgNWBk/o01Lj2gUEI4tjzmjFKxkYU1k0d7his106BzPE201S6r4NliqaYhxfpri2iXT4r2N7CZSlxRCRYodmk1bxJyWHg9fmAnHO11UUjc4mgQvdjZFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745442589; c=relaxed/simple;
	bh=UwkcRHkLZilZ/knAJ/M2k+tIEyVclgsZATAiOTdvXls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0x1wQ91sKI98vruP0qgP44NPB/+/TzmOYoOfx7+f0g7pPQHcXBJe3GLyqAQz24967xQr1ftnHZIhqOXAB48k3PwmT5u97zxAhmj3+CPI6ewtUkZ0AoeCGg0N/8jkGXDLXCD7ex1xUr85zEeShjoyStUFyXQrWNkFsfiqyfy6Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dm71TREn; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dm71TREn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fg9h1YTinP79U/n/fe/wF59FNmjwrPuwdpOHduokRK4=; b=dm71TREneTxnkCveVWL2juWce+
	wC/2OaO0FeIwQAPDxMG0tkeeXZ1eIdz+mVhLt0XzpPL7TQMuToofMqhCi5pI0fIsLnRXO/NnDoS1I
	2QYj7syGFFKE7s/P6vuhKVeEJ2q/H7Ve/IFku9bdEdgeemhnBvVyON9xaMYdlJnfgd/impgWdKxXw
	eOtsgMY0sBodHQMiYjsalJTG/IfWIOZCaecFM2IPR8wnHxvRF5TDQjAJ/Q+jNdwGff6d5yKXg9k2b
	0k3Ez3sSUmOhW9b/w8LSxbIT3BP2Jf2hnw4Q1U9+zIgQR51rkggkJrKhb6s7/zcZcm1EZafhmDLJg
	w2wwtH6A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u7hLl-000000007bg-1piG;
	Wed, 23 Apr 2025 23:09:45 +0200
Date: Wed, 23 Apr 2025 23:09:45 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: [iptables PATCH] xshared: Accept an option if any given command
 allows it
Message-ID: <aAlXGcRNV4AkXGk-@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	Adam Nielsen <a.nielsen@shikadi.net>
References: <20250423121929.31250-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423121929.31250-1-phil@nwl.cc>

On Wed, Apr 23, 2025 at 02:19:29PM +0200, Phil Sutter wrote:
> Fixed commit made option checking overly strict: Some commands may be
> commbined (foremost --list and --zero), reject a given option only if it
> is not allowed by any of the given commands.
> 
> Reported-by: Adam Nielsen <a.nielsen@shikadi.net>
> Fixes: 9c09d28102bb4 ("xshared: Simplify generic_opt_check()")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
