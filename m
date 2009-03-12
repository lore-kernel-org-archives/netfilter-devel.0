From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Allow dropping packet after call to l4proto->packet
Date: Thu, 12 Mar 2009 18:27:03 +0100
Message-ID: <49B945E7.7080203@netfilter.org>
References: <200903121603.02733.christoph.paasch@gmail.com> <1236870826-10054-1-git-send-email-christoph.paasch@gmail.com> <alpine.LSU.2.00.0903121634070.12067@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christoph Paasch <christoph.paasch@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41743 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755000AbZCLR1M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:27:12 -0400
In-Reply-To: <alpine.LSU.2.00.0903121634070.12067@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-03-12 16:13, Christoph Paasch wrote:
> 
>> As NF_DROP = 0, no packets would ever have been dropped.
> 
> Mh would not it be safer to actually give NF_DROP a real value so that 
> -NF_DROP also makes sense?
> (Might need checking places where NF_DROP is used.)

We cannot change the current value of NF_DROP. This is exposed to
userspace in libnetfilter_queue. Changing the value would break backward
compatibility of existing applications.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
