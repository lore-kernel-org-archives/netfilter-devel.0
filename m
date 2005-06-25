From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC][PATCH] kill the fake conntrack
Date: Sat, 25 Jun 2005 20:47:50 +0200
Message-ID: <42BDA6D6.5070604@eurodev.net>
References: <42BD513E.6090306@eurodev.net> <42BD52A7.2090107@trash.net>
	<42BD5829.4030002@eurodev.net> <42BD5C41.2080505@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42BD5C41.2080505@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira wrote:
> 
>>Patrick McHardy wrote:
>>
>>
>>>What is the advantage of this patch?
>>
>>Whenever we work with conntracks, we always have to check if it's the
>>fake or not previously. For example, a bad use of NOTRACK together with
>>other targets, say ipt_CONNMARK, that doesn't currently check if it's
>>working with the fake conntrack or not. Same thing for NAT handlings, I
>>see that this can result in weirdness.
>>
>>Setting nfct to NULL will make NAT targets, conntrack helpers and
>>friends just ignore untracked packets, so we could forget about making
>>sure that we aren't messing with the fake conntrack.
> 
> 
> Sounds reasonable - but couldn't we simply change ip_conntrack_get
> to return NULL for untracked connections?

Then I won't be able to differenciate between invalid and untracked 
connections. So I'd need to return some extra info via ctinfo to achieve 
it, something in ip_conntrack_get like:

if (ct == &ip_conntrack_untracked)
	ctinfo = IP_CT_UNTRACKED

Well, but we'll still need the fake conntrack.

>>>Its changing the assumption
>>>that skb->nfctinfo is only valid if skb->nfct is set, so you probably
>>>need to set nfctinfo to 0 in nf_reset as well. This alone is a reason
>>>not to do it IMO.
>>
>>why need to set nfctinfo to 0 in nf_reset? since skb->nfct is NULL
>>nf_reset shouldn't be ever called. With the logic I'm proposing, this
>>packet will be handle just like invalid ones, so it will be just ignored.
> 
> 
> nf_reset is called independant of the contents of skb->nfct. nfctinfo
> needs to be set to 0 so a packet isn't untracked afterwards anymore.
> Think of tunnel devices.

OK. Hm, do you still consider that bad adding a line to nf_reset to 
reset skb->nfctinfo? This is the only drawback I see at the moment.

--
Pablo
