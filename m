From: cranium2003 <cranium2003@yahoo.com>
Subject: Re: why incoming packet's device not logging?
Date: Sat, 21 May 2005 06:22:57 -0700 (PDT)
Message-ID: <20050521132257.47026.qmail@web33002.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: 6667
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

hello,

>   <snip>
> > -A INPUT -j RH-Lokkit-0-50-INPUT 
> > -A INPUT -j LOG 
>   <snip>
> > -A RH-Lokkit-0-50-INPUT -i lo -j ACCEPT 
> > -A RH-Lokkit-0-50-INPUT -i eth0 -j ACCEPT 
> > -A RH-Lokkit-0-50-INPUT -i eth1 -j ACCEPT 
> 
> It seems that these last three rules accept
> basically all packets and
> thus the LOG rule is never reached.. Or do you have
> more network cards
> than eth0 and eth1 ?
> 
> You say it works for FORWARD, but I don't think I
> see how it could..
>    
> I wonder if those ACCEPTs are there by mistake..
> maybe they should be at
> the end of the RH-Lokkit-0-50-INPUT chain instead?
> 
> If you need further help, please give more info
> about your network setup.

 my ifconfig is
eth0      Link encap:Ethernet  HWaddr
00:80:48:C3:11:94  
          inet addr:10.1.1.1  Bcast:10.255.255.255 
Mask:255.0.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500 
Metric:1
          RX packets:110647 errors:0 dropped:0
overruns:0 frame:0
          TX packets:97 errors:0 dropped:0 overruns:0
carrier:0
          collisions:1 txqueuelen:1000 
          RX bytes:6839310 (6.5 Mb)  TX bytes:6715
(6.5 Kb)
          Interrupt:11 Base address:0xdc00 

eth1      Link encap:Ethernet  HWaddr
00:08:A1:43:61:F5  
          inet addr:192.168.1.10  Bcast:192.168.1.255 
Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500 
Metric:1
          RX packets:33 errors:0 dropped:0 overruns:0
frame:0
          TX packets:29 errors:0 dropped:0 overruns:0
carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:3494 (3.4 Kb)  TX bytes:2246 (2.1
Kb)
          Interrupt:9 Base address:0x9c00 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0
frame:0
          TX packets:0 errors:0 dropped:0 overruns:0
carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

my routing table is
Kernel IP routing table
Destination     Gateway         Genmask         Flags
Metric Ref    Use Iface
192.168.1.0     0.0.0.0         255.255.255.0   U    
0      0        0 eth1
169.254.0.0     0.0.0.0         255.255.0.0     U    
0      0        0 eth1
10.0.0.0        0.0.0.0         255.0.0.0       U    
0      0        0 eth0
127.0.0.0       0.0.0.0         255.0.0.0       U    
0      0        0 lo
0.0.0.0         10.0.2.10       0.0.0.0         UG   
0      0        0 eth0

regards,
cranium.




		
__________________________________ 
Yahoo! Mail Mobile 
Take Yahoo! Mail with you! Check email on your mobile phone. 
http://mobile.yahoo.com/learn/mail 
