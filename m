Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9242243146
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2024 10:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721125834; cv=none; b=mz3JiaV4nboElN+M2PrkQrfoB8ymiaTRpv5WhP8Q2SAS3UPRQEWrPeFGxdvgDnBKCK88RKHH2jmO2fgPZmUFeM4YcHUE3M7rLE/wDaGd7kiER5qMCbsG03n9YaQ2UMORLxbIwdGO4lw36A+0LBAwQKwGxixlZrdYfPNfS0Ehu04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721125834; c=relaxed/simple;
	bh=vJnzNT+zhy24Xdpm1LR3S+hx007EkpJCNyjBW3scYss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NX2SmekDX4ibUzskXtuGmiLiMAYv5F7gSwo8t8buFbx+T2zSBpnQdrZasQVU9CFzqk44l1Zd6zvq1r8EmkjMo1L6kOtbO1x0cnF5sFY70XzpavN6kU2ZbYYYknkHz5mkK3vFFu0FvqkNm/t/49GW3oLGa+V3IEleosLHe99ENyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=40148 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sTfRx-007jYK-A5; Tue, 16 Jul 2024 12:30:27 +0200
Date: Tue, 16 Jul 2024 12:30:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Stephan Brunner <s.brunner@stephan-brunner.net>
Cc: netfilter-devel@vger.kernel.org,
	Reinhard =?utf-8?B?TmnDn2w=?= <reinhard.nissl@fee.de>
Subject: Re: [PATCH] conntrack: tcp: fix parsing of tuple-port-src and
 tuple-port-dst
Message-ID: <ZpZLwAibYGwCeHib@calendula>
References: <e8786a769b04bbc6e72ff96f1527bc869f4f75af.1721052742.git.s.brunner@stephan-brunner.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e8786a769b04bbc6e72ff96f1527bc869f4f75af.1721052742.git.s.brunner@stephan-brunner.net>
X-Spam-Score: -1.9 (-)

On Mon, Jul 15, 2024 at 04:13:42PM +0200, Stephan Brunner wrote:
> As seen in the parsing code above, L4PROTO should be set to IPPROTO_TCP, not the port number itself.

Applied, thanks
