From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Mon, 02 Jun 2008 11:09:37 +0200
Message-ID: <4843B8D1.4070402@trash.net>
References: <483AB493.6010503@trash.net> <200805300933.53869.thomas.jarosch@intra2net.com> <alpine.LNX.1.10.0805301007120.19264@fbirervta.pbzchgretzou.qr> <48430FB5.3070302@trash.net> <alpine.LNX.1.10.0806012336000.4055@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61525 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYFBJJn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:09:43 -0400
In-Reply-To: <alpine.LNX.1.10.0806012336000.4055@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-06-01 23:08, Patrick McHardy wrote:
>>> I assume people would not be amused if we start requiring perl.
>>> But you can use it as a workaround...
>>>  perl -ne 'print$&if/\b[A-Z0-9]+\b/'
>> What exactly is that grep supposed to do? How about sed
>> or awk?
>>
> It should grep all uppercase-only names from the module name list.
> grep seems more lightweight, I would not bother with awk.


Well, working properly takes precendence in my opinion.
I don't want to mess with this myself, but I'd apply a
patch to either use awk as fallback or unconditionally
if that works better.


