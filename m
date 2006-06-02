From: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
Subject: Bi-directional packet classification with ACK prioritization
Date: Fri, 2 Jun 2006 13:06:23 -0400
Message-ID: <0633E0EDB4F25F43A2D7179CA11FAFAB255421@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter@lists.netfilter.org>, <lartc@mailman.ds9a.nl>,
	"Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
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


Sorry for making this a cross-post, but the pressure is on for getting
this bandwidth shaper working.

I have an interesting dilemma with bi-directional packet classification
while doing ACK prioritization. This is an overly simplified summary of
my setup:

Internet
  |
Eth0=20
  |
  Router
  |
Eth1
  |
Intranet


A client on the Intranet establishes a flow to a server on the Internet.
Packets get classified into 3 different priority bands. Priority 1 is
for VoIP, DNS, SSH, Telnet, and ACK packets with no data payload.
Priority 2 is for general traffic that does not fall into band 1 or band
3. Priority 3 band is for P2P.=20

When the flow (download) is established, it starts out with the packets
coming in on Priority Band 2.=20

The client then sends an ACK packet to the server with no data payload.=20

The router then classifies that ACK packet into Priority Band 1 and
saves the mark that was set to put it in that classification.=20

A response then comes back from the server and the router restores the
mark it previously saved. Now it is flagged for Priority Band 1.=20

The packet now traverses the iptables ruleset and remains classified as
Priority Band 1 because the rules that classify it in a different manner
don't trigger. The reason these rules don't trigger is that the original
marking in the outbound direction is done on SOURCE MAC address. Since I
can't classify on SOURCE MAC address for packets coming back from the
Internet, I am left with using the CONNMARK --restore-mark option.

The response packet thus gets classified back into Priority Band 1 for
going back out to the client on the Intranet.=20

This problem will be true for generally classified traffic and P2P
traffic. I would use tc filters in one direction if I could possibly
distinguish P2P traffic from other types of traffic with them.=20

Essentially, what I need to be able to do is match on _destination_ MAC
address in the iptables POSTROUTING chain in the mangle table, but do
this _before_ it goes through the tc packet classification.=20

Ideally, what should happen is:

ACK packets with no data payload always get classified in Priority Band
1 and the rest of their flow's data gets classified in either Priority
Band 2 or 3 depending on the type of their traffic (or Priority Band 1
if it happens to be VoIP, Telnet, SSH, or DNS). This should happen for
all traffic going in both directions.=20

These are my iptables rules for a single client:

- Adding rules to classify traffic for 00:13:D3:67:D7:05
  - iptables -A macfilter -m mac --mac-source 00:13:D3:67:D7:05=20
  - iptables -I macfilter_nat -t nat -m mac --mac-source
00:13:D3:67:D7:05 -j ACCEPT

- Adding rules to flag General traffic
  - iptables -A PREROUTING -t mangle -m mac --mac-source
00:13:D3:67:D7:05 -j MARK --set-mark 0x1A5=20
  - iptables -A PREROUTING -t mangle -m mark --mark 0x1A5 -j CONNMARK
--save-mark=20

- Adding rules to flag VoIP / Interactive traffic
  - iptables -A PREROUTING -t mangle -p udp -m mac --mac-source
00:13:D3:67:D7:05 -m multiport --ports 53,4569,5060,10000:20000 -j MARK
--set-mark 420
  - iptables -A PREROUTING -t mangle -p tcp -m mac --mac-source
00:13:D3:67:D7:05 -m multiport --ports 22,23,53 -j MARK --set-mark 0x1A4
  - iptables -A PREROUTING -t mangle -p icmp -m mac --mac-source
00:13:D3:67:D7:05 -j MARK --set-mark 0x1A4=20
  - iptables -A PREROUTING -t mangle -p tcp --tcp-flags SYN,RST,ACK ACK
-m length --length :128 -m mac --mac-source 00:13:D3:67:D7:05 -j MARK
--set-mark
 0x1A4=20
  - iptables -A PREROUTING -t mangle -m mark --mark 0x1A4 -j CONNMARK
--save-mark=20

- Adding rules to flag P2P traffic
  - iptables -A PREROUTING -t mangle -m mac --mac-source
00:13:D3:67:D7:05 -m ipp2p --ipp2p -j MARK --set-mark 0x1A6
  - iptables -A PREROUTING -t mangle -m mark --mark 0x1A6 -j CONNMARK
--save-mark=20
  - iptables -I FORWARD -t mangle -m mark --mark 0x1A4 -j ACCEPT
  - iptables -I FORWARD -t mangle -m mark --mark 0x1A5 -j ACCEPT
  - iptables -I FORWARD -t mangle -m mark --mark 0x1A6 -j ACCEPT

- Adding rules to classify traffic on br1
  - iptables -A POSTROUTING -t mangle -o br1 -m mark --mark 0x1A4 -j
CLASSIFY --set-class 0x1:0x1A4=20
  - iptables -A POSTROUTING -t mangle -o br1 -m mark --mark 0x1A5 -j
CLASSIFY --set-class 0x1:0x1A5=20
  - iptables -A POSTROUTING -t mangle -o br1 -m mark --mark 0x1A6 -j
CLASSIFY --set-class 0x1:0x1A6=20

- Adding rules to classify traffic on wivl4
  - iptables -A POSTROUTING -t mangle -o wivl4 -m mark --mark 0x1A4 -j
CLASSIFY --set-class 0x5:0x1A4=20
  - iptables -A POSTROUTING -t mangle -o wivl4 -m mark --mark 0x1A5 -j
CLASSIFY --set-class 0x5:0x1A5=20
  - iptables -A POSTROUTING -t mangle -o wivl4 -m mark --mark 0x1A6 -j
CLASSIFY --set-class 0x5:0x1A6

In these rules, wivl4 is equivalent to eth1 up in the diagram and br1 is
equivalent to eth0.=20

Also, the unshown CONNMARK --restore-mark rule is the first rule in the
PREROUTING mangle chain.=20

If anyone could be of assistance in solving this little dilemma, it
would be greatly appreciated.
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
=20
Now offering Broadband Wireless Internet access in Croswell, Lexington,
Brown City, Yale, Worth Township, and Sandusky. Call for details.
