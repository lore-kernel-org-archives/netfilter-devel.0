From: varun <varun@rocsys.com>
Subject: Netfilter reg problem
Date: Fri, 09 Jun 2006 18:05:05 +0530
Message-ID: <44896AF9.1020606@rocsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all,

             I have a module which basically registers to the netfilter 
like shown below.
 
               static struct nf_hook_ops my_preroute_ops
= { { NULL, NULL }, my_Input, PF_INET, NF_IP_PRE_ROUTING, 
NF_IP_PRI_NAT_DST-1 };

              Now in this when i get a packet based on certain condition 
i use NF_STOLEN.

           Now the scenario is that i want to register iptables with 
REDIRECT facility also.
          The reason is that if i get a packet which has destination 
port 80 i will redirect to 5555 where i run squid proxy.
          so i use a policy like
         iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j 
REDIRECT --to-port 5555

          So for this to happen iptables should get the packet first 
before my module otherwise i will steal the packet and iptables will not 
get the packet.

         So i registered my module first and then try to insmod iptables 
modules. ip_conntrack.o refuses to insmod saying that resource busy. so 
without conntrck i cannot use REDIRECT. Why is this happening?

         Next if first register iptables and then my module then every 
thing works fine. But packets are not coming to iptables .
Only my modules get it. So how can i overcome this situation? How to 
change my module reg functionality to suit the scenario?
      The important thing is that once iptables hits on the above policy 
then my module should get the packet after iptables.
       Please help me.
       Iam working on 2.4 kernel
Varun
