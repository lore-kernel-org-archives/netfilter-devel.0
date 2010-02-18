From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v4] netfilter: ebtables: CONFIG_COMPAT support
Date: Thu, 18 Feb 2010 12:10:10 +0100
Message-ID: <4B7D2012.1020803@trash.net>
References: <1266338348-6233-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62578 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab0BRLKO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:10:14 -0500
In-Reply-To: <1266338348-6233-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> Version 4 of the ebtables CONFIG_COMPAT patch set.
> 
> Changes since v3:
> - reformat to get rid of overly long lines.
> 
> One long line remains (a BUG_ON() ), fixing this would make this much
> more ugly, so I'd rather remove the BUG_ON if that one line is still a
> problem.
> 
> Changes since v2:
> - remove last use of MEMPRINT macro
> - remove BUGPRINT line instead of adding compat argument to copy_counters_to_user
> 
> First patches are preparation patches to reduce copy & paste in later
> patches.  Patch 4 is the main CONFIG_COMPAT hunk, next ones
> handles those ebtables binaries specifically built for 64 bit kernel
> (i.e. pad in userspace).
> Last two patches add CONFIG_COMPAT support to the targets/matches that
> need special handling (maybe I missed some, though).
> 
> Tested on x86_64 with x86 userland by comparing output of 32 and 64 bit ebtables binaries.
> 
> Changes since v1 were:
> - also move handling of ebt counter set/getsockopt handling to helper functions to avoid
> copy & pasting the same code in the COMPAT handlers.
> - add missing length check to compat_do_ebt_get_ctl().
> - add a patch to handle "userspace-side-padding" in some ebtables 32bit userspace binaries.
> - add "const *" qualifiers to the compat_from/to user functions.
> 
> The following changes since commit 3e5e524ffb5fcf2447eb5dd9f8e54ad22dd9baa7:
>   Florian Westphal (1):
>         netfilter: CONFIG_COMPAT: allow delta to exceed 32767
> 
> are available in the git repository at:
> 
>   git://git.breakpoint.cc/fw/nf-next-2.6.git ebt_config_compat_v4
> 
> Florian Westphal (7):
>       netfilter: ebtables: split do_replace into two functions
>       netfilter: ebtables: split copy_everything_to_user into two functions
>       netfilter: ebtables: split update_counters into two functions
>       netfilter: ebtables: add CONFIG_COMPAT support
>       netfilter: ebtables: try native set/getsockopt handlers, too
>       netfilter: ebt_limit: add CONFIG_COMPAT support
>       netfilter: ebtables: mark: add CONFIG_COMPAT support

Pulled, thanks a lot Florian.
