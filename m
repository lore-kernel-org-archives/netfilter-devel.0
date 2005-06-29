From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Wed, 29 Jun 2005 21:13:35 +0200
Message-ID: <42C2F2DF.7070301@eurodev.net>
References: <42C03F2E.30706@eurodev.net> <42C0806E.3010400@trash.net>
	<20050628071308.GE13239@sunbeam.de.gnumonks.org>
	<42C1747A.3010703@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42C1747A.3010703@trash.net>
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
> Harald Welte wrote:
> 
>>On Tue, Jun 28, 2005 at 12:40:46AM +0200, Patrick McHardy wrote:
>>
>>
>>>These should be changed not to use internal conntrack structures, it
>>>will hurt us when we want to change them. Instead it should replicate
>>>the fields interesting for the user. Also please use fixed-size types
>>>instead of unions etc. All structures including u64 types should be
>>>padded to multiples of 8 so they are equally sized on 32-bit and 64-bit
>>>systems.
>>
>>agreed.  However, we still don't have some kind of versioning in the
>>protocol, too.  I think we've learned by now that we need versioned
>>structures ;)
> 
> Netlink is easy to extend by adding new fields at the end if users
> only check for msgsize >= sizeof(struct). Do you think we should
> have versioning anyway?

I think that we could split the structure into fine grain fields. For 
example, CTA_TUPLE_ORIG would composed of:

CTA_ORIG_IPV4_SRC
CTA_ORIG_IPV4_DST
CTA_L4_PROTONUM
CTA_PROTO_IPV4_SRC
CTA_PROTO_IPV4_DST
CTA_DIR

So, instead of sending a packet that contains a reference to an 
ip_conntrack_tuple (CTA_TUPLE_ORIG), we'll have a set of fields 
(CTA_ORIG_IPV4_SRC + CTA_ORIG_IPV4_DST + ...) that compose such structure.

But I'll need a function to glue all the fields to create a 
ip_conntrack_tuple. Maybe too bloated?

>>>+/* ctnetlink multicast groups: reports any change of ctinfo,
>>>+ * ctstatus, or protocol state change.
>>>+ */
>>>+#define NFGRP_IPV4_CT_TCP      0x01
>>>+#define NFGRP_IPV4_CT_UDP      0x02
>>>+#define NFGRP_IPV4_CT_ICMP     0x04
>>>+#define NFGRP_IPV4_CT_OTHER    0x08
>>>
>>>I'm not sure how useful these groups are. I think groups for different
>>>event-types might be more useful to reduce the noise.
>>
>>
>>that was my idea in the beginning (since I didn't think of events at
>>that point).
>>
>>Still, I think creating messages for any kind of event (even if noone
>>listens) is too much overhead.  netlink needs to be extended to deal
>>with that issue.
>>
>>Maybe the 'which socket is subscribed to which group' accounting should
>>be done by the core netlink layer, which would then only export a
>>merged bitmask of all netlink sockets.  This way ctnetlink can easily
>>check whether it makes sense to create a certain event message or not.
>>
>>This should be useful for other netlink users, too.

Isn't netlink broadcast subscription enough? netlink_broadcast doesn't 
enqueue packets for a socket that isn't subscribed to a group, so the 
process never gets useless packets.

So I think that we can group event, say:

level 1 (weak):
	- IPCT_NEW
	- IPCT_DESTROY

level 2 (normal):
	- IPCT_NEW
	- IPCT_UPDATE
	- IPCT_STATUS
	- ...
	- IPCT_DESTROY

At reserve some groups to let the user define some level whenever he 
wants. Although such level would be unique.

OTOH, there are 10 events currently, why is that bad creating a group 
per event?

--
Pablo
