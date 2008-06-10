From: Patrick McHardy <kaber@trash.net>
Subject: [ANNOUNCE] Release of iptables 1.4.1
Date: Tue, 10 Jun 2008 08:44:12 +0200
Message-ID: <484E22BC.4000501@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000708070902060004070604"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"'netfilter@vger.kernel.org'" <netfilter@vger.kernel.org>,
	netfilter-announce@lists.netfilter.org,
	Netfilter Cor
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56954 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbYFJGoS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2008 02:44:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000708070902060004070604
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

The netfilter coreteam proudly presents:

     iptables version 1.4.1

The header resync turned out to be unproblematic, changes since
-rc3 include fixes for iptables-save output of the owner match,
support for revision 1 of the addrtype match, more manpage
updates and some sparse fixes.

For people updating from 1.4.0, this release brings:

- new build system with better configurability

- scalability improvements for large number of chains

- Support for multiple new matches, targets and revisions
   (supports all features available in the current kernel tree)

- IPv6 support for more matches and targets

- manpage improvements

- lots of minor improvements and fixes all over the place,
   check out the changelog for the full details

Version 1.4.1 can be obtained from (please note that the
webpage hasn't been rebuilt yet, but will be shortly):

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/
git://git.netfilter.org/iptables.git

On behalf of the Netfilter Core Team.
Happy firewalling!

--------------000708070902060004070604
Content-Type: text/plain;
 name="changes-iptables-1.4.1-rc3-1.4.1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-iptables-1.4.1-rc3-1.4.1.txt"

Jan Engelhardt (2):
      libxt_owner: add spaces to output
      manpage updates

Laszlo Attila Toth (1):
      addrtype match: added revision 1

Lutz Jaenicke (1):
      Fix iptables-save output of libxt_owner match

Patrick McHardy (4):
      libiptc: move variable definitions to head of function
      iptables-xml: sparse fixes
      sparse warning fixes: integer used as pointer
      v1.4.1


--------------000708070902060004070604
Content-Type: text/plain;
 name="changes-iptables-1.4.1.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="changes-iptables-1.4.1.txt"

Filippo Zangheri (1):
      removes useless white spaces from iptables-xml manpages.

Gáspár Lajos (1):
      iptables: use C99 lists for struct options

Henrik Nordstrom (5):
      Make iptables-restore usable over a pipe
      Add support for --set-counters to iptables -P
      iptables --list-rules command
      iptables --list chain rulenum
      Make --set-counters (-c) accept comma separated counters

James King (1):
      [IPTABLES]: libxt_iprange: Fix IP validation logic

Jamie Strandboge (1):
      fix ip6tables dest address printing

Jan Engelhardt (55):
      Converts the iptables build infrastructure to autotools.
      Introduce strtonum(), which works like string_to_number(), but passes
      common error messages
      libxt_owner
      libxt_tos
      libxt_TOS
      libxt_MARK r2
      libxt_connmark r1
      print warning when dlopen fails
      libxt_conntrack r0
      bunch o' renames
      rename overlapping function names
      libxt_hashlimit checks
      libxt_mark r1
      libxt_iprange r0
      libxt_iprange r1
      Give preference to iptables header files
      Build adjustments
      libxt_CONNMARK revision 1
      [IPTABLES]: libxt_conntrack revision 1
      [IPTABLES]: libxt_owner: UID/GID range support
      Fix compilation of iptables-static build
      Correct the family member value of libxt_mark revision 1
      Makefile: add a "tarball" target
      Drop -W from CFLAGS and some tiny code cleanups
      Fix -Wshadow warnings and clean up xt_sctp.h
      Update the libxt_owner manpage with the UID/GID-range feature
      Fix all remaining warnings (missing declarations, missing prototypes)
      xtables.h: move non-exported parts to internal.h
      Add support for xt_hashlimit match revision 1
      Combine IP{,6}T_LIB_DIR into XTABLES_LIBDIR
      manpages: fix broken markup (missing close tags)
      manpages: grammar and spelling
      manpages: update to reflect fine-grained control
      configure: split --enable-libipq from --enable-devel
      Add all necessary header files - compilation fix for various cases
      Install libiptc header files because xtables.h depends on it
      RATEEST: add manpage
      Implement AF_UNSPEC as a wildcard for extensions
      Combine ipt and ip6t manpages
      Resolve warnings on 64-bit compile
      Wrap dlopen code into NO_SHARED_LIBS
      Remove support for compilation of conditional extensions
      Resolve libipt_set warnings
      Update documentation about building the package
      configure.ac: AC_SUBST must be separate
      Dynamically create xtables.h.in with version
      configure.ac: remove already-defined variables
      Remove old functions, constants
      Makefile.am: use PACKAGE_TARNAME
      iptables out-of-tree build directory
      Update .gitignore
      build: check for missing feature files
      libxt_owner: add spaces to output
      manpage updates

Jesper Dangaard Brouer (3):
      Inline functions iptcc_is_builtin() and set_changed().
      Introduce a counter for number of user defined chains.
      Solving scalability issue: for chain list "name"	searching.

Kristof Provost (1):
      REDIRECT: Allow symbolic port in REDIRECT --to-port

Laszlo Attila Toth (1):
      addrtype match: added revision 1

Lutz Jaenicke (1):
      Fix iptables-save output of libxt_owner match

Martin F. Krafft (1):
      Import iptables-apply

Max Kellermann (7):
      Fix REDIRECT manpage
      whitespace cleanup
      use size_t
      escape strings
      unescape parameters
      allow empty strings in argument parser
      fix gcc warnings

Naohiro Ooiwa (1):
      Fix define value of SCTP chunk type.

Pablo Neira Ayuso (2):
      - cleanup several code wraparounds
      bump iptables version to prepare 1.4.1 release

Patrick McHardy (16):
      Add RATEEST target extension
      Add rateest match extension
      Remove obsolete file
      Add netfilter.h
      Remove compiler.h inclusions.
      Retry ruleset dump when kernel returns EAGAIN.
      Properly initialize revision for ip6tables targets
      Bump version to 1.4.1-rc1
      iptables 1.4.1-rc2
      manpages: consistent syntax
      Resync header files with kernel
      Bump version
      libiptc: move variable definitions to head of function
      iptables-xml: sparse fixes
      sparse warning fixes: integer used as pointer
      v1.4.1

Peter Warasin (1):
      Fix CONNMARK mask initialisation

Shan Wei (1):
      iptables-save:remove unnecessary code.

Sven Schnelle (1):
      libxt_TCPOPTSTRIP

Thomas Jacob (1):
      Don't assume /bin/sh is bash

Thomas Jarosch (1):
      Add xtables version defines.

Yasuyuki Kozakai (1):
      Use s6_addr32 to access bits in int6_addr instead of incompatible name


--------------000708070902060004070604--
