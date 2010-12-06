From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: Bug? iptables-save dumps resolved uids/gids for owner matches
Date: Mon, 06 Dec 2010 13:26:39 +0100
Message-ID: <874oaroznk.fsf@tac.ki.iif.hu>
References: <87sjyercks.fsf@tac.ki.iif.hu>
	<alpine.LNX.2.01.1012032018321.26825@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:35830 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab0LFM0n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:26:43 -0500
In-Reply-To: <alpine.LNX.2.01.1012032018321.26825@obet.zrqbmnf.qr> (Jan
	Engelhardt's message of "Fri, 3 Dec 2010 20:19:54 +0100 (CET)")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> writes:

> On Friday 2010-12-03 18:27, Ferenc Wagner wrote:
>
>> I opened http://bugzilla.netfilter.org/show_bug.cgi?id=683 quite some
>> time ago, but it hasn't received a single comment yet.  Don't you think
>> it's a real problem?  If you do, I'm willing to work on fixing it,
>> either by introducing a new option or by changing the default behaviour.
>> Actually, since we're seriously affected by this, I'm determined to
>> solve it, but of course I'd prefer to take a blessed route to get my
>> changes incorporated into the official sources if at all possible.
>
> This was done on purpose by me, because username resolution usually does 
> not take ages like DNS, and user ids can actually change if you copy a 
> ruleset to another machine (this is much more unlikely to be the case 
> with DNS).

This is indeed true if you only use a local passwd and group database.
So we're talking about a design decision, which I'd have taken the other
way, and not for pure consistency alone.  But how do we proceed now?  You
took responsibily of the ticket (thanks for that and the enlightening
comment, too), does it mean you've got an action plan and will carry that
out shortly?  I'm sure you could resolve this in about half an hour, but
have you got the time?  Also, I'd probably need this backported to 1.4.8.
Shall I start hacking or had I better wait for you?
-- 
Thanks,
Feri.
