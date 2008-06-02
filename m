From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch] iptables version defines
Date: Mon, 2 Jun 2008 19:03:02 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806021809030.4055@fbirervta.pbzchgretzou.qr>
References: <200806021549.15005.thomas.jarosch@intra2net.com> <alpine.LNX.1.10.0806021646350.4055@fbirervta.pbzchgretzou.qr> <200806021732.57124.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55117 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYFBRDF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:03:05 -0400
In-Reply-To: <200806021732.57124.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-06-02 17:32, Thomas Jarosch wrote:
>Jan,
>>
>> #define XTABLES_API_VERSION(a,b,c) (((a) << 16) | ((b) << 8) | (c))
>
>As you already pointed out, it's a matter of taste and neither
>of both versions will hurt as it will be expanded at compile time.
>
>Infact, imagine we would add another version level like "(x) << 32",
>on x86 it is only valid to do a left shift operation for 0-31 bits
>and so it could fail...

First, you would use << 24 not << 32 :-)
Even so, << 32 is perfectly valid if you correctly declare it as a
unsigned long long.

>> >+#define XTABLES_VERSION_MAJOR(x)  (((x)>>16) & 0xFF)
>> >+#define XTABLES_VERSION_MINOR(x)  (((x)>> 8) & 0xFF)
>> >+#define XTABLES_VERSION_PATCH(x)  ( (x)      & 0xFF)
>>
>> I do not see a need for these three. The linux kernel does not
>> have such either, so please don't overdesign :)
>
>Well, I've created the same macros as there are already in include/iptables.h.

That's just leftover, they are not used either.

>I'm alright with your proposed change to XTABLES_API_VERSION
>and the drop of _MAJOR, _MINOR and _PATCH macros as
>one can easily check for same thing via "xyz < XTABLES_API_VERSION(2,6,0)"
>
>Attached is an updated patch.

I approve.
