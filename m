From: wanghtb@legend.com.cn
Subject: BUG related with in_range()
Date: Thu, 4 Mar 2004 14:42:00 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <OFDECF36AD.3B6C79B3-ON48256E4D.001CCF85@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: hidden@balabit.hu
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

As metioned in Krisztian KOVACS' letter,just before 2.4.23 released, a patch for in_range() is rolled 
back, though it seems definitly correct.

Here is the rollback code in in_range();

--- linux-2.4.23-pre3/net/ipv4/netfilter/ip_nat_core.c 2003-11-08 
03:01:59.000000000 -1000
+++ linux-2.4.23-pre4/net/ipv4/netfilter/ip_nat_core.c 2003-11-08 
03:00:47.000000000 -1000
@@ -157,8 +157,8 @@
                                                                 continue;
                                 }
 
-                                if ((mr->range[i].flags & 
IP_NAT_RANGE_PROTO_SPECIFIED)
-                                    && proto->in_range(&newtuple, 
IP_NAT_MANIP_SRC,
+                                if (!(mr->range[i].flags & 
IP_NAT_RANGE_PROTO_SPECIFIED)
+                                    || proto->in_range(&newtuple, 
IP_NAT_MANIP_SRC,
 &mr->range[i].min, &mr->range[i].max))
                                                 return 1;
                 }


Because bug is reported related with this patch:
http://lists.netfilter.org/pipermail/netfilter-devel/2003-November/013099.html)
which will make the machine hange on, in dead loop in ip_nat_setup_info().
which means get_unique_tuple() always return same new tuple and 
ip_conntrack_alter_reply()
always fail.

I thought about this problem for serveral days, and at last  figured out 
one
situation it can go into the loop, with in_range() patched:-)

ip_conntrack_alter_reply() will fail only in the situation another ct have 
the same tuple 
with the new reply tuple. However, since the new reply must be generated 
by a null mapping,
which means this ct will not changed at all. So, if another ct already 
exists, then 
when the skb comes into the box, it will be attached to the existing ct, 
since it's reply tuple matches the existing ct's reply tuple, which will 
not create a new ct and new nat steps will not happen:-)

It seems correct, but in fact, it is not the whole things. We must notice 
it is only that the new skb's reply tuple  matches existing ct's reply 
tuple, not definitly means skb's orig tuple matches
existing ct's reply/orig tuple, which is ip_conntrack_find_get() will do. 
if they do not match, which means the existing ct MUST NOT be a  null 
mapping, new ct will be built, and problem is comming.

Still consider the scenario, which is a simple SNAT 

[ Client A ] -----> [ Box B ] ----> [ Server C ]
iptalbes -A POSTROUTING -t nat -p udp -s A -j MASQUERADE

existing ct:  orig A.1 --> C.1   reply C.1 ---> B.1 //assume port not 
changed
considerate the  new skb generated at Box B, B.1 ---> C.1, as we can see, 
new ct is built.
When find_appropriate_src() is called , if another ct B.1--->D.2 already 
exists, find_appropriate_src() will always tell us he get the right manip, 
and the dead loop happen!

It seems complete, but wait for a while, never forget that 
find_appropriate_src() is only called
at POSTROUTING hook, so when skb(B.1--->C.1) reaches NF_IP_LOCAL_OUT, a 
null mapping is setted for it, and ip_nat_setup_info() will change the ct 
for the skb like (B.1-->C.1 and C.1--->B.2), since the reply tuple 
(C.1-->B.1) is already occupied. So, nothing will happen in this way.


So, only in the situation that local out skb not do a null NAT mapping, 
bad things can happen.
When I got it, I checked the kernel configuration file Beau E. Cox posted: it didnot make
CONFIG_IP_NF_NAT_LOCAL selected. But why his box works correct before 
2.4.23? I checked the 2.4.23.patch.tar.bz2,  and got the answer: in 
2.4.23, without CONFIG_IP_NF_NAT_LOCAL
configured, ip_nat_local_fn() will not be compiled, while 2.4.22 will 
do:-)

Then I made some experiments in my 2.4.24 Box:  de-select 
CONFIG_IP_NF_NAT_LOCAL,
and patching the in_range() and using nc as the packet generator, and 
everytime I really can make my machine hang on:-)

So, this bug exist in 2.6. However, I think the behavior of 
find_appropriate_src() is 
too strange, it only can be used in null mappping situation :-)
