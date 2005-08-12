From: "Eric Leblond" <eric@inl.fr>
Subject: Re: [PATCH] message parsing functions for nfqueue
Date: Fri, 12 Aug 2005 10:42:56 +0200 (CEST)
Message-ID: <11702.195.25.48.253.1123836176.squirrel@mail.inl.fr>
References: <1123794106.4980.11.camel@porky> <42FBFBAD.8020807@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	Vincent Deffontaines <vincent@inl.fr>, Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <42FBFBAD.8020807@netfilter.org>
To: "Pablo Neira" <pablo@netfilter.org>
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

> Eric Leblond wrote:
>> This is a patch against libnfnetlink_queue.
>>
>> It adds "high" level functions to access to the data contained in a
>> nfqueue message. These are mostly encapsulation of NFA macros.

> Instead of adding a function to access every attribute like above, why
> don't we add something more generic in libnfnetlink? Like the following
> macros:
>
> Maybe too generic ?

In a way, yes, you will only access to things one at a time, and when you
want the payload you also want to know its size.
But I think such functions are needed to be able to have an evolving API.
I will try to work on it.

> OTOH, if we add such high level functions we'll have to do the same in
> other libnfnetlink_* libraries to keep homogeneity of the API.

yes ...
