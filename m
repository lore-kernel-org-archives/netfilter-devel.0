From: "ArcosCom Linux User" <linux@arcoscom.com>
Subject: Re: dst cache overflow
Date: Thu, 4 Jan 2007 22:32:48 +0100 (CET)
Message-ID: <55635.10.1.1.10.1167946368.squirrel@www.arcoscom.com>
References: <60665.10.1.1.10.1167776653.squirrel@www.arcoscom.com>
Reply-To: linux@arcoscom.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
Return-path: <lartc-bounces@mailman.ds9a.nl>
In-Reply-To: <60665.10.1.1.10.1167776653.squirrel@www.arcoscom.com>
To: linux@arcoscom.com
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

The log says:

Dec 30 00:52:27 cura kernel: dst cache overflow
Dec 30 00:52:27 cura kernel: MASQUERADE: No route: Rusty's brain broke!
Dec 30 00:52:27 cura kernel: dst cache overflow
Dec 30 00:52:28 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:28 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:28 cura kernel: dst cache overflow
Dec 30 00:52:30 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:30 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:32 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:32 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:32 cura kernel: printk: 15 messages suppressed.
Dec 30 00:52:32 cura kernel: dst cache overflow
Dec 30 00:52:34 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:34 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:36 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
Dec 30 00:52:36 cura kernel: zlan0: topology change detected, propagating
Dec 30 00:52:37 cura kernel: printk: 40 messages suppressed.
Dec 30 00:52:37 cura kernel: dst cache overflow

zlan0 is a bridge (with STP configured) between some LANs.

Thanks

P.D.: I'm a bit desesperated with this error, I changed "MASQUERADE" with
"SNAT" with no sense. Some hours after router is booted up, the network
appears to be UP but all ifaces haven't responses.

El Mar, 2 de Enero de 2007, 23:24, ArcosCom Linux User escribi=F3:
> Hi all, I'm having this problem with this system configuration:
>    1) iptables 1.3.7
>    2) kernel 2.6.19.1
>    3) SMP computer
>    4) 2 external links + 2 internal (bridged).
>
> Some hours after the system is working without any troubles, all networ=
k
> devices stop respond.
>
> Anyone could help me to fix this problem?
>
> Googling some ours I detect that this was a problem with old kernels an=
d
> were solved with 2.6.11 kernel version.
>
> Any help will be appretiated.
>
> Regards.
>
> P.D.: With MASQUERADE the problem begans more quickly than with SNAT
> target.
