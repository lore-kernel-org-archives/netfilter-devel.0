From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch] fix compile error in libxt_condition
Date: Thu, 23 Oct 2008 09:14:13 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810230911550.14500@fbirervta.pbzchgretzou.qr>
References: <200810231232.17331.thomas.jarosch@intra2net.com> <alpine.LNX.1.10.0810230815190.14500@fbirervta.pbzchgretzou.qr> <200810231510.23807.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39817 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbYJWNOP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:14:15 -0400
In-Reply-To: <200810231510.23807.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-10-23 09:10, Thomas Jarosch wrote:
>On Thursday, 23. October 2008 14:18:26 Jan Engelhardt wrote:
>> >libxt_condition.c:95: error: static declaration of 'libxt_condition_init'
>> > follows non-static declaration ../include/xtables/internal.h:64: error:
>> > previous declaration of 'libxt_condition_init' was here
>>
>> Does this only hit libxt_condition? Who set the XTABLES_INTERNAL macro
>> to trigger inclusion of xtables/internal.h?
>
>Good question, I manually downloaded libxt_condition from your gitweb as it's 
>the only extension I needed from xtables addons. XTABLES_INTERNAL gets set
>by the "extensions/GNUmakefile" in "regular_CFLAGS".
>A quick grep reveals it gets always defined in configure.ac.

No way.

09:11 nuqneh:~/Coding/xtables-addons > grep -r XTABLES_INTERNAL .
09:11 nuqneh:~/Coding/xtables-addons > 

Wait... you downloaded libxt_condition.c from *xtables-addons*
and put it into the *iptables/* tree? Well, that is not going
to fly on its own. You need the patch of course, but then this
is not an xtables-addons problem.
