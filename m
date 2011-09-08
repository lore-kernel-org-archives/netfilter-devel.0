From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH RFC] iptables-restore: new option to change the commit
 timing
Date: Thu, 8 Sep 2011 17:00:04 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109081652310.13219@frira.zrqbmnf.qr>
References: <4E68C314.3070709@dump-Storage.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Hiroshi KIHIRA <hiro@dump-Storage.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:32838 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab1IHPAH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Sep 2011 11:00:07 -0400
In-Reply-To: <4E68C314.3070709@dump-Storage.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2011-09-08 15:28, Hiroshi KIHIRA wrote:
>
>I propose to add a new command line option to iptables-restore.

I propose on top that it should be made the default, since half
tables are not really useful to anybody. (This has gone as far as to
people writing that iptables-apply script, and I'd love to see it
being replaced by something included in the C code instead.)

>In the situation that some tables are restored, each of tables are
>applied into the kernel space when the COMMIT statement was read from
>the input. If there was a syntax error in rules, iptables-restore
>will end without doing any modification to the table. However the
>table that was already committed into kernel space does not reverted.
>[...]

I am in favor of that. Though, I have to add, it actually misses the
inconsistency case {syntax is accepted, but the options are rejected
by the kernel}.

What would probably be most desirable is that iptables-restore keeps
copies in memory of each table it attempted to touch,
for the eventual case of a rollback.
