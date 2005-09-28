From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [ANNOUNCE] Release of nf-HiPAC 0.9.0
Date: Wed, 28 Sep 2005 21:46:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0509282125120.8767@filer.marasystems.com>
References: <200509260441.42483.mbellion@hipac.org>
	<433AA30E.7060709@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <433AA30E.7060709@ufomechanic.net>
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

On Wed, 28 Sep 2005, Amin Azez wrote:

> Does it also remove the "upload rules in bulk" issue of iptables and
> make use of links lists (or trees) to upload small changes singly?

Yes. nf-HiPAC uses netlink messages for rule updates, carrying just the 
updates. It does not exchange complete rulesets on each update like 
iptables does.

> I recall someone released a re-write a while ago that took care of this, 
> but this seems to do rule-factoring too to reduce the number of check 
> operations.

iptables per definition must always send a whole new iptable (compiled 
ruleset) to the kernel as one big blob as it is the userspace who 
constructs the iptable and the kernel has no knowledge (or capability) to 
modify an iptable inplace, only replace it with another submitted by 
userspace.

As nf-HiPAC is using another internal representation of the rules it does 
not need this, and the updates carry only the rules you are updating.

> Speaking under fear of blasphemy I'm wondering what stops this becoming
> iptables proper?

Not much. It is already very near a full replacement of iptables filter 
table. It does not yet have support for the other table types but it's 
trivial to add. The nat table has to wait for the completetion of the 
restructuring of the nat code currently taking place however, but after 
2.6.14 this should not be a problem to implement from what I have 
understood. The problem currently is that the nat core nat is very tightly 
coupled with iptable_nat, but this is being addressed already by the 
Netfilter team.

> OK, it would want linking to nf_conntrack instead of ip_conntrack

This should be trivial. The optional conntrack dependency is already well 
isolated in a separate very small module. Some of this isolated code 
obviously needs to be changed when using nf_conntrack but not much.

> and a v6 version doing type stuff, but it seems the biz.

IPv6 requires a bit more work due to the larger key size in 
source/destination addresses. HiPAC currently only implements up to 32-bit 
lookup dimensions (source/destination/protocol/ports etc..).

Regards
Henrik
