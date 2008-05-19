From: Patrick McHardy <kaber@trash.net>
Subject: [ANNOUNCE] Release of iptables 1.4.1-rc1
Date: Mon, 19 May 2008 13:59:41 +0200
Message-ID: <48316BAD.2010206@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050409090503090806090106"
Cc: "'netfilter@vger.kernel.org'" <netfilter@vger.kernel.org>,
	netfilter-core@lists.netfilter.org
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050409090503090806090106
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

The netfilter coreteam proudly presents:

	iptables version 1.4.1-rc1

This release candidate contains a larger number of changes than
usual:

- fixes for some minor issues (mostly compilation problems with
   old kernel headers) in the 1.4.0 release

- big scalability improvements from Jesper Brouer

- A new build system from Jan Engelhardt using autotools

- Support for multiple new matches, targets and revisions

- Continued merging of iptables and ip6tables code, bringing
   new features to ip6tables

- Manpage cleanups and additions

- iptables *should* now build without kernel headers or sources

Additionally work has begun to merge ebtables and arptables
functionality in iptables, this will hopefully continue after
1.4.1 has been released.

Starting with this release candidate, some changes are happening:

- The iptables repository has been moved from SVN to git. The
   Changelog is already in a format that vaguely resembles
   git-shortlog output, but is written manually because SVN
   doesn't track author information (and most likely contains
   a few incorrect attributions). To make this simpler in the
   future, all patch submitters are asked to sign off on their
   patches from now on, similar as for kernel patches. The
   "Developer's Certificate of Origin" from the kernel source
   will be added to iptables.

- The release frequency will be increased, the plan is to
   have one iptables release per kernel release in order to
   get support for new features to users as quickly as
   possible.

I think thats it, so back to this release:

Version 1.4.1-rc1 can be obtained from (please note that the
webpage hasn't been rebuilt yet, but will be shortly):

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/
git://git.netfilter.org/iptables.git

Please test and report any problems you might notice. If things
go well, I hope to release 1.4.1 in about two weeks.

On behalf of the Netfilter Core Team.
Happy testing!

--------------050409090503090806090106
Content-Type: text/plain;
 name="changes-iptables-1.4.1-rc1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-iptables-1.4.1-rc1.txt"

iptables v1.4.1-rc1 Changelog:
======================================================================
Changes from 1.4.0:

Peter Warasin:
	Fix CONNMARK mask initialisation

Jesper Dangaard Brouer:
	Inline functions iptcc_is_builtin() and set_changed()
	Introduce a counter for number of user defined chains
	Solving scalability issue: for chain list "name" searching

Patrick McHardy:
	Add RATEEST target extension
	Add rateest match extension
	Remove obsolete file
	Add netfilter.h
	Remove compiler.h inclusions
	Retry ruleset dump when kernel returns EAGAIN

Pablo Neira Ayuso:
	Cleanup several code wraparounds
	Check for malloc() return value in merge_opts()
	Check for merge_opts() return value

Jan Engelhardt:
	Converts the iptables build infrastructure to autotools
	Introduce strtonum()
	Introduce common error messages
	Add libxt_owner
	Add libxt_tos
	Add libxt_TOS
	Add libxt_MARK r2
	Add libxt_connmark r1
	Print warning when dlopen fails
	Add libxt_conntrack r0
	Bunch o' renames
	Rename overlapping function names
	Add more libxt_hashlimit checks
	Add libxt_mark r1
	Add libxt_iprange r0
	Add libxt_iprange r1
	Give preference to iptables header files
	Build adjustments
	Add libxt_CONNMARK revision 1
	Add libxt_conntrack revision 1
	libxt_owner: UID/GID range support
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
	Import iptables-apply
	Add all necessary header files - compilation fix for various cases
	Install libiptc header files because xtables.h depends on it
	iptables: use C99 lists for struct options
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
	Properly initialize revision for ip6tables targets
	Makefile.am: use PACKAGE_TARNAME
	iptables out-of-tree build directory

Sven Schnelle:
	Add libxt_TCPOPTSTRIP

Max Kellermann:
	Fix REDIRECT manpage
	Whitespace cleanup
	Use size_t
	Escape strings
	Unescape parameters
	Allow empty strings in argument parser
	Fix gcc warnings

Naohiro Ooiwa:
	Fix define value of SCTP chunk type

Filippo Zangheri:
	Remove useless white spaces from iptables-xml manpages

James King:
	libxt_iprange: Fix IP validation logic

Shan Wei:
	iptables-save: remove unnecessary code

Henrik Nordstrom:
	Make iptables-restore usable over a pipe
	Add support for --set-counters to iptables -P
	iptables --list-rules command
	iptables --list chain rulenum
	Make --set-counters (-c) accept comma separated counters

Jamie Strandboge:
	Fix ip6tables dest address printing


--------------050409090503090806090106--
