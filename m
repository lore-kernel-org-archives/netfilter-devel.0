From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: input/output interface on a bridging firewall
Date: Mon, 08 Mar 2004 22:30:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1078781445.2453.30.camel@anduril.intranet.cartel-securite.net>
References: <404C7DBB.3000508@aiqa.com>  <404CA29D.80808@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eicke Friedrich <tady@gmx.net>
In-Reply-To: <404CA29D.80808@gmx.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le lun 08/03/2004 =E0 17:43, Eicke Friedrich a =E9crit :
> One thing does _not_ work anymore: I can't match the incoming (-i=20
> ethX) or outgoing (-o ethX) interface anymore if the interface is a=20
> port of a bridge interface (brX). I've to match the outgoing interface=20
> for -j CLASSIFY to sort packets in htb classes. Using kernel 2.4.x=20
> this was possible. Any hints or comments for me?

<joke>
Yep, RTFM :)))
</joke>

Since 2.5.$idontrememberwhichone, output interface for a bridge is
matched as br0 as it should be. To match physical interface that is part
of the bridge, you have to use physdev match. From iptables help page :

physdev v1.2.9 options:
 --physdev-in [!] input name[+]         bridge port name ([+] for
wildcard)
 --physdev-out [!] output name[+]       bridge port name ([+] for
wildcard)
 [!] --physdev-is-in                    arrived on a bridge device
 [!] --physdev-is-out                   will leave on a bridge device
 [!] --physdev-is-bridged               it's a bridged packet

So -i eth0 becomes -m physdev --physdev-in eth0 and -o eth1 becomes -m
physdev --physdev-out eth1.

The three last options allows one to match packets that are routed from
or to a bridge and packets that will get bridged.


--=20
http://www.netexit.com/~sid/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
