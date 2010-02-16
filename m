From: Florian Westphal <fw@strlen.de>
Subject: Re: [Patch v3] netfilter: ebtables: CONFIG_COMPAT support
Date: Tue, 16 Feb 2010 15:41:59 +0100
Message-ID: <20100216144159.GB20183@Chamillionaire.breakpoint.cc>
References: <1266267939-7736-1-git-send-email-fw@strlen.de>
 <4B7AAE06.7040103@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34144 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754687Ab0BPOmB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:42:01 -0500
Content-Disposition: inline
In-Reply-To: <4B7AAE06.7040103@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > The following changes since commit 3e5e524ffb5fcf2447eb5dd9f8e54ad22dd9baa7:
> >   Florian Westphal (1):
> >         netfilter: CONFIG_COMPAT: allow delta to exceed 32767
> > 
> > are available in the git repository at:
> > 
> >   git://git.breakpoint.cc/fw/nf-next-2.6.git ebt_config_compat_v3
> > 
> > Florian Westphal (7):
> >       netfilter: ebtables: split do_replace into two functions
> >       netfilter: ebtables: split copy_everything_to_user into two functions
> >       netfilter: ebtables: split update_counters into two functions
> >       netfilter: ebtables: add CONFIG_COMPAT support
> >       netfilter: ebtables: try native set/getsockopt handlers, too
> >       netfilter: ebt_limit: add CONFIG_COMPAT support
> >       netfilter: ebtables: mark: add CONFIG_COMPAT support
> 
> This looks fine to me. There are however a couple of very long
> lines contained in your patchset. Please fix this up not to
> exceed 80 characters where reasonably possible.

Fair enough, I'll fix those and re-send later today.

