From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 08/10] netfilter: ebtables: try native set/getsockopt
 handlers, too
Date: Thu, 11 Feb 2010 22:50:04 +0100
Message-ID: <20100211215004.GD27427@Chamillionaire.breakpoint.cc>
References: <1265897559-10610-1-git-send-email-fw@strlen.de>
 <1265897559-10610-9-git-send-email-fw@strlen.de>
 <4B7440FC.3090508@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46420 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757131Ab0BKVuF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:50:05 -0500
Content-Disposition: inline
In-Reply-To: <4B7440FC.3090508@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > ebtables can be compiled to perform userspace-side padding of
> > structures. In that case, all the structures are already in the
> > 'native' format expected by the kernel.
> > 
> > This tries to determine what format the userspace program is
> > using.
> > 
> > For most set/getsockopts, this can be done by re-trying the
> > native handler once the compat_ version returns an error.
> > 
> > In case of EBT_SO_GET_ENTRIES, the native handler is tried first,
> > it should error out very early when checking the *len argument
> > (the compat version has to defer this check until after
> >  iterating over the kernel data set once, to adjust for all
> >  the structure size differences).
> 
> Can't we place an explicit check somewhere instead of "probing"
> for compatibility? Checking the size of struct ebt_replace for
> compat tasks should be suitable.

Yes, thats what is being done where possible.
Here is a list of the set/getsockopts and the current "detect" strategy:

EBT_SO_SET_COUNTERS:
in compat handler, copy struct ebt_replace from user, check that
len == sizeof(struct compat_ebt_replace) + repl.num_counters * sizeof(struct ebt_counter)

if yes: continue, else try non-compat handler

EBT_SO_SET_ENTRIES:
in compat handler, copy struct ebt_replace from user, check that
len == sizeof(struct compat_ebt_replace) + repl.entries_size

if yes, continue, else try non-compat handler.

Actually, one could move the call to the non-compat handler around
so that the non-compat handler is only called when this
particular error occurs and not on other errors, like e.g. EFAULT.

I can do this in the next version of the patch series.

EBT_SO_GET_INFO, EBT_SO_GET_INIT_INFO:
trivial: *len must be sizeof(struct compat_ebt_replace), else try
non-compat handler

EBT_SO_GET_ENTRIES, EBT_SO_GET_INIT_ENTRIES:
In the non-compat case, this check is easy:
len must be "sizeof(struct ebt_replace) + entries_size_in_kernel"
(and size of all counters, but this is irrelevant because the counters
 do not need compat fixups).

Thus in case of EBT_SO_GET_ENTRIES and EBT_SO_GET_INIT_ENTRIES
the native handler gets called first (compat_ translates
the kernel table first to determine how large the data set would be
in user space, so the check cannot be done right after copying struct
compat_ebt_replace from userspace).


