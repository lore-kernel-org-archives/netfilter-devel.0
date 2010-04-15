From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
 	finding.
Date: Thu, 15 Apr 2010 17:05:15 +0200
Message-ID: <4BC72B2B.9010104@trash.net>
References: <4BBEA97A.5020303@gmail.com> <1271162669.16881.301.camel@edumazet-laptop> 	<r2q412e6f7f1004130609we90ce635u673ba882b8b50f50@mail.gmail.com> 	<1271164991.16881.346.camel@edumazet-laptop> <4BC470B3.4030007@trash.net> 	<h2n412e6f7f1004142353uac023edfqc59d076c0d8a1784@mail.gmail.com> 	<4BC6EC15.4070205@trash.net> <t2t412e6f7f1004150735l54619e32t3e7fcdce7b118bd9@mail.gmail.com> 	<4BC72572.1050507@trash.net> <4BC726B4.1030003@trash.net> <j2w412e6f7f1004150801m66503602wbd0296c09aa45e90@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33361 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab0DOPFR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:05:17 -0400
In-Reply-To: <j2w412e6f7f1004150801m66503602wbd0296c09aa45e90@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> On Thu, Apr 15, 2010 at 10:46 PM, Patrick McHardy <kaber@trash.net> wrote:
>> Patrick McHardy wrote:
>>> That should be easily fixable. For the lookup we can add a reference
>>> counter so we don't need the rcu read side critical section.
>> Actually we don't even need that, since we're holding nfnl_mutex the
>> instance can't go away.
>>
> 
> I don't think so. a netlink queue instance maybe destroyed by
> nfqnl_rcv_nl_event(). And the function is called by netlink directly
> without nfnl_mutex.

No its not:

static void nfnetlink_rcv(struct sk_buff *skb)
{
	nfnl_lock();
	netlink_rcv_skb(skb, &nfnetlink_rcv_msg);
	nfnl_unlock();
}

