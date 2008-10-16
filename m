From: Patrick McHardy <kaber@trash.net>
Subject: Re: arptables and the generic xtables issues
Date: Thu, 16 Oct 2008 15:23:38 +0200
Message-ID: <48F7405A.2050302@trash.net>
References: <48F69C2A.8010001@netfilter.org> <alpine.LNX.1.10.0810152151070.28060@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34002 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbYJPNXn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 09:23:43 -0400
In-Reply-To: <alpine.LNX.1.10.0810152151070.28060@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-10-15 21:43, Pablo Neira Ayuso wrote:
>> Currently, we have tagged quite a lot of targets and matches with
>> AF_UNSPEC as they are generic for the netfilter supported protocols.
>> This is fine if we only think of ebtables, iptables and ip6tables but
>> not for arptables, I doubt that all those target and matches can work
>> with arptables - even if we still need the userspace support, of course.
>>
>> I think that we should fix those, right?
> 
> That would be a tremendous amount of work, given that arptables (and
> ebtables too) is not quite the same codebase as iptables anymore.
> Most of the iptables development just went by arp and ebtables due
> to the nature of all these semiforks.
> 
> I think we should rather focus on a truly family-independent table
> in the very near future. In fact I have ideas floating around that,
> but am stuck with how I'd exactly funnel it into reviewable patch
> chunks.

I think we should finish the unification/resyncing efforts before
adding new features in this area. There's still *a lot* of old
cruft that could probably be removed.
