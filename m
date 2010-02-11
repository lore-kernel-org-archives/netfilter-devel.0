From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/10] netfilter: ebtables: try native set/getsockopt
 handlers, too
Date: Thu, 11 Feb 2010 18:40:12 +0100
Message-ID: <4B7440FC.3090508@trash.net>
References: <1265897559-10610-1-git-send-email-fw@strlen.de> <1265897559-10610-9-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46842 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab0BKRkO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:40:14 -0500
In-Reply-To: <1265897559-10610-9-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> ebtables can be compiled to perform userspace-side padding of
> structures. In that case, all the structures are already in the
> 'native' format expected by the kernel.
> 
> This tries to determine what format the userspace program is
> using.
> 
> For most set/getsockopts, this can be done by re-trying the
> native handler once the compat_ version returns an error.
> 
> In case of EBT_SO_GET_ENTRIES, the native handler is tried first,
> it should error out very early when checking the *len argument
> (the compat version has to defer this check until after
>  iterating over the kernel data set once, to adjust for all
>  the structure size differences).

Can't we place an explicit check somewhere instead of "probing"
for compatibility? Checking the size of struct ebt_replace for
compat tasks should be suitable.

Alternatively we could declare the userspace attempts to fix
up the ruleset broken and ignore this case. This is what we
did for iptables.
