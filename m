Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB25B27707
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 19:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770836946; cv=none; b=FSHnv4G5DAdWpLCnwRno7z+MgWIGGmxhwwa/5vYg/8IErQc6Tt2hw9NE8j+aJNZxjABQLxzQZZ7Z908Bef6ICWGoWmcFEbXN7KHosOx62PLbnuV9prp+E6KwKMrTYds78wsjXBdobcXFhebaWQlOVa9Iy6CE2NQ7GX9L8Zt0Pvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770836946; c=relaxed/simple;
	bh=RfTMwlAekjTDsQA7wKBlWekoeecMn64Ij/GfQU+HAoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sA6N6hYqqV7tzKTlQziuq9bWdI7Yg+4tisWhue73avXLJo6y2JVMTteCrNr9ZxMoyZyjLkCRXwKrSnOYLqTyI7DY0KyoKmAKnF7aE+3ClILgEtM9DM/EqjjxjDSfvETAS3Os44s0f5zJXz38Gj0blFevPjJ6sV+2xIAgXxdodm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F081F60345; Wed, 11 Feb 2026 20:03:45 +0100 (CET)
Date: Wed, 11 Feb 2026 20:03:45 +0100
From: Florian Westphal <fw@strlen.de>
To: Alan Ross <alan@sleuthco.ai>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] security: use secure_getenv() to prevent env-var
 privilege escalation
Message-ID: <aYzSkR0lrv8MIgg7@strlen.de>
References: <CAKgz23Gtsg4HGV8qqk7OovcK21ZdpwNzEnzoPzqrW=5eE6jV_w@mail.gmail.com>
 <aYy3ApR8MskC805m@strlen.de>
 <CAKgz23Hendu+Y=rhSwupr30Vf0JuJS5b6D-vp8A0TAC2swA-Bw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKgz23Hendu+Y=rhSwupr30Vf0JuJS5b6D-vp8A0TAC2swA-Bw@mail.gmail.com>

Alan Ross <alan@sleuthco.ai> wrote:
>   The gap is when iptables is run with file capabilities rather than via
> sudo:
> 
>   setcap cap_net_admin+ep /usr/sbin/iptables
> 
>   In that case the kernel sets AT_SECURE, the linker correctly strips
> LD_PRELOAD, but getenv("XTABLES_LIBDIR") still
>   returns the attacker-controlled value and gets passed to dlopen().
> secure_getenv() closes that specific gap.
> 
> >>  iptables requires CAP_NET_ADMIN to work and it was never designed to
> work with setuid-to-root.
> 
>   Understood. The capability-elevated case above is the primary scenario —
> some container runtimes and minimal
>   distributions grant cap_net_admin via setcap rather than running through
> sudo, and that's where the env-controlled
>   dlopen() becomes reachable.

ARGH!

cd ~/git/iproute2
git grep getenv | wc -l
36

>   That said, I recognize this is defense-in-depth rather than a critical
> fix. secure_getenv() is a strict behavioral
>   superset of getenv() for unprivileged execution (returns the same value
> when euid==uid), so the patch has no impact on
>    normal usage. The precedent is util-linux (su, mount) and sudo, which
> made the same change for similar env-controlled
>    paths.
>
>   If the consensus is that capability-elevated iptables is not a supported
> configuration, I understand. Happy to drop
>   the patch or adjust scope.

If there are distros that are dumb enough to setuid-to-0/setcap random
binaries then we should cope with this.

Would you have the cycles to go through all of nf software to make this
change?  nftables, ipet, conntrack, ulogd etc would all need this
change.  And non-netfilter software too, iproute2 tool has 36 getenv
calls.

As for this patch, I think it just needs a rework of the commit message
to explain that this is about existing distros/containers that setcap the
binary.

Any reason for the wrapper to not do

static inline const char *secure_getenv(const char *name)
{
        unsigned long x = getauxval(AT_SECURE);

	return x == 0 ? getenv(name) : NULL
}

?

It probably doesn't matter too much given glibc 2.17 is ancient, but
still, I'm curious.

Another option is to alter ef7781eb1437a2d6fd37eb3567c599e3ea682b96
("libxtables: exit if called by setuid executeable")
to enforce non-capability binary and then followup in nftables and
others.
