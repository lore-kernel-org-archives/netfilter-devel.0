From: zhi wang <pangy2004@yahoo.com>
Subject: Re: find_appropriate_src() BUG also exist in 2.4.24
Date: Fri, 2 Apr 2004 18:01:19 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040403020119.1945.qmail@web41707.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Develop <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>Still consider  a simple SNAT, without CONFIG_IP_NF_NAT_LOCAL selected 
>
>[ Client A ] -----> [ Box B ] ----> [ Server C ]
>iptalbes -A POSTROUTING -t nat -p udp  -j SNAT --to-source B:2000-3000

>when two udp connection built:
>ct1: ORIG A.1---> C.1   REPLY  C.1 ---> B.2000
>ct2: ORIG B.2000 ---> C.2 REPLY C.2 ---> B.2000

>then the third will hang on the system

>B.2000 ---> C.1

After some email communication with wanght@legend, and cleared my own
misunderstander, I agree that this is a bug. The following steps can faithfully
hang the linux 2.4.24 machine.
     [1.1.1.2]<--->[1.1.1.1  2.2.2.1] <--->[2.2.2.2]
     iptalbes -A POSTROUTING -t nat -j SNAT --to-source 2.2.2.1:2000-3000

1. Deselect the CONFIG_IP_NF_NAT_LOCAL.
   set up the route:
   at [1.1.1.2]: ip route add 2.2.2.0/24 via 1.1.1.1
   at [2.2.2.2]: ip route add 1.1.1.0/24 via 2.2.2.1
   at [1.1.1.1]: echo 1 > /proc/sys/net/ipv4/ip_forward

2. at [2.2.2.2] execute:
   nc -l -p 1023
   nc -l -p 1024

3. at [1.1.1.2] execute:
   nc -n -p 1023 2.2.2.2 1023
   at [1.1.1.1], assume port 2000 is used. that is, there is a conntrack:
             {1.1.1.2:1023-->2.2.2.2:1023, 2.2.2.2:1023-->2.2.2.1:2000}

4. at [1.1.1.1] execute:
   nc -n -s 2.2.2.1 -p 2000 2.2.2.2 1024
   then another conntrack will be created:
             {2.2.2.1:2000-->2.2.2.2:1024,  2.2.2.2:1024-->2.2.2.1:2000}

5. at [1.1.1.1] again execute:
   nc -n -s 2.2.2.1 -p 2000 2.2.2.2 1023
   Then NF will try to create a conntrack with:
             {2.2.2.1:2000-->2.2.2.2:1023, 2.2.2.2:1023-->2.2.2.1:2000}
   This will trigger the dead loop.


Why CONFIG_IP_NF_NAT_LOCAL disabled:
   When CONFIG_IP_NF_NAT_LOCAL is enabled, a null binding will be allocated at
LOCAL_OUT hook. While a LOCAL_OUT hook is consided for DNAT, nat will not call
find_appropriate_src, and it will try to do implicit source NAT. So, the
conntrack will be change to something like {2.2.2.1:2000-->2.2.2.2:1023,
2.2.2.2:1023-->2.2.2.1:2001} before the POSTROUTING hook is called, dead loop
will NOT occur. I believe this DNAT identity is the power of
CONFIG_IP_NF_NAT_LOCAL. It covers this and the LIST_DELETE bug. Because it is
consided as DNAT, the PREROUTING hook will NOT call ip_nat_rule_find in
LIST_DELETE bug setup. 

Current 2.6 kernel has fixed this bug. It should be used in current 2.4 kernel
also.

Some thoughts:
The purpose of find_appropriate_src as stated by the comment in the source
code, "If this srcip/proto/src-proto-part is currently mapped,and that same
mapping gives a unique tuple within the given range, use that". I am just
wondering why we can't be the first to use that mapping, if it is valid within
the given range?


=====
--
Regards
Wang, zhi

__________________________________
Do you Yahoo!?
Yahoo! Small Business $15K Web Design Giveaway 
http://promotions.yahoo.com/design_giveaway/
