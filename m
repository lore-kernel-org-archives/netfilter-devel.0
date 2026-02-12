Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8527519005E
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 00:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770855521; cv=none; b=GrAG4l22YUWlx7ZsxXz5RI7TEN0gCXH44ElsasTYXKfpXZTKTO5nHwqhNrWtabZUCB/aig3AS5cn14EhfvOYvdMQtHKKoJluW1edzZ9YEvuTwbpF04nzd7KZdvA5FSa3Wz0smE5RspO9eEsWehH+4iOF15iWbGkAa5r/AGDB8CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770855521; c=relaxed/simple;
	bh=mS0kWtL//G3ZQiAXf53vskKrrybLAAxUJtfHHh4mCGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IYrqnnHha4ZpRkH90nykJWgokmLysWrWNlzazarXC+JaT727Ap1Scm8KJ3ijV5aUqy7V6llklZcbDYW92y+TiqnQ5H2DebTMi6GoMkc9L+on6cQdcnqmRJNZ/DLc4GDDUESZv0lTCqBty1ihTSEZNaPu1nzNEK6g46B1lhmzHos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 36D6E60138; Thu, 12 Feb 2026 01:18:37 +0100 (CET)
Date: Thu, 12 Feb 2026 01:18:36 +0100
From: Florian Westphal <fw@strlen.de>
To: Alan Ross <alan@sleuthco.ai>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] security: use secure_getenv() to prevent env-var
 privilege escalation
Message-ID: <aY0cXHepIpELznWA@strlen.de>
References: <CAKgz23Gtsg4HGV8qqk7OovcK21ZdpwNzEnzoPzqrW=5eE6jV_w@mail.gmail.com>
 <aYy3ApR8MskC805m@strlen.de>
 <CAKgz23Hendu+Y=rhSwupr30Vf0JuJS5b6D-vp8A0TAC2swA-Bw@mail.gmail.com>
 <aYzSkR0lrv8MIgg7@strlen.de>
 <CAKgz23GWzqiryJwfjJyf7ObTkAnLciFZ6vKXcxACtm-N8xZi-w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKgz23GWzqiryJwfjJyf7ObTkAnLciFZ6vKXcxACtm-N8xZi-w@mail.gmail.com>

Alan Ross <alan@sleuthco.ai> wrote:
> >> Would you have the cycles to go through all of nf software to make this
> change?
> 
>   Yes, happy to take this on. I'll work through them in order: nftables,
> ipset, conntrack-tools, ulogd. iproute2 I can
>   look at as well, though that's a separate tree/maintainer so I'd send
> those separately.

Sure, iproute2 patches go to netdev@ , not to netfilter-devel.

>  >> I think it just needs a rework of the commit message
> 
>   Will do — v2 will lead with the setcap/container-runtime scenario as the
> motivation.

Thanks!

>  >> Any reason for the wrapper to not do getauxval(AT_SECURE)?
> 
>   No good reason. getauxval is available since glibc 2.16 (one release
> before secure_getenv in 2.17), and since this is
>   all Linux-only code there's no portability concern. Your version is
> cleaner — I'll use that for the fallback.

Alright.

>   In practice the #ifdef HAVE_SECURE_GETENV path will hit on anything
> remotely modern, but agreed the getauxval fallback
>    is simpler than a uid/euid comparison.

Agreed, it should not be hit in practice.

>  >> Another option is to alter ef7781eb1437a ("libxtables: exit if called
> by setuid executable") to enforce non-capability
>    binary
> 
>   That would work as a first step for xtables specifically — extend the
> existing getuid() != geteuid() check to also
>   bail on getauxval(AT_SECURE). The secure_getenv changes would then be
> belt-and-suspenders on top. Want me to include
>   both in v2, or would you prefer the enforcement-first approach across the
> nf suite?

I would prefer enforcement-first, but you are free to followup with
getenv_secure if you want.  I mean, the change isn't wrong, I am just
not sure there isn't anything else that we might be missing.

xtables has a plugin architecture, so we don't know what other
extensions that might get shipped by some distros do.

For nftables, thats less of a concern, BUT I don't know what some of the
libraries we link against do with untrusted input.  Or what will happen
when nft is invoked with stdin/stdout/stderr closed.

So I would prefer to enforce a no-setcap/setuid approach in any case
and followup with secure_getenv later.

> I'll start with the iptables v2 (reworked message + getauxval fallback)
> and then work through nftables and the others
> as follow-up series.

Thank you, much appreciated.
