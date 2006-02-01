From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: expectation mask handling in nfctnetlink (Was Re: [PATCH] fix
 nf_conntrack_netlink expectation dumping/event notification)
Date: Wed, 01 Feb 2006 03:09:21 +0100
Message-ID: <43E01851.4040306@netfilter.org>
References: <200601130938.k0D9c6ud007984@toshiba.co.jp>	<43C78C3C.6080707@netfilter.org>	<200601151307.k0FD7evx014168@toshiba.co.jp>
	<200601200457.k0K4vvAI001787@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200601200457.k0K4vvAI001787@toshiba.co.jp>
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

Hi Yasuyuki,

I'd like to recover this thread.

Yasuyuki KOZAKAI wrote:
>>I feel strange to find l3proto with 0xffff as address family or to find proto
>>with 0xff as protocol number.
>>
>>After all, ctnetlink_dump_tuples() gets nf_conntrack_l3proto_generic /
>>nf_conntrack_proto_generic and they doesn't fill any contents, right ?
>>
>>If so, I think that it's better to make ctnetlink_exp_dump_expect() use
>>l3proto/proto for &exp->tuple to dump &exp->mask, and then
>>we would not need to remove above unlikely().
> 
> I've re-visited this. For now, I'm not sure this is the best solution
> because I don't see how format and contents of expectation mask
> is required by libnetfilter_conntrack. It doesn't use dumped expectation
> mask at all.

Maybe userspace helpers could need that information some day. I don't
want to add limitations to libnetfilter_conntrack just because we have
some assumptions.

> Then the other idea can be considerd, too. For example, dumping union of
> l3part(mask->u3.all) and union of proto part(mask->u.all) without assumption
> of specific address family/protocol. Do you have any idea on this ?

We shouldn't send the whole union via netlink. If the union is modified
further, it will break backward compatibility for userspace applications
since the size could change.

So, the possibilities I see up to now are:

a) just remove the unlikely() statement.
Drawback: Not so efficient, since that checking isn't always required.

b) back to my idea: set l3num to the maximum known value (0x1F), and add
a bug trap in nf_ct_expect_related to check that nobody uses a value >=
AF_MAX.
Drawback: People surely will hit bug while writing their own helpers.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
