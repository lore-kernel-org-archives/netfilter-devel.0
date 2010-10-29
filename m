From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE]: Release of iptables-1.4.10
Date: Fri, 29 Oct 2010 19:58:12 +0200
Message-ID: <4CCB0B34.6030108@trash.net>
References: <4CCAEB8A.5090504@trash.net> <alpine.LNX.2.01.1010291953580.9183@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44245 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab0J2R6O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:58:14 -0400
In-Reply-To: <alpine.LNX.2.01.1010291953580.9183@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 29.10.2010 19:54, schrieb Jan Engelhardt:
> 
> On Friday 2010-10-29 17:43, Patrick McHardy wrote:
> 
>> The netfilter coreteam presents:
>>
>>    iptables version 1.4.10
>>
>> Version 1.4.10 can be obtained from:
>>
>> http://www.netfilter.org/projects/iptables/downloads.html
>> ftp://ftp.netfilter.org/pub/iptables/
>> git://git.netfilter.org/iptables.git
> 
> The v1.4.10 tag seems to not have made it onto the server. :^)
> 

It should be there:

$ hostname
vishnu.netfilter.org

$ git tag -l|grep 1.4.10
v1.4.10
