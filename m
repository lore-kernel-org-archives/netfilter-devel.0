From: "Sumit Pandya" <sumit@elitecore.com>
Subject: RE: strange packets
Date: Wed, 10 Dec 2003 21:15:31 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002c01c3bf34$a4e1ec60$3901a8c0@elite.co.in>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>,
	"Maciej Soltysiak" <solt@dns.toxicfilms.tv >,
	"Linux NICS" <linux.nics@intel.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Donald Becker" <becker@scyld.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi All,
    I'm addressing years back issue in this mail. In our network I've
observed strange behavior which is mentioned on link
http://lists.netfilter.org/pipermail/netfilter/2001-October/026510.html

-----------------------------------------------------------------
Maciej Soltysiak solt@dns.toxicfilms.tv  wrote on
Mon, 1 Oct 2001 09:57:20 +0200 (CEST)
> > 09:07:42.443298 0:0:0:0:0:30 1:0:0:0:0:0 8808 60:
> > 09:07:42.485245 0:0:0:0:0:30 1:0:0:0:0:0 8808 60:
> > 09:07:42.527191 0:0:0:0:0:30 1:0:0:0:0:0 8808 60:
> > 09:07:42.569138 0:0:0:0:0:30 1:0:0:0:0:0 8808 60:
> >
> > I dont think that these are valid mac-adresses.
> let me just add that netwatch shows that my cisco router has invalid mac
> it looks something like: 00:20:00:00:so:me:thing

> Maybe it is some router ? try to identify the machine.
-----------------------------------------------------------------
P.S. This is not related to netfilter. But as this message found on that
list so I'm CCing to them also.

Following are few information from my system
# cat /proc/pci
PCI devices found:
  Bus  0, device   0, function  0:
    Host bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev
3).
      Master Capable.  Latency=32.
      Prefetchable 32 bit memory at 0xd0000000 [0xd3ffffff].
  Bus  0, device   1, function  0:
    PCI bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 3).
      Master Capable.  Latency=64.  Min Gnt=136.
  Bus  0, device   7, function  0:
    ISA bridge: Intel Corp. 82371AB/EB/MB PIIX4 ISA (rev 2).
  Bus  0, device   7, function  1:
    IDE interface: Intel Corp. 82371AB/EB/MB PIIX4 IDE (rev 1).
      Master Capable.  Latency=32.
      I/O at 0xf000 [0xf00f].
  Bus  0, device   7, function  2:
    USB Controller: Intel Corp. 82371AB/EB/MB PIIX4 USB (rev 1).
      IRQ 5.
      Master Capable.  Latency=32.
      I/O at 0xe000 [0xe01f].
  Bus  0, device   7, function  3:
    Bridge: Intel Corp. 82371AB/EB/MB PIIX4 ACPI (rev 2).
      IRQ 9.
  Bus  0, device   8, function  0:
    Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 8).
      IRQ 10.
      Master Capable.  Latency=32.  Min Gnt=8.Max Lat=56.
      Non-prefetchable 32 bit memory at 0xd9100000 [0xd9100fff].
      I/O at 0xe400 [0xe43f].
      Non-prefetchable 32 bit memory at 0xd9000000 [0xd90fffff].
  Bus  0, device  19, function  0:
    Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 16).
      IRQ 11.
      Master Capable.  Latency=32.  Min Gnt=32.Max Lat=64.
      I/O at 0xe800 [0xe8ff].
      Non-prefetchable 32 bit memory at 0xd9101000 [0xd91010ff].
  Bus  1, device   0, function  0:
    VGA compatible controller: ATI Technologies Inc Rage XL AGP 2X (rev
101).
      IRQ 12.
      Master Capable.  Latency=32.  Min Gnt=8.
      Non-prefetchable 32 bit memory at 0xd4000000 [0xd4ffffff].
      I/O at 0xd000 [0xd0ff].
      Non-prefetchable 32 bit memory at 0xd6000000 [0xd6000fff].

# tcpdump  -nv ether multicast
Kernel filter, protocol ALL, datagram packet socket
tcpdump: listening on all devices
19:43:33.103096 eth0 M 48:90:16:d3:1:60 1:0:0:0:0:0 8808 60:
[000] 00 01 00 00 00 00 88 08 00 01 00 00 00 00 88 08 ................
[010] 00 01 00 00 00 00 88 08 00 01 00 00 00 00 88 08 ................
[020] 00 01 00 00 00 00 88 08 00 01 00 00 00 00        ..............

So the same strange packets I also see on my host. With various kernel
version; both Intel's (e100) and the Modified by Andrey V. Savochkin
(eepro100 with mii) was tested and finally I tried the __GEM__ driver from
Donald Becker (eepro100 with pci-scan).

    Using this driver no more produces any such packets. And now my n/w is
very clean. Earlier I get very high collisions and other error on my
interfaces. And with Becker's driver all went away.
    One of my observations is... Those strange packets have been seen with
eepro chipset (rev 8) only. Except (rev 8) We also have few cards of (rev 5)
and (rev 13) which did not encounter any such problem. I mean those cards
are fine with any of 3 drivers.

    If Intel or Andrey V. Savochkin is interested for digging into problem
then here is little more information.

#dmesg
pci-scan.c:v1.11 8/31/2002  Donald Becker <becker@scyld.com>
http://www.scyld.com/linux/drivers.html
eepro100.c:v1.28 7/22/2003 Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/eepro100.html
eth0: Intel i82559 rev 8 at 0xc884c000, 00:03:47:1A:DB:93, IRQ 10.
  Board assembly 741462-005, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0x04f4518b).
eth1: Intel i82559 rev 8 at 0xc884e000, 00:03:47:1A:E7:DB, IRQ 9.
  Board assembly 741462-005, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0x04f4518b).

    3 Cheers for Becker.

Regards,
--Sumit
