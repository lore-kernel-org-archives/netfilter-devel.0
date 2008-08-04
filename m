From: Patrick McHardy <kaber@trash.net>
Subject: Re: rfc: reject use of drop in nat table
Date: Mon, 04 Aug 2008 21:08:12 +0200
Message-ID: <4897539C.1080102@trash.net>
References: <alpine.LNX.1.10.0808041252270.27953@fbirervta.pbzchgretzou.qr> <489734F1.8040808@trash.net> <Pine.LNX.4.64.0808042050300.7375@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62287 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761257AbYHDTIQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:08:16 -0400
In-Reply-To: <Pine.LNX.4.64.0808042050300.7375@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Mon, 4 Aug 2008, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> This just happened to be within my thoughts. Comments, declinations?
>> Well, first thought is the usual fear of breaking setups.
>>
>> But I do agree that this makes sense, we've had a number
>> of "bugreports" over the years from people how tried to
>> do filtering in the nat table and didn't realize it only
>> sees the first packet of a connection.
>>
>> Not sure - anyone else with an opinion? :)
> 
> Instead of the line
> 
> +                       exit_error(OTHER_PROBLEM, "The nat table is not for filtering");
> 
> the next one would probably be little bit more user friendly:
> 
> +                       fprintf(stderr, "The nat table is not for filtering, next iptables release won't support it at all. Fix your setup.\n");
> 
> And in the next release it could be changed to 'exit_error'.

That sounds good, lets do that.
