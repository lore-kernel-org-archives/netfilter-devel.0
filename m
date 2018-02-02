From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] nftables 0.8.2 release
Date: Fri, 2 Feb 2018 18:03:37 +0100
Message-ID: <20180202170337.ik4o4y3vaoqj6txg@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="yroqbmzlwmjuvdoe"
Cc: netdev@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49920 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752816AbeBBRDm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Feb 2018 12:03:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C4CF71B6969
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2018 18:03:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3828BAC28
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2018 18:03:40 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--yroqbmzlwmjuvdoe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 0.8.2

This release fixes ./configure --with-xtables that enables interaction
between iptables-compat [1] and nft, and it also includes a bunch of
documentation updates.

This release introduces a new explicit option for interval sets, that
enables auto-merge of adjacent/overlapping elements when adding them to
the set, eg.

     table ip x {
            ...
            set y {
                    type ipv4_addr
                    flags interval
                    auto-merge
            }
     }
     # nft add element x z { 1.1.1.1-2.2.2.2, 1.1.1.2 }

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

Happy firewalling!

[1] https://wiki.nftables.org/wiki-nftables/index.php/Moving_from_iptables_to_nftables#using_the_nf_tables_compat_backend

--yroqbmzlwmjuvdoe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-nftables-0.8.2.txt"

Arturo Borrero Gonzalez (1):
      doc/nft.xml: mention nftables earlier

Florian Westphal (2):
      meta: add secpath support
      doc: dup and fwd statements

Harsha Sharma (1):
      tests: shell: fetch rule handle with '-a' option and then delete rule

Pablo M. Bermudo Garay (1):
      update gitignore

Pablo Neira Ayuso (4):
      Revert ("src: Remove xt_stmt_() functions").
      src: add 'auto-merge' option to sets
      netlink_delinearize: add assertion to prevent infinite loop
      build: Bump version to v0.8.2

Phil Sutter (4):
      build: Eliminate forgotten traces of libnftables exporting
      configure: Fix help text regarding --enable-debug
      configure: Allow to disable man page building
      tests/shell: Add back named_interval_automerging_0

Shyam Saini (2):
      src: Add import command for low level json
      tests: shell: Add tests for low level json import

Varsha Rao (5):
      tests: Add test for compile options.
      configure: Remove AC_HEADER_STDBOOL, AC_C_ and AC_TYPE_ macros
      tests: build: Add README.
      configure: Remove macro AC_CHECK_FUNCS
      tests: build: Add enable man page option.


--yroqbmzlwmjuvdoe--
