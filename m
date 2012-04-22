From: "alois.klingler@chello.at" <alois.klingler@chello.at>
Subject: Re: wrong order of received packets/bytes and sent packets/bytes
 with local incoming connections
Date: Sun, 22 Apr 2012 19:25:07 +0200
Message-ID: <4F943EF3.6030808@chello.at>
References: <4F92FD5F.5010204@chello.at> <alpine.LNX.2.01.1204221749230.24779@frira.zrqbmnf.qr>
Reply-To: alois.klingler@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep11.mx.upcmail.net ([62.179.121.31]:39993 "EHLO
	fep11.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2DVRZL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Apr 2012 13:25:11 -0400
In-Reply-To: <alpine.LNX.2.01.1204221749230.24779@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 04/22/2012 05:55 PM, Jan Engelhardt wrote:
> On Saturday 2012-04-21 20:33, alois.klingler@chello.at wrote:
>
>    
>> in /proc/net/nf_conntrack (and also in conntrack -L) i can see received
>> packets/bytes and sent packets/bytes.
>> with connections, which are local incoming connections (i.e. a
>> ssh-connection from anywhere to my machine) these fields are mixed,
>> means that the received packets/bytes are the sent packets/bytes and vice
>> versa.
>>
>> with local outbound connections or forwarding connections these fields
>> are correct filled.
>>
>> is there anywhere a configuation option to fix this?
>>      
> I do not see any error here. The first bytes/packet= field shows
> bytes flowing in the "original direction", and the other
> is the reply direction.
>
>    
got it, it was my mistake ... thanks. ;)

Alois
