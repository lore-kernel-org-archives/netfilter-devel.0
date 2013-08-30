From: Valentijn Sessink <valentyn@blub.net>
Subject: Re: xt_recent.c bug - and cleanup
Date: Fri, 30 Aug 2013 07:27:01 +0200
Message-ID: <52202D25.6030606@blub.net>
References: <521F1F77.3030808@blub.net> <20130829220904.GA6810@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Phil Oester <kernel@linuxace.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from filter.openoffice.nl ([178.63.187.165]:35641 "EHLO
	filter.openoffice.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3H3FfT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Aug 2013 01:35:19 -0400
In-Reply-To: <20130829220904.GA6810@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

First, thanks for looking into this.

On 30-08-13 00:09, Phil Oester wrote:
> I disagree with your assessment.  Take a closer look at the man page
> for recent match (emphasis added to relevant portion):
>   [!] --update
>      Like --rcheck, except it will update the "last seen" timestamp **if it matches**
> Your rule _does not match_ for "friends".  Because you used inversion, it only
> matches for non-friends (and then, of course, there is no timestamp to
> update).

The manpage says "This will always return success (or failure if ! is
passed in).", which IMHO means the "!" is only meant to reverse the
return value. But I agree that the man page is not very clear.

But, as you have reviewed the code, I'd like to ask you why the code
calls recent_entry_update(t, e) when there's nothing to update (i.e. a
call to recent_entry_init(), if any, would be more appropriate) - and
the code knows it?

> By design.

Then calling recent_entry_update is a bug. Besides, see below how the
--seconds check fits in.

You're right though, that --update --seconds 10 only updates within the
10 seconds scope as well.

> This is confusing, to be sure, but from my review of the code, it is also
> by design.  Unfortunately when you use --seconds, it DOES NOT MATCH,
> and therefore it does not update.  But then on the next packet, since
> there was no update on the first packet, it still does not match on the
> second.  And on and on...  It will never match, and it will never update
> the entry.

Let's say you use
-A INPUT -m recent ! --update --name friends --seconds 600 --rsource -j
LOG --log-prefix "go away: "

Then the first 600 seconds, you're welcome. Then after 600 seconds, you
don't match - ** and suddenly your entry is updated **. So for the next
600 seconds, you're welcome again! After that, you're not welcome, so
your entry is updated again.

That's silly.

The reason I found this, is that I'm trying to actually * use * the
recent module with the inversion, and if this is not a bug, well, then
its really odd at least - I can't even think how it could be useful this
way.

Best regards,

Valentijn
