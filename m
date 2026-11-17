Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.6.0.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932806;
	b=zejXSZdWpGN0AoXHGc5V4TmUGosZbJ4MNUD0/Mx83FcNW3KgOJQ/2FeS9sQJSmTkGPQ/
	 bb5kbiyx3wjhdFG7wKhNdNqaF51q4V1AoyD8Lju+z4sOgx5lYyhb0fGauwAZ0f4VZWMXu
	 TpYF8h3P1Q6k0C3IX05KagvEhx6bNdKRmIMvDBdUtNPEOd5RQM5/Hmyn135jA5NdRSIH0
	 86cNiqNuaT4/4mOEnKKnqICXXprUPPGibwHm4VjviC8pS/thGG/cZRNBAmy7I0OOwLD2j
	 75i6/rCD/4Ghu03f/J/7KzcS/F7HLfzKfCau2ZtTIeOWWoO1CHygxyvGSek5SKyqJDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932806;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type;
	bh=I/fWbj3qaoG1xJAZIgo5gTbVOR5ApvHDki8G+h0TtwU=;
	b=Yop7oqQDL1qagXPuxlD5f+CJnkuovwJAht1/9JuXB+6pxViq28YFExxrICtGs01KV5rS
	 iynaatTMh45t+leFyvmrfdq7BSbL+P6mRANJvIbL7Xut7lSHdADI1Zfe+7Snr6rp8rEMh
	 4iQBi38uhpqNDMk2OqN6Jhqw1DtkubL7cFIuILe+MWsMZB2j/vY3zvHytbkMwLVePMw11
	 3EpMirj/4Iz1LYequ2YR0HaKRRkcp4JBe092a5jyERLsw3ZVcxNFMNgMBAsIaf0m/fr9T
	 6KDQEq7LNO6GUkm+5Rl0SGhTCsptiTKP2jAfz8el1n2W7PVcJ10mLF53/uwkaW4TvfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	arc=none smtp.remote-ip=148.6.0.51
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DA5606A338
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 16:26:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92DA5606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4jTVVQ0lvJz7s7xK;
	Tue, 17 Nov 2026 17:26:38 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id b_MpjU6eftxL; Tue, 17 Nov 2026 17:26:36 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4jTVVN1CXdz7s7x1;
	Tue, 17 Nov 2026 17:26:36 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id F346F340D0D; Tue, 17 Nov 2026 17:26:35 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id F1D17340CFB;
	Tue, 17 Nov 2026 17:26:35 +0100 (CET)
Date: Tue, 17 Nov 2026 17:26:35 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ipset] tests: hash:net,iface.t: add test case for wildcard
 matching behaviour
In-Reply-To: <avn4KIth2ics2YkS@strlen.de>
Message-ID: <c8ce3baf-9b2a-f149-47ba-1c8b5ee1885c@netfilter.org>
References: <20261028130203.1398-1-fw@strlen.de> <86662718-9117-5c82-cd2e-74298a9a2c7f@netfilter.org> <avn4KIth2ics2YkS@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hi Florian,

On Sun, 15 Nov 2026, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > +# Delete the specific entry.
> > > +0 ipset del test 10.0.1.0/24,eth0
> > > +# The wildcard entry should still be there and match eth1 via its prefix.
> > > +0 ipset test test 10.0.1.0/24,eth1
> > 
> > The original code does not handle the case properly and the wildcard entry 
> > can be deleted instead the specific one. If it passes for you then it's 
> > just lucky ordering.
> 
> Yes, it passes both on main and rhashtable_v10.

I don't quite understand why does it passes for you in the case of the 
original code.

> > > +# eth0 is excluded by the nomatch entry; it must not match via the wildcard.
> > > +1 ipset test test 10.0.3.0/24,eth0
> > > +0 ipset destroy test
> > 
> > This part also does not handled properly with the current code: it lacks 
> > the ordering to match/delete first the specific and then the wildcard 
> > records.
> 
> Lucky coincidence, then? What do we do now?  Will you make test cases 
> that demonstrate the expected behaviour and I respin a v11 that passes 
> those tests?

The tests you added verify the expected behaviour and v10 passes all 
tests. I'd not add bug-compatibility even when that means the experienced 
behaviour changes.

Please apply your patches :-).

Tested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
