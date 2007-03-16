From: "Gladewitz, Robert (FH)" <Robert.Gladewitz@fh-heidelberg.de>
Subject: AW: patch: Port- and netscan detection for netfilter
Date: Fri, 16 Mar 2007 23:29:49 +0100
Message-ID: <DF74C782E6463841A9BD3322977588813532AB@FHCLUSRV-EX.dcs.fh-heidelberg.de>
References: <45FABA87.4090601@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
In-Reply-To: <45FABA87.4090601@trash.net>
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



The problem is, on the most attacks, the hacker try to get some =
information on the network. This module implements 3 different =
situations:

- Netscan (Scan more hosts on less ports)
- Portscan (Scan less Hosts and many ports)
- Combined Scan (Scan many Ports on many)

On the testing-systems we can see, that the attacs to different service =
will be less then before! The interesting thing is, that no more attacks =
on unknown services are happens.=20

The Portscan is only the one side - the other side is, that the source =
can be blocked on a defined time - please read the documentation =
ipt-portscan.sourceforge.net.=20

LG

Robert

-----Urspr=FCngliche Nachricht-----
Von: netfilter-devel-bounces@lists.netfilter.org =
[mailto:netfilter-devel-bounces@lists.netfilter.org] Im Auftrag von =
Patrick McHardy
Gesendet: Freitag, 16. M=E4rz 2007 16:41
An: Gladewitz, Robert (FH)
Cc: netfilter-devel@lists.netfilter.org
Betreff: Re: patch: Port- and netscan detection for netfilter

Gladewitz, Robert (FH) wrote:
> in my Master-Theses I designed a new kernel- and netfilter module for
> detection of net- and portscans. Now, the module is tested on more =
then
> 10 different firewall-installations. It's working without any problems
> during the last 8 months.
>=20
> Your can read the documentation on
> http://ipt-portnetscan.sourceforge.net/. There is also a possibility =
to
> download all versions of Kernel- and IpTables-Patches.
>=20
> I would be pleased to see you integrated these patches into IpTables =
of
> your use.
> Looking forward to your answer

Please attach patches inline so they can be read in the mail client.

> +++ linux-2.6.20.2/Documentation/ipt_PORTNETSCAN.txt
> @@ -0,0 +1,389 @@
> +Allgemein Informationen zum Modul ipt_PORTNETSCAN

Luckily I speak german :)

But seriously, we already had different portscan-detection matches
submitted, but decided against merging them since its not clear
what the benefit of detecting scans is. It clearly doesn't improve
security since

- you can just scan slow enough not to be detected
- you don't need to scan to crack something

So all it offers is a bit of correlated information ("you were scanned
by ..."), that can also be extracted from log-files.
