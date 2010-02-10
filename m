From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/4] netfilter: xtables: use xt_table for hook
 instantiation
Date: Wed, 10 Feb 2010 20:43:28 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002102042190.28163@obet.zrqbmnf.qr>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de> <1265813954-13854-4-git-send-email-jengelh@medozas.de> <4B72D069.2040106@trash.net> <alpine.LSU.2.01.1002101705260.12673@obet.zrqbmnf.qr> <4B72DA65.4040308@trash.net>
 <alpine.DEB.2.00.1002102013450.13645@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41590 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184Ab0BJTna (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 14:43:30 -0500
In-Reply-To: <alpine.DEB.2.00.1002102013450.13645@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-02-10 20:26, Jozsef Kadlecsik wrote:
>> 
>> This might actually be a bug. IPv4 uses:
>> 
>> 	NF_IP_PRI_FIRST = INT_MIN,
>> 	NF_IP_PRI_CONNTRACK_DEFRAG = -400,
>> 	NF_IP_PRI_RAW = -300,
>> 	NF_IP_PRI_SELINUX_FIRST = -225,
>> 	NF_IP_PRI_CONNTRACK = -200,
>> 
>> while IPv6 uses:
>> 
>> 	NF_IP6_PRI_FIRST = INT_MIN,
>> 	NF_IP6_PRI_CONNTRACK_DEFRAG = -400,
>> 	NF_IP6_PRI_SELINUX_FIRST = -225,
>> 	NF_IP6_PRI_CONNTRACK = -200,
>> 
>> So we actually defragment packets in IPv4 even though they're
>> untracked. Perhaps Jozsef knows more details why we use
>> different priorities here.
>
>We have to defragment otherwise we could not track and untrack connections 
>at the same time. Fragments don't carry protocol/port so we cannot tell 
>which fragment belongs to a not tracked and which one belongs to a tracked 
>connection.

How so? If I untrack something in the raw table, I would have
assumed it skips all conntracking - including defrag.

Even before defrag, what's wrong with skb->nfct = &the_untracked_conn?
