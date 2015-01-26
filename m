From: Ana Rey Botello <ana@soleta.eu>
Subject: [nf v2 0/6] Accounting objects support in nft
Date: Mon, 26 Jan 2015 20:43:26 +0100
Message-ID: <cover.1422299627.git.ana@soleta.eu>
Cc: Ana Rey Botello <ana@soleta.eu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:47436 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbbAZTm4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:42:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

With this patchset, we add accounting objects support to let us
manipulate extended accounting objects.

Example of use in nft:

 # nft add counter ip filter http-traffic
 # nft add counter ip filter https-traffic

 # nft add rule ip filter output tcp dport 80 counter name http-traffic
 # nft add rule ip filter output tcp dport 443 counter name https-traffic

 # nft delete counter ip filter https-traffic

 # nft list table ip test

table ip filter {
        counter http-traffic { pkts 779 bytes 99495}
        counter https-traffic { pkts 189 bytes 37824}

        chain output {
             type filter hook output priority 0;
             tcp dport http counter http-traffic
             tcp dport https counter https-traffic
        }
}

It is difficult to reuse the existing code of nfacct because:
 * nfacct does not have transation support transactions.
 * We need something that integrated well to nf_tables.

There is a reset accounter support in the kernel-space and libnftnl. But
not in nft-tool yet.

No quota support yet.

[Changes in v2]
* This deletes the acct module and uses the counter module.
* This renames from nft_counter to nft_counter_priv struct
* This uses _COUNTER_ names instead of _ACCT_ names in variables and functions
* Rename acct netlink attributes to named counter netlink attributes. The new
names are NFTA_NAMED_CTR_XXX
* This limits NFT_CTR_MAXNAMELEN to 16
* This fixes some memory problems

These changes were sugguested by Pablo Neira and Patrick McHardy.


[kernel-nf]
Ana Rey (1):
  netfilter: named counter: add support to counters in nftables

Ana Rey Botello (1):
  netfilter: Rename from nft_counter to nft_counter_priv

 include/net/netfilter/nf_tables.h        |   49 +++
 include/uapi/linux/netfilter/nf_tables.h |   34 +++
 net/netfilter/nf_tables_api.c            |  486 +++++++++++++++++++++++++++++-
 net/netfilter/nft_counter.c              |  130 ++++++--
 4 files changed, 677 insertions(+), 22 deletions(-)

[libnftnl]

Ana Rey (1):
  src: Add counters support

Ana Rey Botello (1):
  tests: add unit tests for counters

 examples/Makefile.am                |   27 +-
 examples/nft-counter-add.c          |  140 ++++++++
 examples/nft-counter-del.c          |  135 +++++++
 examples/nft-counter-get.c          |  137 +++++++
 examples/nft-counter-reset.c        |  123 +++++++
 examples/nft-counters-get.c         |  136 +++++++
 examples/nft-rule-add.c             |    2 +-
 examples/nft-rule-counter-add.c     |  221 ++++++++++++
 examples/nft-rule-get.c             |    1 +
 include/buffer.h                    |    1 +
 include/libnftnl/Makefile.am        |    3 +-
 include/libnftnl/counter.h          |   97 +++++
 include/libnftnl/expr.h             |    1 +
 include/linux/netfilter/nf_tables.h |   33 ++
 src/Makefile.am                     |    1 +
 src/counter.c                       |  671 +++++++++++++++++++++++++++++++++++
 src/expr/counter.c                  |   48 ++-
 src/internal.h                      |    6 +
 src/libnftnl.map                    |   30 ++
 tests/Makefile.am                   |    4 +
 tests/nft-counter-test.c            |   86 +++++
 tests/nft-expr_counter-test.c       |    4 +
 22 files changed, 1902 insertions(+), 5 deletions(-)
 create mode 100644 examples/nft-counter-add.c
 create mode 100644 examples/nft-counter-del.c
 create mode 100644 examples/nft-counter-get.c
 create mode 100644 examples/nft-counter-reset.c
 create mode 100644 examples/nft-counters-get.c
 create mode 100644 examples/nft-rule-counter-add.c
 create mode 100644 include/libnftnl/counter.h
 create mode 100644 src/counter.c
 create mode 100644 tests/nft-counter-test.c

[nft]
Ana Rey (2):
  src: Add the accounter support
  tests: regression: Add counters support

 include/linux/netfilter/nf_tables.h |   32 +++++
 include/mnl.h                       |    8 ++
 include/netlink.h                   |   22 ++++
 include/rule.h                      |   47 +++++++
 include/statement.h                 |    1 +
 src/evaluate.c                      |   13 +-
 src/mnl.c                           |  119 ++++++++++++++++++
 src/netlink.c                       |  235 +++++++++++++++++++++++++++++++++++
 src/netlink_delinearize.c           |    3 +
 src/netlink_linearize.c             |    4 +
 src/parser_bison.y                  |   60 ++++++++-
 src/rule.c                          |  139 +++++++++++++++++++++
 src/scanner.l                       |    1 +
 src/statement.c                     |    8 +-
 tests/regression/ip/counter.t       |   15 +++
 tests/regression/nft-test.py        |  110 ++++++++++++++++
 16 files changed, 810 insertions(+), 7 deletions(-)
 create mode 100644 tests/regression/ip/counter.t


-- 
1.7.10.4

