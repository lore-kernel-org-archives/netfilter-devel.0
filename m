From: Florian Lohoff <flo@rfc822.org>
Subject: sparc64 ipv6 ip6tables nogo
Date: Thu, 12 Sep 2002 17:53:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020912155314.GA20741@paradigm.rfc822.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,
i seem to have been hit by a ip6tables problem on sparc64 - It seems
that there are some hidden 64bit kernel / 32 bit userspace problems
somewhere in netfilter (Same happened with tunnel ioctls on sparc64)

Setup:
tracepath:~# uname -a
Linux tracepath 2.4.19 #1 Thu Aug 8 15:05:32 CEST 2002 sparc64 unknown
tracepath:~# egrep "^CONFIG_IPV*6" /boot/config-2.4.19=20
CONFIG_IPV6=3Dy
CONFIG_IP6_NF_IPTABLES=3Dm
CONFIG_IP6_NF_MATCH_LIMIT=3Dm
CONFIG_IP6_NF_MATCH_MAC=3Dm
CONFIG_IP6_NF_MATCH_MULTIPORT=3Dm
CONFIG_IP6_NF_MATCH_OWNER=3Dm
CONFIG_IP6_NF_MATCH_MARK=3Dm
CONFIG_IP6_NF_FILTER=3Dm
CONFIG_IP6_NF_TARGET_LOG=3Dm
CONFIG_IP6_NF_MANGLE=3Dm
CONFIG_IP6_NF_TARGET_MARK=3Dm
tracepath:~# lsmod
Module                  Size  Used by    Not tainted
ip6_tables             14272   0=20
iptable_filter          2040   1  (autoclean)
ip_tables              13952   1  [iptable_filter]
sunhme                 25256   1  (autoclean)
tracepath:~# ip6tables -L
ip6tables v1.2.6a: can't initialize ip6tables table `filter': Table does
not exist (do you need to insmod?)
Perhaps iptables or your kernel needs to be upgraded.
tracepath:~# modprobe ip6table_filter
/lib/modules/2.4.19/kernel/net/ipv6/netfilter/ip6table_filter.o: init_modul=
e: Invalid argument
Hint: insmod errors can be caused by incorrect module parameters, including=
 invalid IO or IRQ parameters
/lib/modules/2.4.19/kernel/net/ipv6/netfilter/ip6table_filter.o: insmod
/lib/modules/2.4.19/kernel/net/ipv6/netfilter/ip6table_filter.o failed
/lib/modules/2.4.19/kernel/net/ipv6/netfilter/ip6table_filter.o: insmod ip6=
table_filter failed
tracepath:~# iptables -v
iptables v1.2.6a: no command specified
Try `iptables -h' or 'iptables --help' for more information.

Same happens with iptables 1.2.7 - Distribution is a Debian/Woody on
an Ultrasparc 5 with a 2.4.19 (vanilla) kernel.

Flo
PS: I am not subscribed to netfilter-devel
--=20
Florian Lohoff                  flo@rfc822.org             +49-5201-669912
                        Heisenberg may have been here.

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9gLhqUaz2rXW+gJcRAkOSAJ9lta3m1U6U5IyoW0OmN1qDcytDVwCeLDwV
4OhLKSPsTXvUA/YhVpPQWk0=
=rb7G
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
