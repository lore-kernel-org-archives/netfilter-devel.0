From: Phil Oester <kernel@linuxace.com>
Subject: Re: xt_recent.c bug - and cleanup
Date: Fri, 30 Aug 2013 08:24:48 -0700
Message-ID: <20130830152448.GB7648@linuxace.com>
References: <521F1F77.3030808@blub.net>
 <20130829220904.GA6810@linuxace.com>
 <52202D25.6030606@blub.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Valentijn Sessink <valentyn@blub.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:47483 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab3H3PZG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:25:06 -0400
Received: by mail-pb0-f52.google.com with SMTP id wz12so1989108pbc.39
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Aug 2013 08:25:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <52202D25.6030606@blub.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 30, 2013 at 07:27:01AM +0200, Valentijn Sessink wrote:
> The manpage says "This will always return success (or failure if ! is
> passed in).", which IMHO means the "!" is only meant to reverse the
> return value. But I agree that the man page is not very clear.

Yes, it says that, but ONLY for the --set option, NOT for any of the others,
including the --update option you are using.  As noted previously, the
--update option includes "if it matches" as a qualifier.

> But, as you have reviewed the code, I'd like to ask you why the code
> calls recent_entry_update(t, e) when there's nothing to update (i.e. a
> call to recent_entry_init(), if any, would be more appropriate) - and
> the code knows it?

Eh?  You might be misreading the code.  First of all, this segment of
code is only reached if an entry has been found to exist in the relevant
table:

        if (info->check_set & XT_RECENT_SET ||
            (info->check_set & XT_RECENT_UPDATE && ret)) {
                recent_entry_update(t, e);

And it clearly states that it will update the entry unconditionally if you
used --set, and only if all other options matched in the case of --update.
What makes you think there's nothing to update here??

> The reason I found this, is that I'm trying to actually * use * the
> recent module with the inversion, and if this is not a bug, well, then
> its really odd at least - I can't even think how it could be useful this
> way.

Well, clearly the author had in mind the example in the man page:

	you can create a "badguy" list out of people attempting to connect to
	port 139 on your firewall and then DROP all future packets from them
	without considering them.

Which takes two rules to achieve: a --set first, then a --rcheck or --update.

You can certainly use inversion with this match, but in your original example,
you are expecting that anything which does not match will get it's timestamp
updated.  That is simply not how the match works.  You probably will need to
use two rules to achieve this: an --update with an -j ACCEPT for "friends",
and a second rule for the rest.

Phil
