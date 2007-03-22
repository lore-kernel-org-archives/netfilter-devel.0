From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFNL_NFA_NEST
Date: Thu, 22 Mar 2007 14:18:58 +0100
Message-ID: <46028242.4090609@netfilter.org>
References: <4600BDBB.8020205@trash.net> <4601B796.5030100@netfilter.org>
	<460261EB.4000402@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <460261EB.4000402@trash.net>
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
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>
>>> One of the worst mistakes in nfnetlink in my opinion was the
>>> introduction of the NFNL_NFA_NEST bit. It prevents us from
>>> using a large part of the generic netlink stuff, since that
>>> just interprets it as a really huge attribute type. Since
>>> its not used even for anything, this is really annoying.
>>
>> I'm using this bit to convert attribute headers from host byte order to
>> network byte order in conntrackd. I'm unsure about how I would do the
>> conversion if we remove such bit.
> 
> That was the original idea behind it. But where do we use host byte
> order?

Currently, some parts of the nfnetlink message are in host byte order
and some in network byte order. For example, the netlink header and the
attribute header (TL) are un host byte order, but the attribute values
(V) are in network byte order.

Having a look at the code, if we decide to remove the nested bit,
conntrackd will have to parse the message coming from the kernel, put in
a nf_conntrack object and generate a new message un network byte order.
Moreover, I'll have to extend libnfnetlink and libnetfilter_conntrack to
indicate the byte order of a certain nfnetlink message, since without
the nested bit, I can't do proxying anymore.

>>> Unfortunately there is no easy way to get rid of it, current
>>> userspace code sends it to the kernel, so even if we stop
>>> including it in the kernel, we need to deal with it for
>>> compatibilty.
>>
>> We have a field in the nfnetlink that contains the protocol version that
>> we can use for this kind of changes without breaking backward.
> 
> If we still support the old stuff we can't get rid of it.
> I would really like to remove all the duplicated code and
> use the much nicer netlink infrastructure we have today.

I'm fine with using the new netlink infrastructure. We could remove the
nested bit, release new libraries that don't send it to kernel anymore
and keep the old nfnetlink code that understand the nest bit thing for
quite some time. Thus, doing the port to the new infrastructure later.

Thoughts?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
