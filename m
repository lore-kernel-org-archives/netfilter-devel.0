Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4727A38D
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2024 15:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232057; cv=none; b=DYc+t19Fn8wa0eZAKyze5CnMAzHeWopL7X2vr94SnhcQ8V8y3F6YgRw3pN8TDG+aUvbHbKTBYuHGh/nE/MBQTWemd+b8F1W05ejq+E64wdSP4zQl5xCW4hUejs4gVfmH7FkdqkFb5vJNdePaR2KDax9bPkr0XQpeebtjCmi/siU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232057; c=relaxed/simple;
	bh=1xhFKaXOyC559n6KIGI/2jtSC1sc+sehW9PAtCmr/f0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kdHdNJ0s/Zi2pledl5pql6dVXi3feegOiw+k/Qe9qTNERylYdNujh6LuwrZ+kSdOEGFNe2fCEWqzBrXch/tM5rBXdBkrur+GP0kfEoRomPl5bsvljAGnhJ9E8GCHuiG+hIcCFsdhdyPgMG0SHdRWVGvI6JyUN74kFx28KN9xgXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MuBj8OcP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MuBj8OcP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Im7Ax/NnwJeFBDlXmNBimRRHVEo4fIxrxjbCYy9CEFA=; b=MuBj8OcP639O5p8CxzTmGEYYsU
	PWPTBUUrAJfljzISSqdS4joWMkEPr85746e3P2r/GzMqip5+52ulanqCRt2w6IcopKTQC5OomO10w
	6q5jxVGUUr7YDxPLjWMn4jPi4w+SV3MR5zDjcMXtli1X1tTA+qqUT9PqZy4BtOXRIconOLISUY6bY
	O8xre7AWD+l2KmTQqwSkMFduhdLrn4Cf14Ku03yXUvGDHk/mWf8Eqd9m1bPx+GFEuy+UPyVMrWJ2v
	UKDcJyFqtaMoQvdGn0d784kgLmeTiBq+m9MbkYYWCv34kAu46uCwVY8AQAAKsCLjIx51HREqUrx18
	fF+K+bMg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rXN2j-000000007Xg-1k3R;
	Tue, 06 Feb 2024 16:07:25 +0100
Date: Tue, 6 Feb 2024 16:07:25 +0100
From: Phil Sutter <phil@nwl.cc>
To: Roman Mamedov <rm@romanrm.net>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: iptables: considers incomplete rule in -C and finds an erroneous
 match
Message-ID: <ZcJLLfd6mqN-kGF2@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Roman Mamedov <rm@romanrm.net>,
	netfilter-devel@vger.kernel.org
References: <20240205044519.45334f8e@nvm>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240205044519.45334f8e@nvm>

Hi,

On Mon, Feb 05, 2024 at 04:45:19AM +0500, Roman Mamedov wrote:
> Hello,
> 
> According to my ip6tables, a rule like this already exists:
> 
>   # ip6tables -C INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT && echo Exists
>   Exists
> 
> Except that it doesn't, and an extra IP filter is present:
> 
>   # ip6tables-save | grep 80,443
>   -A INPUT -s fd39::/16 -p tcp -m multiport --dports 80,443 -j ACCEPT
> 
> Is that the expected behaviour?
> 
> ip6tables v1.8.9 (legacy)

This is already fixed in v1.8.10 by commit 78850e7dba64a ("ip6tables:
Fix checking existence of rule").

Cheers, Phil
