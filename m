From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] nftables 0.8.1 release
Date: Tue, 16 Jan 2018 14:01:59 +0100
Message-ID: <20180116130159.m3dzom4zgitglfhh@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zkuu3jz5tuutiqwd"
Cc: netdev@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48884 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751451AbeAPNCJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 08:02:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9A3041176C4
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 14:02:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74A2BBAC4D
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 14:02:07 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--zkuu3jz5tuutiqwd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 0.8.1

This release contains mostly incremental fixes and documentation
updates, such as fixing up ./configure --with-mini-gmp for embedded
setups that don't have libgmp.

Deprecated syntax
=================

This release deprecates the "flow table" syntax in favor of "meter" to
address Netfilter's bugzilla issues:

https://bugzilla.netfilter.org/show_bug.cgi?id=1137
https://bugzilla.netfilter.org/show_bug.cgi?id=1185

This is an example of how to use it:

# nft add table filter
# nft add chain filter input { type filter hook input priority 0\; }
# nft add rule filter input meter local-traffic { ip saddr counter }

# nft list ruleset
table ip filter {
        chain input {
                type filter hook input priority 0; policy accept;
                meter local-traffic { ip saddr counter} 
        }
}
# nft list ruleset
table ip filter {
        chain input {
                type filter hook input priority 0; policy accept;
                meter local-traffic { ip saddr counter} 
        }
}
# nft list meter filter local-traffic 
table ip filter {
        meter local-traffic {
                type ipv4_addr
                elements = { 8.8.8.8 : counter packets 1 bytes 84, 84.11.121.21 : counter packets 1 bytes 76, 150.159.126.108 : counter packets 1 bytes 76, 123.102.2.4 : counter packets 1 bytes 76, 21.241.12.143 : counter packets 1 bytes 76 }
        }
}

Former 'flow table' syntax will be still around for a while, but listing
uses the new 'meter' syntax, so please revisit your scripts if you are
using this feature.

Resources
=========

The nftables code can be obtained from:

* http://netfilter.org/projects/nftables/downloads.html
* ftp://ftp.netfilter.org/pub/nftables
* git://git.netfilter.org/nftables

To build the code, libnftnl 1.0.9 and libmnl >= 1.0.2 are required:

* http://netfilter.org/projects/libnftnl/index.html
* http://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* http://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature request, file them via:

* https://bugzilla.netfilter.org

Make sure you create no duplicates already, thanks!

Happy firewalling!

--zkuu3jz5tuutiqwd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-nftables-0.8.1.txt"

Arturo Borrero Gonzalez (1):
      parser: allow classid as set key

Duncan Roe (5):
      doc: nft.8 change "Native Address Translation" to "Network Address Translation"
      doc: nft.8 simplify initial SYNOPSIS line
      doc: nft.8 document use of -f option to start nft scripts
      doc: nft.8 Syslog level is introduced by "level" not "syslog-level"
      doc: nft.8 aim for consistent synopses throughout

Florian Westphal (9):
      rule: fix netlink debug flag when listing table/rules
      tests: fix harmess typo in table name
      tests: icmpX: fix expected output
      tests: add test case that checks icmp6 in-ipv4
      tests: nft removes required payload protocol expressions
      tests: enable ip/ip.t for bridge protocol, too
      tests: nft removes required inet dependency expressions
      ct: don't print newline if label bit cannot be mapped
      netlink_linearize: exthdr op must be u32

Harsha Sharma (4):
      tests: shell: add testcases for named limits
      tests/monitor: Print error "this requires root" and exit
      evaluate: print error for null string
      tests/py: add test for empty string match

Pablo M. Bermudo Garay (1):
      src: do not print limit keyword inside object definition

Pablo Neira Ayuso (9):
      netlink: fix element addition to map with stateful object
      src: add nft_ prefix to everything exposed through include/nftables/nftables.h
      utils: fix one compilation error with --with-mini-gmp
      gmputil: turn mpz_printf into mpz_vfprintf to restore --with-mini-gmp
      src: deprecate "flow table" syntax, replace it by "meter"
      parser_bison: dismiss anonymous meters
      parser_bison: no need for 'name' token for meters
      include: refresh nf_tables.h cached copy
      build: Bump version to v0.8.1

Phil Sutter (19):
      netlink: Use nftnl_expr_fprintf() in netlink_dump_expr()
      main: Fix for wrong argument passed to cache_release in nft_ctx_free
      libnftables: Move library stuff out of main.c
      libnftables: Introduce nft_ctx_flush_cache()
      cli: Use nft_run_cmd_from_buffer()
      libnftables: Introduce getters and setters for everything
      libnftables: Get rid of explicit cache flushes
      libnftables: Flush iface cache after command execution
      Eliminate struct mnl_ctx
      libnftables: Unexport enum nftables_exit_codes
      libnftables: Split code into frontend and library
      rule: Make 'nft export' respect output_fp
      libnftables: Ensure output_fp is never NULL
      tests: shell: Prevent lockout in nft-f/0008split_tables_0
      Make libnftables a local static library
      tests/py: trivial: Fix error message
      src: fix protocol context update on big-endian systems
      build: Restore per object CFLAGS
      src: Don't merge adjacent/overlapping ranges

Varsha Rao (13):
      tests: files: Remove jump chain tests.
      tests: shell: Add test case for jump chain.
      tests: shell: Add test case for sets.
      tests: files: Remove tests for set.
      tests: shell: Add tests for variable definition.
      tests: files: Remove test cases for variable definition.
      tests: files: Remove tests for chain.
      tests: files: Remove tests for table.
      tests: files: Remove tests for verdict maps.
      tests: shell: Add test case for map expression.
      src: tests: files: Remove test files.
      tests: shell: Rename 0025named_limit_0 to 0026named_limit_0
      tests: shell: Add test for IPv4 Mapped IPv6 address.


--zkuu3jz5tuutiqwd--
