From: Daniel 'NebuchadnezzaR' Dehennin <nebuchadnezzar@nerim.net>
Subject: Re: pom-ng and kernel 2.6.6
Date: Thu, 13 May 2004 22:30:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87ekpojci2.fsf@thorr.asgardr.info>
References: <87oeosjd5w.fsf@thorr.asgardr.info>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <87oeosjd5w.fsf@thorr.asgardr.info> (Daniel Dehennin's message
 of "Thu, 13 May 2004 22:16:27 +0200")
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On 3907 September 1993, Daniel Dehennin wrote:
> I say no and try to continue.

I apply all the base section of pom-ng to my 2.6.6, everything seems
to apply cleanly but during make menuconfig I have errors:

net/ipv4/netfilter/Kconfig:682: syntax error, unexpected T_WORD
net/ipv4/netfilter/Kconfig:685: invalid menu option
net/ipv4/netfilter/Kconfig:685: syntax error, unexpected T_WORD
net/ipv4/netfilter/Kconfig:690: invalid menu option
net/ipv4/netfilter/Kconfig:690: syntax error, unexpected T_WORD
net/ipv4/netfilter/Kconfig:695: invalid menu option
net/ipv4/netfilter/Kconfig:695: syntax error, unexpected T_WORD
net/ipv4/netfilter/Kconfig:698: invalid menu option
net/ipv6/netfilter/Kconfig:306: syntax error, unexpected T_WORD
net/ipv6/netfilter/Kconfig:309: invalid menu option
net/ipv6/netfilter/Kconfig:309: syntax error, unexpected T_WORD
net/ipv6/netfilter/Kconfig:314: invalid menu option
net/ipv6/netfilter/Kconfig:314: syntax error, unexpected T_WORD
net/ipv6/netfilter/Kconfig:319: invalid menu option
net/ipv6/netfilter/Kconfig:319: syntax error, unexpected T_WORD
net/ipv6/netfilter/Kconfig:322: invalid menu option
make[1]: *** [menuconfig] Erreur 1
make: *** [menuconfig] Erreur 2


I remove the following help

in /net/ipv4/netfilter/Kconfig, option IP_NF_MATCH_NTH
The same for IP6_NF_MATCH_NTH

[options]
   --every     Nth              Match every Nth packet
  [--counter]  num              Use counter 0-15 (default:0)
  [--start]    num              Initialize the counter at the number 'num'
                                instead of 0. Must be between 0 and Nth-1
  [--packet]   num              Match on 'num' packet. Must be between 0
	                                and Nth-1.

	[options]
	   --every     Nth              Match every Nth packet
	  [--counter]  num              Use counter 0-15 (default:0)
	  [--start]    num              Initialize the counter at the number 'num'
	                                instead of 0. Must be between 0 and Nth-1
	  [--packet]   num              Match on 'num' packet. Must be between 0
	                                and Nth-1.
=09
Thanks.
=2D-=20
Daniel 'NebuchadnezzaR' Dehennin
R=E9cup=E9rer ma clef GPG:
gpg --keyserver pgp.mit.edu --recv-keys 0x4CA73DC6

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iQEVAwUAQKPa9dWamn5Mpz3GAQI5hwgAhLPmEAlxnOyNqr+K1f2TcIxq3d2xCmUY
KvApStuS21neFD+Wsh6L303YGWjoRBgLXqOZJCjeNtia7LA5HZcqxR20PwviTEOG
cu5+Vh5yK0SB2ieYZ6lmlbi2+M2LHJFULFYSTXYNiDXe+3RJJTXtvPf6EIXtkxTW
ljmKhwaT7AnhfnUbnCzCqoH+kYvbU3EmNBVMxxFNnWuuzdresddMnz9Qcs+4SUmJ
dGtqvthCHQOhyHX+2uT1FJ3fqxsA/Hq6qCZNRhB4HENXhQfbxjvuOozRG9KSBvAZ
wZs3G2VzAMqy/LgAvVn7NSX56qapSyjqKqXTxAWECD5uDLgo6Ji9QQ==
=CgwV
-----END PGP SIGNATURE-----
--=-=-=--
