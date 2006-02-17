From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: ipsec with 2.6.16-rc3-git6
Date: Fri, 17 Feb 2006 10:57:05 +0100
Message-ID: <BAY103-F368CBB750059A4D52A2C72B2F80@phx.gbl>
References: <43F5978E.8010203@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <43F5978E.8010203@trash.net>
To: kaber@trash.net
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


Patrick McHardy wrote:

>Marco Berizzi wrote:
> >
> > Patrick McHardy wrote:
> >
> >> I can't see a mistake. Can you please add a logging rule to log
> >> the packets that get dropped without the ACCEPT rule?
> >
> >
> > Sure! Here is:
> >
> > root@Halley:/tmp# iptables -D INPUT -s venezia-gateway -j ACCEPT
> >
> > [started ping from a venezia private host ----> to firenze private host]
> >
> > root@Halley:/tmp# iptables -I INPUT -s venezia-gateway -j LOG
> > --log-level debug --log-ip-options
> >
> > IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00
> > SRC=venezia-gateway DST=firenze-gateway LEN=112 TOS=0x00 PREC=0x00
> > TTL=53 ID=45921 PROTO=ESP SPI=0x583f3ff9
> > IN=eth0 OUT= MAC=00:90:27:74:66:4c:00:0c:ce:93:65:ce:08:00
> > SRC=venezia-gateway DST=firenze-gateway LEN=80 TOS=0x00 PREC=0x00 TTL=53
> > ID=45921 PROTO=4
>
>Thats odd, these packets should be caught by your ESP rule, so I guess
>they must be dropped by another rule. Please post your full ruleset with
>iptables -vxnL.

root@Halley:/tmp# iptables -vxnL
Chain INPUT (policy DROP 20200 packets, 2365881 bytes)
    pkts      bytes target     prot opt in     out     source               
destination
   64008 21604598 ACCEPT     all  --  *      *       venezia-gateway       
0.0.0.0/0
       0        0 ACCEPT     all  --  *      *       127.0.0.1            
127.0.0.1
     221    26259 ACCEPT     all  --  *      *       0.0.0.0/0            
0.0.0.0/0           state RELATED,ESTABLISHED
   14098  1492569 green-me   all  --  eth2   *       172.23.0.0/23        
0.0.0.0/0
    5787   840702 dmz-me     all  --  eth1   *       firenze-dmz/27       
0.0.0.0/0
     302    27969 red-me     all  --  eth0   *       0.0.0.0/0            
0.0.0.0/0

Chain FORWARD (policy DROP 3024 packets, 388141 bytes)
    pkts      bytes target     prot opt in     out     source               
destination
  301354 107910370 ACCEPT     all  --  *      *       0.0.0.0/0            
0.0.0.0/0           state RELATED,ESTABLISHED
    1862   308821 ACCEPT     all  --  *      *       172.23.0.0/23        
172.16.0.0/23
     705    59180 ACCEPT     all  --  *      *       172.16.0.0/23        
172.23.0.0/23
       0        0 ACCEPT     all  --  *      *       172.23.0.0/23        
172.23.2.0/23
       0        0 ACCEPT     all  --  *      *       172.23.2.0/23        
172.23.0.0/23
    4055   518835 ACCEPT     all  --  *      *       172.23.0.0/23        
172.18.1.0/24
    2812   767931 ACCEPT     all  --  *      *       172.18.1.0/24        
172.23.0.0/23
       4      420 ACCEPT     all  --  *      *       172.23.0.0/23        
172.25.1.0/24
       0        0 ACCEPT     all  --  *      *       172.25.1.0/24        
172.23.0.0/23
       0        0 ACCEPT     all  --  *      *       172.23.0.0/23        
172.25.5.0/24
       0        0 ACCEPT     all  --  *      *       172.25.5.0/24        
172.23.0.0/23
       7      762 ACCEPT     all  --  *      *       172.23.0.0/23        
172.17.1.0/24
      31     1860 ACCEPT     all  --  *      *       172.17.1.0/24        
172.23.0.0/23
       0        0 ACCEPT     all  --  *      *       172.23.0.0/23        
172.22.1.0/24
       0        0 ACCEPT     all  --  *      *       172.22.1.0/24        
172.23.0.0/23
       7      762 ACCEPT     all  --  *      *       172.23.0.0/23        
172.21.1.0/24
       0        0 ACCEPT     all  --  *      *       172.21.1.0/24        
172.23.0.0/23
       1       60 green-red  all  --  eth2   eth0    172.23.0.0/23        
0.0.0.0/0
       0        0 green-dmz  all  --  eth2   eth1    172.23.0.0/23        
firenze-dmz/27
      42     2612 dmz-red    all  --  eth1   eth0    firenze-dmz/27       
0.0.0.0/0
       0        0 dmz-green  all  --  eth1   eth2    firenze-dmz/27       
172.23.0.0/23
    3023   388081 syn-flood-dmz  all  --  eth0   eth1    0.0.0.0/0           
  firenze-dmz/27
       0        0 syn-flood-green  all  --  eth0   eth2    0.0.0.0/0         
    172.23.0.0/23

