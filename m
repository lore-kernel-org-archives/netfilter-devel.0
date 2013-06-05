From: Vijay Tandeker <vijayt@india.tejasnetworks.com>
Subject: Locally transmitted Multicast packets are being looped back, even
 if IP_MULTICAST_LOOP option is set to zero
Date: Wed, 5 Jun 2013 16:17:08 +0530
Message-ID: <51AF172C.9090803@india.tejasnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: <netfilter@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,
   I am Vijay Tandeker working in TejasNetworks Bangalore, which works 
in a telecommunication domain. I have one query regarding 
IP_MULTICAST_LOOP option.

My configuration:
Kernel version: 2.6.32
One OSPF routing protocol deamon is running in my system. It has opened 
one raw socket with
- IP_HDRINCL option set to 1
- IP_MULTICAST_LOOP option set to 0

IP fragmentation logic is implemented in my application. Means if OSPF 
tries to send any packet which exceeds MTU of the transmitting 
interface, it fragments it and gives to the kernel using sendmsg(). In 
my case, I am getting all my fragmented packets back to the application 
(which should not happen if IP_MULTICAST_LOOP option is set to zero).

Following are my observations:
1) In ip_mc_output() function inside "net/ipv4/ip_output.c" file:


/*
  *  Multicasts are looped back for other local users
  */

     if (rt->rt_flags&RTCF_MULTICAST) {
         if ((!sk || inet_sk(sk)->mc_loop)
#ifdef CONFIG_IP_MROUTE
                 /* Small optimization: do not loopback not local frames,
                    which returned after forwarding; they will be  dropped
                    by ip_mr_input in any case.
                    Note, that local frames are looped back to be delivered
                    to local recipients.

                    This check is duplicated in ip_mr_input at the moment.
                  */
&& ((rt->rt_flags&RTCF_LOCAL) || !(IPCB(skb)->flags&IPSKB_FORWARDED))
#endif
            ) {
              }

  Here sk(or skb->sk) pointer is NULL and "((rt->rt_flags&RTCF_LOCAL) || 
!(IPCB(skb)->flags&IPSKB_FORWARDED))" condition is True. Because of this 
I am getting all my fragmented packets looped back to application.



  2) On further debugging I found that:
  In nf_ct_ipv4_gather_frags() function inside 
"ipv4/netfilter/nf_defrag_ipv4.c" file
  - skb_orphan(skb); is being called, which is setting skb->sk to NULL.
  - No call to restore skb->sk back to some valid value later on.

My questions:-
  - Is this done intentionally ?
  - If No, please suggest the solution to restore skb->sk pointer.
  - If Yes, please suggest the solution to restore skb->sk pointer.

Kindly let me know in case if the problem is not clear or you need any 
more data.

  Thanks & Regards,
  Vijay


