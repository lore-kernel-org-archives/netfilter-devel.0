Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C2320F998
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2025 13:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736861533; cv=none; b=I04P/phON0xqogADfUDuLoracKBTS8RmxRE8Z4AEmLh2MR8Zg+UMLoAMRe3gk6tdY6PAHGpqxT/32rKVluTTwngjETBrrVkTUB6cG0XF3xwjc2hJwaKI0iL3OPS0qZ7dKJtbVQ7zTSNH0EuQBP+LCRUx5nXGK1Y2Zwh82DjInWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736861533; c=relaxed/simple;
	bh=59J08IGJ8iBHJvPxtrDEL4ZpX8FMPXzs+1qmCDFQ9gQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gSy7WWSTbRcGKUfrF1xz41Er6YgSzmGaQWrtnWJTmG2Z2c4GvpfaO7xc20bmaMGpCMslYydOM9zAIAmRlLM1F/tZzrJGLpCqDBGtO6bNzMzj+2aAU+zyM6OCH/KRifzg4FAI1t7s7AcS0I0j/MPwjKRlqvEp1rxxf9f12tEIRxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tXh1a-00021q-RE; Tue, 14 Jan 2025 14:32:06 +0100
Date: Tue, 14 Jan 2025 14:32:06 +0100
From: Florian Westphal <fw@strlen.de>
To: =?utf-8?B?7KCV7J6s7JykL1Rhc2sgTGVhZGVyL1NXIFBsYXRmb3JtKOyXsCnshKDtlolQ?=
	=?utf-8?B?bGF0Zm9ybeqwnOuwnOyLpCDsi5zsiqTthZxTVw==?= Task <jaeyoon.jung@lge.com>
Cc: Florian Westphal <fw@strlen.de>,
	=?utf-8?B?7KGw7ZmN7IudL+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
	=?utf-8?B?7Iuk?= SW Security TP <hongsik.jo@lge.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	=?utf-8?B?7IaQ7JiB7IStL+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
	=?utf-8?B?7Iuk?= SW Security TP <loth.son@lge.com>,
	=?utf-8?B?64Ko7KCV7KO8L+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
	=?utf-8?B?7Iuk?= SW Security TP <jungjoo.nahm@lge.com>
Subject: Re: Symbol Collision between ulogd and jansson
Message-ID: <20250114133206.GA5817@breakpoint.cc>
References: <SE1P216MB155825DDA1CD5809E1569DDE8F1F2@SE1P216MB1558.KORP216.PROD.OUTLOOK.COM>
 <20250114104114.GA1924@breakpoint.cc>
 <PU4P216MB15179D0909B9BEB9770F24F09A182@PU4P216MB1517.KORP216.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PU4P216MB15179D0909B9BEB9770F24F09A182@PU4P216MB1517.KORP216.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.10.1 (2018-07-13)

정재윤/Task Leader/SW Platform(연)선행Platform개발실 시스템SW Task <jaeyoon.jung@lge.com> wrote:
> Hi,
> 
> It's 2.14 being built with CMake.
> It looks like '-export-symbols-regex' isn't set with CMake.

Can you file a report with jansson? Libraries should not pollute
the namespace like this.  I can confirm that its fine with autotools
but cmake generated .so has everyting exported :-(

[ I also find it very questionable to have two build systems; it
makes these bugs harder to find for everyone, but thats a
different issue ].
