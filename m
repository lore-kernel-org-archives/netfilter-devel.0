From: "Gladewitz, Robert (FH)" <Robert.Gladewitz@fh-heidelberg.de>
Subject: AW: AW: patch: Port- and netscan detection for netfilter
Date: Mon, 19 Mar 2007 14:12:42 +0100
Message-ID: <DF74C782E6463841A9BD332297758881121071@FHCLUSRV-EX.dcs.fh-heidelberg.de>
References: <DF74C782E6463841A9BD3322977588813532AB@FHCLUSRV-EX.dcs.fh-heidelberg.de>
	<45FE1894.3070506@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
In-Reply-To: <45FE1894.3070506@trash.net>
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

Hello Patrick,

This module is not designed for using as locally firewall, it is =
designed for router in networks with dmz. For this, all connection is =
saved in an tree-structure. Internal, I look for all Connection the rule =
sends to check. (Look at the time background) If the module have same =
connection (source - Destination) the the module decide on following =
rules (positive or false answered -from -m). For this, the module saves =
source-ip, dest-ip and dest-port.

Definition: netscan for source address is recognized when:=20
----------------------------------------------------------
(number of destination hosts / number of destination ports) \
> Defined threshold value (quota) for netscan


Definition: portscan for source address is recognized when:
----------------------------------------------------------
(number of destination ports / number of destination hosts) \
> Defined quota for portscan

Definition: combined-scan for source address is recognized when:
----------------------------------------------------------
(number of destination ports / number of destination hosts) \
> Defined threshold value (quota) for combined scan


For all actions your can be sure, that a port- or netscan is be =
happening, not only less / many - port / hosts!! The module can be sure =
deside, that the many dest-port (for axamlpe) comes from this =
source-host!

Please read the documentation /and or source - it is completely =
different to all other modules. The Idea is, that your look for all =
connection, which are match by the rule - the state is totally =
uninteresting.=20

If a source-host is identified as a scan-host you can drop the all =
packages from dir source-ip for a defined time. The interesting is also, =
that you can use it for DROP-Packet on the end of all rules also (In the =
documentation I have defined 2 sceneries). On the start of the rules, =
your have only a check-line - on the end of all rules, you test if the =
client have to much denied traffic - then you can drop all package up =
this time.

The next is, your can check the state of connections and DENY-Hosts in =
/proc/net/stat/portnetscan

For the future, I planed a detection of Bot-Net-Scans.

Cu

Robert


-----Urspr=FCngliche Nachricht-----
Von: Patrick McHardy [mailto:kaber@trash.net]=20
Gesendet: Montag, 19. M=E4rz 2007 05:59
An: Gladewitz, Robert (FH)
Cc: netfilter-devel@lists.netfilter.org
Betreff: Re: AW: patch: Port- and netscan detection for netfilter

Gladewitz, Robert (FH) wrote:
> The problem is, on the most attacks, the hacker try to get some =
information on the network. This module implements 3 different =
situations:

Putting aside the question of the usefulness of this, whats the
difference to using the three rules below?

> - Netscan (Scan more hosts on less ports)

iptables -A PREROUTING -m state --state NEW \
		       -m hashlimit --hashlimit-name netscan \
				    --hashlimit-mode dstip \
				    --hashlimit n/sec \
		       -j DROP

> - Portscan (Scan less Hosts and many ports)

iptables -A PREROUTING -m state --state NEW \
		       -m hashlimit --hashlimit-name portscan \
				    --hashlimit-mode dstport \
				    --hashlimit n/sec \
		       -j DROP

> - Combined Scan (Scan many Ports on many)

iptables -A PREROUTING -m state --state NEW \
		       -m hashlimit --hashlimit-name portnetscan \
				    --hashlimit-mode dstip,dstport \
				    --hashlimit n/sec \
		       -j DROP
