From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_conntrack 0.9.1 release
Date: Thu, 24 Feb 2011 19:38:33 +0100
Message-ID: <4D66A5A9.20900@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000200070809070905070605"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000200070809070905070605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The Netfilter project presents libnetfilter_conntrack-0.9.1

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table. This
library requires a linux kernel >= 2.6.18.

This release includes lots of improvements for the building
infrastructure from Jan Engelhardt, support for user-space conntrack
expectations, the nf_conntrack_timestamp support and the new secctx
field which replaces secmark. ChangeLog is also attached for more details.

You can download it from:

http://www.netfilter.org/projects/libnetfilter_conntrack/
ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/

Enjoy,
Pablo.


--------------000200070809070905070605
Content-Type: text/plain;
 name="changes-libnetfilter_conntrack-0.9.1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="changes-libnetfilter_conntrack-0.9.1.txt"

Jan Engelhardt (24):
      build: use autoconf-suggested naming of files
      build: use modern call syntax for AC_INIT, AM_INIT_AUTOMAKE
      build: avoid use of deprecated INCLUDES
      build: use simpler autoreconf in autogen
      build: run AC_CANONICAL_HOST only
      build: no need for error message in PKG_CHECK_MODULES
      add .gitignore to rootdir
      build: set Libs.private for pkgconfig file
      build: use sh -e, remove autom4te.cache
      build: remove statements without effect
      build: remove unused $(all_includes)
      build: remove -fPIC flag
      build: no need for error message in PKG_CHECK_MODULES
      Update .gitignore
      build: default to not building static libraries
      build: use AC_OUTPUT
      build: run autoupdate to replace obsolete constructs
      src: remove redundant casts
      src: declare non-modified data as const
      utils: use sizeof(buf) over hardcoded number
      build: remove unused LIBTOOL_DEPS
      build: use -Wall across the entire source
      utils: resolve compiler warnings
      qa: resolve compiler warnings

Pablo Neira Ayuso (26):
      doc: minor improvements for doxygen config file
      src: fix warning in compilation
      expect: add CTA_EXPECT_ZONE support
      expect: add support for CTA_EXPECT_FLAGS
      utils: more realistic expectation creation for FTP helper
      utils: add user-space expectation example
      expect: add missing tags for expectation events
      conntrack: fix independent metadata checkings in XML output
      doc: update README file (including re-license to GPLv2+)
      Merge branch 'master' of git://dev.medozas.de/libnetfilter_conntrack
      src: allow to use nfct handler for conntrack and expectations at the same time
      utils: expect_events now listens to all sort of expectation events
      expect: export already implement low-level functions
      src: replace CTA_PROTOINFO_DCCP_SEQ by CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ
      callback: remove unused goto tag
      Merge branch 'master' of git://dev.medozas.de/libnetfilter_conntrack
      src: add support for CTA_SECCTX
      api: fix use-after-free bug in nfct_destroy()
      include: sync IPS_* bits with current in the Linux kernel
      conntrack: add timestamp support
      conntrack: fix segfault in nfct_copy() if secctx of origin is not set
      conntrack: add NFCT_CP_OVERRIDE flag for nfct_copy()
      conntrack: deprecate nfct_sizeof() and nfct_maxsize() functions
      src: deprecate low level API
      conntrack: fix subscript is above array bounds in secctx
      build: bump version to 0.9.1


--------------000200070809070905070605--
