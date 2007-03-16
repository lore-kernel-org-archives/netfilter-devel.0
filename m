From: "Gladewitz, Robert (FH)" <Robert.Gladewitz@fh-heidelberg.de>
Subject: Re: patch: Port- and netscan detection for netfilter
Date: Fri, 16 Mar 2007 23:17:59 +0100
Message-ID: <DF74C782E6463841A9BD3322977588813532AA@FHCLUSRV-EX.dcs.fh-heidelberg.de>
References: <Pine.LNX.4.61.0703162231110.29521@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
In-Reply-To: <Pine.LNX.4.61.0703162231110.29521@yvahk01.tjqt.qr>
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

The interesting is the additional functionality in this module. If a =
host has identifying as portscan-source you can define a time for =
matching the rules after the first identification. For example, you can =
drop all packages for a time xxx from this host after identifying as =
portscan-source. In this cast, the attackers can't find more information =
about your network.=20

Robert

-----Urspr=FCngliche Nachricht-----
Von: netfilter-devel-bounces@lists.netfilter.org =
[mailto:netfilter-devel-bounces@lists.netfilter.org] Im Auftrag von Jan =
Engelhardt
Gesendet: Freitag, 16. M=E4rz 2007 22:32
An: Tim Gardner
Cc: netfilter-devel@lists.netfilter.org; Patrick McHardy; Gladewitz, =
Robert (FH)
Betreff: Re: patch: Port- and netscan detection for netfilter


On Mar 16 2007 10:37, Tim Gardner wrote:
>
>One benefit of being able to block a port scanner is that it reduces or
>stops the amount of ARP traffic that is generated. Depending on your
>internal network design, lots of ARP traffic can have a significant
>impact on WAN links and so on.

ARP traffic is hardly a problem when the attacker is at least two hops =
away
(which is always true in the Internet except when your own ISP pokes on =
you) or
there is a NOARP link at hop 1 (as is the case with PPP/etc.).


Jan
--=20
