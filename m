From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Wed, 12 Apr 2006 20:30:59 +0200
Message-ID: <443D4763.40903@trash.net>
References: <Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>	<43F43FA9.4000906@trash.net>	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>	<43F4426D.9060807@trash.net>	<Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>	<43F4DBDF.9010008@trash.net>	<442B9765.2020105@ufomechanic.net>	<442C81A6.3040501@trash.net>	<Pine.LNX.4.58.0603312026030.9154@blackhole.kfki.hu>	<442D78A8.4050300@trash.net>	<20060401193138.GG11031@sunbeam.de.gnumonks.org>
	<4434F53A.2030302@trash.net> <443BD4BB.7090806@ufomechanic.net>
	<443BD6B3.8020607@trash.net> <443CA579.3030908@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <443CA579.3030908@ufomechanic.net>
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
> Patrick McHardy wrote:
> 
>>> It's no longer the entry of the next conntrack but the entry of the last
>>> conntrack by the time it gets deleted then...? Or have I misunderstood
>>> the way in which the loop would occur?
>>>   
>>
>>
>> Yes, the loop is interrupted when the skb is full and continued when
>> userspace issues the next recvmsg(). The reference is kept to find
>> the point where to continue.
>>  
>>
> Did you mean "yes, you misunderstood" or "yes, good idea"?

Yes, you misunderstood :)

> I thought that what would theoretically cause the problem if the
> next-conntrack is deleted was the fact that conntrack-put is called
> before ctnetlink_fill_info.

Its only a marker, once we have found it in the list we don't
need that reference anymore.

> The problem may not be entirely theoretical if the conntrack is being
> deleted by a userspace conntrack client in response to what it reads
> when enumerating conntracks. (The conntrack may spring back into
> existance as an resurrected established connection - and also may
> therefore be likely in the case of a full contrack table where
> connections flip-flop their resurrected conntrack entry,
> Rather than issue warnings to conntrack developers to avoid certain
> kinds of design, it would be better to avoid this.

The marker points to the next entry that beed dumped yet, so
enumerate-and-delete won't affect it. It is also not the
ID of the connection but the pointer to the conntrack entry
that is used, so resurrections don't affect it in any way.

The problem is in my opinion purely theoretical so far:

- the bucket beeing dumped must contain enough entries to exceed
  the size of a single netlink message (very unlikely)

- when continuing to dump, the entry we wanted to dump next
  must be gone - and there must still be enough entries in the
  bucket to exceed the skb.

For an endless loop we must have a steady refill of the bucket
with new conntrack entries, otherwise at some point it won't
exceed the skb anymore and we can move on to the next bucket.
The jenkins hash should prevent this situation.
