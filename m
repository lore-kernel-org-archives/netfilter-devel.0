From: Dirk Morris <dmorris@metaloft.com>
Subject: Re: REDIRECT differences in 2.6.12.2
Date: Mon, 11 Jul 2005 16:01:49 -0700
Message-ID: <42D2FA5D.6060708@metaloft.com>
References: <42CADB0F.5010804@metaloft.com>
	<42CDD0DA.20303@trash.net>	<42CECAFB.6070709@metaloft.com>
	<42CFE495.9000904@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42CFE495.9000904@trash.net>
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

Hey Patrick,

A bit more info:

internet <--> [alice 192.168.1.1]  <-->  [eve 192.168.1.2] <--> [bob 
192.168.1.3]

alice and bob are on 2.6.8.1, alice is running ipmasq so that eve and 
bob can get to the internet.

eve is a bridge:

~ # uname -a                                               
Linux eve 2.6.12.2 #4 SMP Fri Jul 8 11:05:21 PDT 2005 i686 GNU/Linux

~ # s iptables -t nat -nL                                  
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination        
REDIRECT   tcp  --  0.0.0.0/0            0.0.0.0/0           tcp 
dpt:1234 redir
ports 1234

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination        

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination    

~ # cat 
ifconfig                                                                                            

br0       Link encap:Ethernet  HWaddr 00:30:48:82:CC:A0 
          inet addr:192.168.2.2  Bcast:192.168.2.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3009 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2009 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:245119 (239.3 KiB)  TX bytes:453531 (442.9 KiB)

eth0      Link encap:Ethernet  HWaddr 00:30:48:82:CC:A0 
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:2758 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2344 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:262532 (256.3 KiB)  TX bytes:496238 (484.6 KiB)
          Base address:0xc000 Memory:f2000000-f2020000

eth1      Link encap:Ethernet  HWaddr 00:30:48:82:CC:A1 
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:348 errors:0 dropped:0 overruns:0 frame:0
          TX packets:506 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:50201 (49.0 KiB)  TX bytes:58129 (56.7 KiB)
          Base address:0xd100 Memory:f1000000-f10200

~ # brctl show br0   
bridge name     bridge id               STP enabled     interfaces
br0             8000.00304882cca0       no              eth0
                                                        eth1
~ # route -n      
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use 
Iface
192.168.2.0     0.0.0.0         255.255.255.0   U     0      0        0 br0
0.0.0.0         192.168.2.1     0.0.0.0         UG    0      0        0 br0


I can give you lots more info if you like.

Hope this helps!

-Dirk

Patrick McHardy wrote:

> Dirk Morris wrote:
>
>> eve: iptables -t nat -A PREROUTING -p tcp --destination-port 1234 -j 
>> REDIRECT --to-port 1234
>> eve: echo 255 > /proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid
>> eve: nc -p -l 1234
>>
>> alice: telnet bob 1234
>>
>> messages on eve (192.168.2.2) shows:
>>
>> Jul  8 11:47:34 cartman kernel: ip_ct_tcp: invalid packet ignored IN= 
>> OUT= PHYSIN=eth0 SRC=192.168.2.1 DST=192.168.2.3 LEN=60 TOS=0x10 
>> PREC=0x00 TTL=64 ID=18927 DF PROTO=TCP SPT=33080 DPT=1234 
>> SEQ=1119072953 ACK=0 WINDOW=5840 RES=0x00 SYN URGP=0 OPT 
>> (020405B40402080A18B1070F0000000001030307)
>
>
> You didn't mention anything about a bridge. Please describe your setup
> in full detail. And please use IPs instead of names.
>
> Regards
> Patrick
>
