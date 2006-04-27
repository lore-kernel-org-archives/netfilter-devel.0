From: "Sachin Shelar" <sachin.s@s7solutions.com>
Subject: kernel module acquiring virtual ip's
Date: Thu, 27 Apr 2006 14:34:49 +0530
Message-ID: <ops8nsubq7ibd9oo@sachin>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
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

Hi,

    I have a kernel module which "acquires" virtual ips ( not assigned to   
anyone in n/w )
and then respond to any future packets coming to this virtual ip.
    I am handling ARP, TCP, UDP protocols in my module.
To get the arp stuff working I handle all the ARP requests for virtual IP   
and reply to
them with my local hardware address. I can now receive all the packets   
destined to virtual IP.
    E.g Local IP is 192.168.1.2
        Virtual ip is 192.168.1.244 ( Not existing in network )

    I catch every arp request for .244 and reply with my mac. I can now
recive all IP packets ( handled in my netfilter hooks ) destined for .244.
According to the natting rules in my module I nat the packets for .244  
and  redirect them to
some listening port on 192.168.1.2
Also I handle all the outgoing packet from 192.168.1.2 and replace the   
source to 192.168.1.244
So that the client machine recives reply from virual IP, as expected.

         192.168.1.21[32774] -> 192.168.1.244[123]

                          Nat Destination   192.168.1.21[32774] ->   
192.168.1.2[23]

(Reply) 192.168.1.2[23] -> 192.168.1.21[32774]
                          Nat Source        192.168.1.244[123] ->   
192.168.1.21[32774].



    Module works perfectly and I can establish any tcp connection ( E.g   
telnet ) with a
non exitsing IP ( 192.168.1.244) from any machine in the network.

Problem is :-
===========
    I want the same behaviour from the module if I try to connect from the   
same machine (local machine )
to the virtual IP.

     E.g 192.168.1.2[32772] -> 192.168.1.244[123]

                         Nat Destination   192.168.1.2[32772] ->   
192.168.1.2[23]

***** But somehow this packet after natting is dropped by the kernel and   
never reaches
192.168.1.2[23]
       Is this because the source and destination ip of this packet is  
same  ?????
       Whats the solution for sending a packet with local ip as its src and  
dst
to local from POSTROUTING hook


Thanks,
Sachin
