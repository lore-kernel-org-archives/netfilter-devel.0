From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] updated ctnetlink patches
Date: Sun, 01 Jun 2003 00:44:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ED9306B.6000607@trash.net>
References: <3ED4BD16.8030606@trash.net> <20030531205210.GE29312@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030531205210.GE29312@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,
thanks for you suggestions.

Harald Welte wrote:

>>All attributes except CTA_HELPINFO and CTA_NATINFO are implemented.
>>
>we should get HELPINFO implemented,
>  
>
already done. i'm still reading into nat and building a userspace 
utility for
testing, but i will probably update the patches (without nat) in the 
next couple
of days.

>>Also noteworthy is the fact that the NEW event is in fact CONFIRM
>>since there is no way to access unconfirmed connections. The DESTROY
>>event is currently in destroy_conntrack, this should probably move to
>>clean_from_lists. 
>>    
>>
>
>ACK. We can have conntracks that are forced to live longer because some
>sibling is still holding a refcount on it.  But userspace should get
>notified once the entry is deactivated - that is, at the time it is
>removed from the lists.  This change would also make it symmetric
>(NEW==confirm, DESTROY==remove_from_lists
>  
>

also done.

>>ip_ct_refresh is changed to only update the timer if timer.expires !=
>>jiffies+extra_jiffies. This reduces timeout change messages to at most
>>HZ/s instead of 1/packet. 
>>    
>>
>>I'm unclear if this change introduces a race condition of some kind.
>>    
>>
>
>I don't think so.
>  
>

then this change would probably also make sense for mainline kernel. i was
even thinking about going a bit further and only doing changes if they are
bigger than say 1s, it doesn't seem to matter. if not that, maybe reduce
only event messages to 1/s for timer changes.

>>There are currently no messages for things done on behalf of ctnetlink
>>itself.
>>    
>>
>
>This means that listener B doesn't get notified if listener A
>adds/changes something via ctnetlink.  This needs to get implemented in
>order to sanely support multiple listeners
>

yes i'm aware of that. i delayed it for now because i have to make sure
there are no "indirect" event messages by calling conntrack functions
from nfnetlink_conntrack that send some, so i'm waiting until that part 
stablizes.

>>-Table dumping:
>>Previous code crashed (known issue i think), 
>>    
>>
>Yes, Martin has a fix for it.
>  
>
>>also if it worked entries would have been dumped multiple times if
>>there was no room in the skb while in the middle of dumping a hash
>>chain. 
>>    
>>
>
>true, but not too problematic.  If we send the address of the conntrack
>entry as ID to userspace, userspace could detect those copies. But it's
>not nice, of course.
>

problems can occur if one chain contains more entries that there is room
in a skb. that chain will be dumped over and over again. i don't see how
this can be prevented without my changes.

>>With my current solution confirmed entries are assigned a unique
>>increasing id and held in an ordered list. 
>>    
>>
>
>Mh, this is the part i really dislike (sorry).  The unique ID is IMHO
>going to be expensive (the cacheline of this ID will always ping-pong,
>as heavy contention is to be expected).  And the ordered list..  is it
>really necessarry to yet again increase the size of ip_conntrack? 
>  
>

i don't like that part either, but how could the problem mentioned
before be solved without it ?

>>The last id successfully dumped is stored in the struct
>>netlink_callback and after an interruption it is continued with the
>>next one. Unfortunately this adds two new fields to struct
>>ip_conntrack. The id field could be useful for ctnetlink itself (since
>>tuples can be reused it is the only unique identifier).
>>    
>>
>
>yes, but passing the address of the conntrack as ID would be much easier
>than than a unique sequential ID.
>
>Or what about using a timestamp as ID? it would not be unique, but at
>least you can say something like 'entries created before jiffies==foo have
>already been sent'.
>
>This still doesn't eliminate the need for the ordered list.  We need to
>find a way around that.
>

yes i would like that too. the unique id doesn't seem to be very important,
i just mentioned it to sweeten the bigger ip_conntrack structure ;)

>>Some thoughts/problems for discussion:
>>- There are too much messages, messages get lost if the socket receive 
>>buffer is exhausted. I only tested on UML so it might have been just
>>too slow.
>>    
>>
>
>did you try to increase the buffer?
>
yes, with uml it didn't help much. now i'm running it between my gateway
and my workstation and there are no drops until now.

>>- If NEW message is lost all further changes are pointless. One could 
>>make messages redundant by always including the attributes required to
>>create new entries. OTOH, this is only interesting for state
>>synchronisation, not for other listeners. 
>>    
>>
>
>No, I don't think this is necessarry.  If a sync receiver gets updates
>for an entry it doesn't have, it can issue an request to receive a full
>[new] copy of this entry.
>  
>

some firewalls with failover-capabilities also seem to do periodic polls of
the state table. i suppose it could be cheaper than event messages under 
some
circumstances.


>>Different messages for different multicast groups ? This is probably
>>needlessly expensive, the overhead of the extra attributes is not
>>much.  It could of course also be handled in userspace (but with high
>>overhead).
>>    
>>
>
>Well, I don't care about the overhead in userspace if it's about a rare
>case (message loss).
>

Currently it is not necessary to be aware of the conntrack table in 
userspace.
If you want to make messages redundant in userspace you'll have to replicate
it.

>>- Helpers: should it be possible to assign arbitary helpers to 
>>connections (respecting protocol, disrespecting ports) or not ? 
>>    
>>
>
>might be a nice feature to have, but I wouldn't consider this important
>  
>
i left it out for know.

>>Should connections created on behalf of ctnetlink be assigned
>>a helper automatically if there is a matching one ?
>>    
>>
>
>yes.
>  
>
i'll change that.

>a couple of thoughts:
>
>- stuff like 'conntrack->proto.tcp = *(struct ip_ct_tcp *)p;' makes the
>  compiler to generate inline memcpy, which is less optimal than the
>  kernel-provided asm memcpy implementation, so let's not do this.
>
i'll also change that.

>- you add two new callback functions 'new' and 'change' to
>  ip_conntrack_protocol.  Can't we unify those two somehow?
>  
>
currently only difference is that change takes locks for some protocols.
we could of course always take the lock.

>Thanks once again, keep up the good work.
>  
>
Thanks ;)

Patrick
