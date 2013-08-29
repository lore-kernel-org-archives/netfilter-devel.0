From: Phil Oester <kernel@linuxace.com>
Subject: Re: xt_recent.c bug - and cleanup
Date: Thu, 29 Aug 2013 15:09:04 -0700
Message-ID: <20130829220904.GA6810@linuxace.com>
References: <521F1F77.3030808@blub.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Valentijn Sessink <valentyn@blub.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37176 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab3H2WJU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Aug 2013 18:09:20 -0400
Received: by mail-pb0-f42.google.com with SMTP id un15so1034465pbc.1
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2013 15:09:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <521F1F77.3030808@blub.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 29, 2013 at 12:16:23PM +0200, Valentijn Sessink wrote:
> There is a bug in the "recent" module's "!" option, as follows.
> 
> Suppose I want a list with IPv4 addresses that are "friends". My
> iptables rules are simple:
> -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
> -A INPUT -m state --state INVALID -j DROP
> -A INPUT -m recent ! --update --name friends --rsource -j LOG
> --log-prefix "go away: "
> 
> This will log "go away" for everyone not on my list of friends (how
> safe ;-) and it should update the "last seen" of everyone who is a
> friend.

I disagree with your assessment.  Take a closer look at the man page
for recent match (emphasis added to relevant portion):

  [!] --update
     Like --rcheck, except it will update the "last seen" timestamp **if it matches**

Your rule _does not match_ for "friends".  Because you used inversion, it only
matches for non-friends (and then, of course, there is no timestamp to
update).

So put more simply:

	       update: -m recent --update
	do not update: -m recent ! --update

> As you can see, the entry is never updated. 

By design.

> It gets even stranger
> when you add a "--seconds" check, because now your entry is only
> updated when the check didn't match; if you did match, there's no
> update. (I will not give an example for this, as the bug is
> complicated enough without it).

This is confusing, to be sure, but from my review of the code, it is also
by design.  Unfortunately when you use --seconds, it DOES NOT MATCH,
and therefore it does not update.  But then on the next packet, since
there was no update on the first packet, it still does not match on the
second.  And on and on...  It will never match, and it will never update
the entry.

It seems the sane way to use --seconds would be in two rules: a --set first
and then a followup --rcheck --seconds.  

> I reported this in 2011, - see my bug report at
> https://bugzilla.kernel.org/show_bug.cgi?id=29332

...should be closed

> Since then, nothing happened. In my bug report is "quick hack" for a
> fix, that leaves the double use of "ret" and two spurious "goto"
> statements intact, but I'd rather have my cleanup patch accepted,
> because it makes recent_mt() much more readable. See here:
> https://bugzilla.kernel.org/attachment.cgi?id=48292&action=diff

One note on your cleanup: there is nothing wrong with using "goto"
in the kernel.  The code as it exists today is easier to read with
the use of it.

> So I kindly ask: is there a way to get my patch accepted, with the
> cleanup? Could someone please look into it? Is there anything else I
> should do?

I see no bug here.

Phil
