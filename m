From: James Morris <jmorris@intercode.com.au>
Subject: Re: What is ip_nat_snmp_basic's interface?
Date: Wed, 10 Jul 2002 01:19:41 +1000 (EST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Mutt.LNX.4.44.0207100111360.31381-100000@blackbird.intercode.com.au>
References: <F127T34CnsdreDIOZWe00008c35@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Eyal k <lalala103@hotmail.com>
In-Reply-To: <F127T34CnsdreDIOZWe00008c35@hotmail.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 9 Jul 2002, Eyal k wrote:

> 
> Hi. I'm having difficulties setting up the ip_nat_snmp_basic module.
> I can't seem to find information how to define mapping rules for it, there's 
> no documentation of anything alike in iptables and ipchains.
> If any of you could shed a light on this, I would be grateful.
> 

I've found the INSTALL file from a much earlier version (when it was 
called 'bsalg' and not part of the kernel), and included it below.  It should 
contain enough information to get up and running.  Obviously, steps 1-5 
are not relevant any more, and you need to have the helper module loaded.  

Note that the ALG is only designed for re-mapping entire /8 networks.

-----------------------------------------------------------------------------
$Id: INSTALL,v 1.8 2000/06/24 16:34:45 jmorris Exp $

Installation instructions for BSALG v0.5.0.

1) Requirements:
	Kernel: 2.4.0-test1-ac21
	Iptables: 1.1.0
	Patches: none

2) Check that the kernel is configured with loadable module support,
   Netfilter and full NAT support.

3) Set your KERNEL_DIR environment variable to the directory where
   your kernel lives (defaults to '/usr/src/linux').
   
4) Type 'make install'.

5) The module may be loaded with 'insmod bsalg'.

6) Debugging may be enabled with 'debug' as a module parameter, 
   either with 'insmod bsalg debug=1' or adding 
   'options bsalg debug=1' to the file '/etc/conf.modules'.
   
   Setting this to a value of 1 will show IP address mappings, while
   setting it to 2 will provide highly verbose debugging info about
   the snmp parsing.
   
7) Try a test like the following from your NMS:
   
   'snmpget 1.5.5.2 public ip.ipRouteTable.ipRouteEntry.ipRouteNextHop.0.0.0.0'
   
   where 1.5.5.2 is the DNAT'd address of the node, which has a real address
   of 10.5.5.2.
   
   The response should look something like:
   
   'ip.ipRouteTable.ipRouteEntry.ipRouteNextHop.0.0.0.0 = IpAddress: 1.5.5.1'
   
   instead of:
   
   'ip.ipRouteTable.ipRouteEntry.ipRouteNextHop.0.0.0.0 = IpAddress: 10.5.5.1'
   

8) General info.

   For the moment, you will need explicit SNAT rules to allows traps to also
   be processed by the module.
   
   This is the NAT table on the system that the code was developed on:
   
   # iptables -L -n -t nat
   Chain PREROUTING (policy ACCEPT)
   target     prot opt source               destination         
   DNAT       all  --  0.0.0.0/0            1.5.5.2            to:10.5.5.2 
   
   Chain POSTROUTING (policy ACCEPT)
   target     prot opt source               destination         
   SNAT       all  --  10.5.5.2             0.0.0.0/0          to:1.5.5.2 
   
   Chain OUTPUT (policy ACCEPT)
   target     prot opt source               destination    


   And a diagram of the topology:
   
   +---------------------- +
   | NMS Box 192.168.32.12 |
   +-----------------------+
              | eth0
              |
              | eth0
   +---------------------- +
   | NAT Box 192.168.32.14 |
   |         10.5.5.1      |
   +-----------------------+
              | eth1
              |
              | eth0
   +---------------------- +
   | Node    10.5.5.2      |
   +-----------------------+
   
   The NMS box running snmpwalk/get and tkined can communicate with the node 
   10.5.5.2 using 1.5.5.2 as a destination (and source of snmp traps).
   
-----------------------------------------------------------------------------    
   
   
   
