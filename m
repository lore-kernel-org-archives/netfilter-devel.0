From: "Eble, Dan" <DanE@aiinet.com>
Subject: RE: Re:  Any way of knowing a packet's been defragmented
Date: Thu, 5 Aug 2004 10:35:14 -0400
Sender: bridge-bounces@lists.osdl.org
Message-ID: <C0170D0AF1277849A4B4518034F855DD0CFC54@aiexchange.ai.aiinet.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============70043690348483034=="
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
   bridge <bridge@osdl.org>, shemminger@osdl.org
Return-path: <bridge-bounces@lists.osdl.org>
Content-class: urn:content-classes:message
To: "Henrik Nordstrom" <hno@marasystems.com>,
   "Bart De Schuymer" <bdschuym@pandora.be>
List-Unsubscribe: <http://lists.osdl.org/mailman/listinfo/bridge>,
	<mailto:bridge-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/bridge>
List-Post: <mailto:bridge@lists.osdl.org>
List-Help: <mailto:bridge-request@lists.osdl.org?subject=help>
List-Subscribe: <http://lists.osdl.org/mailman/listinfo/bridge>,
	<mailto:bridge-request@lists.osdl.org?subject=subscribe>
Errors-To: bridge-bounces@lists.osdl.org
List-Id: netfilter-devel.vger.kernel.org

--===============70043690348483034==
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8bit

> -----Original Message-----
> From: bridge-bounces@lists.osdl.org 
> [mailto:bridge-bounces@lists.osdl.org] On Behalf Of Henrik Nordstrom
> 
> Eh.. I do not claim to be a bridge guru, but won't such bridge cause 
> serious havoc on the network much like PMTU blackholes does?
> 
> You should either reject creating such bridge,

IMO, the driver should not bridge any packets from a device with a
larger MTU to a device with a smaller MTU, which I suppose is almost the
same as forbidding such a bridge to be created, but I seem to remember
Stephen's commenting that the 802 bridge spec says it should be done the
way it is now.

> or make sure to fragment packets including ICMP MUST
> FRAGMENT generation when not allowed (which requires an IP).

The ethernet bridge driver is the wrong place to do IP or any other
higher-layer protocol.  Its job is to be a LAN in a box.  If a device
claims that it can only send packets up to a certain size, the bridge
honors that claim.

If connection tracking is coalescing ethernet packets into a size
greater than would otherwise be received from a device, then connection
tracking should be responsible for undoing that damage (where and when,
I don't know), otherwise the ethernet bridge driver will become a
monstrosity of stuff unrelated to ethernet.


--===============70043690348483034==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Bridge mailing list
Bridge@lists.osdl.org
http://lists.osdl.org/mailman/listinfo/bridge

--===============70043690348483034==--