Chain OUTPUT (policy DROP 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               
destination
       0        0 ACCEPT     all  --  *      *       127.0.0.1            
127.0.0.1
   99249 31713374 ACCEPT     all  --  *      *       0.0.0.0/0            
0.0.0.0/0           state RELATED,ESTABLISHED
       0        0 me-green   all  --  *      eth2    0.0.0.0/0            
172.23.0.0/23
       0        0 me-dmz     all  --  *      eth1    0.0.0.0/0            
firenze-dmz/27
     159    30006 me-red     all  --  *      eth0    0.0.0.0/0            
0.0.0.0/0

Chain dmz-green (1 references)
    pkts      bytes target     prot opt in     out     source               
destination
       0        0 icmp-me    icmp --  *      *       0.0.0.0/0            
0.0.0.0/0
       0        0 REJECT     all  --  *      *       0.0.0.0/0            
0.0.0.0/0           reject-with icmp-host-unreachable

Chain dmz-me (1 references)
    pkts      bytes target     prot opt in     out     source               
destination

Chain dmz-red (1 references)
    pkts      bytes target     prot opt in     out     source               
destination
       0        0 icmp-me    icmp --  *      *       0.0.0.0/0            
0.0.0.0/0
      37     2292 ACCEPT     all  --  *      *       firenze-dmz/27       
venezia-dmz/27

Chain green-dmz (1 references)
    pkts      bytes target     prot opt in     out     source               
destination
       0        0 ACCEPT     all  --  *      *       0.0.0.0/0            
0.0.0.0/0

Chain green-me (1 references)
    pkts      bytes target     prot opt in     out     source               
destination
       0        0 ACCEPT     icmp --  *      *       172.23.1.4           
0.0.0.0/0           icmp type 8

Chain green-red (1 references)
    pkts      bytes target     prot opt in     out     source               
destination

Chain icmp-me (3 references)
    pkts      bytes target     prot opt in     out     source               
destination
       0        0 ACCEPT     icmp --  *      *       0.0.0.0/0            
0.0.0.0/0           icmp type 0
       0        0 ACCEPT     icmp --  *      *       0.0.0.0/0            
0.0.0.0/0           icmp type 8
       1       68 ACCEPT     icmp --  *      *       0.0.0.0/0            
0.0.0.0/0           icmp type 3

Chain me-dmz (1 references)
    pkts      bytes target     prot opt in     out     source               
destination

Chain me-green (1 references)
    pkts      bytes target     prot opt in     out     source               
destination

Chain me-red (1 references)
    pkts      bytes target     prot opt in     out     source               
destination
       1       68 icmp-me    icmp --  *      *       0.0.0.0/0            
0.0.0.0/0
       7     1136 ACCEPT     esp  --  *      *       0.0.0.0/0            
0.0.0.0/0
       0        0 ACCEPT     tcp  --  *      *       0.0.0.0/0            
0.0.0.0/0           multiport dports 53,123
     151    28802 ACCEPT     udp  --  *      *       0.0.0.0/0            
0.0.0.0/0           multiport dports 53,123,500,4500

Chain red-dmz (3 references)
    pkts      bytes target     prot opt in     out     source               
destination
       0        0 ACCEPT     all  --  *      *       venezia-dmz/27    
firenze-dmz/27

Chain red-green (3 references)
    pkts      bytes target     prot opt in     out     source               
destination

Chain red-me (1 references)
    pkts      bytes target     prot opt in     out     source               
destination
       0        0 ACCEPT     icmp --  *      *       0.0.0.0/0            
0.0.0.0/0           icmp type 3
       0        0 ACCEPT     esp  --  *      *       0.0.0.0/0            
0.0.0.0/0
       0        0 ACCEPT     udp  --  *      *       0.0.0.0/0            
0.0.0.0/0           multiport dports 500,4500

Chain syn-flood-dmz (1 references)
    pkts      bytes target     prot opt in     out     source               
destination
    1404    69840 red-dmz    tcp  --  *      *       0.0.0.0/0            
0.0.0.0/0           tcp flags:0x17/0x02 limit: avg 1/sec burst 5
       4      160 red-dmz    tcp  --  *      *       0.0.0.0/0            
0.0.0.0/0           tcp flags:0x17/0x04 limit: avg 1/sec burst 5
     806   278640 red-dmz    udp  --  *      *       0.0.0.0/0            
0.0.0.0/0

Chain syn-flood-green (1 references)
    pkts      bytes target     prot opt in     out     source               
destination
       0        0 red-green  tcp  --  *      *       0.0.0.0/0            
0.0.0.0/0           tcp flags:0x17/0x02 limit: avg 20/min burst 5
       0        0 red-green  tcp  --  *      *       0.0.0.0/0            
0.0.0.0/0           tcp flags:0x17/0x04 limit: avg 20/min burst 5
       0        0 red-green  udp  --  *      *       0.0.0.0/0            
0.0.0.0/0
root@Halley:/tmp#
