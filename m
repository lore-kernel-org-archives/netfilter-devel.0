From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnftnl 1.0.8 release
Date: Fri, 13 Oct 2017 01:41:48 +0200
Message-ID: <20171012234148.GA23593@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Cc: netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:48951 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752804AbdJLXlx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2017 19:41:53 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.0.8

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem. The
library libnftnl has been previously known as libnftables. This library
is currently used by the nft command line tool.

This release includes incremental updates to support new kernel
features and bug fixes.

You can download this library from:

http://www.netfilter.org/projects/libnftnl/downloads.html
ftp://ftp.netfilter.org/pub/libnftnl/

Thanks!

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnftnl-1.0.8.txt"

Alexander Alemayhu (1):
      exthdr: remove unused variable uval8

Elise Lennion (2):
      examples: Remove the use of nftnl_mnl_batch_put()
      src: Use nftnl_buf to export XML/JSON rules

Eric Leblond (1):
      set: free user data

Florian Westphal (9):
      src: ct: add zone support
      object: don't set NFTNL_OBJ_TYPE unless obj->ops is non-null
      object: fix crash when object ops is null
      object: extend set/get api for u8/u16 types
      src: ct helper support
      src: ct eventmask support
      ct: rename eventmask to event
      exthdr: tcp option set support
      rt: tcpmss get support

Laura Garcia Liebana (1):
      expr: hash: support of symmetric hash

Liping Zhang (1):
      src: ct: add average bytes per packet counter support

Manuel Messner (1):
      src: add TCP option matching requirements

Pablo M. Bermudo Garay (1):
      src: limit stateful object support

Pablo Neira Ayuso (11):
      src: get rid of aliases and compat
      include: refresh nf_tables.h copy
      common: get rid of nftnl_batch_build_hdr()
      common: return nlmsghdr in nftnl_batch_{begin,end}()
      rule: add NFTA_RULE_ID attribute
      udata: add nftnl_udata_put_u32() and nftnl_udata_get_u32()
      buffer: use nftnl_expr_snprintf() from nftnl_buf_expr()
      expr: no need to nul-terminate buffer from expression ->snprintf indirection
      src: no need to nul-terminate buffer for nftnl_fprintf() calls
      src: do not nul-terminate internal helper functions
      build: libnftnl 1.0.8 release

Phil Sutter (5):
      exthdr: Add support for exthdr flags
      exthdr: Add missing exthdr flags cases
      fib: Add support for NFTA_FIB_F_PRESENT flag
      expr: exthdr: Display NFT_EXTHDR_F_PRESENT in debug output
      chain: Don't print unset policy value in netlink debug

Shyam Saini (1):
      examples: Fix memory leaks detected by Valgrind

Tobias Klauser (1):
      expr: Add const qualifiers to *2str translation arrays

Varsha Rao (2):
      src: Change parameters of SNPRINTF_BUFFER_SIZE macro.
      src: Buffer is null terminated.


--tKW2IUtsqtDRztdT--
