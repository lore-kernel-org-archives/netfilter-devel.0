From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: ipsec with 2.6.16-rc3-git6
Date: Thu, 16 Feb 2006 16:28:35 +0100
Message-ID: <BAY103-F938A1F933DD48F94C262EB2FB0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

I'm running openswan 2.4.5 with 2.6.16-rc3-git6 on
slackware 10.2 and I have a very strange problem.
I don't know if this is the desired behaviour or a
bug. I'm using iptables 1.3.5
With the following rules I was running ipsec
successfully with linux 2.6.15.1 to all our ipsec
gateway. After I have upgraded to 2.6.16-rc3-git6
I'm able to run ipsec only to venice_gateway.

Chain INPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  venice_gateway       0.0.0.0/0
ACCEPT     all  --  127.0.0.1            127.0.0.1
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state 
RELATED,ESTABLISHED
red-me     all  --  0.0.0.0/0            0.0.0.0/0

Chain red-me (1 references)
pkts bytes target     prot opt in     out     source               
destination
    0     0 ACCEPT     icmp --  *      *       0.0.0.0/0            
0.0.0.0/0           icmp type 3
    0     0 ACCEPT     esp  --  *      *       0.0.0.0/0            
0.0.0.0/0
    0     0 ACCEPT     udp  --  *      *       0.0.0.0/0            
0.0.0.0/0           multiport dports 500,4500

For now, I have workarounded the problem adding a rule for every ipsec 
gateway,
but this is a problem for mobile users.

Chain INPUT (policy DROP 133 packets, 11320 bytes)
pkts bytes target     prot opt in     out     source               
destination
  557 93608 ACCEPT     all  --  *      *       milano_gateay        
0.0.0.0/0
  313 31275 ACCEPT     all  --  *      *       venice_gateway       
0.0.0.0/0
    0     0 ACCEPT     all  --  *      *       127.0.0.1            
127.0.0.1
    2   232 ACCEPT     all  --  *      *       0.0.0.0/0            
0.0.0.0/0           state RELATED,ESTABLISHED
    2   160 red-me     all  --  eth0   *       0.0.0.0/0            
0.0.0.0/0


Chain red-me (1 references)
pkts bytes target     prot opt in     out     source               
destination
    0     0 ACCEPT     icmp --  *      *       0.0.0.0/0            
0.0.0.0/0           icmp type 3
    0     0 ACCEPT     esp  --  *      *       0.0.0.0/0            
0.0.0.0/0
    0     0 ACCEPT     udp  --  *      *       0.0.0.0/0            
0.0.0.0/0           multiport dports 500,4500

Is this the correct behaviour?
FYI: tunnels are ESP+IPCOMP
