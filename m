From: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
Subject: RE: [LARTC] iptables CLASSIFY and MARK not working?
Date: Thu, 1 Jun 2006 15:38:38 -0400
Message-ID: <0633E0EDB4F25F43A2D7179CA11FAFAB255419@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>
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


-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Thursday, June 01, 2006 3:09 PM
To: Eliot, Wireless and Server Administrator, Great Lakes Internet
Cc: lartc@mailman.ds9a.nl; Netfilter Development Mailinglist
Subject: Re: [LARTC] iptables CLASSIFY and MARK not working?

> The bridge case doesn't work because you're using the wrong major
> number (5 instead of 1), the wivl4 rules look correct. I just tested
> HFSC+CLASSIFY and it works fine for me. What kind of device is wivl4?

I knew I was going to typo something when I did all that hex conversion
this morning. Here is the corrected ruleset:


- Adding rules to classify traffic on br1 ...
  - iptables -A POSTROUTING -t mangle -o br1 -m mark --mark 0x1FE -j
CLASSIFY --set-class 0x1:0x1FE
  - iptables -A POSTROUTING -t mangle -o br1 -m mark --mark 0x1FF -j
CLASSIFY --set-class 0x1:0x1FF
  - iptables -A POSTROUTING -t mangle -o br1 -m mark --mark 0x200 -j
CLASSIFY --set-class 0x1:0x200

- Adding rules to classify traffic on wivl4 ...
  - iptables -A POSTROUTING -t mangle -o wivl4 -m mark --mark 0x1FE -j
CLASSIFY --set-class 0x5:0x1FE
  - iptables -A POSTROUTING -t mangle -o wivl4 -m mark --mark 0x1FF -j
CLASSIFY --set-class 0x5:0x1FF
  - iptables -A POSTROUTING -t mangle -o wivl4 -m mark --mark 0x200 -j
CLASSIFY --set-class 0x5:0x200


Here are the new test results:

Chain POSTROUTING (policy ACCEPT 900K packets, 496M bytes)
 pkts bytes target     prot opt in     out     source
destination
  865 67524 CLASSIFY   all  --  *      br1     0.0.0.0/0
0.0.0.0/0           MARK match 0x1fe CLASSIFY set 1:1fe
   16  1216 CLASSIFY   all  --  *      br1     0.0.0.0/0
0.0.0.0/0           MARK match 0x1ff CLASSIFY set 1:1ff
    0     0 CLASSIFY   all  --  *      br1     0.0.0.0/0
0.0.0.0/0           MARK match 0x200 CLASSIFY set 1:200
  840 91456 CLASSIFY   all  --  *      wivl4   0.0.0.0/0
0.0.0.0/0           MARK match 0x1fe CLASSIFY set 5:1fe
   16  1216 CLASSIFY   all  --  *      wivl4   0.0.0.0/0
0.0.0.0/0           MARK match 0x1ff CLASSIFY set 5:1ff
    0     0 CLASSIFY   all  --  *      wivl4   0.0.0.0/0
0.0.0.0/0           MARK match 0x200 CLASSIFY set 5:200


wireless-r1 bwlimit # tc -s class show dev br1
class hfsc 1: root
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 1

class hfsc 1:1fe parent 1: leaf 1c7: sc m1 400000bit d 30.0ms m2
128000bit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 1:1 parent 1: sc m1 0bit d 2.6ms m2 30000Kbit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 1:1ff parent 1: leaf 1c8: sc m1 640000bit d 2.0s m2 128000bit
ul m1 640000bit d 2.0s m2 512000bit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 1:2 parent 1: ls m1 60000Kbit d 2.0s m2 60000Kbit ul m1
60000Kbit d 2.0s m2 60000Kbit
 Sent 187981 bytes 1698 pkt (dropped 3, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 1698 work 187981 bytes level 0

class hfsc 1:200 parent 1: leaf 1c9: ls m1 256000bit d 2.0s m2 256000bit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 1:3 parent 1: ls m1 10000Kbit d 2.0s m2 10000Kbit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 1:1fa parent 1: leaf 1c3: ls m1 32000bit d 2.0s m2 32000bit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 1:1f8 parent 1: leaf 1c1: sc m1 400000bit d 30.0ms m2
128000bit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 1:1f9 parent 1: leaf 1c2: sc m1 80000bit d 2.0s m2 16000bit
ul m1 80000bit d 2.0s m2 64000bit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0


Both devices (br1 and wivl4) are bridged interfaces with spanning tree
turned on. They also do VLANs. Specifically, vconfig was used to create
a VLAN (in this case, VLAN 4) on two interfaces: eth2 and eth3. These
two VLAN interfaces were called e2v4 and e3v4. Then, brctl was used to
bridge the two VLAN interfaces (e2v4 and e3v4) into a new interface
called wivl4. Spanning tree was then enabled on wivl4. The MTU size was
then adjusted -4 bytes to accommodate the VLAN tagging.=20


Also, did you happen to try my specific rules (under different devices)
to see if they work?=20

If possible, could you try creating a VLAN interface and test on that
interface? Then try a bridged interface. And finally, a bridged VLAN
interface.=20

I will try to set this all up on a different machine without the bridged
VLANs and see if it works there.



Eliot Gable
Certified Wireless Network Administrator (CWNA)
Certified Wireless Security Professional (CWSP)
Cisco Certified Network Associate (CCNA)
CompTIA Security+ Certified
CompTIA Network+ Certified
Network and System Engineer
Great Lakes Internet, Inc.
112 North Howard
Croswell, MI 48422
(810) 679-3395
(877) 558-8324
=20
Now offering Broadband Wireless Internet access in Croswell, Lexington,
Brown City, Yale, Worth Township, and Sandusky. Call for details.
