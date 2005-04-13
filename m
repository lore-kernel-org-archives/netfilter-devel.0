From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: [ANNOUNCE] patch2pom conversion script v1
Date: Wed, 13 Apr 2005 00:11:58 +0000
Message-ID: <425C63CE.5080208@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, Harald Welte <laforge@netfilter.org>
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

Hi!

I put together a (perl) script that takes a "diff -Nru" style diff on
input and converts it to pom-ng style directory structure like:

  pom-ng/foobar/linux-2.6/net/ipv4/netfilter/ipt_foobar.c
  pom-ng/foobar/linux-2.6/net/ipv4/netfilter/Kconfig.ladd
  pom-ng/foobar/linux-2.6/net/ipv4/netfilter/Makefile.ladd
  pom-ng/foobar/linux-2.6/include/linux/netfilter_ipv4/ip_foo.h.ladd
  pom-ng/foobar/linux-2.6/include/linux/netfilter_ipv4/ip_foo.h.ladd_2
  ...
  pom-ng/foobar/linux-2.6.patch

The main purpose of the script is to take away some of the everyday
mechanical work done when implementing & updating pom-ng modules.

Features in version 1:

  - support extraction of diffs creating new files

  - support Kconfig diff conversion to .ladd format if the patch adds
only whole new config options

  - support Makefile diff conversion to .ladd format when only new lines
are added

  - support *.c and *.h diff conversion for cases where only new code is
added and only when it's added below comments that look like
    /* yadda yadda add foobar here */

  - unconverted diff chunks are put in the patch file, i.e.
linux-2.6.patch or iptables.patch.

I've tested it on a few netfilter modules and it was able to reproduce
identical directory structures and file contents.

The script is available here:

http://xkr47.outerspace.dyndns.org/netfilter/patch2pom/patch2pom-1.tar.gz

I'll gladly receive ideas, bug reports and whatever you have to say
regarding this script :) For example, do you think the suggested "diff
- -Nru" format is ok?

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCXGPMxyF48ZTvn+4RArdcAKC0P3bPyqL8Q46tdIUqkTkCrs8DHQCeKM5b
Zo6OpwHq7+dlOpuFdaOfB60=
=6Bax
-----END PGP SIGNATURE-----
