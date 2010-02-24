From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_tables: foreachs and reentrancy
Date: Wed, 24 Feb 2010 18:40:40 +0100
Message-ID: <4B856498.9040202@trash.net>
References: <1265970044-19518-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48568 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab0BXRkr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:40:47 -0500
In-Reply-To: <1265970044-19518-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> the next patch group following the previous cleanups is this one.
> 
> The macros were really ugly (you could not easily tell where the
> argument list that was passed to the real function started), so
> I took the freedom to remodel these based upon the excellent ideas
> from linux/list.h. It seems to have turned out well, there is much
> less argument passing.
> 
> The reentrancy patch title should speak for itself.
> 
> 
> The following changes since commit 05c7a108fdbd2ebbc357a78597646c111f8ebc62:
>   Jan Engelhardt (1):
>         netfilter: xtables: add const qualifiers
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/linux master-d30b8f5
> 
> Jan Engelhardt (6):
>       netfilter: xtables: replace XT_ENTRY_ITERATE macro
>       netfilter: xtables: optimize call flow around xt_entry_foreach
>       netfilter: xtables: replace XT_MATCH_ITERATE macro
>       netfilter: xtables: optimize call flow around xt_ematch_foreach
>       netfilter: xtables: reduce arguments to translate_table
>       netfilter: xtables2: make ip_tables reentrant

I've applied patch 1-5 for now. Patch 6 doesn't add any value
so far, so it should go in a series that actually makes use of
this (please note: I don't want any larger changes anymore in
this release however).

BTW, I noticed some minor cosmetic problems that I didn't fix
up to avoid clashes, please send me a patch on top to fix up
indentation in spots like this:

	/* Walk through entries, checking offsets. */
	xt_entry_foreach(iter, entry0, newinfo->size) {
		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
		      entry0 + repl->size, repl->hook_entry, repl->underflow,
		      repl->valid_hooks);

Thanks!
