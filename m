From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Mon, 2 Jun 2008 00:09:30 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806012336000.4055@fbirervta.pbzchgretzou.qr>
References: <483AB493.6010503@trash.net> <200805300933.53869.thomas.jarosch@intra2net.com> <alpine.LNX.1.10.0805301007120.19264@fbirervta.pbzchgretzou.qr> <48430FB5.3070302@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52879 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYFAWJc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2008 18:09:32 -0400
In-Reply-To: <48430FB5.3070302@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-06-01 23:08, Patrick McHardy wrote:
>> 
>> I assume people would not be amused if we start requiring perl.
>> But you can use it as a workaround...
>>  perl -ne 'print$&if/\b[A-Z0-9]+\b/'
>
> What exactly is that grep supposed to do? How about sed
> or awk?
>
It should grep all uppercase-only names from the module name list.
grep seems more lightweight, I would not bother with awk.
