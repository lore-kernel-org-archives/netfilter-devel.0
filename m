From: Patrick McHardy <kaber@trash.net>
Subject: [RFC] updated ctnetlink patches
Date: Wed, 28 May 2003 15:43:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ED4BD16.8030606@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

For some reason my mail didn't make it to netfilter-devel, i assume its 
because of the big patches.
For this reason, i'm sending the patches serperated from the mail.
-------------------[original 
mail]------------------------------------------------

I've done some work on ctnetlink, here is what i've got so far. The 
patch is still incomplete,
i just hope for some comments. I'll try to sum up the changes and some 
thoughts as good as i
can. To keep the reader motivated, attached is a small program which 
enables you to do basic
state synchronisation between two conntracks.

Changes:

- Attributes:
Removed CTA_IIF and CTA_OIF, there is no relation between conntrack and  
interfaces. I also
don't see what meaning CTA_INFO (ctinfo) could have outside of packet 
processing context,
but i left it in for now.

- Creation and manipulation of conntrack entries:
It is possible now to create and change conntrack entries. Only 
confirmed entries are accessible
trough ctnetlink, also only confirmed ones can be created. All 
attributes except CTA_HELPINFO
and CTA_NATINFO are implemented. For NATINFO probably another ugly 
pointer somewhere is
required to access either functions inside ip_nat_core or nat_lock 
without requiring nat to be
loaded.

- Conntrack event notifications:
The patch adds event notifications to conntrack. Since there are very 
much events, it is tried to
cache them where possible and to deliver all cached ones at once. Still, 
there are a lot. The
notifications can be disabled at compile time while keeping parts of 
ctnetlink that don't rely on
them working. Also noteworthy is the fact that the NEW event is in fact 
CONFIRM since there is
no way to access unconfirmed connections. The DESTROY event is currently in
destroy_conntrack, this should probably move to clean_from_lists. 
ip_ct_refresh is changed
to only update the timer if timer.expires != jiffies+extra_jiffies. This 
reduces timeout change
messages to at most HZ/s instead of 1/packet. I'm unclear if this change 
introduces a race
condition of some kind.

- ctnetlink event messages:
ctnetlink sends out a message for each conntrack event. There are two 
types of messages,
CTNL_MSG_NEWCONNTRACK and CTNL_MSG_DELCONNTRACK. Each message includes 
at least
the CTA_ORIG/CTA_RPLY attributes, plus all attributes that changed. 
Messages for new conntrack
entries include all available data, but at least 
CTA_ORIG/CTA_RPLY/CTA_TIMEOUT/
CTA_PROTOINFO/CTA_STATUS. These are also the minimum required attributes 
to create new
entries. There are no special flags set for this message at the moment, 
NLM_F_CREATE | NLM_F_EXCL would make sense to distinguish new entries 
from changes. I have to check what
rtnetlink is doing. There are currently no messages for things done on 
behalf of ctnetlink itself.

-Table dumping:
Previous code crashed (known issue i think), also if it worked entries 
would have been dumped
multiple times if there was no room in the skb while in the middle of 
dumping a hash chain. With
my current solution confirmed entries are assigned a unique increasing 
id and held in an ordered
list. The last id successfully dumped is stored in the struct 
netlink_callback and after an
interruption it is continued with the next one. Unfortunately this adds 
two new fields to struct
ip_conntrack. The id field could be useful for ctnetlink itself (since 
tuples can be reused it is the
only unique identifier).


Some thoughts/problems for discussion:
- There are too much messages, messages get lost if the socket receive 
buffer is exhausted. I
only tested on UML so it might have been just too slow.
- If NEW message is lost all further changes are pointless. One could 
make messages redundant
by always including the attributes required to create new entries. OTOH, 
this is only interesting
for state synchronisation, not for other listeners. Different messages 
for different multicast
groups ? This is probably needlessly expensive, the overhead of the 
extra attributes is not much.
It could of course also be handled in userspace (but with high overhead).
- Helpers: should it be possible to assign arbitary helpers to 
connections (respecting protocol,
disrespecting ports) or not ? Should connections created on behalf of 
ctnetlink be assigned
a helper automatically if there is a matching one ?
- nat: masq_index is current not included in NATINFO. could it be useful ?


Ok my brain is empty now, if i remember some more i'll write a new 
message ..


There are three patches:
ctnetlink-0.11-0.12.diff - incremental, expects CONNMARK and 
ctnetlink-0.11 patched kernel
ctnetlink-0.12.diff - expects CONNMARK patched kernel
connmark.diff - patch to CONNMARK for event notifications

Sorry about expecting a connmark patched kernel, but i started to work 
on ctnetlink because i
wanted to change connection marks ..

For state-syncronization testing there is a small programm. It 
encapsulates netlink messages in
udp and sends them out. The receiver sets NLM_F_REQUEST and passes them 
to the kernel.

Compile with (in libctnetlink directory):

gcc  -I../include -I/usr/src/linux/include -lnfnetlink ctsyncd.c -o ctsyncd

On one side: ./ctsynd listen
Other side: ./ctsynd <ip>

Looking forward for suggestions/comments.

Best regards,
Patrick

PS: I guess many here are aware of it, there is a draft on "Netlink as 
an IP services protocol"
with many information on netlink:
http://www.ietf.org/proceedings/01dec/I-D/draft-ietf-forces-netlink-01.txt
