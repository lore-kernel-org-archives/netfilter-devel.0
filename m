From: Zheng Da <zhengda1936@gmail.com>
Subject: The module I write seems to have conflict with iptables
Date: Sun, 29 Jul 2007 19:06:43 +0200
Message-ID: <46ACC923.6050600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

I write a module based on netfilter.
It is proposed to be used in the filter router, is hooked on FORWARD 
point, and has the lowest priority, NF_IP_PRI_LAST.
It does the following things:
When it finds TCP connection from the client to the server, it will 
pretend as the server to build the connection with the client. It blocks 
the SYN and ACK packets from the client, and sends a UDP packet to the 
server, which can force the server build the TCP connection with the client.
It works as follow:
Client                              Router                              
   Server
          -----------SYN--------->
          <-------SYN,ACK----
          -----------ACK--------->
                                                   
----------UDP-------------->
The UDP packet sent by Router contains all information about the TCP 
connection, and can force Server build the TCP connection with Client.
Suppose the topology is as follow:
Client ----------(eth0) Router (eth1) --------- Server
eth1 of Router and Server can't see the SYN and ACK packet from the 
client because of the module in Router.
I want this module to work with iptables, and the configuration of 
iptables in Router is:
iptables -F
iptables -X
iptables -P FORWARD DROP
iptables -A FORWARD -i eth1 -j ACCEPT
iptables -A FORWARD -i eth0 -m state --state ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -p tcp --dport 22 -m state --state 
ESTABLISHED,NEW -j ACCEPT
I want the client can only access SSH service on Server.
After I insert my module into the kernel, Client can build TCP 
connection with Server, and they can communicate with each other.
But after a few minutes, Server can't receive the packets from the 
client any more. So is my module.
If I clear iptables' rules, the module can work well.
So I guess the module I write may have conflict with iptables.
I don't know how the connection track of iptables works.
Is it possible that my module may make the connection track not work.

Best,
Zheng jDa
