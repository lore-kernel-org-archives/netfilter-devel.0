From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: Add exit_error cb to xtables_globals
Date: Wed, 11 Feb 2009 18:19:06 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902111818190.26797@fbirervta.pbzchgretzou.qr>
References: <1234236584.20903.31.camel@dogo.mojatatu.com>  <alpine.LSU.2.00.0902111618170.20223@fbirervta.pbzchgretzou.qr> <1234372388.20903.108.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54338 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbZBKRTH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:19:07 -0500
In-Reply-To: <1234372388.20903.108.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-02-11 18:13, jamal wrote:
>> 
>> Why move the struct now.. makes it harder to figure out what changed.
>> So right, exit_error.
>
>Right (because of xtables_exittype)

Ok, makes sense. (I guess git got in a dilemma and did not figure
out the enum was moved ;-)

>> > #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
>> > #endif
>> > 
>> >-struct xtables_globals *xt_params;
>> >+struct xtables_globals *xt_params = NULL;
>> 
>> Do not initialize static members - this takes up extra space
>> and adds no benefit. (zeroed anyway even in .bss)
>
>Ok. Do i need to regenerate the patch or send on top?

As long as it's not applied, regen seems best.

>> When is basic_exit_error invoked? In this patch alone, the users
>> are missing (or the #define).
>
>tc/m_xt.c was at this point - but not any of the native iptables apps.
>Later on patches iptables-xml uses the basic_exit_error() as well

Ok.
