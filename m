From: Fridtjof Busse <fridtjof.busse@gmx.de>
Subject: MAC and iptables-save
Date: Fri, 27 Dec 2002 14:51:14 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200212271451.14532@fbunet.de>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_EH6SVUOGLIW0JITMAQCA"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_EH6SVUOGLIW0JITMAQCA
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi
"iptables-restore" doesn't work if "iptables-save" saved a rule with "-m=20
mac --mac-source"
To reproduce this:


Create a rule:
iptables -A INPUT -i eth0 -m mac --mac-source ! 00:01:02:03:04:05 -j=20
REJECT

Save this rule:
iptables-save > test.iptables

Load the ruleset:
iptables-restore test.iptables
iptables-restore v1.2.7a: Bad mac address `!00:01:02:03:04:05'
Try `iptables-restore -h' or 'iptables-restore --help' for more

iptables-save doesn't add a space before it prints the mac-address, it=20
looks like this:
-A INPUT -i wlan0 -m mac --mac !00:02:2D:5C:08:1B -j DROP

instead of:
-A INPUT -i wlan0 -m mac --mac ! 00:02:2D:5C:08:1B -j DROP


Fix attached, since this bug seems to be still in the CVS.

--=20
Fridtjof Busse
BOFH excuse #63:
not properly grounded, please bury computer
--------------Boundary-00=_EH6SVUOGLIW0JITMAQCA
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="iptables-1.2.7a-mac.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="iptables-1.2.7a-mac.diff"

--- extensions/libipt_mac.c.orig	Fri Nov  8 18:20:48 2002
+++ extensions/libipt_mac.c	Fri Nov  8 18:22:48 2002
@@ -90,7 +90,7 @@
 {
 	unsigned int i;
 
-	printf("%s%02X", invert ? "!" : "", macaddress[0]);
+	printf("%s %02X", invert ? "!" : "", macaddress[0]);
 	for (i = 1; i < ETH_ALEN; i++)
 		printf(":%02X", macaddress[i]);
 	printf(" ");
--- extensions/libip6t_mac.c.orig	Fri Nov  8 18:23:10 2002
+++ extensions/libip6t_mac.c	Fri Nov  8 18:23:31 2002
@@ -90,7 +90,7 @@
 {
 	unsigned int i;
 
-	printf("%s%02X", invert ? "!" : "", macaddress[0]);
+	printf("%s %02X", invert ? "!" : "", macaddress[0]);
 	for (i = 1; i < ETH_ALEN; i++)
 		printf(":%02X", macaddress[i]);
 	printf(" ");


--------------Boundary-00=_EH6SVUOGLIW0JITMAQCA--
