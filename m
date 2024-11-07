Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967EC215037
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 16:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730997896; cv=none; b=q3Vs7qu3KXJsQz4P/r5dLI/+z0k5G2pEp38UJFbNzdLkC8k5R3c9MSnq6Vj4CbNHMGH9nlAuFDiOG1RWFHq/bGcNh5oHqG/GzpkUyh90ESGMpjUwvXQd096qFV4lHF+XFN8MKuDZEBUroW0bKJPOrrmJ15oXi6hVcAT2aA1BIYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730997896; c=relaxed/simple;
	bh=dcBBIhHilmEMCbVqZgT6+pb/e/BOCHFkEowRR6UMX4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nAwGs8lr+0KUHybm1f9alJwYQA1VLQti9uIwPpi9kdCItlp+gFPTLyqhUb9YpTsNAJLQ5KBmykjNMenvpRODdOitywzvzECzpglF0L0e8e8hrTLJiczVrty0MEPEOKlCt5+3HgxuqCEEF2DMrn4/OvQRTKylKkXOOT7CVj/mYNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qwMdGWaS; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qwMdGWaS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Y4un4HtusRxIvMxm1nAS7iOxiw/b3bOIFGGHA8yDhUs=; b=qwMdGWaSAsdWVhvfSoQ7ax2ck8
	LRmQJsPRc0KRrPerMhj9wRP4Y0juRXkelYWptUzFm9g62zA0nhuYwS2v/xtnM4a9kuJF1PM0tdivG
	QRpNwpfS7FaEiyMMowjvxnHaZAaeeLjJ+xHIk/G7cSvTvQiyn7uWZiWfEwVwdlaZfIR0H75UNtaYL
	fH8v39OIENYpAaXGEMMZihh+Mx6Pmj6I8vtXJIBrGbVOjMQ+wgJht4l8xQcJbXRnprBbRPpzf/MOv
	OG69UcR3KyZR3yEl1s1kpaWGGxFh9uI5D+d1qFylNktSnnpPM6C4/qk4Awofx4WThUDF3I10fJ6jD
	2ZsU6Jtw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t95ck-000000005L1-39av;
	Thu, 07 Nov 2024 17:44:46 +0100
Date: Thu, 7 Nov 2024 17:44:46 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, coreteam@netfilter.org
Subject: Re: [iptables PATCH] libxtables: Hide xtables_strtoul_base() symbol
Message-ID: <ZyzufuOtzaToGLv8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Jan Engelhardt <ej@inai.de>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, coreteam@netfilter.org
References: <ZyzYApZKx79g8jqm@calendula>
 <20241107161233.22665-1-phil@nwl.cc>
 <8361oqo4-qnss-089n-885s-nqqq6520r6r8@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8361oqo4-qnss-089n-885s-nqqq6520r6r8@vanv.qr>

On Thu, Nov 07, 2024 at 05:43:10PM +0100, Jan Engelhardt wrote:
> 
> On Thursday 2024-11-07 17:12, Phil Sutter wrote:
> 
> >diff --git a/include/xtables_internal.h b/include/xtables_internal.h
> >new file mode 100644
> >index 0000000000000..a87a40cc8dae5
> >--- /dev/null
> >+++ b/include/xtables_internal.h
> >@@ -0,0 +1,7 @@
> >+#ifndef XTABLES_INTERNAL_H
> >+#define XTABLES_INTERNAL_H 1
> >+
> >+extern bool xtables_strtoul_base(const char *, char **, uintmax_t *,
> >+	uintmax_t, uintmax_t, unsigned int);
> >+
> >+#endif /* XTABLES_INTERNAL_H */
> 
> Don't we already have xshared.h for this?

That's iptables/xshared.h and it's not included outside of that
subfolder.
