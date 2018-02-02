From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] iptables 1.6.2 release
Date: Fri, 2 Feb 2018 16:55:19 +0100
Message-ID: <20180202155519.vqb6pdkaxmvmr72t@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="rbnsqhwqlh7nblzn"
Cc: netdev@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47852 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751835AbeBBPz0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Feb 2018 10:55:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2E5D320A552
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2018 16:55:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17B33BAC34
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2018 16:55:24 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--rbnsqhwqlh7nblzn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

	iptables 1.6.2

iptables is the userspace command line program used to configure the
Linux 2.4.x and later packet filtering ruleset. It is targeted towards
system administrators.

This update contains accumulated bugfixes, a few new extensions and
lots of translations via iptables-translate to ease migration to
nftables.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/

Have fun!

--rbnsqhwqlh7nblzn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.6.2.txt"

Aastha Gupta (2):
      iptables-translate: add test file for TCPMSS extension
      iptables: iptables-compat translation for TCPMSS

Ahmed Abdelsalam (1):
      extensions: add support for 'srh' match

Arushi Singhal (1):
      iptables: extensions: Remove typedef in struct.

Baruch Siach (1):
      utils: nfsynproxy: fix build with musl libc

Dan Williams (3):
      libiptc: don't set_changed() when checking rules with module jumps
      iptables-restore/ip6tables-restore: add --version/-V argument
      iptables-restore.8: document -w/-W options

Elise Lennion (1):
      extensions: libxt_hashlimit: Add translation to nft

Florian Westphal (2):
      tests: xlate-test: no need to require superuser privileges
      policy: add nft translation for simple policy none/strict use case

Gargi Sharma (2):
      iptables: Constify option struct
      extensions: libxt_TOS: Add translation to nft

Harsha Sharma (6):
      iptables: Constify option struct
      Update .gitignore
      libxt_TOS: add tests for translation infrastructure
      tests: xlate: print output in same way as nft-test.py
      extensions: add tests for ipcomp protocol
      extensions: libxt_hashlimit: Do not print default timeout and burst

James Cowgill (1):
      extensions: libxt_hashlimit: fix 64-bit printf formats

Jan Engelhardt (2):
      libxtables: remove unnecessary nesting from host_to_ip(6)addr
      libxtables: abolish AI_CANONNAME

Juergen Borleis (1):
      iptables: change large file support handling

Liping Zhang (2):
      xshared: do not lock again and again if "-w" option is not specified
      xshared: using the blocking file lock request when we wait indefinitely

Lorenzo Colitti (5):
      iptables: set the path of the lock file via a configure option.
      iptables: move XT_LOCK_NAME from CFLAGS to config.h.
      iptables: remove duplicated argument parsing code
      iptables-restore: support acquiring the lock.
      iptables: insist that the lock is held.

Louis Sautier (1):
      xtables-compat-restore: fix translation of mangle's OUTPUT

Mart Frauenlob (1):
      iptables: extensions: Fix MARK target help

Max Laverse (1):
      iptables: masquerade: add randomize-full support

Oliver Ford (4):
      libxtables: Display weird character warning for wildcards
      iptables: Fix crash on malformed iptables-restore
      iptables: Add file output option to iptables-save
      iptables-xml: Fix segfault on jump without a target

Pablo M. Bermudo Garay (8):
      tests: add regression tests for xtables-translate
      tests: xlate: remove python 3.5 dependency
      tests: xlate: check if it is being run as root
      tests: xlate: generalize owner
      libip6t_icmp6: xlate: remove leftover space
      xtables-translate: fix double space before comment
      xtables-compat-restore: fix several memory leaks
      xtables-compat: fix memory leak when listing

Pablo Neira Ayuso (7):
      libxt_hashlimit: add new unit test to catch kernel bug
      iptables-translate: print nft command for each expand rules via dns names
      iptables-translate: print nft iff there are more expanded rules to print
      iptables-compat: do not allow to delete populated user define chains
      extensions: hashlimit: fix incorrect burst in translations
      extensions: hashlimit: remove space before burst in translation to nft
      iptables 1.6.2 release

Phil Sutter (8):
      extensions: libxt_addrtype: Add translation to nft
      xtables-translate: Avoid querying the kernel
      utils: nfnl_osf: Fix synopsis in help text
      utils: Add a man page for nfnl_osf
      ip{,6}tables-restore: Don't ignore missing wait-interval value
      ip{,6}tables-restore: Don't accept wait-interval without wait
      extensions: libxt_tcpmss: Detect invalid ranges
      libxt_recent: Remove ineffective checks for info->name

Rafael Buchbinder (1):
      extensions: libxt_bpf: fix missing __NR_bpf declaration

Shyam Saini (2):
      extensions: libxt_cluster: Add translation to nft
      extensions: Add test for cluster nft translation

Thierry Du Tre (2):
      extensions: ip6t_{S,D}NAT: multiple to-dst/to-src arguments not reported
      extensions: ip6t_{S,D}NAT: add more tests

Varsha Rao (6):
      iptables: Remove explicit static variables initalization.
      iptables: Remove unnecessary braces.
      iptables: xtables-eb: Remove const qualifier from struct option
      extensions: libxt_tcpmss: Add test case for invalid ranges.
      iptables: Remove const qualifier from struct option.
      extensions: Add macro _DEFAULT_SOURCE.

Vincent Bernat (1):
      iptables-restore/save: exit when given an unknown option

Vishwanath Pai (1):
      netfilter: xt_hashlimit: add rate match mode

Xose Vazquez Perez (1):
      iptables: update pf.os

Yogesh Prasad (1):
      iptables: patch to correct linker flag sequence

huaibin Wang (1):
      libxt_sctp: fix array out of range in print_chunk

shyam saini (1):
      extensions: hashlimit: Rename 'flow table' keyword to meter


--rbnsqhwqlh7nblzn--
