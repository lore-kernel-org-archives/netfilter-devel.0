From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/1] Conntrack event generation control, kernel part
Date: Thu, 14 May 2009 12:44:19 +0200
Message-ID: <4A0BF603.9090600@netfilter.org>
References: <alpine.DEB.2.00.0905121348460.28379@blackhole.kfki.hu> <4A097752.4030303@netfilter.org> <alpine.DEB.2.00.0905121524020.28379@blackhole.kfki.hu> <4A098B7F.6050605@netfilter.org> <4A0BE512.9010003@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56478 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbZENK3m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 May 2009 06:29:42 -0400
In-Reply-To: <4A0BE512.9010003@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Hi Jozsef,
> 
> Pablo Neira Ayuso wrote:
>> I see, but something similar to nfnetlink_queue/NFQUEUE (per-process)
>> together with an extended version of the `conntrack match' for events
>> would be more flexible
> 
> Another very simple choice can be to add more multicast groups according 
> to the sort of events. We can get more fine grain event selection while 
> keeping it per-process. Currently, there's only three sort of events: 
> NEW, UPDATE and DESTROY. We can add more netlink multicast groups to 
> allow user-space to select what kind of events they are interested.

netlink doesn't seem to support overlapping event groups, and UPDATE and 
ASSURED groups would overlap. Thus, we'll need to call 
netlink_broadcast() twice. I still don't find a non-intrusive way to do 
some non-BPF-based filtering :(

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
