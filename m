Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CFC142E70
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 12:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713963230; cv=none; b=H42mOjMYcBph9hxnWUa+NaJbK3yBTDTrlpvedGWqY+BtWBLeLp4/Sn6/nh9boGjnZOBDL3IKhW44Lj55IdXTfTTHsPPGbmMI72SES7wuYirNu8vwo+dmnRHF7IOgx/qrhrbBSTWUuocyGmuOUShOjPhciwegbCPq1Zva6Bc4acU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713963230; c=relaxed/simple;
	bh=s9/FMmCbHYN6bwODQb3smdFYldGh6hMN9RN5cb/ckc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYXri4PKK9vT45+x9RmVh8vlJyVX37xqSdH/5FUuatZPRHU58DwJDIsGBsNlDCKkdfdDlgGhQnUPgKIa7oARZ5XrtI/fWCjyZx9EIM8DYuiRbk+kPNWvN+3Pj6umeDGHGfvb64Pt2obytJyNUkay7ZK68gvxB9ieiMHAqmLTTzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EYlhTFzk; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EYlhTFzk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=x4EkQMvkrJnZaMcUiBb/r6udDdfxzp4AhPGP1XS8l28=; b=EYlhTFzkXiKjan9YWTDQJFpke1
	4Nm00ONd5AJAlnFixxcyotbZa3dsjDNGjYo1c2bz7x/g+2LGMa14wABgaSzQ0STCh/5XlVD13LVqq
	f3EPd17/DDmYb6ttTyjYJNpx1ES3UH7mBMz2J9uykze8Tvfw3xyI0uKJCGKSh4R3IdhaxaEHMt7np
	TOaluqM5xJ90fFwXVaTrHf8wQuMXq1M5z8e3hCA0d59Nn+mQTEpsMIp571tW4+a+BCU6flfvIrSLh
	qfkYE/tuIgQCRXqeyoCUn650MkToYYElPar1frv2lYGWN3iC5tiygm/NBgR55udLtAmOyoHiE+BQY
	m3XrVqTA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rzc82-0000000069a-1yE0;
	Wed, 24 Apr 2024 14:53:38 +0200
Date: Wed, 24 Apr 2024 14:53:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Alexander Kanavin <alex@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, "Maxin B. John" <maxin.john@intel.com>,
	Khem Raj <raj.khem@gmail.com>
Subject: Re: [iptables][PATCH] configure: Add option to enable/disable
 libnfnetlink
Message-ID: <ZikA0v0PrvZBsqq6@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexander Kanavin <alex@linutronix.de>,
	netfilter-devel@vger.kernel.org,
	"Maxin B. John" <maxin.john@intel.com>,
	Khem Raj <raj.khem@gmail.com>
References: <20240424122804.980366-1-alex@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240424122804.980366-1-alex@linutronix.de>

Hi,

On Wed, Apr 24, 2024 at 02:28:04PM +0200, Alexander Kanavin wrote:
> From: "Maxin B. John" <maxin.john@intel.com>
> 
> This changes the configure behaviour from autodetecting
> for libnfnetlink to having an option to disable it explicitly.
> 
> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> Signed-off-by: Maxin B. John <maxin.john@intel.com>
> Signed-off-by: Alexander Kanavin <alex@linutronix.de>

The patch looks fine as-is, I wonder though what's the goal: Does the
build system have an incompatible libnfnetlink which breaks the build?
It is used by nfnl_osf only, right? So maybe introduce
| AC_ARG_ENABLE([nfnl_osf], ...)
instead?

Thanks, Phil
