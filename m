From: eddie shi <shenminshi@yahoo.com>
Subject: Re: snmp-basic
Date: Mon, 13 Jan 2003 09:43:50 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030113174350.45634.qmail@web40303.mail.yahoo.com>
References: <Pine.LNX.4.44.0301140052140.7621-100000@blackbird.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: James Morris <jmorris@intercode.com.au>
In-Reply-To: <Pine.LNX.4.44.0301140052140.7621-100000@blackbird.intercode.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--- James Morris <jmorris@intercode.com.au> wrote:
> On Sun, 12 Jan 2003, eddie shi wrote:
> 
> >   Is there something obvious I forgot to do? I am
> > using 2.4.17 kernel with newnat patched. I also
> use
> > iptables to do portfording of snmp port 161 to one
> of
> > my internal box running snmp agent. Here is my
> rule.
> >  
> >    iptables -t nat -A PREROUTING -i eth1 -p udp
> > --dport 161 -j DNAT --to 192.168.1.5
> > 
> >    Are there any other rules I need to add?
> 
> If it was an SNMP trap, yes.  It has to be
> configured separately with 
> an SNAT rule (see below).
> 
> What addresses are you trying to translate?
> 

My NAT box has two interfaces:
  
   eth1 (to my ISP): 64.x.y.z
   eth0 (my private net):(192.168.1.0/24)

   I also have a rule performing MASQUERAD in the
FORWARD chain, 192.168.1.0 -> 64.x.y.z perform SNAT.

   My snmp manager is a linux box from another public
IP address.
   I can use snmpwalk from manager :

    snmpwalk -v2c -c public 64.x.y.z ip
   to get all ip MIBS, however, instead of getting
ipAddrEntry with 64.x.y.x, I am still getting
192.168.1.5. The nat_help() in ip_nat_snmp_basic.c did
not get called from nat core at all. My printk()
messages did not show-up on the log/console.

   I should not have to do anything with snmp trap at
this point yet right?
> > 
> >    BTW, does anyone know why there is no
> connection
> > tracking module (ie ip_conntrack_snmp_basic.c) for
> > this ?
> >    All other modules (ftp,talk,irc and etc) are
> > working fine in the system.
> 
> It doesn't need a special connection tracking
> helper, as it doesn't have 
> any specially related connections to manage.
> 

good.
> Below is some old documentation about the
> development/test setup from the
> original package before the code was incorporated
> into the kernel, it may
> be useful in general.
> 

Thanks.

ED
> - James
> -- 
> James Morris
> <jmorris@intercode.com.au>
> 
> [note that the module is called ip_nat_snmp_basic
> instead of bsalg now]
> 
> -  The module may be loaded with 'insmod bsalg'.
> 
> -  Debugging may be enabled with 'debug' as a module
> parameter, 
>    either with 'insmod bsalg debug=1' or adding 
>    'options bsalg debug=1' to the file
> '/etc/conf.modules'.
>    
>    Setting this to a value of 1 will show IP address
> mappings, while
>    setting it to 2 will provide highly verbose
> debugging info about
>    the snmp parsing.
>    
> - Try a test like the following from your NMS:
>    
>    'snmpget 1.5.5.2 public
> ip.ipRouteTable.ipRouteEntry.ipRouteNextHop.0.0.0.0'
>    
>    where 1.5.5.2 is the DNAT'd address of the node,
> which has a real address
>    of 10.5.5.2.
>    
>    The response should look something like:
>    
>   
> 'ip.ipRouteTable.ipRouteEntry.ipRouteNextHop.0.0.0.0
> = IpAddress: 1.5.5.1'
>    
>    instead of:
>    
>   
> 'ip.ipRouteTable.ipRouteEntry.ipRouteNextHop.0.0.0.0
> = IpAddress: 10.5.5.1'
>    
> 
> -  General info.
> 
>    For the moment, you will need explicit SNAT rules
> to allows traps to also
>    be processed by the module.
>    
>    This is the NAT table on the system that the code
> was developed on:
>    
>    # iptables -L -n -t nat
>    Chain PREROUTING (policy ACCEPT)
>    target     prot opt source              
> destination         
>    DNAT       all  --  0.0.0.0/0            1.5.5.2 
>           to:10.5.5.2 
>    
>    Chain POSTROUTING (policy ACCEPT)
>    target     prot opt source              
> destination         
>    SNAT       all  --  10.5.5.2            
> 0.0.0.0/0          to:1.5.5.2 
>    
>    Chain OUTPUT (policy ACCEPT)
>    target     prot opt source              
> destination    
> 
> 
>    And a diagram of the topology:
>    
>    +---------------------- +
>    | NMS Box 192.168.32.12 |
>    +-----------------------+
>               | eth0
>               |
>               | eth0
>    +---------------------- +
>    | NAT Box 192.168.32.14 |
>    |         10.5.5.1      |
>    +-----------------------+
>               | eth1
>               |
>               | eth0
>    +---------------------- +
>    | Node    10.5.5.2      |
>    +-----------------------+
>    
>    The NMS box running snmpwalk/get and tkined can
> communicate with the node 
>    10.5.5.2 using 1.5.5.2 as a destination (and
> source of snmp traps).
>    
>    
>    
>    
>    
> 


__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
