From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Wed, 29 Jun 2005 21:52:52 +0200
Message-ID: <42C2FC14.80609@trash.net>
References: <42C03F2E.30706@eurodev.net> <42C0806E.3010400@trash.net>
	<20050628071308.GE13239@sunbeam.de.gnumonks.org>
	<42C1747A.3010703@trash.net> <42C2F2DF.7070301@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42C2F2DF.7070301@eurodev.net>
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

Pablo Neira wrote:
> I think that we could split the structure into fine grain fields. For
> example, CTA_TUPLE_ORIG would composed of:
> 
> CTA_ORIG_IPV4_SRC
> CTA_ORIG_IPV4_DST
> CTA_L4_PROTONUM
> CTA_PROTO_IPV4_SRC
> CTA_PROTO_IPV4_DST
> CTA_DIR
> 
> So, instead of sending a packet that contains a reference to an
> ip_conntrack_tuple (CTA_TUPLE_ORIG), we'll have a set of fields
> (CTA_ORIG_IPV4_SRC + CTA_ORIG_IPV4_DST + ...) that compose such structure.
> 
> But I'll need a function to glue all the fields to create a
> ip_conntrack_tuple. Maybe too bloated?

I think its fine, but CTA_PROTO_IPV4_{SRC,DST} should be
CTA_PROTO_{SRC,DST}, there's nothing related to IPv4 in them.
Please nest all attributes related to a tuple in CTA_TUPLE
instead of adding them to the top-level.

>>> Still, I think creating messages for any kind of event (even if noone
>>> listens) is too much overhead.  netlink needs to be extended to deal
>>> with that issue.
>>>
>>> Maybe the 'which socket is subscribed to which group' accounting should
>>> be done by the core netlink layer, which would then only export a
>>> merged bitmask of all netlink sockets.  This way ctnetlink can easily
>>> check whether it makes sense to create a certain event message or not.
>>>
>>> This should be useful for other netlink users, too.
> 
> 
> Isn't netlink broadcast subscription enough? netlink_broadcast doesn't
> enqueue packets for a socket that isn't subscribed to a group, so the
> process never gets useless packets.

But we still spent time building them, just to have them thrown away.

> So I think that we can group event, say:
> 
> level 1 (weak):
>     - IPCT_NEW
>     - IPCT_DESTROY
> 
> level 2 (normal):
>     - IPCT_NEW
>     - IPCT_UPDATE
>     - IPCT_STATUS
>     - ...
>     - IPCT_DESTROY
> 
> At reserve some groups to let the user define some level whenever he
> wants. Although such level would be unique.
> 
> OTOH, there are 10 events currently, why is that bad creating a group
> per event?

I don't think its bad, but I fear hitting the 32 group limit some day.
Probably that fear is unfounded and we're never going to reach 32
different types of events. Harald, what do you think?

Regards
Patrick
