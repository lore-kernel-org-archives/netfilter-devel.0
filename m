From: "Eliot, Wireless and Server Administrator,  Great Lakes Internet" <support8@greatlakes.net>
Subject: RE: iptables CLASSIFY and MARK not working?
Date: Thu, 1 Jun 2006 14:49:51 -0400
Message-ID: <0633E0EDB4F25F43A2D7179CA11FAFAB255415@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <lartc-bounces@mailman.ds9a.nl>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Thursday, June 01, 2006 2:23 PM
To: Eliot, Wireless and Server Administrator, Great Lakes Internet
Cc: lartc@mailman.ds9a.nl; Netfilter Development Mailinglist
Subject: Re: [LARTC] iptables CLASSIFY and MARK not working?

> Eliot, Wireless and Server Administrator, Great Lakes Internet wrote:
> > However, this still does not work:
> >=20
> > Chain POSTROUTING (policy ACCEPT 812K packets, 441M bytes)
> >  pkts bytes target     prot opt in     out     source
> > destination
> >  2071  129K CLASSIFY   all  --  *      br1     0.0.0.0/0
> > 0.0.0.0/0           MARK match 0x1fe CLASSIFY set 1c7:0
> >     2   521 CLASSIFY   all  --  *      br1     0.0.0.0/0
> > 0.0.0.0/0           MARK match 0x1ff CLASSIFY set 1c8:0
> >     0     0 CLASSIFY   all  --  *      br1     0.0.0.0/0
> > 0.0.0.0/0           MARK match 0x200 CLASSIFY set 1c9:0
> >  2760 4060K CLASSIFY   all  --  *      wivl4   0.0.0.0/0
> > 0.0.0.0/0           MARK match 0x1fe CLASSIFY set 1db:0
> >     3   500 CLASSIFY   all  --  *      wivl4   0.0.0.0/0
> > 0.0.0.0/0           MARK match 0x1ff CLASSIFY set 1dc:0
> >     0     0 CLASSIFY   all  --  *      wivl4   0.0.0.0/0
> > 0.0.0.0/0           MARK match 0x200 CLASSIFY set 1dd:0
> >=20
> >=20
> > wireless-r1 bwlimit # tc -s qdisc show dev wivl4
> > qdisc hfsc 5: default 2
> >  Sent 8554815 bytes 7797 pkt (dropped 6, overlimits 13 requeues 0)
> >  rate 0bit 0pps backlog 0b 0p requeues 0
> > qdisc sfq 1db: parent 5:1fe limit 128p quantum 1514b
> >  Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >  rate 0bit 0pps backlog 0b 0p requeues 0
> > qdisc sfq 1dc: parent 5:1ff limit 128p quantum 1514b
> >  Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >  rate 0bit 0pps backlog 0b 0p requeues 0
> > qdisc sfq 1dd: parent 5:200 limit 128p quantum 1514b
> >  Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
> >  rate 0bit 0pps backlog 0b 0p requeues 0
>
>=20
> I already told you why this doesn't work, you have to classify to
> the _classes_, not the qdiscs.


These rules make it go to the classes instead of the qdisc:

- Adding rules to classify traffic on br1 ...
  - iptables -A POSTROUTING -t mangle -o br1 -m mark --mark 0x1FE -j
CLASSIFY --set-class 0x5:0x1FE
  - iptables -A POSTROUTING -t mangle -o br1 -m mark --mark 0x1FF -j
CLASSIFY --set-class 0x5:0x1FF
  - iptables -A POSTROUTING -t mangle -o br1 -m mark --mark 0x200 -j
CLASSIFY --set-class 0x5:0x200

- Adding rules to classify traffic on wivl4 ...
  - iptables -A POSTROUTING -t mangle -o wivl4 -m mark --mark 0x1FE -j
CLASSIFY --set-class 0x5:0x1FE
  - iptables -A POSTROUTING -t mangle -o wivl4 -m mark --mark 0x1FF -j
CLASSIFY --set-class 0x5:0x1FF
  - iptables -A POSTROUTING -t mangle -o wivl4 -m mark --mark 0x200 -j
CLASSIFY --set-class 0x5:0x200


Chain POSTROUTING (policy ACCEPT 887K packets, 495M bytes)
 pkts bytes target     prot opt in     out     source
destination
 8662  508K CLASSIFY   all  --  *      br1     0.0.0.0/0
0.0.0.0/0           MARK match 0x1fe CLASSIFY set 5:1fe
   14  8253 CLASSIFY   all  --  *      br1     0.0.0.0/0
0.0.0.0/0           MARK match 0x1ff CLASSIFY set 5:1ff
    0     0 CLASSIFY   all  --  *      br1     0.0.0.0/0
0.0.0.0/0           MARK match 0x200 CLASSIFY set 5:200
  845  222K CLASSIFY   all  --  *      wivl4   0.0.0.0/0
0.0.0.0/0           MARK match 0x1fe CLASSIFY set 5:1fe
   22  5286 CLASSIFY   all  --  *      wivl4   0.0.0.0/0
0.0.0.0/0           MARK match 0x1ff CLASSIFY set 5:1ff
    0     0 CLASSIFY   all  --  *      wivl4   0.0.0.0/0
0.0.0.0/0           MARK match 0x200 CLASSIFY set 5:200



And yet, still nothing hits the classes:



wireless-r1 ~ # tc -s class show dev wivl4
class hfsc 5: root
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 1

class hfsc 5:1fe parent 5: leaf 1db: sc m1 400000bit d 30.0ms m2
128000bit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 5:1 parent 5: sc m1 0bit d 2.6ms m2 30000Kbit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 5:1ff parent 5: leaf 1dc: sc m1 2560Kbit d 2.0s m2 512000bit
ul m1 2560Kbit d 2.0s m2 2048Kbit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 5:2 parent 5: ls m1 60000Kbit d 2.0s m2 60000Kbit ul m1
60000Kbit d 2.0s m2 60000Kbit
 Sent 19906674 bytes 13396 pkt (dropped 9, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 13396 work 19906674 bytes level 0

class hfsc 5:200 parent 5: leaf 1dd: ls m1 1024Kbit d 2.0s m2 1024Kbit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 5:3 parent 5: ls m1 10000Kbit d 2.0s m2 10000Kbit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 5:1fa parent 5: leaf 1d7: ls m1 64000bit d 2.0s m2 64000bit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 5:1f8 parent 5: leaf 1d5: sc m1 400000bit d 30.0ms m2
128000bit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0

class hfsc 5:1f9 parent 5: leaf 1d6: sc m1 160000bit d 2.0s m2 32000bit
ul m1 160000bit d 2.0s m2 128000bit
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 0 level 0


wireless-r1 ~ # tc -s class show dev br1
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
 Sent 856222 bytes 10041 pkt (dropped 13, overlimits 0 requeues 0)
 rate 0bit 0pps backlog 0b 0p requeues 0
 period 10041 work 856222 bytes level 0

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



No matter how I write these rules, it always still goes to the default
class (5:2 or 1:2). If this is still wrong, please give me an example of
what I should be writing.=20


=20
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
