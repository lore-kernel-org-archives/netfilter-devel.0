From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Move extensions' arguments into compound structure
 (1/2)
Date: Sun, 05 Oct 2008 17:31:09 +0200
Message-ID: <48E8DDBD.20906@trash.net>
References: <alpine.LNX.1.10.0810031851430.13861@fbirervta.pbzchgretzou.qr> <48E8CF70.9090309@trash.net> <alpine.LNX.1.10.0810051036170.21891@fbirervta.pbzchgretzou.qr> <48E8D493.5@trash.net> <alpine.LNX.1.10.0810051054460.21891@fbirervta.pbzchgretzou.qr> <48E8D957.3000803@trash.net> <alpine.LNX.1.10.0810051123470.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47446 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbYJEPbP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 11:31:15 -0400
In-Reply-To: <alpine.LNX.1.10.0810051123470.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-10-05 11:12, Patrick McHardy wrote:
>>> Ok just let me rebase all the stuff, and I'll send you something
>>> that goes on top of 8d51a66159a6fbc27342ee80e5b69910a679735e .
>> Thanks. As an added explanation - the benchmarking I did for nftables
>> indicated that we're somewhere between 50 and 110 cycles for a "usual"
>> rule on my x2. So its really easy to degrade performance significantly
>> by just requiring a few more cycles. The upside is that it works in both
>> directions :)
> 
> Can I at least make it a single patch (i.e. on top of the batch of 6
> that do the minimal transformation) or does it need to be right from
> the start? (at the expensive of enlarging the patch and setting up
> the reviewer ;-)

I'm not sure which batch of 6 you're referring to, but in general
having a lower patch size for these transformations is preferrable
to me; having a slight potential performance degradation that is
fixed up immediately is not a real problem.

I hope that answered your question.

