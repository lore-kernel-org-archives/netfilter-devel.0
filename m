From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: NAT configuration over ctnetlink
Date: Wed, 03 May 2006 15:40:11 +0200
Message-ID: <4458B2BB.8000407@trash.net>
References: <4451BA40.4050207@trash.net> <445388B9.2010308@netfilter.org>
	<4457677D.7060607@trash.net> <44578E0C.5070705@netfilter.org>
	<4457926D.5010209@trash.net> <4457EBF9.3080606@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4457EBF9.3080606@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
> 
>>Pablo Neira Ayuso wrote:
>>
>>
>>>>I don't know. I would prefer to just remove it. Since the library
>>>>takes all parameters as arguments to a single function (one more
>>>>thing I definitely don't like), compatibility of the library will
>>>>break anyway when we add support for multiple manips. Do you really
>>>>think its worth keeping around?
>>>
>>>Not really, if it's trash better remove this sooner than later. Now that
>>>we are going to break backward compatibility, please let me know if you
>>>don't like anything else that we could change at this point.
>>
>>One thing that would make a lot of sense is to change or introduce a new
>>interface in libnetfilter_conntrack that allows to add netfilter
>>attributes to a conntrack "object" one at a time, so we don't have to
>>change function prototypes each time we're introducing something new.
> 
> 
> what do you think about the incomplete patch attached? Still missing the
> getters and the expectations.
> 
> I think that with the setters/getters we can make private nfct_conntrack
> and friends.

This goes even further than what I meant :) I'll have a closer look,
but probably going to take a bit, I'm quite busy currently.

Another item I would like to bring up for discussion is whether we
want to continue with (some) of these libraries at all. For a small
pet-project of mine I've been working a bit on Thomas Graf's libnl,
which provides a very nice netlink infrastructure, support for
basically all kernel netlink interfaces, nice object representation
of the individual items, cache management for replication of kernel
databases, and quite a few things more. Besides lots of nice
infrastructure, one main advantage of using libnl would be that
there is a single library which can be used for communication with
any kernel subsystem using netlink in a uniform way.

Comments?
