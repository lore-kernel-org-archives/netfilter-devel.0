From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 1/1] Re: dangerous? Setting mark in nat table
Date: Wed, 14 Mar 2007 14:11:59 +0000
Message-ID: <45F802AF.6010307@ufomechanic.net>
References: <et6fp4$l04$1@sea.gmane.org>
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>
	<45F6CD7C.40708@ufomechanic.net>
	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
	<1173868532.26913.39.camel@henriknordstrom.net>
	<45F7D657.8070907@trash.net>
	<1173876211.26913.73.camel@henriknordstrom.net>
	<45F7F027.9050300@ufomechanic.net> <45F7F3C6.3060908@trash.net>
	<Pine.LNX.4.64.0703141415200.26704@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Henrik Nordstrom <henrik@henriknordstrom.net>,
	Patrick McHardy <kaber@trash.net>, Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0703141415200.26704@blackhole.kfki.hu>
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

* Jozsef Kadlecsik wrote, On 14/03/07 13:21:
> Hi,
>
> On Wed, 14 Mar 2007, Patrick McHardy wrote:
>
>> Amin Azez wrote:
>>> Signed-off-by: Sam Liddicott <azez@ufomechanic.net>
>>> ------------------------------------------------------------------------
>>>
>>>
>>> Index: linux-2.6.17.1/net/netfilter/xt_CONNMARK.c
>>> Index: linux-2.6.17.1/net/netfilter/xt_MARK.c
>>
>> There are quite a few more that are restricted to mangle without
>> good reason:
>>
>> net/netfilter/xt_CLASSIFY.c: .table = "mangle",
>> net/netfilter/xt_CONNSECMARK.c: .table = "mangle",
>> net/netfilter/xt_DSCP.c: .table = "mangle",
>> net/netfilter/xt_MARK.c: .table = "mangle",
>> net/netfilter/xt_SECMARK.c: .table = "mangle",
>> net/ipv4/netfilter/ipt_ECN.c: .table = "mangle",
>> net/ipv4/netfilter/ipt_TOS.c: .table = "mangle",
>> net/ipv4/netfilter/ipt_TTL.c: .table = "mangle",
>> net/ipv6/netfilter/ip6t_HL.c: .table = "mangle",
>>
>> If we're going to remove this, I think we should do it for all of them.
>
> Sorry, but I disagree. The DSCP, ECN, TOS, TTL, HL targets modify the
> packet itself and thus all belong to the mangle table alone.
I'd like to be with Jozsef on that (while we have the current framework,
although I hate the mangle/filter distinction) except that local-out
packets at least have a FILTER after DNAT before routing, but
bridged/routed packets don't have anything betweenPREROUTING DNAT and
routing. With the current framework we could do with a FILTER and MANGLE
both before and after NAT on PREROUTING and communicate using marks.

However, to me, NAT is just a 1-packet MANGLE; and FILTER and MANGLE are
an arbitrary distinction.

It would make more sense to have only 1 table and let users invent
NAT/MANGLE/FILTER chains if they wanted (for old times sake); and just
treat snat and dnat targets as if they had an implicit "-m ctstate
--ctstate NEW".

Am I right, or do tables still help?

Sam
