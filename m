From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: Allow dropping packet after call to
 l4proto->packet
Date: Thu, 12 Mar 2009 17:07:46 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903121707300.13883@fbirervta.pbzchgretzou.qr>
References: <200903121603.02733.christoph.paasch@gmail.com> <1236870826-10054-1-git-send-email-christoph.paasch@gmail.com> <alpine.LSU.2.00.0903121634070.12067@fbirervta.pbzchgretzou.qr> <200903121649.07014.christoph.paasch@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Christoph Paasch <christoph.paasch@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42244 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZCLQHu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:07:50 -0400
In-Reply-To: <200903121649.07014.christoph.paasch@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-12 16:49, Christoph Paasch wrote:
>On Thu March 12 2009 wrote Jan Engelhardt:
>> On Thursday 2009-03-12 16:13, Christoph Paasch wrote:
>> >As NF_DROP = 0, no packets would ever have been dropped.
>>
>> Mh would not it be safer to actually give NF_DROP a real value so that
>> -NF_DROP also makes sense?
>Yes, why not...
>
>> (Might need checking places where NF_DROP is used.)
>NF_DROP is used only in tcp_packet (as far as I can see, no other l4 proto 
>uses it in *_packet)

NF_DROP is also used in net/netfilter/x_tables.c - that's what I meant.
