From: Patrick McHardy <kaber@trash.net>
Subject: Re: aggg Re: libnfnetlink_conntrack encapsulation issues
Date: Thu, 27 Jul 2006 16:32:22 +0200
Message-ID: <44C8CE76.2090500@trash.net>
References: <44C89B2E.1080401@ufomechanic.net>
	<44C89DD8.7030103@ufomechanic.net> <44C8C6E1.8010004@trash.net>
	<44C8CC58.1080909@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44C8CC58.1080909@ufomechanic.net>
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

Amin Azez wrote:
> * Patrick McHardy wrote, On 27/07/06 15:00:
> 
>>it appears the layer7 match does some
>>bad hacks here. 
> 
> Thats my layer7 stuff.
> I recognize that ifdef's here are no good because the file is used for
> userspace, which doesn't solve the general problem of adding conntrack
> attributes generally (which I've been doing for the last 15 months). The
> current mechanism effectively ensures that this cannot happen (sadly)

One way to add new stuff is to get your patch into the kernel. Other
than that its hard, I agree. ifdefs are not a good idea because
following members don't have a constant value anymore.

>>It looks like a really dumb idea, this will break
>>once we add new attributes. Not sure why a match would need ctnetlink
>>attributes.
>>  
> 
> Some matches (like layer7) store state which is output via
> /proc/net/ip_conntrack, I also need it as part of conntrack updates.
> I like receiving a conntrack update when the layer7 is detected, for
> instance.

A match shouldn't do that - what kind of state does it store? Can't
you just use your match and combine it with CONNMARK?

> I also output the link layer mac addresses as part of conntrack dumps/

The LL address is not part of the conntrack entry and can change at any
time, so it doesn't belong in ctnetlink.
