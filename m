Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BA32940D
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jan 2025 16:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736614275; cv=none; b=loMIyfHdO1BETx1Dee24V1rjLhBQ9ywZa0G4RJkcTyJL5u6jCKCCvxs+mSyf0vJ8EZTuRic1uoCq2USzNdcE03F7nLl6SF7SnZ+nI75gc4Ty8RQsFAruABwSD+TsPiW3bNGV3LhNWFlkDoR9BUEdT3gsofF63KHn0L2S01fqUNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736614275; c=relaxed/simple;
	bh=iOWVZPGVNpbA9djXXWWK+QW/haB8m0S5npv4do4ponk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TFUX5karBLqrWWCrpW3W7qXQNWKSykonpeI7YoSpzf8Hsf5L1uOZTX1HQuw69fqAg2pJTY4lyTHrZkJ7jUg8PpMGROlsrKFkKsyT+y/qncWouUnLqD4un10rNRr+82A9pvnK9hpboTDM9NfhzMHXRsaPbb+nCNLl/ZAg57IQsVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 112EE32E01AE;
	Sat, 11 Jan 2025 17:51:05 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id SFyKq-_9b4KV; Sat, 11 Jan 2025 17:51:03 +0100 (CET)
Received: from mentat.rmki.kfki.hu (80-95-82-5.pool.digikabel.hu [80.95.82.5])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 2E89932E01AD;
	Sat, 11 Jan 2025 17:51:03 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 0AC8C142836; Sat, 11 Jan 2025 17:51:03 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 06D8B1424A2;
	Sat, 11 Jan 2025 17:51:03 +0100 (CET)
Date: Sat, 11 Jan 2025 17:51:02 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>, 
    Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, 
    Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Android boot failure with 6.12
In-Reply-To: <20250111140543.GB14912@breakpoint.cc>
Message-ID: <94f5258d-c40a-4bcf-0e1e-f791d5fdb9cf@netfilter.org>
References: <CAHo-OozVuh4wbTHLxM2Y2+qgQqHTwcmhAfeFOM9W8thqzz6gdg@mail.gmail.com> <CAHo-OozPA7Z9pwBgEA3whh_e3NBhVi1D7EC4EXjNJdVHYNToKg@mail.gmail.com> <CAHo-Ooz-_idiFe4RD8DtbojKJFEa1N-pdA8pdwUPLJTp7iwGhw@mail.gmail.com> <CAHo-OozUg4UWvaP-FtHL44mygWwsnGO_eeFREhHddf=cc2-+ww@mail.gmail.com>
 <16d951e0-5fce-c227-5f50-10ecf3f16967@netfilter.org> <20250111140543.GB14912@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 0%

Hi Florian,

On Sat, 11 Jan 2025, Florian Westphal wrote:

> > Also, why the "mark" match was not split into NFPROTO_IPV4, 
> > NFPROTO_ARP, NFPROTO_IPV6 explicitly (and other matches where the 
> > target was split)?
> 
> mark match is fine, afaics.  Whats the concern?
> 
> The target got split because ebtables EBT_CONTINUE isn't equal to
> XT_CONTINUE, so it won't do the right thing.

I have just reread the description of your patch "netfilter: xtables: 
avoid NFPROTO_UNSPEC where needed" and now I see why the match is fine as 
is. Thanks!

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
