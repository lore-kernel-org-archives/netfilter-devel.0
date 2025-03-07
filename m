Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500D623E34E
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741366314; cv=none; b=IQ0IHlCABzPnEvRxABly5AfNaH8tM9zVJn2U9WrjgLKhbUApbWCf8W7NQMUHNrmefurTwtCjGUTvn8OmSvndnVRkK2yDySfQox/hkiHcf0XV423FfTGbBArrSk2cq63o8Axw+VD+i+wloG8gjh8BZKNN2DJD9k+DWjSnupxtJO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741366314; c=relaxed/simple;
	bh=ZXtGEDrZDaRRg9qeyOWuvt9GaVp8shecJxAGkGi0NAM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=md28DPsBUKmXjrliPKPMIn8zS7lATCDerxiiHMsV6ZKiY45pxdGVyBIXr3hWzttv1NDz5bKnEKZvcpTsQ+rqKadgO+29gUGRqBoAqVsjiHiiYjTXAN7DvIkdgoS86XoWglii83YjKNo1Uf4B+A9TIeUBBUkOC9V62JlA9JHa4qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 215791003BB141; Fri,  7 Mar 2025 17:51:47 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 211541100AD650;
	Fri,  7 Mar 2025 17:51:47 +0100 (CET)
Date: Fri, 7 Mar 2025 17:51:47 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Guido Trentalancia <guido@trentalancia.com>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
In-Reply-To: <1741361076.5380.3.camel@trentalancia.com>
Message-ID: <931rns88-4o59-s61q-6400-4prp16prsqs7@vanv.qr>
References: <1741354928.22595.4.camel@trentalancia.com>  <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr> <1741361076.5380.3.camel@trentalancia.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Friday 2025-03-07 16:24, Guido Trentalancia wrote:

>Of course, if the DNS is not available the "evil hacker" rule is
>skipped when this patch is merged.
>
>However the drawbacks of not applying this patch are far worse, because
> if the DNS is not available and some rules in the table contain domain
>names, then all rules are skipped and the operation is aborted even for
>numeric IP addresses and resolvable names.

A silent/ignored error is much worse than an explicit error;
the latter you can at least test for, scripting or otherwise.
