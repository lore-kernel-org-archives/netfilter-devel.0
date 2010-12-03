From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Bug? iptables-save dumps resolved uids/gids for owner matches
Date: Fri, 3 Dec 2010 20:19:54 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012032018321.26825@obet.zrqbmnf.qr>
References: <87sjyercks.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ferenc Wagner <wferi@niif.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52246 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab0LCTTz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Dec 2010 14:19:55 -0500
In-Reply-To: <87sjyercks.fsf@tac.ki.iif.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-12-03 18:27, Ferenc Wagner wrote:

>Hi,
>
>I opened http://bugzilla.netfilter.org/show_bug.cgi?id=683 quite some
>time ago, but it hasn't received a single comment yet.  Don't you think
>it's a real problem?  If you do, I'm willing to work on fixing it,
>either by introducing a new option or by changing the default behaviour.
>Actually, since we're seriously affected by this, I'm determined to
>solve it, but of course I'd prefer to take a blessed route to get my
>changes incorporated into the official sources if at all possible.

This was done on purpose by me, because username resolution usually does 
not take ages like DNS, and user ids can actually change if you copy a 
ruleset to another machine (this is much more unlikely to be the case 
with DNS).
