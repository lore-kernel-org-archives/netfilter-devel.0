From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [RFC] NAT tuple reservation
Date: Mon, 17 Nov 2003 15:47:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FB8DF90.5090505@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


   Hi,

   Netfilter's NAT subsystem currently does not support reservation of 
tuples. This means, there are no facility which you could use to 
"preallocate" exact IP/port pairs which could be later used by the 
registrator _for_sure_. However, this causes problems when NAT-ting 
certain protocols: when the protocol uses secondary channels, and the NAT 
helper has to modify the addresses/ports in the negotiation. (This is the 
case for example with SIP. See Harald's mail at 
http://lists.netfilter.org/pipermail/netfilter-devel/2003-November/012999.html 
for more info.)

   So, some kind of tuple reservation was really needed to be able to 
solve these problems. The reservation facility would provide a way to 
reserve a "half-tuple" (manip), which wouldn't be allocated by the NAT 
facility when a unique tuple is searched. When the registrator of the 
reserved tuple would like to use it, it would use a special function, 
which calls ip_nat_setup_info() with a special flag, and after applying 
the mapping succeeded, removes the reservation. The reservation would be 
per-expectation, ip_conntrack_expect would store a reference to the 
reservation, and when the expectation is deleted all related reservations 
are deleted, too.

   The allocation routines in ip_nat_core.c should be extended to check if 
a tuple is reserved. ip_nat_used_tuple() would be extended to check if the 
given tuple uses an already reserved manip. The reserved manips would be 
stored in a hash table, hashed based on the manip structure. The stored 
structures would look something like this:

struct ip_nat_reserved {
   /* hash chain */
   list_head prev, next;

   /* reference count */
   atomic_t use;

   /* reserved manip */
   struct ip_conntrack_manip m;
}

The functions used by the NAT helpers would look something like this:

ip_nat_reserved_register(struct ip_conntrack_expect *expect,
			 struct ip_conntrack_manip *manip)

ip_nat_reserved_unregister(struct ip_conntrack_expect *expect,
			   struct ip_conntrack_manip *manip)

ip_nat_setup_info_reserved(...): This is basically the same as 
ip_nat_setup_info, except that it calls ip_nat_setup_info() with the 
appropriate flag, and deletes the reservation in case of successful 
allocation.

   Do you see any shortcomings/problems with this?

-- 
   Regards,
     Krisztian KOVACS
