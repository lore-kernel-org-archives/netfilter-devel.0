From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: Linux Routers working
Date: Fri, 13 May 2005 05:24:23 +0000
Message-ID: <42843A07.6010702@outerspace.dyndns.org>
References: <20050513041529.87978.qmail@web41424.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: cranium2003 <cranium2003@yahoo.com>
In-Reply-To: <20050513041529.87978.qmail@web41424.mail.yahoo.com>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting cranium2003 on 2005-05-13 04:15 UTC:
>         Is there any way on linux routers to know on
> which interface packet is forwarded before actually
> packet trasmission begins?

In the FORWARD table you know both the incoming and outgoing interface:

This will match packets coming in from eth0 and going out on eth1:

iptables -A FORWARD -i eth0 -o eth1 ...

> Also before packet
> processed by IP layer can it be possible to know from
> which adjecent Router'IP packet came to that router?

No, but the MAC address is available. You just have to find out what the
mac address of the router in question and do:

iptables -A INPUT -m mac --mac-source 01:23:45:67:89:AB ...

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFChDoExyF48ZTvn+4RAsN5AJwPHokkgN2tnHTiA0skEJqT3x72BACgnPdp
Szvrqa0td9onDdsoNDw19Zw=
=gp/k
-----END PGP SIGNATURE-----
