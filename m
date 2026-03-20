Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EE237CD2E
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 12:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774010115; cv=none; b=jQK6w3Yg0QeJEbp5GGIyiBp7i14n1hWavOioPJMGnxp5E1CpcLxpPZwvN2b57NlNelcroYMke4ThuR33I+Fi1sbO8U1XkDByz7OTMHUaS6DKtKGL6H0pv1Bq0t/kkIxjCvdlYE5y0Z899EXAKKNgmAb2DET7W2Lvs8612VDELDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774010115; c=relaxed/simple;
	bh=djAZzzVGi16Eo6Y4pFyvdVb+G8lifaHh+bvdCY3eTic=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MhRa2416RbMgXrSHciNjDwJdWWRrzI/0S0ewKXGH8nbEy+EU0JkE/4+i8nTQwBitsS+rj+YcBkaRXgLDTZ+Rd3SzAdNE4sMrEqUqinJg/fW68NQyrZu2cQCe5rNJt8lTl29xtXDZXA90HmbfiLQp4dSZJwufd4+bHT4by2HtLoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=rz7Tt+kU; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="rz7Tt+kU"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4fchq25XQSz7s85h;
	Fri, 20 Mar 2026 13:35:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1774010108; x=1775824509; bh=7j/h4eRITs
	5Ov47FgaSr8A0FcVNWEy0QCkMc7/0MFzQ=; b=rz7Tt+kUXHJGMNogip8k6sB9ng
	6ETn2lCsIeFG7A5OLDJlXZvp0X9NHGbWCrym1zO3x/RyNmBfATvkwHkb9/Lm79Jf
	q7LxIknBbJz5jao71vgOyLvsJG3Oh6KqoNViVXxb2tczPNTYP/zdJbbgG6nOi9Bn
	m15VNanAQRayHQlO0=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id YUXy0hb0fXr9; Fri, 20 Mar 2026 13:35:08 +0100 (CET)
Received: from mentat.rmki.kfki.hu (unknown [148.6.192.8])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4fchq064zzz7s84c;
	Fri, 20 Mar 2026 13:35:08 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id ABBAF140DF3; Fri, 20 Mar 2026 13:35:08 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id A9E7614010F;
	Fri, 20 Mar 2026 13:35:08 +0100 (CET)
Date: Fri, 20 Mar 2026 13:35:08 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/1] netfilter: ipset: Fix data race between add and list
 header
In-Reply-To: <ab05DjDyx_ZOksqY@chamomile>
Message-ID: <e5a000a5-1d79-7785-f5c8-9669e17358b1@blackhole.kfki.hu>
References: <20260320114041.3486273-1-kadlec@netfilter.org> <ab03vtQI7WWq9puC@strlen.de> <ab05DjDyx_ZOksqY@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 20 Mar 2026, Pablo Neira Ayuso wrote:

> On Fri, Mar 20, 2026 at 01:04:14PM +0100, Florian Westphal wrote:
> > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > 
> > > Please consider applying the next patch:
> > > 
> > > * Fix data race between add and list header commands in all hash types 
> > >   by protecting the list header dumping part as well.
> > 
> > Thanks Jozsef for the quick fix.
> > Just to be sure, is this nf-next or nf material?
> 
> I think this is nf material, to deal with the KCSAN report from syzbot.

The patch can be applied cleanly on top of nf too, so yes, better nf and 
not nf-next.

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
