From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: several messages
Date: Mon, 9 Feb 2009 22:44:47 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902092242460.26793@fbirervta.pbzchgretzou.qr>
References: <1234213032.20903.13.camel@dogo.mojatatu.com>  <alpine.LSU.2.00.0902092202020.25199@fbirervta.pbzchgretzou.qr> <1234214841.20903.27.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39397 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZBIVos (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:44:48 -0500
In-Reply-To: <1234214841.20903.27.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>







On Monday 2009-02-09 22:27, jamal wrote:
>On Mon, 2009-02-09 at 22:04 +0100, Jan Engelhardt wrote:
>> 
>> I do not think a library should call exit() and cause the main program 
>> to terminate; 
>> to this end it might be best to add a
>> 
>> 	void (*exit_error)(..
>> 
>> function pointer to the xtables_global struct you are proposing.
>
>Thanks for the suggestion - it sounds reasonable. 
>Note, however, grep says there are about 700 references  to exit_error()
>- so my intent of moving it into xtables.c is for usability more than
>anything.

Hm you are right; much of the code assumes that exit_error()
never returns. We need to stick to that for the time being.

>> If you could convert iptables.c and friends to also make use of this, 
>> that'd be great.
>
>There are only 3 definitions as far as i can see. If i can convert those
>to use that global struct then I should be able to compile that basic
>program.

Yep.
