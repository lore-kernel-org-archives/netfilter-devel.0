Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D371321858C
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2025 12:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736944204; cv=none; b=C3HVs7adzWG1Kx3XQp64i1YcG8Pmi4urA4/BnQAT4JQmCXwGKzbQMPFzGgla5SgmknV51TCBgog5BT0E4bIdrQJCab4y+0N/fUW3IooiqzA7SI7xlJWpT5FlOAsvi3v4WB15fN7Vr7POveLvZ4wFIpprZP+6dQ4nVsVuI6p6pO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736944204; c=relaxed/simple;
	bh=V3Y1wlLXy4e7Fm0Exr+eo9zZH5QsFnRLkYVb/cuel+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLqQ7dUV3B3DM7iSdvo0601/1u/xNLvi4LMfOzGcDA/ct0G9UgWVzXk/Ev0SITjQUQ+LgGS8xpkGR1RsEo7Xn2VtwP65dNs/tfaVm9y8YlLSk8W2+L8BYJGAebTaOSoPztWQkwalJFU+5kiTR2RnSGdRmpElLb4fTSUuizhXHt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tY2Wu-0005PO-8s; Wed, 15 Jan 2025 13:29:52 +0100
Date: Wed, 15 Jan 2025 13:29:52 +0100
From: Florian Westphal <fw@strlen.de>
To: =?utf-8?B?7KGw7ZmN7IudL+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
	=?utf-8?B?7Iuk?= SW Security TP <hongsik.jo@lge.com>
Cc: Florian Westphal <fw@strlen.de>,
	=?utf-8?B?7KCV7J6s7JykL1Rhc2sgTGVhZGVyL1NXIFBsYXRmb3JtKOyXsCnshKDtlolQ?=
	=?utf-8?B?bGF0Zm9ybeqwnOuwnOyLpCDsi5zsiqTthZxTVw==?= Task <jaeyoon.jung@lge.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	=?utf-8?B?7IaQ7JiB7IStL+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
	=?utf-8?B?7Iuk?= SW Security TP <loth.son@lge.com>,
	=?utf-8?B?64Ko7KCV7KO8L+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
	=?utf-8?B?7Iuk?= SW Security TP <jungjoo.nahm@lge.com>
Subject: Re: Symbol Collision between ulogd and jansson
Message-ID: <20250115122952.GA20715@breakpoint.cc>
References: <SE1P216MB155825DDA1CD5809E1569DDE8F1F2@SE1P216MB1558.KORP216.PROD.OUTLOOK.COM>
 <20250114104114.GA1924@breakpoint.cc>
 <PU4P216MB15179D0909B9BEB9770F24F09A182@PU4P216MB1517.KORP216.PROD.OUTLOOK.COM>
 <20250114133206.GA5817@breakpoint.cc>
 <SE1P216MB1558645CCB94B6522E460B638F192@SE1P216MB1558.KORP216.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SE1P216MB1558645CCB94B6522E460B638F192@SE1P216MB1558.KORP216.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.10.1 (2018-07-13)

조홍식/책임연구원/SW Security개발실 SW Security TP <hongsik.jo@lge.com> wrote:
> > Libraries should not pollute the namespace like this.
> I completely agree with your opinion.
> As you mentioned, I checked the only Cmake build has the problem. And It is the approprate to fix in jansson. I'll try to report it to jansson.
> 
> I believe that it could be reasonable approach avoding duplicated naming when such explicit symbol collisions are recognized, regardless of whether you are a library user or maintainer. But it's not a mandatory and up to you.

Sure, but if you assume libraries that export generic names, then
both hashtable_del or hashtable_delete could clash in the future.

If anything, we need to prefix *ALL* non-static functions with
ulogd_ or similar, which is huge churn and should not be needed
given ulogd isn't a library, i.e. all applications in existence
would have to do it.

And it would still be a problem in jansson.
