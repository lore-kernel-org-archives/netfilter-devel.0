From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: why incoming packet's device not logging?
Date: Sat, 21 May 2005 10:07:54 +0000
Message-ID: <428F087A.6050809@outerspace.dyndns.org>
References: <20050521070446.49238.qmail@web33015.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: cranium2003 <cranium2003@yahoo.com>
In-Reply-To: <20050521070446.49238.qmail@web33015.mail.mud.yahoo.com>
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

Quoting cranium2003 on 2005-05-21 07:04 UTC:
> hello,
>     I added 3 rules to iptables as
> iptables -A INPUT -j LOG
> iptables -A OUTPUT -j LOG
> iptables -A FORWARD -j LOG
>  But i am getting log of forward and output chain
> correctly but why when packet comes its incoming
> device is not logged. My IPTABLES is
  <snip>
> -A INPUT -j RH-Lokkit-0-50-INPUT 
> -A INPUT -j LOG 
  <snip>
> -A RH-Lokkit-0-50-INPUT -i lo -j ACCEPT 
> -A RH-Lokkit-0-50-INPUT -i eth0 -j ACCEPT 
> -A RH-Lokkit-0-50-INPUT -i eth1 -j ACCEPT 

It seems that these last three rules accept basically all packets and
thus the LOG rule is never reached.. Or do you have more network cards
than eth0 and eth1 ?

You say it works for FORWARD, but I don't think I see how it could..

I wonder if those ACCEPTs are there by mistake.. maybe they should be at
the end of the RH-Lokkit-0-50-INPUT chain instead?

If you need further help, please give more info about your network setup.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCjwh5xyF48ZTvn+4RAiQnAJ96URdIrQ37/dbn2+LNUNameG3vHwCfewQ+
LJ6nyzYfe4Zg4L+Xr3ifXyE=
=npwq
-----END PGP SIGNATURE-----
