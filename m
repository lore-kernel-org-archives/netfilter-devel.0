From: Amin Azez <azez@ufomechanic.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Mon, 10 Jul 2006 10:56:04 +0100
Message-ID: <44B22434.3050801@ufomechanic.net>
References: <44AA3446.6050609@trash.net>
	<44AA3496.5050909@trash.net>	<44AEFE20.3020307@shorewall.net>
	<44AF200F.9000204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44AF200F.9000204@trash.net>
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
> Tom Eastep wrote:
>> Patrick McHardy wrote:
>>
>>
>>> +Why:	The defered output hooks are a bad layering violation causing
>>> +	lots of unusual and broken behaviour on bridge devices.
>>> +	Examples include broken QoS classifation using the MARK or
>>> +	CLASSIFY targets, broken behaviour with the IPsec policy match,
>>> +	broken connection tracking with VLAN on a bridge, ...
>>> +
>>> +	Their only use is to enable bridge output port filtering within
>>> +	iptables with the physdev match, which can just as well be done by
>>> +	combining iptables and ebtables using netfilter marks.
>>
>> Patrick,
>>
>> Once again, netfilter marks are the solution of last resort. This is
>> becoming very painful for those of us who produce general Netfilter
>> configuration tools. The situation is exacerbated by the fact that
>> ebtables doesn't support modifying the mark value via logical AND/OR and
>> the other fwmark consumers (tc, ip) don't allow a mask when testing the
>> fwmark value.
> 
> I understand your problems perfectly, one of my netfilter backgrounds
> is creating (proprietary) high-level tools as well (aka typical
> applicance vendor). I know the problems getting along with netfilter
> marks and specifying reasonable limits, but this stuff has created
> so much problems that I just don't care. If we need more bits, so be
> it, and introducing bitwise operations to ebtables MARK can only be
> a good thing anyway (and for that matter, in every other spot using
> nfmark).


This morning in the shower I was wondering if I would have to add back
in what you are just taking out; however I am willing to accept this
qualified expert opinion!

This leads me to suggest addition of ipt_marks instead of ipt_mark

Not only is "the" mark overutilized but the problems of managing free
bit-ranges in iptables/ebtables (if/when ebtables supports masking) will
also be too troublesome to bear.

I re-suggest adding multiple on-demand storage slots to conntrack (and
now also skb's), for storing labelled cookie-type values tor checking
later, by iptables or ebtables or any-other.

My I copy my latest RFC attempt here (still a work in progress)

A lot of iptables modules patch ip_conntrack.h to allocate storage.

To avoid the number of conntrack or iptables modules that taint and grow
the size of an skb, or conntrack (even when they are not loaded into the
kernel), I suggest another way of iptables modules having per-conntrack
storage.

More detail of advantages

Sometimes data does not need to be stored for every conntrack, for
example per-subnet data aggregated over all ip addresses in a subnet.
Current style is to implement some kind of hash or list (often from
scratch) and store data there, but often the hash key is a function of
some of the skb or conntrack fields.

Sometimes the hash stores per-conntrack data, which could be stored in
the conntrack directly, sometimes the hash stores data aggegated for
multiple connections,  but the conntrack can cache the pointer to the
hash entry to that hash/list making access quicker.

(I think the kernel also needs common multi-indexed collections. but
anyway...)

Implementation

One slot in the conntrack is a pointer to an array of pointers.

Each module that wants to use storage will register and receives and an
index from the storage manager. This index is used as the offset to the
array element containing data for that module.

Complications

As more modules register we approach the current problem with a lot of
extra storage allocated per conntrack, but hopefully only for modules
that are actually loaded. If modules delay requesting an offset till
they first need one, that problem will be reduced except for people who
briefly play with all modules.

ID re-use.

It will be hard to re-use an id if conntracks still exist with non-zero
values for that slot; if the slot is re-allocated the new module using
the old ID may read bad data.

One solution is to maintain a global version counter. This is stamped
into each allocated conntrack. The version counter is updated when a
slot is re-allocated.

The brief #define style API used to retrieve a slot from the conntrack
will compare the conntrack recorded version stamp to the storage manager
version stamp when that slot was last allocated. If the conntrack
version stamp is old, then the value is obviously fromthe previous user
and is zeroed before being returned.

The other problem is of growing the array for older conntracks, if new
slots have been made available since the conntrack had it's storage
array allocated. The same solution applies except
that the array would also need growing, which implies a lock in the
conntrack that must be obtained before using (or growing) the array.



Do these overheads waste any advantage in merely trying to save space in
the conntrack?

Do this neatly solve the problem of passing state between tables?

Do these overheads waste any advantage in using the conntrack as a
caching mechanism?

Sam
