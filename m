From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: arbitrary address mask matching
Date: Mon, 10 Aug 2009 17:12:29 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908101711030.15342@fbirervta.pbzchgretzou.qr>
References: <4A7F5CF1.8030708@gmail.com> <4A7FDEFA.3020009@plouf.fr.eu.org> <4A7FE32B.4040409@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: "Christoph A." <casmls@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50991 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbZHJPMa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:12:30 -0400
In-Reply-To: <4A7FE32B.4040409@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-08-10 11:06, Christoph A. wrote:
>On 10.08.2009 10:48, Pascal Hambourg wrote:
>>> iptables -A OUTPUT -d 10.10.97.1/255.255.255.253 -m iprange --dst-range
>>> 10.10.97.1-10.10.97.7 -j REJECT
>>>
>>> this should match on 10.10.97.1,3,5,7 but matches only 1 and 3
>> 
>> 253 is binary 11111101, so this is the expected behaviour.
>> BTW, what is the use of iprange in this rule ?
>
>The rule is mainly a copy n paste from
>http://jengelh.medozas.de/documents/Perfect_Ruleset.pdf page 7 (just
>changing the input to output direction)
>
>to get the desired/described behaviour one should set this mask:
>255.255.255.1
>
>the line
>-A INPUT -s 10.10.97.1/255.255.255.253
>
>should be changed to
>-A INPUT -s 10.10.97.1/255.255.255.1
>
>Jan, would you correct this in the paper (if you agree with my
>correction of the mask)

Nope, the example should really read 255.255.255.249. Here's why:

10.10.97.1 <=> 10.10.97.0b00000001
10.10.97.3 <=> 10.10.97.0b00000011
10.10.97.5 <=> 10.10.97.0b00000101
10.10.97.7 <=> 10.10.97.0b00000111
                          XXXXX--X

All the X bits are static, and 11111001 is 249.


thanks for noticing the errneous 253,
Jan
