Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84CC1FC11F
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Jun 2025 08:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749458578; cv=none; b=ni7SrxZi4y35JSQUs8WxcdfVlSZO4INhFFB+Ui4928N7TjvNlmox/ASzhJM6Fw220uBso81KtuOGWDwaLGA/ooFyL1xEFQW3p+hl9IKPv/Xp55Q9x5o0/5dPkOrDHBd4s3CRtnejWf3CtSWov85M/5EKkS8nmWe2j82+C7QWVpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749458578; c=relaxed/simple;
	bh=Ar2O4HOt2gEV8BXETHlPrs3ol0WcegEwxKmsmQDxtU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhXyZzyHUWqpTJj5Oy948SvQLqiZ/XxW/ivI0NUT/vvGYhdypL30MzMrVHo27QzIHzGh5Zc7l78Z7oIRsAtLTHrgE4a8H45TDePdOKbMxtCRdV47oH2wIJA7NhNqQXWYbvtP9futnUNokkYsJaUyvW/Ig/Y24HOX7HGLpPYbbug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DDB926123D; Mon,  9 Jun 2025 10:37:38 +0200 (CEST)
Date: Mon, 9 Jun 2025 10:37:38 +0200
From: Florian Westphal <fw@strlen.de>
To: Yi Chen <yiche@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] tests: shell: Add a test case for FTP helper combined
 with NAT.
Message-ID: <aEadUq1HYYoP2sbX@strlen.de>
References: <20250605103339.719169-1-yiche@redhat.com>
 <20250605104911.727026-1-yiche@redhat.com>
 <aELx30qiSdDJ40vl@strlen.de>
 <CAJsUoE38FbpdGGGMkjLOyc5z5bQt9hviex2UmD_zcHuWNhY1ew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJsUoE38FbpdGGGMkjLOyc5z5bQt9hviex2UmD_zcHuWNhY1ew@mail.gmail.com>

Yi Chen <yiche@redhat.com> wrote:
> > Is tcpdump a requirement? AFAICS the dumps are only used
> > as a debug aid when something goes wrong?
> tcpdump is widely used in our LNST test cases. for example check if
> one packet got modified.
> Is it bad to use in upstream tests? If you still feel strange, I can
> remove the tcpdump check.

No need, you can keep tcpdump around.

> What I care about most is whether the ruleset in the test is
> configured correctly.
> One only needs to NAT the control connection — the data connection
> will be NATed automatically.

I'd have expected that the ftp connection would fail in case
there is a problem with NAT.

But if you prefer to also validate via tcpdump thats fine.

Thanks for v2, I will have a look.
