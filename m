From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 0/10] netfilter: ebtables: CONFIG_COMPAT support
Date: Sat, 13 Feb 2010 14:31:53 +0100
Message-ID: <20100213133153.GE27427@Chamillionaire.breakpoint.cc>
References: <1265897559-10610-1-git-send-email-fw@strlen.de>
 <4B76A730.4000203@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47855 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487Ab0BMNbz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:31:55 -0500
Content-Disposition: inline
In-Reply-To: <4B76A730.4000203@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer <bdschuym@pandora.be> wrote:
> > First patches are minor bug fixes/preparation patches.  Patch 7 is the
> > main CONFIG_COMPAT hunk, 8 handles those ebtables binaries specifically
> > built for 64 bit kernel (i.e. pad in userspace).
> > 
> > Last two patches add CONFIG_COMPAT support to the targets/matches that
> > need special handling (maybe I missed some, though).
> > 
> > Tested on x86_64 with x86 userland by comparing output of 32 and 64 bit ebtables binaries.
> 
> One little cleanup that could be done is remove the last use of MEMPRINT
> and the corresponding macro in patch 5/10.

Okay, I'll do that then in the next iteration.

> For patch 8/10, I'd just remove the BUGPRINT line instead of adding the
> compat argument to copy_counters_to_user().

Perfect, I was a bit concerned if removing it would be acceptable; thats
the sole reason I added this ugly "bool compat" argument...

I'll just remove it, thanks Bart.

> But apart from that, the patches look ok to me (patch 10 was missing I
> think).

Whoops. Proabably because I ran send-email 000* .
It was unchanged from v1, though (except added const qualifiers).

Thanks a lot for taking the time to review this.

Regards, Florian
