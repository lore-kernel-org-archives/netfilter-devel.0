From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Patch v3] netfilter: ebtables: CONFIG_COMPAT support
Date: Tue, 16 Feb 2010 15:39:02 +0100
Message-ID: <4B7AAE06.7040103@trash.net>
References: <1266267939-7736-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51567 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab0BPOjK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:39:10 -0500
In-Reply-To: <1266267939-7736-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> This is v3 of ebtables CONFIG_COMPAT patch set.
> Only changes since v2 are those pointed out by Bart:
> - remove MEMPRINT macro
> - remove BUGPRINT line instead of adding compat argument to
>   copy_counters_to_user().
> 
> Also, I rebased things on top of nf-next master.
> 
> The following changes since commit 3e5e524ffb5fcf2447eb5dd9f8e54ad22dd9baa7:
>   Florian Westphal (1):
>         netfilter: CONFIG_COMPAT: allow delta to exceed 32767
> 
> are available in the git repository at:
> 
>   git://git.breakpoint.cc/fw/nf-next-2.6.git ebt_config_compat_v3
> 
> Florian Westphal (7):
>       netfilter: ebtables: split do_replace into two functions
>       netfilter: ebtables: split copy_everything_to_user into two functions
>       netfilter: ebtables: split update_counters into two functions
>       netfilter: ebtables: add CONFIG_COMPAT support
>       netfilter: ebtables: try native set/getsockopt handlers, too
>       netfilter: ebt_limit: add CONFIG_COMPAT support
>       netfilter: ebtables: mark: add CONFIG_COMPAT support

This looks fine to me. There are however a couple of very long
lines contained in your patchset. Please fix this up not to
exceed 80 characters where reasonably possible.
