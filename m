From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC][PATCH] kill the fake conntrack
Date: Sat, 25 Jun 2005 15:12:09 +0200
Message-ID: <42BD5829.4030002@eurodev.net>
References: <42BD513E.6090306@eurodev.net> <42BD52A7.2090107@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42BD52A7.2090107@trash.net>
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
>>The patch attached kills the fake conntrack and propose a new logic to
>>explicitely set connection as untracked. We set nfct to NULL and use a
>>new flag called IP_CT_UNTRACKED for nfctinfo. I've slightely tested it
>>here and works fine.
>>
>>Comments welcome.
> 
> What is the advantage of this patch?

Whenever we work with conntracks, we always have to check if it's the 
fake or not previously. For example, a bad use of NOTRACK together with 
other targets, say ipt_CONNMARK, that doesn't currently check if it's 
working with the fake conntrack or not. Same thing for NAT handlings, I 
see that this can result in weirdness.

Setting nfct to NULL will make NAT targets, conntrack helpers and 
friends just ignore untracked packets, so we could forget about making 
sure that we aren't messing with the fake conntrack.

> Its changing the assumption
> that skb->nfctinfo is only valid if skb->nfct is set, so you probably
> need to set nfctinfo to 0 in nf_reset as well. This alone is a reason
> not to do it IMO.

why need to set nfctinfo to 0 in nf_reset? since skb->nfct is NULL 
nf_reset shouldn't be ever called. With the logic I'm proposing, this 
packet will be handle just like invalid ones, so it will be just ignored.

--
Pablo
