From: "Markus" <listuser@sally.epygi.de>
Subject: i have problems understanding the "Nat-Reservation"-patch
Date: Wed, 21 Jul 2004 15:43:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BDEHJGPIKNLKJJBCCFPLAEJKCOAA.listuser@sally.epygi.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

HiHo!

I am trying to understand the nat-reservation patch,
but i have some problems:
1) 
 ip_nat_reserved_register(struct ip_conntrack_expect *expect,
			 const struct ip_conntrack_manip *manip,
			 const u_int16_t proto,
			 const struct ip_conntrack_manip *peer)

 I understand the manip,proto and peer part, but why do i need 
 an expect and for what? Do i have to build one myself, or this
 a container pointer that already exists?

(i am naughty and used __ip_nat_reserved_hash which is doing fine 
 for me now but maybe i am missing something, i also have the feeling
 that the expect is the key to #2) 

2)
 If i have a runtime case where hooknum == NF_IP_POST_ROUTING
 Is there a way to find out if a packet came via 
   NF_IP_LOCAL_OUT or via NF_IP_FORWARD ?

 I tried to tweak ip_nat_used_tuple with something like
  	res = __ip_nat_reserved_find_tuple(tuple, maniptype);

	if ( res ) {
-->		if ( hooknum == NF_IP_LOCAL_OUT ) {
			DEBUGP("ip_nat_used_tuple: IP_NAT_RANGE_USE_RESERVED overwrite for local aka reserved for us\n");
			..proceed normal as if not reserved...
		}
	}

 Unfortunatly my reservation (as the src is reserved)
 will be found of course when hooknum == NF_IP_POST_ROUTING,
 but than i can't decide if i can "use" this reservation or not.

 I am trying to reserve a certain port for a service
 running on the same machine as netfilter. Peeking at
 tproxy i come as far as reserving a manip tuple:
   say 10.20.10.193:5060 (no peer)
 It is so far reserved for everyone, now i need a way
 to "use" this reservation (aka reserved by me), that
 leads to #3.

3)
 IP_NAT_RANGE_USE_RESERVED seems to do the trick and
 i can find from tproxy that it is set as a flag to 
 a multi_range (whatever this is). What do i have to
 do to "use" a simple reservation. 

can anyone help me out a little here?
thanks alot
  ciao
    markus

P.S. If I am running along a totally wrong path here,
     feel free too turn me around, netfilter is yet
     some dark matter to me that unveils only slightly. :)
------------------------------------------------------
   
