From: Patrick McHardy <kaber@trash.net>
Subject: Re: ebtables extension 'http'
Date: Mon, 25 Jan 2010 17:50:50 +0100
Message-ID: <4B5DCBEA.5000501@trash.net>
References: <8a87046f1001250546w1dec4136nc509510e8ac15eb8@mail.gmail.com>  <alpine.LSU.2.01.1001251453460.10705@obet.zrqbmnf.qr> <8a87046f1001250632hd4220d1s9f44cad2c3b268a8@mail.gmail.com> <alpine.LSU.2.01.1001251707500.20906@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47470 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab0AYQux (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:50:53 -0500
In-Reply-To: <alpine.LSU.2.01.1001251707500.20906@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2010-01-25 15:32, Felipe W Damasio wrote:
>>> For the same reason:
>>> http://l7-filter.sourceforge.net/FAQ#usage
>>  Right, thanks!
>>
>>  But I just don't see the point of letting all the http traffic flows
>> through squid since it'll only care about a handful of domains...
>>
>>  I don't suppose there is a way  of "putting" the connection back on
>> the forwarding-state on the bridge after ebtables already dropped it
>> on the broute table, is there?
> 
> Once you decided which machine handles the packet stream, it's decided. 
> The twist is, you have to decide when you see the very first packet.

CT actually doesn't really care, it should be possible with TPROXY
if the local socket could be persuaded to close silently.
