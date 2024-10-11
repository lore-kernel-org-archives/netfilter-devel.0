Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D881F9415
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 09:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728639471; cv=none; b=Q8O3zlmFyQOIQP/abmN9L591y6HWMzTyFf0g3BO3OC9IzK4dUS07U3/3876EnuR6hVh2mIGnrhi2oZiIbmXDov24T6vi4D/j2oq++uEjqrGvG5xMwY3B6UTFefQNm5wnduYa2F7Nw6RBVdvikbC1sqYiBo3NyKmY8462AJZiylM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728639471; c=relaxed/simple;
	bh=DfQQ1UKp8Ll4MucxFHaHuSeUaFZ/UxcUzselGlpEUj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o19rnu7tFjVRDk7wYPcMn7GC2dpFh2Lu4ILU/QB4oKivscG0msoB4Cz1u/pHMX5rU21ajBxE2v3gEOwuaFQuXHowPI5JiYLPShUAl+66QKcaOzemJrg2li4dohcwd/K2shhGcZgAIlPDKo1DFIrLv3VXDhOYQFLZy+dcywpr1f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=NxKMt2sg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="NxKMt2sg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=F1ovADDr4YT4gXu/pNXTerII38y2olLItzJ3fRtJEl4=; b=NxKMt2sgy/se4abf6XhJd0SDxk
	tdhs603cGIdN7ONQVwnUtQhp4oJWe0ZsWKxvvCefGxnI2JlFe3EW7Yztdf5deF12ASfj/jTNXO06K
	9yM8FBSUWvPT7e5Sh0lwU2eCdomG9akTxolC8rQ1jzvmw9rUTEx6pZ/hEg3mA414pJBekeq0yFvCc
	irH6RntC0Ll4vpJbC2GwaYu97rEAAK476WWL+XY8hu4YAU2UX/vY2oMl5IW+o56HSYGzvTwX8ApEo
	Sdyhf39LMEmZa5LJFVGVSRSwyoz7v5orVhzFsCxn+zvFF4ev00UWI5QE4C+O9sVhEhIA0Lc+E9dft
	St9ravGw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1szC5k-000000001fk-2irz;
	Fri, 11 Oct 2024 11:37:48 +0200
Date: Fri, 11 Oct 2024 11:37:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [nft PATCH] tests: shell: Join arithmetic statements in
 maps/vmap_timeout
Message-ID: <Zwjx7AN8jcOlyrXI@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20241011092508.1488-1-phil@nwl.cc>
 <ZwjviVcN1LfcBXee@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwjviVcN1LfcBXee@calendula>

On Fri, Oct 11, 2024 at 11:27:37AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 11, 2024 at 11:25:08AM +0200, Phil Sutter wrote:
> > In light of the recent typo fix, go an extra step and merge the modulo
> > and offset adjustment in a single term.
> 
> LGTM.

Patch applied, thanks guys!

Cheers, Phil
