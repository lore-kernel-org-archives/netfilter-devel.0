From: Patrick McHardy <kaber@trash.net>
Subject: Re: NFNL_NFA_NEST
Date: Thu, 22 Mar 2007 14:29:56 +0100
Message-ID: <460284D4.30709@trash.net>
References: <4600BDBB.8020205@trash.net> <4601B796.5030100@netfilter.org>
	<460261EB.4000402@trash.net> <46028242.4090609@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46028242.4090609@netfilter.org>
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
>>>I'm using this bit to convert attribute headers from host byte order to
>>>network byte order in conntrackd. I'm unsure about how I would do the
>>>conversion if we remove such bit.
>>
>>That was the original idea behind it. But where do we use host byte
>>order?
> 
> 
> Currently, some parts of the nfnetlink message are in host byte order
> and some in network byte order. For example, the netlink header and the
> attribute header (TL) are un host byte order, but the attribute values
> (V) are in network byte order.


Right.

> Having a look at the code, if we decide to remove the nested bit,
> conntrackd will have to parse the message coming from the kernel, put in
> a nf_conntrack object and generate a new message un network byte order.
> Moreover, I'll have to extend libnfnetlink and libnetfilter_conntrack to
> indicate the byte order of a certain nfnetlink message, since without
> the nested bit, I can't do proxying anymore.


Not really. The NEST bit allows to walk nested structures without
being aware of the structure. So all you need to do is make it aware
of which attributes are nested - something you need anyway for
parsing I suppose.

The byteorder is already clear, all netlink header values are in
host byte order, all attributes in network byte order.

> I'm fine with using the new netlink infrastructure. We could remove the
> nested bit, release new libraries that don't send it to kernel anymore
> and keep the old nfnetlink code that understand the nest bit thing for
> quite some time. Thus, doing the port to the new infrastructure later.


Yes, we should probably wait for at least one year.
