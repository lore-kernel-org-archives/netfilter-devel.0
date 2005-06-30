From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Thu, 30 Jun 2005 03:00:53 +0200
Message-ID: <42C34445.9020709@trash.net>
References: <42C03F2E.30706@eurodev.net> <42C0806E.3010400@trash.net>
	<20050628071308.GE13239@sunbeam.de.gnumonks.org>
	<42C1747A.3010703@trash.net> <42C2F2DF.7070301@eurodev.net>
	<42C2FC14.80609@trash.net> <42C33E33.7090908@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42C33E33.7090908@eurodev.net>
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

Pablo Neira wrote:
> Patrick McHardy wrote:
>>
>> I think its fine, but CTA_PROTO_IPV4_{SRC,DST} should be
>> CTA_PROTO_{SRC,DST}, there's nothing related to IPv4 in them.
> 
> 
> That could be fine for nf_conntrack to differenciate between conntracks
> that represents an ipv4 and ipv6 connections.
> 
> CTA_PROTO_IPV4_SRC and CTA_PROTO_IPV6_SRC

It can do that by looking at the IP attributes (CTA_ORIG_IPV4_SRC and
CTA_IPV6_SRC).

>> Please nest all attributes related to a tuple in CTA_TUPLE
>> instead of adding them to the top-level.
> 
> Sorry, how that will look like?

You add a new nfattr header with the type set to CTA_TUPLE and
note the position of skb->tail. Then you add the nested attributes
as usual. When you're done you set the length of the nfattr header
to skb->tail - old_tail. The RTA_NEST/RTA_NEST_END macros handle
this for rtnetlink (include/linux/rtnetlink.h).

Regards
Patrick
