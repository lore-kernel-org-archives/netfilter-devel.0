From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 0/7] netfilter: ebtables: CONFIG_COMPAT support
Date: Fri, 5 Feb 2010 15:00:21 +0100
Message-ID: <20100205140021.GB21611@Chamillionaire.breakpoint.cc>
References: <1265334195-28120-1-git-send-email-fw@strlen.de>
 <alpine.LSU.2.01.1002050807580.16226@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48191 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932810Ab0BEOAW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:00:22 -0500
Received: id: fw by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1NdOjN-0006BW-3C
	for netfilter-devel@vger.kernel.org; Fri, 05 Feb 2010 15:00:21 +0100
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1002050807580.16226@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> wrote:
> In a quick look, ebtables 2.0.8-2 seems to just work there in both
> 32/64 and 64/64 [U/K-bitness] combinations:
[..]
> 
> So I wonder whether extra patches are really needed for x86_64.

I did investigate the "lets pad the structures in userspace" scenario.
It has two problems.

First of all, support for a few targets/matches is missing.

Second, the point is to run unmodified binaries with either a 32
or 64 bit kernel without recompiling.

Solving this transparently (i.e. same binary) would thus
require a run-time check for the kernel architecture before the
set/getsockopt can be made.

As far as I could see this would require a lot of changes to the ebtables
userland code base, too.
