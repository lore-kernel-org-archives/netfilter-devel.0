From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Xtables-addons 1.5.3 & xt_geoip
Date: Sat, 22 Mar 2008 05:51:43 +0100 (CET)
Message-ID: <alpine.LNX.1.00.0803220303120.28078@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,


Xtables-addons 1.5.3 has been released. What's new?

- some compat code got added so that the package should now compile on
   older kernels, down to including 2.6.18 (and upwards to 2.6.25).
   This should make a number of enterprise distribution users (Centos..=
=2E)
   happier that run not-so-new kernels.

- improved geoip match
   * works in {64-bit-kernel + 32-bit-userland} environments
     (important for sparc distros and for 32-bit installs on amd64)
   * endianess correctness (hopefully, I do not have sparc hw to test)
   * O(log(n)) list search time [previously O(n)]
   * a fix in address comparison (previously left out first and
     last address of an IP range)
   * geoip database at http://jengelh.hopto.org/files/geoip/

Usual places to obtain it:
tarball	=BB http://dev.computergmbh.de/files/xtables/
gitweb	=BB http://dev.computergmbh.de/gitweb.cgi?p=3Dxtables-addons
clone	=BB git://dev.computergmbh.de/xtables-addons
