From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 4/4] iptables: libxt_owner
Date: Sun, 25 Nov 2007 16:55:26 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711251623160.9477@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711250204360.25644@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711250206430.25644@fbirervta.pbzchgretzou.qr>
 <4749932A.4010902@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60248 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbXKYPz1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 10:55:27 -0500
In-Reply-To: <4749932A.4010902@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 25 2007 16:22, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> +static void owner_mt_help(void)
>> +{
>> +	printf(
>> +"owner match v%s options:\n"
>> +"[!] --uid-owner userid     Match local UID\n"
>> +"[!] --gid-owner groupid    Match local GID\n"
>> +"[!] --socket-exists        Match if socket exists\n"
>> +"[!] --filp-exists          Match if filp exists\n"
>> +"\n",
>> +IPTABLES_VERSION);
>
> The filp-exists option strikes me as useless, what would the
> use case be? For the socket-exists option, I'd prefer for the
> owner match to simply accept no further option, i.e. "-m owner".
>


hasSocket hasFilp whatCouldItBe
===============================
       0       0  forwarded packet
       1       0  ping, nfs client, nfsd
       1       1  real connection

However, you mentioned that encapsulated (socket=1,filp=1) traffic
will show up without a "socket", but did you actually mean socket
or filp?

I just checked, and xfrm'ed traffic has the same properties as before 
the transformation.

So actually socket-exists is the useless one, as there is always a 
socket in any normal case.

What do you think?



