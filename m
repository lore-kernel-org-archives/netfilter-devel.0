From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: expectation mask handling in nfctnetlink (Was Re: [PATCH] fix
 nf_conntrack_netlink expectation dumping/event notification)
Date: Fri, 20 Jan 2006 13:57:56 +0900 (JST)
Message-ID: <200601200457.k0K4vvAI001787@toshiba.co.jp>
References: <200601130938.k0D9c6ud007984@toshiba.co.jp>
	<43C78C3C.6080707@netfilter.org>
	<200601151307.k0FD7evx014168@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
In-Reply-To: <200601151307.k0FD7evx014168@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi, Pablo,

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Sun, 15 Jan 2006 22:07:39 +0900 (JST)

> I feel strange to find l3proto with 0xffff as address family or to find proto
> with 0xff as protocol number.
> 
> After all, ctnetlink_dump_tuples() gets nf_conntrack_l3proto_generic /
> nf_conntrack_proto_generic and they doesn't fill any contents, right ?
> 
> If so, I think that it's better to make ctnetlink_exp_dump_expect() use
> l3proto/proto for &exp->tuple to dump &exp->mask, and then
> we would not need to remove above unlikely().

I've re-visited this. For now, I'm not sure this is the best solution
because I don't see how format and contents of expectation mask
is required by libnetfilter_conntrack. It doesn't use dumped expectation
mask at all.

Then the other idea can be considerd, too. For example, dumping union of
l3part(mask->u3.all) and union of proto part(mask->u.all) without assumption
of specific address family/protocol. Do you have any idea on this ?

BTW, Harald, I have not read your userspace conntrack helper yet, but I think
that this issue might relate to it, too.

Regards,

-- Yasuyuki Kozakai
