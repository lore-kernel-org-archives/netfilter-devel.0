From: "Eble, Dan" <DanE@aiinet.com>
Subject: RE: Re:  Any way of knowing a packet's been defragmented
Date: Thu, 5 Aug 2004 10:58:17 -0400
Sender: bridge-bounces@lists.osdl.org
Message-ID: <C0170D0AF1277849A4B4518034F855DD0CFC55@aiexchange.ai.aiinet.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============27441117608308874=="
Cc: bridge <bridge@osdl.org>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>,
   Bart De Schuymer <bdschuym@pandora.be>, shemminger@osdl.org
Return-path: <bridge-bounces@lists.osdl.org>
Content-class: urn:content-classes:message
To: "Henrik Nordstrom" <hno@marasystems.com>
List-Unsubscribe: <http://lists.osdl.org/mailman/listinfo/bridge>,
	<mailto:bridge-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/bridge>
List-Post: <mailto:bridge@lists.osdl.org>
List-Help: <mailto:bridge-request@lists.osdl.org?subject=help>
List-Subscribe: <http://lists.osdl.org/mailman/listinfo/bridge>,
	<mailto:bridge-request@lists.osdl.org?subject=subscribe>
Errors-To: bridge-bounces@lists.osdl.org
List-Id: netfilter-devel.vger.kernel.org

--===============27441117608308874==
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8bit

> -----Original Message-----
> From: Henrik Nordstrom [mailto:hno@marasystems.com] 

> The check should be after all 
> netfilter hooks just before the packet is given to the NIC 
> driver, dropped 
> on transmit because it can not be sent out on the target media, not 
> dropped in "bridge forwarding" because it seems to be bigger than the 
> intended target device.

That makes sense.

Regards,
Dan


--===============27441117608308874==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Bridge mailing list
Bridge@lists.osdl.org
http://lists.osdl.org/mailman/listinfo/bridge

--===============27441117608308874==--
