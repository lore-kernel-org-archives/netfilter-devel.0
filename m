From: ana@soleta.eu
Subject: Accounting objects support in nft
Date: Mon, 12 Jan 2015 11:55:50 +0100
Message-ID: <cover.1421059192.git.ana@soleta.eu>
Cc: Ana Rey Botello <ana@soleta.eu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:46821 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbbALLEB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:04:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ana Rey Botello <ana@soleta.eu>

Hi,

With this patchset, we add accounting objects support to let us
manipulate extended accounting objects.

Example of use in nft:

 # nft add acct ip filter http-traffic
 # nft add acct ip filter https-traffic

 # nft add rule ip filter output tcp dport 80 acct http-traffic
 # nft add rule ip filter output tcp dport 443 acct https-traffic

 # nft delete acct ip filter https-traffic

 # nft list table ip test

table ip filter {
        acct http-traffic { pkts 779 bytes 99495}
        acct https-traffic { pkts 189 bytes 37824}

        chain output {
             type filter hook output priority 0;
             tcp dport http acct http-traffic
             tcp dport https acct https-traffic
        }
}

It is difficult to reuse the existing code of nfacct because:
 * nfacct does not have transation support transactions.
 * We need something that integrated well to nf_tables.

There is a reset accounter support in the kernel-space and libnftnl. But
not in nft-tool yet.

No quota support yet.

Ana Rey (2):

  netfilter: acct: add support to accounters in nftables

 include/net/netfilter/nf_tables.h        |   41 +++
 include/uapi/linux/netfilter/nf_tables.h |   41 +++
 net/netfilter/Kconfig                    |    7 +
 net/netfilter/Makefile                   |    1 +
 net/netfilter/nf_tables_api.c            |  485 +++++++++++++++++++++++++++++-
 net/netfilter/nft_acct.c                 |  109 +++++++
 6 files changed, 679 insertions(+), 5 deletions(-)
 create mode 100644 net/netfilter/nft_acct.c

  src: Add accounters support

 examples/Makefile.am                |   23 +-
 examples/nft-acct-add.c             |  136 ++++++++
 examples/nft-acct-del.c             |  133 ++++++++
 examples/nft-acct-get.c             |  135 ++++++++
 examples/nft-acct-reset.c           |  121 +++++++
 examples/nft-rule-acct-add.c        |  220 +++++++++++++
 examples/nft-rule-get.c             |    1 +
 include/buffer.h                    |    1 +
 include/libnftnl/Makefile.am        |    3 +-
 include/libnftnl/acct.h             |   87 +++++
 include/libnftnl/expr.h             |    3 +
 include/linux/netfilter/nf_tables.h |   41 +++
 src/Makefile.am                     |    2 +
 src/acct.c                          |  612 +++++++++++++++++++++++++++++++++++
 src/expr/acct.c                     |  201 ++++++++++++
 src/libnftnl.map                    |   30 ++
 16 files changed, 1747 insertions(+), 2 deletions(-)
 create mode 100644 examples/nft-acct-add.c
 create mode 100644 examples/nft-acct-del.c
 create mode 100644 examples/nft-acct-get.c
 create mode 100644 examples/nft-acct-reset.c
 create mode 100644 examples/nft-rule-acct-add.c
 create mode 100644 include/libnftnl/acct.h
 create mode 100644 src/acct.c
 create mode 100644 src/expr/acct.c

  src: Add the accounter support
  tests: regression: Accounter support

 include/linux/netfilter/nf_tables.h |   41 +++++++
 include/mnl.h                       |    8 ++
 include/netlink.h                   |   18 +++
 include/rule.h                      |   46 +++++++
 include/statement.h                 |    9 ++
 src/evaluate.c                      |   14 ++-
 src/mnl.c                           |  117 ++++++++++++++++++
 src/netlink.c                       |  231 +++++++++++++++++++++++++++++++++++
 src/netlink_delinearize.c           |   14 +++
 src/netlink_linearize.c             |   16 +++
 src/parser_bison.y                  |   72 ++++++++++-
 src/rule.c                          |  137 +++++++++++++++++++++
 src/scanner.l                       |    2 +
 src/statement.c                     |   16 +++
 tests/regression/ip/acct.t          |   17 +++
 tests/regression/nft-test.py        |  112 +++++++++++++++++
 16 files changed, 866 insertions(+), 4 deletions(-)
 create mode 100644 tests/regression/ip/acct.t

-- 
1.7.10.4

