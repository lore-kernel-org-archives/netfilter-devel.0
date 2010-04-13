From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] netfilter: xtables: inclusion of xt_condition
Date: Tue, 13 Apr 2010 14:00:49 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004131358320.10059@obet.zrqbmnf.qr>
References: <1270214599-22734-1-git-send-email-jengelh@medozas.de> <1270214599-22734-2-git-send-email-jengelh@medozas.de> <4BBB4134.2020007@trash.net> <alpine.LSU.2.01.1004131337180.16098@obet.zrqbmnf.qr> <4BC458D1.10506@trash.net>
 <alpine.LSU.2.01.1004131354210.32000@obet.zrqbmnf.qr> <4BC45BF5.7000105@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58451 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab0DMMAv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:00:51 -0400
In-Reply-To: <4BC45BF5.7000105@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-04-13 13:56, Patrick McHardy wrote:
>>> Yeah. We could allow just the creating rule to specify permissions.
>>> But its not necessary.
>> 
>> Well, don't forget that adding a rule means creating a new table
>> adding two rules and throwing away the old one.
>
>That doesn't matter. The condition either exists or it doesn't.
>In the later case you could specify permissions.

That would not work either, because the reference count of the
condition variable won't go below 1 when a table with a
single -m condition rule changes its UID.
Let's just leave it as it is right now.
If root can run iptables, so can he chown.
