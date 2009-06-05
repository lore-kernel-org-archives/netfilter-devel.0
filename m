From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Passive OS fingerprint xtables match.
Date: Fri, 5 Jun 2009 15:44:21 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906051541410.10429@fbirervta.pbzchgretzou.qr>
References: <20090604162212.GA24661@ioremap.net> <4A290767.6080202@trash.net> <alpine.LSU.2.00.0906051508300.17010@fbirervta.pbzchgretzou.qr> <4A291DE5.9040802@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Evgeniy Polyakov <zbr@ioremap.net>, netdev@vger.kernel.org,
	David Miller <davem@davemloft.net>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52806 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZFENoT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:44:19 -0400
In-Reply-To: <4A291DE5.9040802@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-06-05 15:30, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> On Friday 2009-06-05 13:54, Patrick McHardy wrote:
>>   
>>>> +
>>>> +		if (optsize > sizeof(opts))
>>>> +			optsize = sizeof(opts);
>>>>       
>>> How can this happen? The doff field can only represent up to 40
>>> bytes of option length.
>>>     
>>
>> Forged packets?
>
>How would that increase the size of the doff field? :)

Ah never mind. Just had to read the RFC... again.
