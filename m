From: Michael Richardson <mcr@sandelman.ottawa.on.ca>
Subject: Re: New extension: CRYPT target
Date: Tue, 23 May 2006 09:08:50 -0400
Message-ID: <22306.1148389730@sandelman.ottawa.on.ca>
References: <44708E68.9080508@speedy.com.ar> <44709CFC.7050007@gmx.net>
	<4470D859.7000706@speedy.com.ar>
	<10007.1148252261@sandelman.ottawa.on.ca>
	<44724AE0.5040708@speedy.com.ar>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gervasio Bernal <gervasiobernal@speedy.com.ar>
In-Reply-To: Message from Gervasio Bernal <gervasiobernal@speedy.com.ar>
	of "Mon, 22 May 2006 20:36:00 -0300." <44724AE0.5040708@speedy.com.ar>
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


>>>>> "Gervasio" == Gervasio Bernal <gervasiobernal@speedy.com.ar> writes:
    Gervasio> The idea behind CRYPT extension is not to replace IPSEC
    Gervasio> absolutely, but to be a simple alternative of use for
    Gervasio> encryption/decryption and packet authentication using
    Gervasio> Iptables. It could be useful for somebody.

  Tell me the threat model.

  Under what circumstances is it better than:
	a) IPsec with OE (with is dirty simple to configure)
	b) TLS/SSL LD_PRELOAD wrapper
	c) using SCP instead of FTP (or rsync over SSH)
	d) OpenVPN or SSH port forwarding
	e) HIP

    Gervasio> We have also developed a module in Python that use the
    Gervasio> CRYPT extension, configuration files, has automatic key
    Gervasio> management and user authentication using certificates. But
    Gervasio> we need that someone else can test first the extension
    Gervasio> alone, and comments its experience to us.

  Why in the world would you build such a complicated system? 
  You just told us that you wanted something simpler than IPsec.

  It seems like vanity crypto to me.

- -- 
]       ON HUMILITY: to err is human. To moo, bovine.           |  firewalls  [
]   Michael Richardson,    Xelerance Corporation, Ottawa, ON    |net architect[
] mcr@xelerance.com      http://www.sandelman.ottawa.on.ca/mcr/ |device driver[
] panic("Just another Debian GNU/Linux using, kernel hacking, security guy"); [

    "The Microsoft _Get the Facts CD_ does not work on Linux." - orospakr

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Finger me for keys

iQEVAwUBRHMJYICLcPvd0N1lAQIdDAf/bMGdfP6zIJ39lGgduUbfYmx7QEX5EwC7
4tK+Px3Lk4z8P1nowLyCLHUL11YXn6t+WfaPGc/Gp9jvVd0r1R0UXOSuiQ4b3bSy
kcdalGLMAe9XEusecIfEqdhHm+xu8311eGSN1Q2fJbajPy0D1w9dATSY51BWgKU6
0+Pm6YHTQzYOYZOMTzlx4BYZbanrpYXgS+klm3liE10VcB4JtOD4/w9D69kYEm6R
ajDacRC8Hjp068JeKEbr/DJegxBLf/Rkt/GepRoiwQea2kYN8/E8ZAMuYjqafL2b
S49KUwjIHVac+Gad9Y0MJquVvdp+QmST/o/JWcCVJoyLB1yL2znDMw==
=lCRN
-----END PGP SIGNATURE-----
