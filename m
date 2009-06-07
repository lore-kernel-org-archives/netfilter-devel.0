From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] iptables: accept multiple IP address specifications
 for -s, -d
Date: Sun, 07 Jun 2009 23:12:06 +0200
Message-ID: <4A2C2D26.6000605@netfilter.org>
References: <1244229955-27642-1-git-send-email-jengelh@medozas.de> <1244229955-27642-2-git-send-email-jengelh@medozas.de> <4A2A1260.7050207@netfilter.org> <alpine.LSU.2.00.0906061314330.22992@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49592 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbZFGVtm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Jun 2009 17:49:42 -0400
In-Reply-To: <alpine.LSU.2.00.0906061314330.22992@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Saturday 2009-06-06 08:53, Pablo Neira Ayuso wrote:
>>> 	# ip6tables -I INPUT -s 2001:db8::d,2001:db8::e -j DROP
>>>
>>> References: http://marc.info/?l=netfilter-devel&m=123929790719202&w=2
>> I think this is handy for users so I can find it useful.
>>
>> The only concern that I have with this is that it changes the existing
>> 1:1 mapping between commands and iptables rules. I mean, people may get
>> confused because of this "rule expansion" feature, they may think that
>> we natively support layer 3 address sets? Probably it's a matter of
>> documenting this.
> 
> Hence:
> 
>>> +Multiple addresses can be specified when, but this will \fBreplicate\fP the
>>                                       ^^^^
>> This sentence is incomplete? I suggest to refer to the rule expansion
>> feature.
> 
> Well, I think <b>replicate</b> hits the expansion pretty good.

To replicate means to make a copy, and this is not what this does. But,
to be frank, I really don't care.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
