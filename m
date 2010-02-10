From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: generate initial table
 on-demand
Date: Wed, 10 Feb 2010 17:21:27 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002101708320.12673@obet.zrqbmnf.qr>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de> <1265813954-13854-5-git-send-email-jengelh@medozas.de> <4B72D198.7040204@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41338 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0BJQV2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:21:28 -0500
In-Reply-To: <4B72D198.7040204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-02-10 16:32, Patrick McHardy wrote:

>Jan Engelhardt wrote:
>> +void *arpt_alloc_initial_table(const struct xt_table *info)
>> +{
>> +	return xt_repldata_mk(arpt, ARPT);
>
>I vaguely recall asking for a nicer (more pronouncable) name.
>xt_alloc_initial_table() perhaps? xt_init_table()?

Yes you asked for a nicer name. And I gave it one. To quote you and me:

http://osdir.com/ml/general/2009-08/msg10540.html

Jan> #define xt_repldata_mk(type, typ2)

Patrick> I also would prefer a nicer name, something like
xt_alloc_initial_table().
