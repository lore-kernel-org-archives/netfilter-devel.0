From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] IP sets
Date: Mon, 9 Feb 2004 15:41:56 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0402091505440.23818-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

The IP sets support is available from the netfilter cvs repository!

IP sets are based on the excellent IP pools package. Due to the
internal modifications, backward compatibility cannot be kept and
therefore a new package was created (thanks to Patrick Schaaf for the
naming suggestion). The most important new features are:

- multi-level sets can be defined
- sets can be swapped without disturbing the iptables rules
- the current list of set types are: ipmap (known as bitmap in ippool),
  macipmap, portmap and iphash
- network addresses can be stored/matched in the ipmap and iphash set
  types

IP sets can make the rule management easier and netfilter operation much
faster when otherwise there were hundreds/thousands of "normal" iptables
rules, with slow processing.

In order to try out IP sets, you have to

- check out the
	iptables and
	netfilter/patch-o-matic or patch-o-matic-ng
  repositories from the netfilter cvs
- patch your kernel source tree with the 'set' patchlet from base
- configure, compile etc. your kernel
- recompile and install the iptables binaries, which will
  install the ipset set management utility
- read the ipset(8) manpage

Please note, this is the first, beta release. Suggestions, comments,
bug reports, patches are highly welcomed.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
