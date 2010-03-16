From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nf-next: netfilter: xt_recent: Add an entry reaper
Date: Wed, 17 Mar 2010 00:48:46 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003170022460.8803@obet.zrqbmnf.qr>
References: <20100316170915.8F49FF88DA@sepang.rtg.net> <4B9FD4A8.4070704@trash.net> <4B9FDF59.4060409@canonical.com> <alpine.LSU.2.01.1003162131130.17804@obet.zrqbmnf.qr> <4BA00D11.6030801@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42076 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab0CPXss (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 19:48:48 -0400
In-Reply-To: <4BA00D11.6030801@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-03-16 23:58, Tim Gardner wrote:
>> It's perfectly fine to say
>>
>> enum {
>> 	a,
>> 	c = a | b,
>> };
>>
>> as long as it's const/compile-time-computable.
>
> I guess because I'm old school I just hacked out a macro without
> really thinking about it. Its long been my habit to never used a
> signed quantity in a device driver unless signedness is really
> called for.

A macro won't magically give you unsignedness.
(And not that the sign would matter anyhow, we don't deal with numbers 
but the raw bits.)
