From: Michael Richardson <mcr@sandelman.ottawa.on.ca>
Subject: Re: Multiple Targets
Date: Wed, 02 Mar 2005 17:26:09 -0500
Message-ID: <5046.1109802369@marajade.sandelman.ottawa.on.ca>
References: <7174b1e405021900052b4545c4@mail.gmail.com>
Cc: Ben La Monica <ben.lamonica@gmail.com>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: Message from Ben La Monica <ben.lamonica@gmail.com> of "Sat,
	19 Feb 2005 01:05:07 MST." <7174b1e405021900052b4545c4@mail.gmail.com>
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


It seems to me that having a "RETURN" option for all targets might be
one way. (IPFilter has "quick", which can be overused...)

Or write a module called "MARKRETURN".

In general, I would, however, like to have a way to load tables of
various kinds and lookup things in them.  That would, for me, include
"the default routing table".

Actually, I'd like to replace all of the IP forwarding logic with
iptables :-)

- -- 
] Michael Richardson          Xelerance Corporation, Ottawa, ON |  firewalls  [
] mcr @ xelerance.com           Now doing IPsec training, see   |net architect[
] http://www.sandelman.ca/mcr/    www.xelerance.com/training/   |device driver[
] panic("Just another Debian GNU/Linux using, kernel hacking, security guy"); [
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)
Comment: Finger me for keys

iQCVAwUBQiY9gIqHRg3pndX9AQFLjAP/f1dHEUeGO/H15Ipwpy8uHqgl5uLqs5zd
UrCrA+yJY4+5GzeUtpg7dumFw22TEX721r7CbNJF32ozopLsoJvpCXI39MJkLFbT
AOwjGk7/cnlyAraQHLXNuHbbd24YsVNOdGu5ceRJMPKT3winZ6ShfQxyHGV5fkdD
P+i2rMrWUGw=
=gSJl
-----END PGP SIGNATURE-----
