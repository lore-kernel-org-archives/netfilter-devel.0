From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] libnfnetlink and iface conversion to string
Date: Tue, 09 Jan 2007 11:22:06 +0100
Message-ID: <45A36CCE.3060109@trash.net>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Vincent Deffontaines <vincent@inl.fr>, Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <45940145.3020003@netfilter.org>
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
> Eric Leblond wrote:
> 
>>I'm currently working on NuFW where I try to do iface conversion from
>>integer to string to be able to filter "naturally" on interfaces.
>>
>>For now, it is impossible to do this conversion from either
>>libnetfilter_queue or libnfnetlink. But there is two files in
>>libnfnetlink (iftable.c and rntl.c) which have been put here by Harald
>>to provide this conversion (if I remember correctly an old mail from
>>Harald).
>>
>>It was a long time ago and I don't know if it still planned to modify
>>libnfnetlink to include this feature. Or, would it be a better choice to
>>create a new library dedicated to this conversion.

There already is libnl .. it may be a bit overkill if all you
need is ifindex<->ifname conversion though.

> Interesting question. Since this is related with the rtnetlink
> subsystem, I'm unsure that this feature naturally belongs to
> libnfnetlink nor to libnetfilter_queue.
> 
> However, IMO libnetfilter_queue should provide enough features to let
> userspace apps implement filtering without requiring extra dependencies.

Agreed, this would be a good addition in my opinion. Probably
better to keep in it libnfnetlink since that doesn't require
people to unnecessarily link libnfnetlink_queue just for this.
