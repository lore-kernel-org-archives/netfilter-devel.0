From: Ana Rey Botello <ana@soleta.eu>
Subject: [v4 nf 0/5] Named counter objects support in nft
Date: Wed,  4 Feb 2015 19:55:08 +0100
Message-ID: <cover.1423075525.git.ana@soleta.eu>
Cc: Ana Rey Botello <ana@soleta.eu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:48222 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161429AbbBDSya (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Feb 2015 13:54:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

With this patchset, we add named counter objects support. It is similar
to nfacct in iptables.

Examples of use in nft of this new feature:
i
* Add a new counter:
nft add counter ip filter http-traffic
nft add counter ip filter https-traffic

* Delete the counter (No rule uses this counter)
nft delete counter ip filter https-traffic

* Set the counter to a rule.
nft add rule ip filter output tcp dport 80 counter name http-traffic
nft add rule ip filter output tcp dport 443 counter name https-traffic

* Reset the number of bytes and packets of the counter.
nft reset counter ip filter http-traffic

* List all counter:
nft list counters

* List information about the counter.
nft list counter ip test https-traffic

Example of the table with some counter:
 # nft list table ip test

    table ip filter {
            counter http-traffic { pkts 779 bytes 99495}
            counter https-traffic { pkts 189 bytes 37824}

            chain output {
                     type filter hook output priority 0;
                     tcp dport http counter name http-traffic
                     tcp dport https counter name https-traffic
            }
    }

It is difficult to reuse the existing code of nfacct because:
 * nfacct does not have transation support transactions.
 * We need something that integrated well to nf_tables.

No quota support yet.

[Changes in v4]
* Add supppot for "nft list counters" command
* Add support for reset counter command in nft:
  Example: "nft reset counter ip test counter1"
* Add support for reset counters command in nft.
  Example:  "nft reset counters"
* Add named counters with default values.
  Example: nft add counter ip test c1 { packets 2 bytes 10}

These changes were sugguested by Pablo Neira

[Changes in v3]
* Delete the patch " Rename from nft_counter to nft_counter_priv". Now, we
use "nft_counter" and nft_named_ctr names.
* Add support for NFT_NAMED_CTR_INACTIVE
These changes were sugguested by Pablo Neira

* Fix a kernel panic

[Changes in v2]
* This deletes the acct module and uses the counter module.
* This renames from nft_counter to nft_counter_priv struct
* This uses _COUNTER_ names instead of _ACCT_ names in variables and functions
* Rename acct netlink attributes to named counter netlink attributes. The new
names are NFTA_NAMED_CTR_XXX
* This limits NFT_CTR_MAXNAMELEN to 16
* This fixes some memory problems

These changes were sugguested by Pablo Neira and Patrick McHardy.


Ana Rey Botello (1):
  netfilter: add named counters support

 include/net/netfilter/nf_tables.h        |   47 +++
 include/uapi/linux/netfilter/nf_tables.h |   31 ++
 net/netfilter/nf_tables_api.c            |  482 +++++++++++++++++++++++++++++-
 net/netfilter/nft_counter.c              |   97 +++++-
 4 files changed, 651 insertions(+), 6 deletions(-)

[libnftnf]
Ana Rey (1):
  src: Add named counters support

Ana Rey Botello (1):
  tests: add unit tests for counters

 examples/Makefile.am                |   27 +-
 examples/nft-counter-add.c          |  140 ++++++++
 examples/nft-counter-del.c          |  135 +++++++
 examples/nft-counter-get.c          |  137 +++++++
 examples/nft-counter-reset.c        |  123 +++++++
 examples/nft-counters-get.c         |  136 +++++++
 examples/nft-rule-counter-add.c     |  222 ++++++++++++
 include/buffer.h                    |    1 +
 include/libnftnl/Makefile.am        |    3 +-
 include/libnftnl/counter.h          |   97 +++++
 include/libnftnl/expr.h             |    1 +
 include/linux/netfilter/nf_tables.h |   31 ++
 src/Makefile.am                     |    1 +
 src/counter.c                       |  673 +++++++++++++++++++++++++++++++++++
 src/expr/counter.c                  |   48 ++-
 src/internal.h                      |    6 +
 src/libnftnl.map                    |   30 ++
 tests/Makefile.am                   |    4 +
 tests/nft-counter-test.c            |   86 +++++
 tests/nft-expr_counter-test.c       |    4 +
 tests/test-script.sh                |    1 +
 21 files changed, 1902 insertions(+), 4 deletions(-)
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
  src: Add named counters support
  tests: regression: Add counters support

 include/linux/netfilter/nf_tables.h |   30 ++++
 include/mnl.h                       |   11 ++
 include/netlink.h                   |   27 +++
 include/rule.h                      |   47 ++++++
 include/statement.h                 |    1 +
 src/evaluate.c                      |   14 +-
 src/mnl.c                           |  135 +++++++++++++++
 src/netlink.c                       |  318 +++++++++++++++++++++++++++++++++++
 src/netlink_delinearize.c           |    3 +
 src/netlink_linearize.c             |    4 +
 src/parser_bison.y                  |  101 ++++++++++-
 src/rule.c                          |  154 +++++++++++++++++
 src/scanner.l                       |    2 +
 src/statement.c                     |    8 +-
 tests/regression/ip/counter.t       |   15 ++
 tests/regression/nft-test.py        |  110 ++++++++++++
 16 files changed, 972 insertions(+), 8 deletions(-)
 create mode 100644 tests/regression/ip/counter.t

-- 
1.7.10.4

