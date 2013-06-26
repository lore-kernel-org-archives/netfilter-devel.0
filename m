From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 00/21] Small fixes for XML
Date: Wed, 26 Jun 2013 13:36:55 +0200
Message-ID: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54639 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751817Ab3FZLhG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series implements a bunch of small fixes for the XML code in libnftables.

These are some of the changes Pablo requested me to make previous to the inclusion of the parsing test bench.

---

Arturo Borrero Gonzalez (21):
      chain: add hooknum2str
      src: xml: convert family values to string
      rule: xml: conditional compat info
      bitwise: xml: mask and xor use same number of data registers
      expr: xml: validate registers < NFT_REG_MAX
      nat: xml: change nat types string to dnat/snat
      nat: xml: change IP range node names
      byteorder: xml: op as string
      ct: xml: add extra dir check
      ct: xml: use key's name string instead of numbers
      exthdr: xml: fix mandatory elements
      chain: xml: use string for policy
      data_reg: xml: len node shows byte length
      data_reg: xml: fix bytes movements
      target&match: xml: don't print rev number
      payload: xml: use string for base attribute
      exthdr: xml: use string for type node
      meta: xml: use string to represent key attribute
      nat: snprintf: fix buffer offset
      nat: xml: rename node type to nat_type
      exthdr: xml: rename type node to exthdr_type


 src/Makefile.am           |    3 +
 src/chain.c               |  100 +++++++++++++++++++++++---------
 src/expr/bitwise.c        |   20 ++++++
 src/expr/byteorder.c      |   29 +++++++--
 src/expr/cmp.c            |    5 ++
 src/expr/ct.c             |   58 +++++++++++++++++--
 src/expr/data_reg.c       |   21 ++++---
 src/expr/exthdr.c         |  139 ++++++++++++++++++++++++++++++++-------------
 src/expr/immediate.c      |    5 ++
 src/expr/lookup.c         |   10 +++
 src/expr/match.c          |   18 ------
 src/expr/meta.c           |   55 ++++++++++++++++--
 src/expr/nat.c            |   57 ++++++++----------
 src/expr/payload.c        |   57 ++++++++++++++++--
 src/expr/target.c         |   20 ------
 src/internal.h            |    3 +
 src/rule.c                |   72 ++++++++++++-----------
 src/table.c               |   24 ++++----
 src/utils.c               |   49 ++++++++++++++++
 test/nft-chain-xml-add.sh |   18 +++---
 test/nft-rule-xml-add.sh  |   25 +++-----
 test/nft-table-xml-add.sh |    4 +
 22 files changed, 540 insertions(+), 252 deletions(-)
 create mode 100644 src/utils.c

-- 
Signature
