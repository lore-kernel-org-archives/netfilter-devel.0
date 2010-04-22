From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: xtables: inclusion of xt_condition
Date: Thu, 22 Apr 2010 13:27:41 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004221320300.1232@obet.zrqbmnf.qr>
References: <1271856792-20872-1-git-send-email-jengelh@medozas.de> <1271856792-20872-2-git-send-email-jengelh@medozas.de> <4BCF001D.4090304@trash.net> <alpine.LSU.2.01.1004220100530.6257@obet.zrqbmnf.qr> <4BD02FAA.7000207@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50808 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab0DVL1m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:27:42 -0400
In-Reply-To: <4BD02FAA.7000207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-04-22 13:14, Patrick McHardy wrote:

>This looks better, thanks. A few remaining questions about things
>I missed previously:

Will deal with it shortly.

>> +static struct xt_match condition_mt_reg __read_mostly = {
>> +	.name       = "condition",
>> +	.revision   = 1,
>
>Why are we starting with revision 1?

So as to avoid collisions with previously-deployed extensions.

Debian once decided to patch their etch 2.6.18 kernel with
ipt_connlimit ("connlimit.0"). That subsequently backfired with the
etchnhalf upgrade where xt_connlimit (also known as "connlimit.0")
was introduced.

condition.0 was used by pom-ng.

For the same reason, xt_TEE-2.6.35 starts with TEE.1, because TEE.0
is already in use by the variant without oif in struct xt_tee_tginfo;
i.e. all the Xtables-addons installations to date, basically.

It is not a particularl hardship to pick a revision number that is
distinct from all revision numbers previously seen in the wild, so
I'm set to go this way.
